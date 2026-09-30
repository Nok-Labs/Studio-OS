package config

import (
	"strings"
	"testing"
)

// setEnv populates the process environment for one test and registers cleanup
// that restores the previous value of every key it touched, so tests do not
// leak configuration into each other or into the developer's own shell.
func setEnv(t *testing.T, env map[string]string) {
	t.Helper()
	for k, v := range env {
		t.Setenv(k, v)
	}
}

// clearEnv neutralizes every variable Load reads, so a test starts from a
// known-empty state regardless of what the developer has exported in their
// shell or left in server/.env.
//
// The values are set to the empty string rather than unset. Load treats empty
// as absent, and — more importantly — godotenv.Load() only populates variables
// that are not already present in the environment. Setting them to "" therefore
// also blocks the repository's real .env from leaking into the test, which
// unsetting would not.
func clearEnv(t *testing.T) {
	t.Helper()
	for _, k := range []string{
		"PORT", "DATABASE_URL", "JWT_SECRET", "RESEND_API_KEY",
		"RESEND_FROM_ADDRESS", "CORS_ALLOWED_ORIGINS", "TRUSTED_PROXY_CIDRS",
		"APP_BASE_URL", "GOOGLE_CLIENT_ID",
	} {
		t.Setenv(k, "")
	}
}

// validEnv is a minimal environment that passes validation, used as the base
// for tests that vary one field at a time.
func validEnv() map[string]string {
	return map[string]string{
		"DATABASE_URL":        "postgres://u:p@localhost:5432/studio_os?sslmode=disable",
		"JWT_SECRET":          strings.Repeat("k", 32),
		"RESEND_API_KEY":      "re_test",
		"RESEND_FROM_ADDRESS": "onboarding@resend.dev",
	}
}

func TestLoadAcceptsAValidEnvironment(t *testing.T) {
	clearEnv(t)
	setEnv(t, validEnv())

	cfg, err := Load()
	if err != nil {
		t.Fatalf("Load() = %v, want nil", err)
	}
	if cfg.DatabaseURL == "" || cfg.JWTSecret == "" {
		t.Fatal("Load() returned an empty required value")
	}
}

// TestLoadDefaultsToDevOrigins is the load-bearing test for the wildcard
// question: with CORS_ALLOWED_ORIGINS unset the allowlist must be the narrow
// dev pair, never "*".
func TestLoadDefaultsToDevOrigins(t *testing.T) {
	clearEnv(t)
	setEnv(t, validEnv())

	cfg, err := Load()
	if err != nil {
		t.Fatalf("Load() = %v, want nil", err)
	}
	for _, origin := range cfg.AllowedOrigins {
		if origin == "*" {
			t.Fatal("AllowedOrigins defaulted to a wildcard; a forgotten env var must not open CORS to every origin")
		}
	}
	if len(cfg.AllowedOrigins) != len(defaultDevOrigins) {
		t.Fatalf("AllowedOrigins = %v, want %v", cfg.AllowedOrigins, defaultDevOrigins)
	}
}

func TestLoadParsesCommaSeparatedLists(t *testing.T) {
	clearEnv(t)
	env := validEnv()
	env["CORS_ALLOWED_ORIGINS"] = "https://a.example, https://b.example ,"
	env["TRUSTED_PROXY_CIDRS"] = "10.0.0.0/8,172.16.0.0/12"
	setEnv(t, env)

	cfg, err := Load()
	if err != nil {
		t.Fatalf("Load() = %v, want nil", err)
	}
	if len(cfg.AllowedOrigins) != 2 {
		t.Fatalf("AllowedOrigins = %v, want 2 entries", cfg.AllowedOrigins)
	}
	if cfg.AllowedOrigins[1] != "https://b.example" {
		t.Fatalf("AllowedOrigins[1] = %q, want trimmed value", cfg.AllowedOrigins[1])
	}
	if len(cfg.TrustedProxyCIDRs) != 2 {
		t.Fatalf("TrustedProxyCIDRs = %v, want 2 entries", cfg.TrustedProxyCIDRs)
	}
}

// TestLoadRejectsEveryMissingVariableAtOnce confirms validate reports the full
// set rather than the first. An operator repairing .env should not have to
// restart the binary once per missing key.
func TestLoadRejectsEveryMissingVariableAtOnce(t *testing.T) {
	clearEnv(t)

	_, err := Load()
	if err == nil {
		t.Fatal("Load() = nil error, want failure with no configuration set")
	}
	msg := err.Error()
	for _, want := range []string{
		"DATABASE_URL", "JWT_SECRET", "RESEND_API_KEY", "RESEND_FROM_ADDRESS",
	} {
		if !strings.Contains(msg, want) {
			t.Errorf("error does not mention %s:\n%s", want, msg)
		}
	}
}

// TestLoadRejectsShortJWTSecret is the check slipwise's loader is missing:
// "required" alone lets a one-character secret through.
func TestLoadRejectsShortJWTSecret(t *testing.T) {
	clearEnv(t)
	env := validEnv()
	env["JWT_SECRET"] = "short"
	setEnv(t, env)

	_, err := Load()
	if err == nil {
		t.Fatal("Load() = nil error, want failure for a JWT secret below the minimum length")
	}
	if !strings.Contains(err.Error(), "JWT_SECRET") {
		t.Fatalf("error does not mention JWT_SECRET:\n%s", err)
	}
}

func TestLoadRejectsCleartextAppBaseURL(t *testing.T) {
	clearEnv(t)
	env := validEnv()
	env["APP_BASE_URL"] = "http://app.studio.example"
	setEnv(t, env)

	_, err := Load()
	if err == nil {
		t.Fatal("Load() = nil error, want failure for a non-https APP_BASE_URL")
	}
	if !strings.Contains(err.Error(), "APP_BASE_URL") {
		t.Fatalf("error does not mention APP_BASE_URL:\n%s", err)
	}
}

// TestLoadAllowsLocalhostAppBaseURL documents the exemption: local development
// traffic never leaves the machine, so requiring https there would be noise.
func TestLoadAllowsLocalhostAppBaseURL(t *testing.T) {
	clearEnv(t)
	env := validEnv()
	env["APP_BASE_URL"] = "http://localhost:3000"
	setEnv(t, env)

	if _, err := Load(); err != nil {
		t.Fatalf("Load() = %v, want nil for a localhost APP_BASE_URL", err)
	}
}

func TestLoadDefaultsPortAndAppBaseURL(t *testing.T) {
	clearEnv(t)
	setEnv(t, validEnv())

	cfg, err := Load()
	if err != nil {
		t.Fatalf("Load() = %v, want nil", err)
	}
	if cfg.Port != "8080" {
		t.Fatalf("Port = %q, want 8080", cfg.Port)
	}
	if cfg.AppBaseURL != "http://localhost:3000" {
		t.Fatalf("AppBaseURL = %q, want the localhost default", cfg.AppBaseURL)
	}
}

func TestLoadTrimsTrailingSlashFromAppBaseURL(t *testing.T) {
	clearEnv(t)
	env := validEnv()
	env["APP_BASE_URL"] = "https://app.studio.example/"
	setEnv(t, env)

	cfg, err := Load()
	if err != nil {
		t.Fatalf("Load() = %v, want nil", err)
	}
	if cfg.AppBaseURL != "https://app.studio.example" {
		t.Fatalf("AppBaseURL = %q, want the trailing slash removed", cfg.AppBaseURL)
	}
}
