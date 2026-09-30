// Package helpers provides internal utility and mapping functions for auth services.
package helpers

import (
	"context"
	"strings"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgtype"

	"server/internal/auth/config"
	"server/internal/auth/model"
	"server/internal/auth/repository"
	"server/internal/auth/utils"
	db "server/internal/db/generated"
)

// IssueTokenPair generates a signed HS256 access token and a cryptographic CSPRNG refresh token.
// The raw refresh token is returned to the caller, while its SHA-256 hash is persisted in the database.
func IssueTokenPair(
	ctx context.Context,
	repo repository.AuthRepository,
	jwtIssuer *utils.JWTIssuer,
	sessionConfig config.SessionConfig,
	userID uuid.UUID,
) (*model.TokenPair, error) {
	// 1. Issue signed HS256 JWT access token with configured TTL
	accessToken, err := jwtIssuer.Issue(userID, sessionConfig.AccessTokenTTL)
	if err != nil {
		return nil, err
	}

	// 2. Generate secure 32-byte CSPRNG refresh token and compute its SHA-256 hash
	rawRefreshToken, tokenHash, err := utils.GenerateRandomToken()
	if err != nil {
		return nil, err
	}

	// 3. Persist the refresh token hash with configured expiration window
	expiresAt := time.Now().Add(sessionConfig.RefreshTokenTTL)
	_, err = repo.CreateRefreshToken(ctx, userID, tokenHash, expiresAt)
	if err != nil {
		return nil, err
	}

	// 4. Return plaintext token pair to caller
	return &model.TokenPair{
		AccessToken:  accessToken,
		RefreshToken: rawRefreshToken,
	}, nil
}

// NormalizeEmail canonicalizes an email string by converting it to lowercase and stripping leading/trailing whitespace.
func NormalizeEmail(email string) string {
	return strings.ToLower(strings.TrimSpace(email))
}

// TextToPtr converts an sqlc-generated nullable pgtype.Text column into a Go *string pointer.
func TextToPtr(text pgtype.Text) *string {
	if !text.Valid {
		return nil
	}
	return &text.String
}

// MapToUserProfile converts internal database records (db.User and db.Profile) into the public domain UserProfile representation.
func MapToUserProfile(user db.User, profile db.Profile) *model.UserProfile {
	return &model.UserProfile{
		ID:          user.ID,
		Email:       user.Email,
		FirstName:   TextToPtr(profile.FirstName),
		LastName:    TextToPtr(profile.LastName),
		Username:    TextToPtr(profile.Username),
		DisplayName: TextToPtr(profile.DisplayName),
		AvatarURL:   TextToPtr(profile.AvatarUrl),
		IsVerified:  user.EmailVerifiedAt != nil,
	}
}
