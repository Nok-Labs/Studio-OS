package handler

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
	"server/internal/platform/apiresponse"
	db "server/internal/platform/db/generated"
	prepo "server/internal/project/repository"
	"server/internal/project/service"
)

// stubRepo satisfies prepo.ProjectRepository; unset methods panic loudly.
// Embedding the interface keeps the stub honest about what the handler
// actually touches — and nothing here exercises WithTx.
type stubRepo struct {
	prepo.ProjectRepository

	getProjectByIDFn func(ctx context.Context, id uuid.UUID) (db.Project, error)
	createProjectFn  func(ctx context.Context, ownerID uuid.UUID, name string, summary *string) (db.Project, error)
}

func (stub *stubRepo) GetProjectByID(ctx context.Context, id uuid.UUID) (db.Project, error) {
	if stub.getProjectByIDFn != nil {
		return stub.getProjectByIDFn(ctx, id)
	}
	panic("stubRepo: GetProjectByID not set")
}

func (stub *stubRepo) CreateProject(ctx context.Context, ownerID uuid.UUID, name string, summary *string) (db.Project, error) {
	if stub.createProjectFn != nil {
		return stub.createProjectFn(ctx, ownerID, name, summary)
	}
	panic("stubRepo: CreateProject not set")
}

// stubUserLookup satisfies service.UserLookup; the member tests never reach
// it, and the project tests don't either.
type stubUserLookup struct{}

func (stubUserLookup) GetUserByEmail(ctx context.Context, email string) (db.User, error) {
	return db.User{}, prepo.ErrNotFound
}

// newTestRouter builds Echo with the same error handling and actor seeding the
// real pipeline's RequireAuth provides — but bolted on directly, so the tests
// run without a token issuer.
func newTestRouter(h *ProjectHandler, callerID uuid.UUID) *echo.Echo {
	e := echo.New()
	e.HTTPErrorHandler = apiresponse.ErrorHandler
	g := e.Group("/v1", func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			// RequireAuth seeds the context the same way.
			c.Set("user_id", callerID)
			return next(c)
		}
	})
	g.POST("/projects", h.CreateProject)
	g.GET("/projects/:id", h.GetProject)
	return e
}

func authedRequest(e *echo.Echo, method, target, body string) *httptest.ResponseRecorder {
	req := httptest.NewRequest(method, target, strings.NewReader(body))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	rec := httptest.NewRecorder()
	e.ServeHTTP(rec, req)
	return rec
}

// TestCreateProjectHappyPath happy path: naked stub repo, disguised jwt
func TestCreateProjectHappyPath(t *testing.T) {
	caller := uuid.New()
	projectID := uuid.New()
	repo := &stubRepo{
		createProjectFn: func(ctx context.Context, ownerID uuid.UUID, name string, summary *string) (db.Project, error) {
			if ownerID != caller {
				t.Errorf("owner = %s, want the caller %s", ownerID, caller)
			}
			if name != "Studio OS" {
				t.Errorf("name = %q", name)
			}
			return db.Project{
				ID: projectID, OwnerID: ownerID, Name: name, Status: "draft", Metadata: []byte("{}"),
			}, nil
		},
	}
	h := NewProjectHandler(service.NewServices(repo, &stubUserLookup{}))

	rec := authedRequest(newTestRouter(h, caller), http.MethodPost, "/v1/projects", `{"name":"Studio OS"}`)
	if rec.Code != http.StatusCreated {
		t.Fatalf("status = %d, body = %s", rec.Code, rec.Body.String())
	}

	var payload struct {
		Data struct {
			ID     uuid.UUID `json:"id"`
			Status string    `json:"status"`
		} `json:"data"`
	}
	if err := json.Unmarshal(rec.Body.Bytes(), &payload); err != nil {
		t.Fatalf("body is not an envelope: %v", err)
	}
	if payload.Data.ID != projectID {
		t.Fatalf("data.id = %s, want %s", payload.Data.ID, projectID)
	}
	if payload.Data.Status != "draft" {
		t.Fatalf("data.status = %q, want draft", payload.Data.Status)
	}
}

// TestGetProjectNotFoundEnvelope proves an invisible or missing project is
// the same 404 envelope, not raw errors.
func TestGetProjectNotFoundEnvelope(t *testing.T) {
	repo := &stubRepo{
		getProjectByIDFn: func(ctx context.Context, id uuid.UUID) (db.Project, error) {
			return db.Project{}, prepo.ErrNotFound
		},
	}
	h := NewProjectHandler(service.NewServices(repo, &stubUserLookup{}))
	caller := uuid.New()

	rec := authedRequest(newTestRouter(h, caller), http.MethodGet, "/v1/projects/"+uuid.New().String(), "")
	if rec.Code != http.StatusNotFound {
		t.Fatalf("status = %d, body = %s", rec.Code, rec.Body.String())
	}
	var body struct {
		Error struct {
			Code string `json:"code"`
		} `json:"error"`
	}
	_ = json.Unmarshal(rec.Body.Bytes(), &body)
	if body.Error.Code != "project_not_found" {
		t.Fatalf("error.code = %q, want project_not_found", body.Error.Code)
	}
}

// TestGetProjectInvalidIDEnvelope proves a malformed id is a 400 envelope.
func TestGetProjectInvalidIDEnvelope(t *testing.T) {
	h := NewProjectHandler(service.NewServices(&stubRepo{}, &stubUserLookup{}))

	rec := authedRequest(newTestRouter(h, uuid.New()), http.MethodGet, "/v1/projects/not-a-uuid", "")
	if rec.Code != http.StatusBadRequest {
		t.Fatalf("status = %d, body = %s", rec.Code, rec.Body.String())
	}
}
