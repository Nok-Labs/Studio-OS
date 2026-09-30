// Package config defines the configuration structures and defaults for authentication.
package config

import (
	"time"

	"server/internal/auth/service/oauth"
)

// RegistrationMode defines how new accounts can be created.
type RegistrationMode string

const (
	// RegistrationModeOpen allows anyone to sign up with a valid email/password or OAuth.
	RegistrationModeOpen RegistrationMode = "open"

	// RegistrationModeInviteOnly allows signups only with a valid, non-expired invitation token.
	RegistrationModeInviteOnly RegistrationMode = "invite_only"
)

// RegistrationConfig controls account registration rules.
type RegistrationConfig struct {
	Mode                       RegistrationMode // "open" vs "invite_only"
	EnablePasswordRegistration bool             // true = allow email/password signup
	EnableOAuthRegistration    bool             // true = allow third-party OAuth signup
}

// VerificationConfig controls email OTP verification behavior.
type VerificationConfig struct {
	Required       bool          // true = block login until email is verified
	OTPTTL         time.Duration // lifetime of a 6-digit OTP code (e.g., 15m)
	MaxOTPAttempts int           // failed attempts before OTP is invalidated (e.g., 5)
	ResendCooldown time.Duration // minimum duration between OTP requests (e.g., 60s)
}

// SessionConfig controls JWT and refresh token lifetimes.
type SessionConfig struct {
	AccessTokenTTL      time.Duration // short-lived access token TTL (e.g., 15m)
	RefreshTokenTTL     time.Duration // long-lived refresh token TTL (e.g., 30d)
	RotateRefreshToken  bool          // true = issue fresh refresh token on every /refresh
}

// PasswordConfig controls password requirements and security parameters.
type PasswordConfig struct {
	EnablePasswordLogin bool // true = allow password authentication
	MinLength           int  // minimum password length (e.g., 8)
	BcryptCost          int  // bcrypt work factor (default: 12)
}

// ProfileConfig defines which user profile fields are enabled for this project.
type ProfileConfig struct {
	EnableName        bool // collect first_name, last_name
	EnableUsername    bool // require unique username
	EnableDisplayName bool // allow customizable display_name
}

// OAuthConfig registers supported OAuth providers.
type OAuthConfig struct {
	Enabled   bool                             // master toggle for all OAuth sign-ins
	Providers map[string]oauth.Provider        // keyed by provider name, e.g. "google"
}

// AuthConfig aggregates all configuration sub-sections.
type AuthConfig struct {
	Registration RegistrationConfig
	Verification VerificationConfig
	Session      SessionConfig
	Password     PasswordConfig
	Profile      ProfileConfig
	OAuth        OAuthConfig
}

// DefaultConfig provides production-ready defaults matching Studio OS requirements.
func DefaultConfig() AuthConfig {
	return AuthConfig{
		Registration: RegistrationConfig{
			Mode:                       RegistrationModeOpen,
			EnablePasswordRegistration: true,
			EnableOAuthRegistration:    true,
		},
		Verification: VerificationConfig{
			Required:       true,
			OTPTTL:         15 * time.Minute,
			MaxOTPAttempts: 5,
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
			EnableName:        true,
			EnableUsername:    true,
			EnableDisplayName: true,
		},
		OAuth: OAuthConfig{
			Enabled:   true,
			Providers: make(map[string]oauth.Provider),
		},
	}
}
