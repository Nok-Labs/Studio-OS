package mailer

import (
	"context"
	"log/slog"
)

// NoOpMailer is a mock mailer that logs emails instead of sending them.
// Useful for local development and testing.
type NoOpMailer struct{}

func NewNoOpMailer() *NoOpMailer {
	return &NoOpMailer{}
}

func (m *NoOpMailer) SendOTP(ctx context.Context, email, code string) error {
	slog.Info("Simulating sending OTP email", "email", email, "code", code)
	return nil
}

func (m *NoOpMailer) SendPasswordReset(ctx context.Context, email, code string) error {
	slog.Info("Simulating sending Password Reset email", "email", email, "code", code)
	return nil
}
