package token

import (
	"errors"
	"testing"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
)

func TestJWTIssueAndValidateRoundTrip(t *testing.T) {
	issuer := NewJWTIssuer("test-secret")
	userID := uuid.New()

	raw, err := issuer.Issue(userID, time.Minute)
	if err != nil {
		t.Fatalf("Issue returned error: %v", err)
	}

	claims, err := issuer.Validate(raw)
	if err != nil {
		t.Fatalf("Validate returned error: %v", err)
	}
	if claims.UserID != userID {
		t.Fatalf("claims.UserID = %s, want %s", claims.UserID, userID)
	}
}

func TestJWTValidateRejectsExpiredToken(t *testing.T) {
	issuer := NewJWTIssuer("test-secret")

	raw, err := issuer.Issue(uuid.New(), -time.Minute)
	if err != nil {
		t.Fatalf("Issue returned error: %v", err)
	}

	if _, err := issuer.Validate(raw); !errors.Is(err, ErrInvalidToken) {
		t.Fatalf("Validate(expired) = %v, want ErrInvalidToken", err)
	}
}

func TestJWTValidateRejectsWrongSecret(t *testing.T) {
	raw, err := NewJWTIssuer("secret-a").Issue(uuid.New(), time.Minute)
	if err != nil {
		t.Fatalf("Issue returned error: %v", err)
	}

	if _, err := NewJWTIssuer("secret-b").Validate(raw); !errors.Is(err, ErrInvalidToken) {
		t.Fatalf("Validate(wrong secret) = %v, want ErrInvalidToken", err)
	}
}

func TestJWTValidateRejectsGarbage(t *testing.T) {
	for _, raw := range []string{"", "not-a-jwt", "a.b.c"} {
		if _, err := NewJWTIssuer("test-secret").Validate(raw); !errors.Is(err, ErrInvalidToken) {
			t.Fatalf("Validate(%q) = %v, want ErrInvalidToken", raw, err)
		}
	}
}

// TestJWTValidatePinsHS256 ensures a token signed with a different HMAC
// variant is rejected even though it uses the same secret.
func TestJWTValidatePinsHS256(t *testing.T) {
	const secret = "test-secret"
	claims := Claims{
		UserID: uuid.New(),
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(time.Minute)),
		},
	}
	raw, err := jwt.NewWithClaims(jwt.SigningMethodHS512, claims).SignedString([]byte(secret))
	if err != nil {
		t.Fatalf("signing HS512 token: %v", err)
	}

	if _, err := NewJWTIssuer(secret).Validate(raw); !errors.Is(err, ErrInvalidToken) {
		t.Fatalf("Validate(HS512) = %v, want ErrInvalidToken", err)
	}
}
