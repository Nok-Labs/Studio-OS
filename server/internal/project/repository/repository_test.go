package repository

import (
	"context"
	"errors"
	"testing"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"

	db "server/internal/platform/db/generated"
)

// fakeQuerier is a test double satisfying db.Querier; only the hooks a test
// needs are set, the rest panic via the embedded nil interface… no: the
// embedded interface returns typed zero values. Each test sets the hooks it
// cares about.
type fakeQuerier struct {
	db.Querier

	createProjectFn    func(ctx context.Context, arg db.CreateProjectParams) (db.Project, error)
	getProjectByIDFn   func(ctx context.Context, id uuid.UUID) (db.Project, error)
	updateProjectFn    func(ctx context.Context, arg db.UpdateProjectParams) (db.Project, error)
	addProjectMemberFn func(ctx context.Context, arg db.AddProjectMemberParams) (db.ProjectMember, error)
	createTaskFn       func(ctx context.Context, arg db.CreateTaskParams) (db.Task, error)
	updateTaskFn       func(ctx context.Context, arg db.UpdateTaskParams) (db.Task, error)
	setTaskAssigneeFn  func(ctx context.Context, arg db.SetTaskAssigneeParams) (db.Task, error)
}

func (f *fakeQuerier) CreateProject(ctx context.Context, arg db.CreateProjectParams) (db.Project, error) {
	if f.createProjectFn != nil {
		return f.createProjectFn(ctx, arg)
	}
	return db.Project{}, nil
}

func (f *fakeQuerier) GetProjectByID(ctx context.Context, id uuid.UUID) (db.Project, error) {
	if f.getProjectByIDFn != nil {
		return f.getProjectByIDFn(ctx, id)
	}
	return db.Project{}, nil
}

func (f *fakeQuerier) UpdateProject(ctx context.Context, arg db.UpdateProjectParams) (db.Project, error) {
	if f.updateProjectFn != nil {
		return f.updateProjectFn(ctx, arg)
	}
	return db.Project{}, nil
}

func (f *fakeQuerier) AddProjectMember(ctx context.Context, arg db.AddProjectMemberParams) (db.ProjectMember, error) {
	if f.addProjectMemberFn != nil {
		return f.addProjectMemberFn(ctx, arg)
	}
	return db.ProjectMember{}, nil
}

func (f *fakeQuerier) CreateTask(ctx context.Context, arg db.CreateTaskParams) (db.Task, error) {
	if f.createTaskFn != nil {
		return f.createTaskFn(ctx, arg)
	}
	return db.Task{}, nil
}

func (f *fakeQuerier) UpdateTask(ctx context.Context, arg db.UpdateTaskParams) (db.Task, error) {
	if f.updateTaskFn != nil {
		return f.updateTaskFn(ctx, arg)
	}
	return db.Task{}, nil
}

func (f *fakeQuerier) SetTaskAssignee(ctx context.Context, arg db.SetTaskAssigneeParams) (db.Task, error) {
	if f.setTaskAssigneeFn != nil {
		return f.setTaskAssigneeFn(ctx, arg)
	}
	return db.Task{}, nil
}

// TestPartialUpdateProjectNilsMeanUnchanged pins the contract the service and
// handler rely on: a nil pointer in the repository signature must reach sqlc
// as an invalid pgtype.Text (NULL → COALESCE keeps the column), while a value
// must be valid.
func TestPartialUpdateProjectNilsMeanUnchanged(t *testing.T) {
	name := "renamed"
	status := "active"

	var captured db.UpdateProjectParams
	fake := &fakeQuerier{
		updateProjectFn: func(ctx context.Context, arg db.UpdateProjectParams) (db.Project, error) {
			captured = arg
			return db.Project{}, nil
		},
	}
	repo := NewProjectRepository(fake)

	if _, err := repo.UpdateProject(context.Background(), uuid.New(), &name, nil, &status, nil); err != nil {
		t.Fatalf("UpdateProject() = %v, want nil", err)
	}

	if !captured.Name.Valid || captured.Name.String != name {
		t.Errorf("name = %+v, want valid %q", captured.Name, name)
	}
	if captured.Summary != nil {
		t.Errorf("summary = %v, want nil (unchanged)", captured.Summary)
	}
	// Status is pgtype.Text — the generated map keeps it non-pointer.
	if !captured.Status.Valid || captured.Status.String != status {
		t.Errorf("status = %+v, want valid %q", captured.Status, status)
	}
	if captured.Metadata != nil {
		t.Errorf("metadata = %v, want nil slice (unchanged)", captured.Metadata)
	}
}

// TestUpdateTaskNilTagsMeanUnchanged pins the tags field's tri-state: nil
// slice = NULL = unchanged, non-nil slice (even empty) replaces.
func TestUpdateTaskNilTagsMeanUnchanged(t *testing.T) {
	var captured db.UpdateTaskParams
	fake := &fakeQuerier{
		updateTaskFn: func(ctx context.Context, arg db.UpdateTaskParams) (db.Task, error) {
			captured = arg
			return db.Task{}, nil
		},
	}
	repo := NewProjectRepository(fake)

	if _, err := repo.UpdateTask(context.Background(), uuid.New(), nil, nil, nil, nil); err != nil {
		t.Fatalf("UpdateTask() = %v, want nil", err)
	}
	if captured.Tags != nil {
		t.Errorf("tags = %v, want nil slice (unchanged)", captured.Tags)
	}

	if _, err := repo.UpdateTask(context.Background(), uuid.New(), nil, nil, nil, []string{}); err != nil {
		t.Fatalf("UpdateTask() = %v, want nil", err)
	}
	if captured.Tags == nil || len(captured.Tags) != 0 {
		t.Errorf("tags = %v, want empty non-nil slice (clears)", captured.Tags)
	}
}

func TestCreateProjectMapsArguments(t *testing.T) {
	owner := uuid.New()
	summary := "shipping the minimum"

	fake := &fakeQuerier{
		createProjectFn: func(ctx context.Context, arg db.CreateProjectParams) (db.Project, error) {
			if arg.OwnerID != owner {
				t.Errorf("owner_id = %s, want %s", arg.OwnerID, owner)
			}
			if arg.Name != "Studio OS" {
				t.Errorf("name = %q, want %q", arg.Name, "Studio OS")
			}
			if arg.Summary == nil || *arg.Summary != summary {
				t.Errorf("summary = %v, want %q", arg.Summary, summary)
			}
			return db.Project{Name: arg.Name}, nil
		},
	}
	repo := NewProjectRepository(fake)

	project, err := repo.CreateProject(context.Background(), owner, "Studio OS", &summary)
	if err != nil {
		t.Fatalf("CreateProject() = %v, want nil", err)
	}
	if project.Name != "Studio OS" {
		t.Fatalf("returned project name = %q", project.Name)
	}
}

func TestErrorMapping(t *testing.T) {
	t.Run("no rows becomes ErrNotFound", func(t *testing.T) {
		fake := &fakeQuerier{
			getProjectByIDFn: func(ctx context.Context, id uuid.UUID) (db.Project, error) {
				return db.Project{}, pgx.ErrNoRows
			},
		}
		if _, err := NewProjectRepository(fake).GetProjectByID(context.Background(), uuid.New()); !errors.Is(err, ErrNotFound) {
			t.Fatalf("GetProjectByID() = %v, want ErrNotFound", err)
		}
	})

	t.Run("unique violation becomes ErrAlreadyExists", func(t *testing.T) {
		fake := &fakeQuerier{
			addProjectMemberFn: func(ctx context.Context, arg db.AddProjectMemberParams) (db.ProjectMember, error) {
				return db.ProjectMember{}, &pgconn.PgError{Code: "23505"}
			},
		}
		if _, err := NewProjectRepository(fake).AddProjectMember(context.Background(), uuid.New(), uuid.New()); !errors.Is(err, ErrAlreadyExists) {
			t.Fatalf("AddProjectMember() = %v, want ErrAlreadyExists", err)
		}
	})

	t.Run("foreign key violation becomes ErrForeignKey", func(t *testing.T) {
		fake := &fakeQuerier{
			setTaskAssigneeFn: func(ctx context.Context, arg db.SetTaskAssigneeParams) (db.Task, error) {
				return db.Task{}, &pgconn.PgError{Code: "23503"}
			},
		}
		if _, err := NewProjectRepository(fake).SetTaskAssignee(context.Background(), uuid.New(), nil); !errors.Is(err, ErrForeignKey) {
			t.Fatalf("SetTaskAssignee() = %v, want ErrForeignKey", err)
		}
	})
}

// TestUnassignPassesNilPointer verifies SetTaskAssignee hands the nil pointer
// straight through so pgx renders an actual SQL NULL (unassign) rather than a
// UUID zero value.
func TestUnassignPassesNilPointer(t *testing.T) {
	var captured db.SetTaskAssigneeParams
	fake := &fakeQuerier{
		setTaskAssigneeFn: func(ctx context.Context, arg db.SetTaskAssigneeParams) (db.Task, error) {
			captured = arg
			return db.Task{}, nil
		},
	}

	if _, err := NewProjectRepository(fake).SetTaskAssignee(context.Background(), uuid.New(), nil); err != nil {
		t.Fatalf("SetTaskAssignee(nil) = %v, want nil", err)
	}
	if captured.AssigneeID != nil {
		t.Fatalf("assignee_id = %v, want nil pointer", captured.AssigneeID)
	}
}
