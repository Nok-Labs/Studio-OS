// Package repository provides the persistence layer for the projects domain.
// It wraps the sqlc-generated *db.Queries and translates database-level errors
// (such as pgx.ErrNoRows and 23505) into domain-safe sentinel errors — the
// same discipline as the auth repository. Higher layers (service/handler)
// never import the generated db package directly.
package repository

import (
	"context"
	"errors"
	"fmt"
	"log"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/jackc/pgx/v5/pgtype"

	db "server/internal/platform/db/generated"
)

// ProjectRepository defines the persistence contract for projects, their
// members, and their tasks.
//
// WithTx supports read-decide-write units (member grants, task assignment)
// inside one transaction; production wiring supplies a TxBeginner via
// WithTxSource, exactly as the auth repository does.
type ProjectRepository interface {
	// ===================================
	// PROJECTS
	// ===================================

	CreateProject(ctx context.Context, ownerID uuid.UUID, name string, summary *string) (db.Project, error)
	GetProjectByID(ctx context.Context, id uuid.UUID) (db.Project, error)
	ListProjectsForUser(ctx context.Context, userID uuid.UUID) ([]db.Project, error)

	// UpdateProject applies a partial update: nil/NULL pointers leave the
	// field unchanged. metadata semantics: nil = unchanged, non-nil bytes =
	// replace (an empty `{}` therefore clears it). Soft-deleted projects are
	// not updateable; the query's deleted_at IS NULL guard surfaces as
	// ErrNotFound.
	UpdateProject(ctx context.Context, id uuid.UUID, name, summary, status *string, metadata []byte) (db.Project, error)

	// SoftDeleteProject marks the project deleted; its tasks, members and
	// history survive and are hidden rather than destroyed.
	SoftDeleteProject(ctx context.Context, id uuid.UUID) error

	// ===================================
	// PROJECT MEMBERS
	// ===================================

	// AddProjectMember grants plain membership. A duplicate grant
	// (UNIQUE(project_id, user_id)) surfaces as ErrAlreadyExists.
	AddProjectMember(ctx context.Context, projectID, userID uuid.UUID) (db.ProjectMember, error)
	GetProjectMember(ctx context.Context, projectID, userID uuid.UUID) (db.ProjectMember, error)
	ListProjectMembers(ctx context.Context, projectID uuid.UUID) ([]db.ProjectMember, error)
	RemoveProjectMember(ctx context.Context, projectID, userID uuid.UUID) error

	// ===================================
	// TASKS
	// ===================================

	CreateTask(ctx context.Context, projectID uuid.UUID, title string, description *string, area string, tags []string, status string, assigneeID *uuid.UUID, dueDate *time.Time) (db.Task, error)
	GetTaskByID(ctx context.Context, id uuid.UUID) (db.Task, error)
	ListTasksByProject(ctx context.Context, projectID uuid.UUID) ([]db.Task, error)

	// ListTasksByAssignee is the login-time "my tasks" board: tasks assigned
	// to the user in projects that are not soft-deleted.
	ListTasksByAssignee(ctx context.Context, userID uuid.UUID) ([]db.Task, error)

	// UpdateTask applies a partial update. Field semantics:
	//   - title, description, area: nil = unchanged
	//   - tags: nil = unchanged, non-nil slice = replace ([] clears)
	UpdateTask(ctx context.Context, id uuid.UUID, title, description, area *string, tags []string) (db.Task, error)

	// UpdateTaskStatus moves a task through todo / in_progress / done.
	UpdateTaskStatus(ctx context.Context, id uuid.UUID, status string) (db.Task, error)

	// SetTaskAssignee assigns or unassigns: assigneeID nil = unassign. The
	// caller is responsible for only letting a project member be assigned.
	SetTaskAssignee(ctx context.Context, id uuid.UUID, assigneeID *uuid.UUID) (db.Task, error)

	// SetTaskDueDate sets or clears: dueDate nil = clear.
	SetTaskDueDate(ctx context.Context, id uuid.UUID, dueDate *time.Time) (db.Task, error)

	DeleteTask(ctx context.Context, id uuid.UUID) error

	// ===================================
	// TRANSACTIONS
	// ===================================

	// WithTx runs fn inside a single database transaction, committing when fn
	// returns nil and rolling back when it returns an error or panics. fn
	// must use the repository handed to it, not the receiver.
	WithTx(ctx context.Context, fn func(ProjectRepository) error) error
}

// ErrTransactionsUnsupported is returned by WithTx when the repository was
// built without a transaction source. Production wiring must supply one via
// WithTxSource; tests that never exercise WithTx can omit it.
var ErrTransactionsUnsupported = errors.New(
	"repository: transactions are not configured; pass WithTxSource when constructing the repository",
)

// TxBeginner opens a database transaction. *pgxpool.Pool satisfies it.
type TxBeginner interface {
	Begin(ctx context.Context) (pgx.Tx, error)
}

// RepositoryOption customises a repository at construction time.
type RepositoryOption func(*projectRepositoryImpl)

// WithTxSource enables WithTx on the repository by supplying the pool or
// connection that transactions are started from.
func WithTxSource(beginner TxBeginner) RepositoryOption {
	return func(repo *projectRepositoryImpl) {
		repo.beginner = beginner
	}
}

type projectRepositoryImpl struct {
	queries  db.Querier
	beginner TxBeginner
}

// NewProjectRepository creates a new ProjectRepository backed by db.Querier.
// Without the WithTxSource option the repository still works, but WithTx
// returns ErrTransactionsUnsupported.
func NewProjectRepository(queries db.Querier, opts ...RepositoryOption) ProjectRepository {
	repo := &projectRepositoryImpl{queries: queries}
	for _, opt := range opts {
		opt(repo)
	}
	return repo
}

// WithTx runs fn in a transaction, committing on success and rolling back on
// error or panic.
func (repo *projectRepositoryImpl) WithTx(ctx context.Context, fn func(ProjectRepository) error) error {
	if repo.beginner == nil {
		return ErrTransactionsUnsupported
	}

	tx, err := repo.beginner.Begin(ctx)
	if err != nil {
		return fmt.Errorf("repository: begin transaction: %w", err)
	}

	// Rollback after a successful commit is a safe-to-ignore ErrTxClosed.
	// Rolling back on an aborted handler's panic is not optional: it must not
	// leave row locks held.
	committed := false
	defer func() {
		if !committed {
			if rbErr := tx.Rollback(ctx); rbErr != nil && !errors.Is(rbErr, pgx.ErrTxClosed) {
				log.Printf("projects repository: rollback failed: %v", rbErr)
			}
		}
	}()

	if err := fn(&projectRepositoryImpl{queries: db.New(tx)}); err != nil {
		return err
	}

	if err := tx.Commit(ctx); err != nil {
		return fmt.Errorf("repository: commit transaction: %w", err)
	}
	committed = true
	return nil
}

// ===================================
// PROJECTS
// ===================================

func (repo *projectRepositoryImpl) CreateProject(ctx context.Context, ownerID uuid.UUID, name string, summary *string) (db.Project, error) {
	project, err := repo.queries.CreateProject(ctx, db.CreateProjectParams{
		OwnerID: ownerID,
		Name:    name,
		Summary: summary,
	})
	return project, wrap(err)
}

func (repo *projectRepositoryImpl) GetProjectByID(ctx context.Context, id uuid.UUID) (db.Project, error) {
	project, err := repo.queries.GetProjectByID(ctx, id)
	return project, wrap(err)
}

func (repo *projectRepositoryImpl) ListProjectsForUser(ctx context.Context, userID uuid.UUID) ([]db.Project, error) {
	projects, err := repo.queries.ListProjectsForUser(ctx, userID)
	return projects, wrap(err)
}

func (repo *projectRepositoryImpl) UpdateProject(ctx context.Context, id uuid.UUID, name, summary, status *string, metadata []byte) (db.Project, error) {
	project, err := repo.queries.UpdateProject(ctx, db.UpdateProjectParams{
		Name:     toText(name),
		Summary:  summary,
		Status:   toText(status),
		Metadata: metadata,
		ID:       id,
	})
	return project, wrap(err)
}

func (repo *projectRepositoryImpl) SoftDeleteProject(ctx context.Context, id uuid.UUID) error {
	err := repo.queries.SoftDeleteProject(ctx, id)
	return wrap(err)
}

// ===================================
// PROJECT MEMBERS
// ===================================

func (repo *projectRepositoryImpl) AddProjectMember(ctx context.Context, projectID, userID uuid.UUID) (db.ProjectMember, error) {
	member, err := repo.queries.AddProjectMember(ctx, db.AddProjectMemberParams{
		ProjectID: projectID,
		UserID:    userID,
	})
	return member, wrap(err)
}

func (repo *projectRepositoryImpl) GetProjectMember(ctx context.Context, projectID, userID uuid.UUID) (db.ProjectMember, error) {
	member, err := repo.queries.GetProjectMember(ctx, db.GetProjectMemberParams{
		ProjectID: projectID,
		UserID:    userID,
	})
	return member, wrap(err)
}

func (repo *projectRepositoryImpl) ListProjectMembers(ctx context.Context, projectID uuid.UUID) ([]db.ProjectMember, error) {
	members, err := repo.queries.ListProjectMembers(ctx, projectID)
	return members, wrap(err)
}

func (repo *projectRepositoryImpl) RemoveProjectMember(ctx context.Context, projectID, userID uuid.UUID) error {
	err := repo.queries.RemoveProjectMember(ctx, db.RemoveProjectMemberParams{
		ProjectID: projectID,
		UserID:    userID,
	})
	return wrap(err)
}

// ===================================
// TASKS
// ===================================

func (repo *projectRepositoryImpl) CreateTask(ctx context.Context, projectID uuid.UUID, title string, description *string, area string, tags []string, status string, assigneeID *uuid.UUID, dueDate *time.Time) (db.Task, error) {
	task, err := repo.queries.CreateTask(ctx, db.CreateTaskParams{
		ProjectID:   projectID,
		Title:       title,
		Description: description,
		Area:        area,
		Tags:        tags,
		Status:      status,
		AssigneeID:  assigneeID,
		DueDate:     dueDate,
	})
	return task, wrap(err)
}

func (repo *projectRepositoryImpl) GetTaskByID(ctx context.Context, id uuid.UUID) (db.Task, error) {
	task, err := repo.queries.GetTaskByID(ctx, id)
	return task, wrap(err)
}

func (repo *projectRepositoryImpl) ListTasksByProject(ctx context.Context, projectID uuid.UUID) ([]db.Task, error) {
	tasks, err := repo.queries.ListTasksByProject(ctx, projectID)
	return tasks, wrap(err)
}

func (repo *projectRepositoryImpl) ListTasksByAssignee(ctx context.Context, userID uuid.UUID) ([]db.Task, error) {
	tasks, err := repo.queries.ListTasksByAssignee(ctx, &userID)
	return tasks, wrap(err)
}

func (repo *projectRepositoryImpl) UpdateTask(ctx context.Context, id uuid.UUID, title, description, area *string, tags []string) (db.Task, error) {
	task, err := repo.queries.UpdateTask(ctx, db.UpdateTaskParams{
		Title:       toText(title),
		Description: description,
		Area:        toText(area),
		Tags:        tags,
		ID:          id,
	})
	return task, wrap(err)
}

func (repo *projectRepositoryImpl) UpdateTaskStatus(ctx context.Context, id uuid.UUID, status string) (db.Task, error) {
	task, err := repo.queries.UpdateTaskStatus(ctx, db.UpdateTaskStatusParams{
		Status: status,
		ID:     id,
	})
	return task, wrap(err)
}

func (repo *projectRepositoryImpl) SetTaskAssignee(ctx context.Context, id uuid.UUID, assigneeID *uuid.UUID) (db.Task, error) {
	task, err := repo.queries.SetTaskAssignee(ctx, db.SetTaskAssigneeParams{
		AssigneeID: assigneeID,
		ID:         id,
	})
	return task, wrap(err)
}

func (repo *projectRepositoryImpl) SetTaskDueDate(ctx context.Context, id uuid.UUID, dueDate *time.Time) (db.Task, error) {
	task, err := repo.queries.SetTaskDueDate(ctx, db.SetTaskDueDateParams{
		DueDate: dueDate,
		ID:      id,
	})
	return task, wrap(err)
}

func (repo *projectRepositoryImpl) DeleteTask(ctx context.Context, id uuid.UUID) error {
	err := repo.queries.DeleteTask(ctx, id)
	return wrap(err)
}

// ===================================
// HELPERS & ERROR HANDLING
// ===================================

// Sentinel errors exposed by the repository package. Mirrors the auth
// repository so the error-mapping habit is identical across domains.
var (
	ErrNotFound         = errors.New("project not found")
	ErrAlreadyExists    = errors.New("record already exists")
	ErrPermissionDenied = errors.New("insufficient database privilege")
	ErrForeignKey       = errors.New("referenced record does not exist")
)

// wrap normalizes database-level errors (pgx, pgconn) into domain-safe errors.
func wrap(err error) error {
	if err == nil {
		return nil
	}

	if errors.Is(err, pgx.ErrNoRows) {
		return ErrNotFound
	}

	var pgErr *pgconn.PgError
	if errors.As(err, &pgErr) {
		switch pgErr.Code {
		case "42501": // insufficient_privilege
			return ErrPermissionDenied
		case "23505": // unique_violation — already a member, etc.
			return ErrAlreadyExists
		case "23503": // foreign_key_violation — assigning a non-member, etc.
			return ErrForeignKey
		}
	}

	return err
}

// toText maps a *string onto pgtype.Text, where nil means "leave unchanged"
// (the COALESCE(...) side of the partial updates).
func toText(value *string) pgtype.Text {
	if value == nil {
		return pgtype.Text{Valid: false}
	}
	return pgtype.Text{String: *value, Valid: true}
}
