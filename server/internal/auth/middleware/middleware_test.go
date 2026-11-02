package middleware

import (
	"context"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
	"time"
	"server/internal/auth/repository"
	"server/internal/auth/token"
	db "server/internal/platform/db/generated"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
)

type stubRepository struct {
	repository.AuthRepository
	user db.User
	err  error
}

func (s *stubRepository) GetUserByID(ctx context.Context, id uuid.UUID) (db.User, error) {
	return s.user, s.err
}

func runMiddleware(t *testing.T, mw echo.MiddlewareFunc, setup func(c echo.Context)) (echo.Context, *httptest.ResponseRecorder, bool) {
	t.Helper()

	e := echo.New()
	rec := httptest.NewRecorder()
	c := e.NewContext(httptest.NewRequest(http.MethodGet, "/v1/users/me", nil), rec)
	if setup != nil {
		setup(c)
	}

	reached := false
	next := func(c echo.Context) error {
		reached = true
		return c.NoContent(http.StatusOK)
	}

	if err := mw(next)(c); err != nil {
		t.Fatalf("middleware returned %v; it must answer with c.JSON, not a bare error", err)
	}
	return c, rec, reached
}

func setUserID(id uuid.UUID) func(echo.Context) {
	return func(c echo.Context) { c.Set("user_id", id) }
}

func TestRequireAuth(t *testing.T) {
	secret := "secret-key-12345678901234567890"
	issuer := token.NewJWTIssuer(secret)
	userID := uuid.New()
	validToken, err := issuer.Issue(userID, 15*time.Minute)
	if err != nil {
		t.Fatalf("failed to issue token: %v", err)
	}

	t.Run("valid bearer token allows request and sets user_id", func(t *testing.T) {
		c, rec, reached := runMiddleware(t, RequireAuth(issuer), func(c echo.Context) {
			c.Request().Header.Set("Authorization", "Bearer "+validToken)
		})

		if !reached {
			t.Fatalf("handler not reached; status %d body %s", rec.Code, rec.Body.String())
		}
		if id := GetUserID(c); id != userID {
			t.Errorf("GetUserID = %s, want %s", id, userID)
		}
	})

	t.Run("missing authorization header rejects with 401", func(t *testing.T) {
		_, rec, reached := runMiddleware(t, RequireAuth(issuer), nil)
		if reached {
			t.Fatal("handler was reached without authorization header")
		}
		if rec.Code != http.StatusUnauthorized {
			t.Fatalf("status = %d, want 401", rec.Code)
		}
	})

	t.Run("malformed header rejects with 401", func(t *testing.T) {
		_, rec, reached := runMiddleware(t, RequireAuth(issuer), func(c echo.Context) {
			c.Request().Header.Set("Authorization", "InvalidHeaderFormat")
		})
		if reached {
			t.Fatal("handler was reached with malformed header")
		}
		if rec.Code != http.StatusUnauthorized {
			t.Fatalf("status = %d, want 401", rec.Code)
		}
	})

	t.Run("expired token rejects with 401", func(t *testing.T) {
		expiredToken, err := issuer.Issue(userID, -1*time.Minute)
		if err != nil {
			t.Fatalf("failed to issue token: %v", err)
		}
		_, rec, reached := runMiddleware(t, RequireAuth(issuer), func(c echo.Context) {
			c.Request().Header.Set("Authorization", "Bearer "+expiredToken)
		})
		if reached {
			t.Fatal("handler was reached with expired token")
		}
		if rec.Code != http.StatusUnauthorized {
			t.Fatalf("status = %d, want 401", rec.Code)
		}
	})
}

func TestLoadUserPutsActorInContext(t *testing.T) {
	id := uuid.New()
	repo := &stubRepository{user: db.User{ID: id, Email: "test@example.com"}}

	c, rec, reached := runMiddleware(t, LoadUser(repo), setUserID(id))

	if !reached {
		t.Fatalf("terminal handler not reached; status %d body %s", rec.Code, rec.Body.String())
	}

	actor := GetActor(c)
	if actor.UserID != id {
		t.Errorf("actor.UserID = %s, want %s", actor.UserID, id)
	}
	if actor.Email != "test@example.com" {
		t.Errorf("actor.Email = %s, want test@example.com", actor.Email)
	}
}

func TestLoadUserRefusesBlockedOrMissingAccounts(t *testing.T) {
	id := uuid.New()

	tests := []struct {
		name string
		repo *stubRepository
		want int
	}{
		{
			name: "suspended",
			repo: &stubRepository{user: db.User{ID: id, IsSuspended: true}},
			want: http.StatusForbidden,
		},
		{
			name: "deactivated",
			repo: &stubRepository{user: db.User{ID: id, IsDeactivated: true}},
			want: http.StatusForbidden,
		},
		{
			name: "no such user",
			repo: &stubRepository{err: repository.ErrNotFound},
			want: http.StatusUnauthorized,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			_, rec, reached := runMiddleware(t, LoadUser(tt.repo), setUserID(id))

			if reached {
				t.Fatal("terminal handler ran; the request should have been stopped")
			}
			if rec.Code != tt.want {
				t.Fatalf("status = %d, want %d (body: %s)", rec.Code, tt.want, rec.Body.String())
			}
			if !strings.Contains(rec.Body.String(), `"error"`) {
				t.Errorf("body %s is not the error envelope", rec.Body.String())
			}
		})
	}
}
