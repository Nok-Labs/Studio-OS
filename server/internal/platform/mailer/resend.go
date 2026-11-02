package mailer

import (
	"context"
	"fmt"
	"log/slog"

	"github.com/resend/resend-go/v2"
)

// ResendMailer implements model.Mailer using the Resend API.
type ResendMailer struct {
	client      *resend.Client
	fromAddress string
	appBaseURL  string
}

// NewResendMailer constructs a Mailer that sends actual emails via Resend.
func NewResendMailer(apiKey, fromAddress, appBaseURL string) *ResendMailer {
	client := resend.NewClient(apiKey)
	return &ResendMailer{
		client:      client,
		fromAddress: fromAddress,
		appBaseURL:  appBaseURL,
	}
}

// SendOTP sends an email verification code.
func (m *ResendMailer) SendOTP(ctx context.Context, email, code string) error {
	params := &resend.SendEmailRequest{
		From:    m.fromAddress,
		To:      []string{email},
		Subject: "Your Verification Code",
		Html:    fmt.Sprintf("<p>Your verification code is: <strong>%s</strong></p><p>This code will expire in 15 minutes.</p>", code),
	}

	_, err := m.client.Emails.SendWithContext(ctx, params)
	if err != nil {
		slog.Error("Failed to send OTP email via Resend", "email", email, "error", err)
		return fmt.Errorf("failed to send OTP email: %w", err)
	}

	return nil
}

// SendPasswordReset sends a password reset code.
func (m *ResendMailer) SendPasswordReset(ctx context.Context, email, code string) error {
	params := &resend.SendEmailRequest{
		From:    m.fromAddress,
		To:      []string{email},
		Subject: "Password Reset Request",
		Html:    fmt.Sprintf("<p>Your password reset code is: <strong>%s</strong></p><p>If you did not request this, please ignore this email.</p>", code),
	}

	_, err := m.client.Emails.SendWithContext(ctx, params)
	if err != nil {
		slog.Error("Failed to send Password Reset email via Resend", "email", email, "error", err)
		return fmt.Errorf("failed to send Password Reset email: %w", err)
	}

	return nil
}
