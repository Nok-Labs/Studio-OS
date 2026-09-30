package service

import (
	"context"
	"time"
)

// RegistrationMode defines how new users join the application.
type RegistrationMode string

const (
	RegistrationModeOpen       RegistrationMode = "open"
	RegistrationModeInviteOnly RegistrationMode = "invite_only"
)

// AuthConfig controls product-level authentication behavior for Studio OS
// and future Nok Labs projects.
type AuthConfig struct {
	Registration RegistrationConfig
	Verification VerificationConfig
	Session      SessionConfig
	Password     PasswordConfig
	Profile      ProfileConfig
	OAuth        OAuthConfig
}

// RegistrationConfig controls how users sign up.
type RegistrationConfig struct {
	Mode                       RegistrationMode // "open" or "invite_only"
	EnablePasswordRegistration bool             // Allow new signups with email/password
	EnableOAuthRegistration    bool             // Allow creating new accounts via OAuth
}

// VerificationConfig controls email OTP verification behavior.
type VerificationConfig struct {
	Required       bool          // If false, users can log in without verifying email
	OTPTTL         time.Duration // Validity window for an OTP (e.g. 10m)
	MaxOTPAttempts int           // Max incorrect attempts before code is dead (e.g. 3)
	ResendCooldown time.Duration // Cooldown before allowing another OTP send (e.g. 60s)
}

// SessionConfig controls JWT and Refresh Token lifecycles.
type SessionConfig struct {
	AccessTokenTTL     time.Duration // JWT lifetime (e.g. 15m)
	RefreshTokenTTL    time.Duration // Refresh token lifetime (e.g. 30 days)
	RotateRefreshToken bool          // If true, rotates token on every refresh (theft detection)
}

// PasswordConfig controls password login and validation requirements.
type PasswordConfig struct {
	EnablePasswordLogin bool // If false, password login is disabled
	MinLength           int  // Minimum password length (e.g. 8; max is 72 for bcrypt)
	BcryptCost          int  // Cost factor for hashing (default: 12)
}

// ProfileConfig controls which identity fields the product collects and requires.
// If all three are disabled, the product operates as an account-only system (e.g., a synced notes app).
type ProfileConfig struct {
	EnableUsername    bool // Product uses unique @handles
	EnableName        bool // Product collects first and last name
	EnableDisplayName bool // Product uses a friendly display name / nickname
}

// OAuthConfig manages OAuth providers.
type OAuthConfig struct {
	Enabled   bool
	Providers map[string]OAuthProvider // Keyed by provider name ("google", "apple")
}

// OAuthIdentity represents the verified identity returned by an OAuth provider.
type OAuthIdentity struct {
	ProviderID string // Unique identifier from provider (e.g., Google sub)
	Email      string
	FirstName  string
	LastName   string
	AvatarURL  string
}

// OAuthProvider abstracts third-party token validation so adding
// Apple/GitHub later requires zero changes to AuthService logic.
type OAuthProvider interface {
	VerifyToken(ctx context.Context, idToken string) (*OAuthIdentity, error)
}

// DefaultConfig provides production-ready defaults matching Studio OS requirements.
func DefaultConfig() AuthConfig {
	return AuthConfig{
		Registration: RegistrationConfig{
			Mode:                       RegistrationModeInviteOnly,
			EnablePasswordRegistration: true,
			EnableOAuthRegistration:    true,
		},
		Verification: VerificationConfig{
			Required:       true,
			OTPTTL:         10 * time.Minute,
			MaxOTPAttempts: 3,
			ResendCooldown: 60 * time.Second,
		},
		Session: SessionConfig{
			AccessTokenTTL:     15 * time.Minute,
			RefreshTokenTTL:    30 * 24 * time.Hour,
			RotateRefreshToken: true,
		},
		Password: PasswordConfig{
			EnablePasswordLogin: true,
			MinLength:           8,
			BcryptCost:          12,
		},
		Profile: ProfileConfig{
			EnableUsername:    true,
			EnableName:        false,
			EnableDisplayName: false,
		},
		OAuth: OAuthConfig{
			Enabled:   true,
			Providers: make(map[string]OAuthProvider),
		},
	}
}
