package service

import (
	"context"
	"errors"
	"time"

	"server/internal/auth/config"
	autherr "server/internal/auth/errors"
	"server/internal/auth/model"
	"server/internal/auth/repository"
	"server/internal/auth/service/helpers"
	"server/internal/auth/utils"
)

// SignupService handles user registration, email verification, and invitation acceptance.
type SignupService struct {
	repo      repository.AuthRepository
	config    config.AuthConfig
	jwtIssuer *utils.JWTIssuer
	mailer    model.Mailer
}

// NewSignupService constructs a new SignupService.
func NewSignupService(
	repo repository.AuthRepository,
	cfg config.AuthConfig,
	jwtIssuer *utils.JWTIssuer,
	mailer model.Mailer,
) *SignupService {
	return &SignupService{
		repo:      repo,
		config:    cfg,
		jwtIssuer: jwtIssuer,
		mailer:    mailer,
	}
}

// Signup registers a new account using an email address and a plaintext password.
//
// Lifecycle & Verification behavior:
// 1. Validates registration mode: if RegistrationConfig.Mode != RegistrationModeOpen or
//    EnablePasswordRegistration is false, registration is rejected with ErrRegistrationDisabled.
// 2. Validates password constraints (length between MinLength and 72 bytes).
// 3. If ProfileConfig.EnableUsername is true, ensures the proposed username is not already claimed.
// 4. Hashes the password with bcrypt using PasswordConfig.BcryptCost.
// 5. Creates user record and associated profile with optional attributes (first name, last name, display name, avatar).
// 6. Verification Branch:
//    - If VerificationConfig.Required is true: generates a 6-digit OTP code, stores its SHA-256 hash
//      with purpose "signup_verify", dispatches the email via Mailer.SendOTP, and returns (nil, nil)
//      indicating the account is pending email verification.
//    - If VerificationConfig.Required is false: marks the account verified immediately and returns
//      an active TokenPair (access token + refresh token).
//
// Returns:
// - (*model.TokenPair, nil): User created and immediately active (when verification is disabled).
// - (nil, nil): User created and awaiting email verification OTP (when verification is required).
// - (nil, ErrRegistrationDisabled): Public registration or password signup is turned off.
// - (nil, ErrPasswordTooShort / ErrPasswordTooLong): Password violates length policies.
// - (nil, ErrUsernameTaken): Chosen username is already claimed.
// - (nil, ErrEmailAlreadyRegistered): Email address is already in use.
func (service *SignupService) Signup(
	ctx context.Context,
	email string,
	password string,
	profileInput model.ProfileInput,
) (*model.TokenPair, error) {
	// 1. Enforce registration mode and feature flags
	if service.config.Registration.Mode != config.RegistrationModeOpen || !service.config.Registration.EnablePasswordRegistration {
		return nil, autherr.ErrRegistrationDisabled
	}

	// 2. Validate password requirements
	if len(password) < service.config.Password.MinLength {
		return nil, autherr.ErrPasswordTooShort
	}
	if len(password) > 72 {
		return nil, autherr.ErrPasswordTooLong
	}

	// 3. Normalize email address (lowercase and trim whitespace)
	normalizedEmail := helpers.NormalizeEmail(email)

	// 4. Validate unique username if username profile feature is enabled
	if service.config.Profile.EnableUsername && profileInput.Username != nil && *profileInput.Username != "" {
		exists, err := service.repo.CheckUsernameExists(ctx, *profileInput.Username)
		if err != nil {
			return nil, err
		}
		if exists {
			return nil, autherr.ErrUsernameTaken
		}
	}

	// 5. Hash password with configured bcrypt work factor
	hashedPassword, err := utils.HashPassword(password, service.config.Password.BcryptCost)
	if err != nil {
		return nil, err
	}

	// 6. Create user record in database
	user, err := service.repo.CreateUser(ctx, normalizedEmail, &hashedPassword)
	if err != nil {
		if errors.Is(err, repository.ErrAlreadyExists) {
			return nil, autherr.ErrEmailAlreadyRegistered
		}
		return nil, err
	}

	// 7. Create profile respecting configuration toggles
	var firstName, lastName, username, displayName, avatarURL *string
	if service.config.Profile.EnableName {
		firstName = profileInput.FirstName
		lastName = profileInput.LastName
	}
	if service.config.Profile.EnableUsername {
		username = profileInput.Username
	}
	if service.config.Profile.EnableDisplayName {
		displayName = profileInput.DisplayName
	}
	avatarURL = profileInput.AvatarURL

	_, err = service.repo.CreateProfile(ctx, user.ID, firstName, lastName, username, displayName, nil, avatarURL)
	if err != nil {
		return nil, err
	}

	// 8. If email verification is required, issue OTP and dispatch email
	if service.config.Verification.Required {
		otpCode, err := utils.GenerateOTP()
		if err != nil {
			return nil, err
		}

		otpHash := utils.HashToken(otpCode)
		expiresAt := time.Now().Add(service.config.Verification.OTPTTL)

		_, err = service.repo.CreateOTP(ctx, user.ID, otpHash, "signup_verify", expiresAt)
		if err != nil {
			return nil, err
		}

		if service.mailer != nil {
			if err := service.mailer.SendOTP(ctx, normalizedEmail, otpCode); err != nil {
				return nil, err
			}
		}

		// Account is created but pending verification; no token pair returned yet
		return nil, nil
	}

	// 9. If verification is optional, mark verified and issue tokens immediately
	_ = service.repo.MarkEmailVerified(ctx, user.ID)
	return helpers.IssueTokenPair(ctx, service.repo, service.jwtIssuer, service.config.Session, user.ID)
}

// VerifyEmail validates a pending signup verification code and activates the user account.
//
// Security guarantees:
// - Uses a pessimistic database row-lock (SELECT FOR UPDATE) on the OTP record to prevent
//   race conditions and simultaneous brute-force verification requests.
// - Enforces VerificationConfig.MaxOTPAttempts threshold.
// - Compares SHA-256 hashes of submitted code and database record.
// - Upon success, consumes the OTP record, marks the user's email as verified, and issues
//   an active access/refresh token pair.
//
// Returns:
// - (*model.TokenPair, nil): Verification successful; active session tokens issued.
// - (nil, ErrOTPNotFound): User does not exist or no active OTP record found for this email.
// - (nil, ErrOTPMaxAttempts): Verification failed too many times; OTP is locked out.
// - (nil, ErrOTPIncorrect): The provided code is invalid (increments failed attempt count).
func (service *SignupService) VerifyEmail(ctx context.Context, email, code string) (*model.TokenPair, error) {
	// 1. Normalize email address
	normalizedEmail := helpers.NormalizeEmail(email)

	// 2. Fetch user by email
	user, err := service.repo.GetUserByEmail(ctx, normalizedEmail)
	if err != nil {
		if errors.Is(err, repository.ErrNotFound) {
			return nil, autherr.ErrOTPNotFound
		}
		return nil, err
	}

	// 3-7. Read the OTP under a row lock, decide, and act — atomically.
	//
	// This must be one transaction. SELECT ... FOR UPDATE holds its lock only
	// until the end of the enclosing transaction, so in autocommit mode the
	// lock dies with the SELECT and concurrent requests all read attempts=0
	// before any of them writes. The attempt limit would then only bind
	// sequential guesses, letting parallel guesses bypass it entirely.
	//
	// The outcome is captured in a variable rather than returned from fn,
	// because a wrong guess must still commit its attempt increment — returning
	// the error from fn would roll that back and the counter would never move.
	var verifyErr error

	err = service.repo.WithTx(ctx, func(txRepo repository.AuthRepository) error {
		otpRecord, err := txRepo.GetValidOTPForUpdate(ctx, user.ID, "signup_verify")
		if err != nil {
			if errors.Is(err, repository.ErrNotFound) {
				verifyErr = autherr.ErrOTPNotFound
				return nil
			}
			return err
		}

		// Enforce brute-force attempt limits
		if otpRecord.Attempts >= int32(service.config.Verification.MaxOTPAttempts) {
			verifyErr = autherr.ErrOTPMaxAttempts
			return nil
		}

		// Verify submitted OTP hash against database record
		if utils.HashToken(code) != otpRecord.CodeHash {
			if _, err := txRepo.IncrementOTPAttempts(ctx, otpRecord.ID); err != nil {
				return err
			}
			verifyErr = autherr.ErrOTPIncorrect
			return nil
		}

		// Mark the OTP consumed so it cannot be replayed, and flip the user's
		// verified flag. Both commit together or not at all.
		if err := txRepo.MarkOTPUsed(ctx, otpRecord.ID); err != nil {
			return err
		}
		if err := txRepo.MarkEmailVerified(ctx, user.ID); err != nil {
			return err
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	if verifyErr != nil {
		return nil, verifyErr
	}

	// 8. Issue active session token pair (access token + refresh token)
	return helpers.IssueTokenPair(ctx, service.repo, service.jwtIssuer, service.config.Session, user.ID)
}

// ResendOTP generates and dispatches a fresh verification code subject to cooldown limits.
//
// Security & Anti-Enumeration:
// - Returns nil without error if the email address does not exist or is already verified,
//   mitigating account enumeration attacks.
// - Enforces VerificationConfig.ResendCooldown to prevent inbox flooding.
// - Invalidates any previous unconsumed signup verification code before generating a new one.
//
// Returns:
// - nil: OTP generated and sent, or email not eligible for resend (anti-enumeration).
// - ErrOTPCooldown: A verification code was already requested within the cooldown window.
func (service *SignupService) ResendOTP(ctx context.Context, email string) error {
	// 1. Normalize email address
	normalizedEmail := helpers.NormalizeEmail(email)

	// 2. Fetch user by email. Only a genuine "no such user" is swallowed, to
	// mitigate account enumeration (AUTH-16 style). Any other error is a real
	// failure — a database outage must surface as an error, not as a silent
	// success that leaves the caller believing an email was sent.
	user, err := service.repo.GetUserByEmail(ctx, normalizedEmail)
	if err != nil {
		if errors.Is(err, repository.ErrNotFound) {
			return nil
		}
		return err
	}

	// 3. Do not dispatch codes to already verified accounts
	if user.EmailVerifiedAt != nil {
		return nil
	}

	// 4. Check if an existing code was issued within the resend cooldown window.
	// ErrNotFound simply means there is nothing to invalidate; any other error
	// is propagated so a transient database failure cannot cause a second code
	// to be mailed out while the first is still live.
	existingOTP, err := service.repo.GetValidOTP(ctx, user.ID, "signup_verify")
	switch {
	case err == nil:
		timeSinceCreation := time.Since(existingOTP.CreatedAt)
		if timeSinceCreation < service.config.Verification.ResendCooldown {
			return autherr.ErrOTPCooldown
		}
		// 5. Invalidate the previous unconsumed verification code. If this fails
		// we must abort: issuing a new code while the old one still verifies
		// would leave two live codes for the same purpose.
		if err := service.repo.MarkOTPUsed(ctx, existingOTP.ID); err != nil {
			return err
		}
	case errors.Is(err, repository.ErrNotFound):
		// No active code on record; fall through and issue a fresh one.
	default:
		return err
	}

	// 6. Generate fresh CSPRNG 6-digit numeric OTP code
	newCode, err := utils.GenerateOTP()
	if err != nil {
		return err
	}

	// 7. Store SHA-256 hash of new OTP with configured TTL
	newHash := utils.HashToken(newCode)
	expiresAt := time.Now().Add(service.config.Verification.OTPTTL)

	_, err = service.repo.CreateOTP(ctx, user.ID, newHash, "signup_verify", expiresAt)
	if err != nil {
		return err
	}

	// 8. Dispatch verification code via transactional mailer
	if service.mailer != nil {
		return service.mailer.SendOTP(ctx, normalizedEmail, newCode)
	}

	return nil
}

// AcceptInvite redeems an invitation token, creates the user account and profile, and issues session tokens.
//
// Security guarantees:
// - Verifies token validity, expiry, and non-redemption before proceeding.
// - Sets email_verified_at immediately, as the invite token was delivered directly to the user's inbox.
// - Marks the invitation accepted with a timestamp to prevent duplicate redemptions.
//
// Returns:
// - ErrInvitationNotFound / ErrInvitationExpired / ErrInvitationAlreadyAccepted for invalid tokens.
// - ErrPasswordTooShort / ErrPasswordTooLong if password violates length policy.
// - ErrUsernameTaken if profile.enable_username is true and username is already claimed.
// - ErrEmailAlreadyRegistered if an account with this email was created out-of-band.
func (service *SignupService) AcceptInvite(
	ctx context.Context,
	rawToken string,
	password string,
	profileInput model.ProfileInput,
) (*model.TokenPair, error) {
	// 1. Hash raw token with SHA-256
	tokenHash := utils.HashToken(rawToken)

	// 2. Look up invitation record
	invitation, err := service.repo.GetInvitationByToken(ctx, tokenHash)
	if err != nil {
		if errors.Is(err, repository.ErrNotFound) {
			return nil, autherr.ErrInvitationNotFound
		}
		return nil, err
	}

	// 3. Enforce single-use invitation lifecycle
	if invitation.AcceptedAt != nil {
		return nil, autherr.ErrInvitationAlreadyAccepted
	}

	// 4. Enforce expiration window
	if time.Now().After(invitation.ExpiresAt) {
		return nil, autherr.ErrInvitationExpired
	}

	// 5. Validate password policy constraints
	if len(password) < service.config.Password.MinLength {
		return nil, autherr.ErrPasswordTooShort
	}
	if len(password) > 72 {
		return nil, autherr.ErrPasswordTooLong
	}

	// 6. Validate unique username if username profile feature is enabled
	if service.config.Profile.EnableUsername && profileInput.Username != nil && *profileInput.Username != "" {
		exists, err := service.repo.CheckUsernameExists(ctx, *profileInput.Username)
		if err != nil {
			return nil, err
		}
		if exists {
			return nil, autherr.ErrUsernameTaken
		}
	}

	// 7. Hash password using bcrypt with configured cost
	hashedPassword, err := utils.HashPassword(password, service.config.Password.BcryptCost)
	if err != nil {
		return nil, err
	}

	// 8. Create user account with verified email (inbox possession proven via invite token)
	user, err := service.repo.CreateUser(ctx, invitation.Email, &hashedPassword)
	if err != nil {
		if errors.Is(err, repository.ErrAlreadyExists) {
			return nil, autherr.ErrEmailAlreadyRegistered
		}
		return nil, err
	}
	_ = service.repo.MarkEmailVerified(ctx, user.ID)

	// 9. Create user profile respecting configuration toggles
	var firstName, lastName, username, displayName, avatarURL *string
	if service.config.Profile.EnableName {
		firstName = profileInput.FirstName
		lastName = profileInput.LastName
	}
	if service.config.Profile.EnableUsername {
		username = profileInput.Username
	}
	if service.config.Profile.EnableDisplayName {
		displayName = profileInput.DisplayName
	}
	avatarURL = profileInput.AvatarURL

	_, err = service.repo.CreateProfile(ctx, user.ID, firstName, lastName, username, displayName, nil, avatarURL)
	if err != nil {
		return nil, err
	}

	// 10. Mark invitation as accepted to prevent replay
	_ = service.repo.MarkInvitationAccepted(ctx, invitation.ID)

	// 11. Issue active session token pair (access + refresh)
	return helpers.IssueTokenPair(ctx, service.repo, service.jwtIssuer, service.config.Session, user.ID)
}
