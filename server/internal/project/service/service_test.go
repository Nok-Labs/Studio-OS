package service

import (
	"context"
	"errors"
	"testing"
	"time"

	"github.com/google/uuid"

	db "server/internal/platform/db/generated"
	"server/internal/project/model"
	"server/internal/project/projecterr"
	prepo "server/internal/project/repository"
)

// ===================================
// INPUT HELPERS (keep the tests readable)
// ===================================

func modelCreateProject(name string) model.CreateProjectInput {
	return model.CreateProjectInput{Name: name}
}

func modelUpdateProjectWithStatus(status string) model.UpdateProjectInput {
	return model.UpdateProjectInput{Status: &status}
}

func modelCreateTask(title string) model.CreateTaskInput {
	return model.CreateTaskInput{Title: title}
}

func modelCreateTaskWithArea(title, area string) model.CreateTaskInput {
	return model.CreateTaskInput{Title: title, Area: area}
}

func modelCreateTaskWithAssignee(title string, assignee *uuid.UUID) model.CreateTaskInput {
	return model.CreateTaskInput{Title: title, AssigneeID: assignee}
}

func modelUpdateTaskWithTags(tags []string) model.UpdateTaskInput {
	return model.UpdateTaskInput{Tags: tags}
}

// mockProjectRepo satisfies prepo.ProjectRepository. Unset methods panic —
// loudly — so tests fail fast if the service calls something a test didn't
// anticipate.
type mockProjectRepo struct {
	createProjectFn       func(ctx context.Context, ownerID uuid.UUID, name string, summary *string) (db.Project, error)
	getProjectByIDFn      func(ctx context.Context, id uuid.UUID) (db.Project, error)
	listProjectsForUserFn func(ctx context.Context, userID uuid.UUID) ([]db.Project, error)
	updateProjectFn       func(ctx context.Context, id uuid.UUID, name, summary, status *string, metadata []byte) (db.Project, error)
	softDeleteProjectFn   func(ctx context.Context, id uuid.UUID) error

	addProjectMemberFn    func(ctx context.Context, projectID, userID uuid.UUID) (db.ProjectMember, error)
	getProjectMemberFn    func(ctx context.Context, projectID, userID uuid.UUID) (db.ProjectMember, error)
	listProjectMembersFn  func(ctx context.Context, projectID uuid.UUID) ([]db.ProjectMember, error)
	removeProjectMemberFn func(ctx context.Context, projectID, userID uuid.UUID) error

	createTaskFn          func(ctx context.Context, projectID uuid.UUID, title string, description *string, area string, tags []string, status string, assigneeID *uuid.UUID, dueDate *time.Time) (db.Task, error)
	getTaskByIDFn         func(ctx context.Context, id uuid.UUID) (db.Task, error)
	listTasksByProjectFn  func(ctx context.Context, projectID uuid.UUID) ([]db.Task, error)
	listTasksByAssigneeFn func(ctx context.Context, userID uuid.UUID) ([]db.Task, error)
	updateTaskFn          func(ctx context.Context, id uuid.UUID, title, description, area *string, tags []string) (db.Task, error)
	updateTaskStatusFn    func(ctx context.Context, id uuid.UUID, status string) (db.Task, error)
	setTaskAssigneeFn     func(ctx context.Context, id uuid.UUID, assigneeID *uuid.UUID) (db.Task, error)
	setTaskDueDateFn      func(ctx context.Context, id uuid.UUID, dueDate *time.Time) (db.Task, error)
	deleteTaskFn          func(ctx context.Context, id uuid.UUID) error
	withTxFn              func(ctx context.Context, fn func(prepo.ProjectRepository) error) error
}

func (mock *mockProjectRepo) notSet(method string) {
	panic("mockProjectRepo: " + method + " called but not set")
}

func (mock *mockProjectRepo) CreateProject(ctx context.Context, ownerID uuid.UUID, name string, summary *string) (db.Project, error) {
	if mock.createProjectFn != nil {
		return mock.createProjectFn(ctx, ownerID, name, summary)
	}
	mock.notSet("CreateProject")
	return db.Project{}, nil
}

func (mock *mockProjectRepo) GetProjectByID(ctx context.Context, id uuid.UUID) (db.Project, error) {
	if mock.getProjectByIDFn != nil {
		return mock.getProjectByIDFn(ctx, id)
	}
	mock.notSet("GetProjectByID")
	return db.Project{}, nil
}

func (mock *mockProjectRepo) ListProjectsForUser(ctx context.Context, userID uuid.UUID) ([]db.Project, error) {
	if mock.listProjectsForUserFn != nil {
		return mock.listProjectsForUserFn(ctx, userID)
	}
	mock.notSet("ListProjectsForUser")
	return nil, nil
}

func (mock *mockProjectRepo) UpdateProject(ctx context.Context, id uuid.UUID, name, summary, status *string, metadata []byte) (db.Project, error) {
	if mock.updateProjectFn != nil {
		return mock.updateProjectFn(ctx, id, name, summary, status, metadata)
	}
	mock.notSet("UpdateProject")
	return db.Project{}, nil
}

func (mock *mockProjectRepo) SoftDeleteProject(ctx context.Context, id uuid.UUID) error {
	if mock.softDeleteProjectFn != nil {
		return mock.softDeleteProjectFn(ctx, id)
	}
	mock.notSet("SoftDeleteProject")
	return nil
}

func (mock *mockProjectRepo) AddProjectMember(ctx context.Context, projectID, userID uuid.UUID) (db.ProjectMember, error) {
	if mock.addProjectMemberFn != nil {
		return mock.addProjectMemberFn(ctx, projectID, userID)
	}
	mock.notSet("AddProjectMember")
	return db.ProjectMember{}, nil
}

func (mock *mockProjectRepo) GetProjectMember(ctx context.Context, projectID, userID uuid.UUID) (db.ProjectMember, error) {
	if mock.getProjectMemberFn != nil {
		return mock.getProjectMemberFn(ctx, projectID, userID)
	}
	mock.notSet("GetProjectMember")
	return db.ProjectMember{}, nil
}

func (mock *mockProjectRepo) ListProjectMembers(ctx context.Context, projectID uuid.UUID) ([]db.ProjectMember, error) {
	if mock.listProjectMembersFn != nil {
		return mock.listProjectMembersFn(ctx, projectID)
	}
	mock.notSet("ListProjectMembers")
	return nil, nil
}

func (mock *mockProjectRepo) RemoveProjectMember(ctx context.Context, projectID, userID uuid.UUID) error {
	if mock.removeProjectMemberFn != nil {
		return mock.removeProjectMemberFn(ctx, projectID, userID)
	}
	mock.notSet("RemoveProjectMember")
	return nil
}

func (mock *mockProjectRepo) CreateTask(ctx context.Context, projectID uuid.UUID, title string, description *string, area string, tags []string, status string, assigneeID *uuid.UUID, dueDate *time.Time) (db.Task, error) {
	if mock.createTaskFn != nil {
		return mock.createTaskFn(ctx, projectID, title, description, area, tags, status, assigneeID, dueDate)
	}
	mock.notSet("CreateTask")
	return db.Task{}, nil
}

func (mock *mockProjectRepo) GetTaskByID(ctx context.Context, id uuid.UUID) (db.Task, error) {
	if mock.getTaskByIDFn != nil {
		return mock.getTaskByIDFn(ctx, id)
	}
	mock.notSet("GetTaskByID")
	return db.Task{}, nil
}

func (mock *mockProjectRepo) ListTasksByProject(ctx context.Context, projectID uuid.UUID) ([]db.Task, error) {
	if mock.listTasksByProjectFn != nil {
		return mock.listTasksByProjectFn(ctx, projectID)
	}
	mock.notSet("ListTasksByProject")
	return nil, nil
}

func (mock *mockProjectRepo) ListTasksByAssignee(ctx context.Context, userID uuid.UUID) ([]db.Task, error) {
	if mock.listTasksByAssigneeFn != nil {
		return mock.listTasksByAssigneeFn(ctx, userID)
	}
	mock.notSet("ListTasksByAssignee")
	return nil, nil
}

func (mock *mockProjectRepo) UpdateTask(ctx context.Context, id uuid.UUID, title, description, area *string, tags []string) (db.Task, error) {
	if mock.updateTaskFn != nil {
		return mock.updateTaskFn(ctx, id, title, description, area, tags)
	}
	mock.notSet("UpdateTask")
	return db.Task{}, nil
}

func (mock *mockProjectRepo) UpdateTaskStatus(ctx context.Context, id uuid.UUID, status string) (db.Task, error) {
	if mock.updateTaskStatusFn != nil {
		return mock.updateTaskStatusFn(ctx, id, status)
	}
	mock.notSet("UpdateTaskStatus")
	return db.Task{}, nil
}

func (mock *mockProjectRepo) SetTaskAssignee(ctx context.Context, id uuid.UUID, assigneeID *uuid.UUID) (db.Task, error) {
	if mock.setTaskAssigneeFn != nil {
		return mock.setTaskAssigneeFn(ctx, id, assigneeID)
	}
	mock.notSet("SetTaskAssignee")
	return db.Task{}, nil
}

func (mock *mockProjectRepo) SetTaskDueDate(ctx context.Context, id uuid.UUID, dueDate *time.Time) (db.Task, error) {
	if mock.setTaskDueDateFn != nil {
		return mock.setTaskDueDateFn(ctx, id, dueDate)
	}
	mock.notSet("SetTaskDueDate")
	return db.Task{}, nil
}

func (mock *mockProjectRepo) DeleteTask(ctx context.Context, id uuid.UUID) error {
	if mock.deleteTaskFn != nil {
		return mock.deleteTaskFn(ctx, id)
	}
	mock.notSet("DeleteTask")
	return nil
}

func (mock *mockProjectRepo) WithTx(ctx context.Context, fn func(prepo.ProjectRepository) error) error {
	if mock.withTxFn != nil {
		return mock.withTxFn(ctx, fn)
	}
	mock.notSet("WithTx")
	return nil
}

// mockUserLookup satisfies the UserLookup interface.
type mockUserLookup struct {
	getUserByEmailFn func(ctx context.Context, email string) (db.User, error)
}

func (mock *mockUserLookup) GetUserByEmail(ctx context.Context, email string) (db.User, error) {
	if mock.getUserByEmailFn != nil {
		return mock.getUserByEmailFn(ctx, email)
	}
	return db.User{}, prepo.ErrNotFound
}

// fixture: a live project with a distinct owner and a nil metadata default.
var (
	fixtureOwnerID  = uuid.MustParse("aaaaaaaa-0000-0000-0000-000000000001")
	fixtureMemberID = uuid.MustParse("aaaaaaaa-0000-0000-0000-000000000002")
	fixtureProject  = db.Project{
		ID:       uuid.MustParse("bbbbbbbb-0000-0000-0000-000000000001"),
		OwnerID:  fixtureOwnerID,
		Name:     "Studio OS",
		Status:   "draft",
		Metadata: []byte("{}"),
	}
)

// liveProjectRepo returns a mock whose project lookups behave like the real
// schema (owner + optional member access), parameterised per test.
func liveProjectRepo() *mockProjectRepo {
	return &mockProjectRepo{
		getProjectByIDFn: func(ctx context.Context, id uuid.UUID) (db.Project, error) {
			if id != fixtureProject.ID {
				return db.Project{}, prepo.ErrNotFound
			}
			return fixtureProject, nil
		},
		getProjectMemberFn: func(ctx context.Context, projectID, userID uuid.UUID) (db.ProjectMember, error) {
			if projectID == fixtureProject.ID && userID == fixtureMemberID {
				return db.ProjectMember{ProjectID: projectID, UserID: userID}, nil
			}
			return db.ProjectMember{}, prepo.ErrNotFound
		},
	}
}

func newXServices(repo prepo.ProjectRepository, users UserLookup) *Services {
	return NewServices(repo, users)
}

// ===================================
// PROJECTS
// ===================================

func TestCreateProject(t *testing.T) {
	var capturedOwner uuid.UUID
	repo := &mockProjectRepo{
		createProjectFn: func(ctx context.Context, ownerID uuid.UUID, name string, summary *string) (db.Project, error) {
			capturedOwner = ownerID
			if name != "Studio OS" {
				t.Errorf("name = %q, want trimmed %q", name, "Studio OS")
			}
			return fixtureProject, nil
		},
	}
	svc := newXServices(repo, &mockUserLookup{})

	project, err := svc.Project.CreateProject(context.Background(), fixtureOwnerID, modelCreateProject("  Studio OS "))
	if err != nil {
		t.Fatalf("CreateProject() = %v, want nil", err)
	}
	if capturedOwner != fixtureOwnerID {
		t.Fatalf("owner = %s, want the caller", capturedOwner)
	}
	if project.Name != "Studio OS" {
		t.Fatalf("returned name = %q", project.Name)
	}

	if _, err := svc.Project.CreateProject(context.Background(), fixtureOwnerID, modelCreateProject("   ")); !errors.Is(err, projecterr.ErrInvalidProjectName) {
		t.Fatalf("blank name → %v, want ErrInvalidProjectName", err)
	}
}

// TestProjectVisibilityMatrix proves existence is not revealed to
// non-participants and soft-deleted projects vanish for everyone.
func TestProjectVisibilityMatrix(t *testing.T) {
	ctx := context.Background()
	svc := newXServices(liveProjectRepo(), &mockUserLookup{})

	if _, err := svc.Project.GetProject(ctx, fixtureOwnerID, fixtureProject.ID); err != nil {
		t.Fatalf("owner GetProject() = %v, want nil", err)
	}
	if _, err := svc.Project.GetProject(ctx, fixtureMemberID, fixtureProject.ID); err != nil {
		t.Fatalf("member GetProject() = %v, want nil", err)
	}
	outsider := uuid.New()
	if _, err := svc.Project.GetProject(ctx, outsider, fixtureProject.ID); !errors.Is(err, projecterr.ErrProjectNotFound) {
		t.Fatalf("outsider GetProject() = %v, want ErrProjectNotFound", err)
	}
	if _, err := svc.Project.GetProject(ctx, outsider, uuid.New()); !errors.Is(err, projecterr.ErrProjectNotFound) {
		t.Fatalf("unknown id GetProject() = %v, want ErrProjectNotFound", err)
	}

	deletedFixture := fixtureProject
	now := time.Now()
	deletedFixture.DeletedAt = &now
	repo := &mockProjectRepo{getProjectByIDFn: func(ctx context.Context, id uuid.UUID) (db.Project, error) { return deletedFixture, nil }}
	svc = newXServices(repo, &mockUserLookup{})
	if _, err := svc.Project.GetProject(ctx, fixtureOwnerID, fixtureProject.ID); !errors.Is(err, projecterr.ErrProjectNotFound) {
		t.Fatalf("owner GetProject(deleted) = %v, want ErrProjectNotFound (hidden, not error-prone)", err)
	}
}

func TestUpdateProjectOwnerOnly(t *testing.T) {
	ctx := context.Background()

	var capturedStatus *string
	repo := liveProjectRepo()
	repo.updateProjectFn = func(ctx context.Context, id uuid.UUID, name, summary, status *string, metadata []byte) (db.Project, error) {
		capturedStatus = status
		return fixtureProject, nil
	}
	svc := newXServices(repo, &mockUserLookup{})

	newStatus := "active"
	if _, err := svc.Project.UpdateProject(ctx, fixtureMemberID, fixtureProject.ID, modelUpdateProjectWithStatus(newStatus)); !errors.Is(err, projecterr.ErrNotProjectOwner) {
		t.Fatalf("member UpdateProject() = %v, want ErrNotProjectOwner", err)
	}
	if _, err := svc.Project.UpdateProject(ctx, fixtureOwnerID, fixtureProject.ID, modelUpdateProjectWithStatus(newStatus)); err != nil {
		t.Fatalf("owner UpdateProject() = %v, want nil", err)
	}
	if capturedStatus == nil || *capturedStatus != newStatus {
		t.Fatalf("status passed to repo = %v, want %q", capturedStatus, newStatus)
	}
	if _, err := svc.Project.UpdateProject(ctx, fixtureOwnerID, fixtureProject.ID, modelUpdateProjectWithStatus("paused")); !errors.Is(err, projecterr.ErrInvalidProjectStatus) {
		t.Fatalf("invalid status → %v, want ErrInvalidProjectStatus", err)
	}
}

// ===================================
// MEMBERS
// ===================================

func TestAddMemberScenarios(t *testing.T) {
	ctx := context.Background()
	newUser := db.User{ID: uuid.New(), Email: "teammate@example.com"}

	repo := liveProjectRepo()
	repo.addProjectMemberFn = func(ctx context.Context, projectID, userID uuid.UUID) (db.ProjectMember, error) {
		return db.ProjectMember{ProjectID: projectID, UserID: userID}, nil
	}

	// Owner invites a known email.
	users := &mockUserLookup{getUserByEmailFn: func(ctx context.Context, email string) (db.User, error) {
		if email == "TEammate@example.com" { // normalized before reaching here
			t.Errorf("email was not normalized: %q", email)
		}
		if email == "teammate@example.com" {
			return newUser, nil
		}
		return db.User{}, prepo.ErrNotFound
	}}
	svc := newXServices(repo, users)

	member, err := svc.Members.Add(ctx, fixtureOwnerID, fixtureProject.ID, "  TEammate@example.com ")
	if err != nil {
		t.Fatalf("owner Add() = %v, want nil", err)
	}
	if member.UserID != newUser.ID {
		t.Fatalf("member user = %s, want resolved user", member.UserID)
	}

	if _, err := svc.Members.Add(ctx, fixtureMemberID, fixtureProject.ID, "teammate@example.com"); !errors.Is(err, projecterr.ErrNotProjectOwner) {
		t.Fatalf("member Add() = %v, want ErrNotProjectOwner", err)
	}
	if _, err := svc.Members.Add(ctx, fixtureOwnerID, fixtureProject.ID, "ghost@example.com"); !errors.Is(err, projecterr.ErrUserNotFound) {
		t.Fatalf("Add(unknown email) = %v, want ErrUserNotFound", err)
	}

	dup := liveProjectRepo()
	dup.addProjectMemberFn = func(ctx context.Context, projectID, userID uuid.UUID) (db.ProjectMember, error) {
		return db.ProjectMember{}, prepo.ErrAlreadyExists
	}
	svc = newXServices(dup, users)
	if _, err := svc.Members.Add(ctx, fixtureOwnerID, fixtureProject.ID, "teammate@example.com"); !errors.Is(err, projecterr.ErrAlreadyMember) {
		t.Fatalf("Add(duplicate) = %v, want ErrAlreadyMember", err)
	}
}

func TestRemoveMemberMissing(t *testing.T) {
	ctx := context.Background()
	svc := newXServices(liveProjectRepo(), &mockUserLookup{})

	if err := svc.Members.Remove(ctx, fixtureOwnerID, fixtureProject.ID, uuid.New()); !errors.Is(err, projecterr.ErrMemberNotFound) {
		t.Fatalf("Remove() = %v, want ErrMemberNotFound", err)
	}
	if err := svc.Members.Remove(ctx, fixtureMemberID, fixtureProject.ID, fixtureMemberID); !errors.Is(err, projecterr.ErrNotProjectOwner) {
		t.Fatalf("member Remove() = %v, want ErrNotProjectOwner", err)
	}
}

// ===================================
// TASKS
// ===================================

func TestCreateTaskRules(t *testing.T) {
	ctx := context.Background()
	projectID := fixtureProject.ID

	var capturedArea string
	var capturedTags []string
	repo := liveProjectRepo()
	repo.createTaskFn = func(ctx context.Context, pid uuid.UUID, title string, description *string, area string, tags []string, status string, assigneeID *uuid.UUID, dueDate *time.Time) (db.Task, error) {
		capturedArea = area
		capturedTags = tags
		return db.Task{ID: uuid.New(), ProjectID: pid, Title: title, Area: area, Tags: tags, Status: status}, nil
	}
	svc := newXServices(repo, &mockUserLookup{})

	// Defaults: area → backend, nil tags → [].
	if _, err := svc.Tasks.Create(ctx, fixtureMemberID, projectID, modelCreateTask(" Ship it ")); err != nil {
		t.Fatalf("Create() = %v, want nil", err)
	}
	if capturedArea != "backend" {
		t.Fatalf("default area = %q, want backend", capturedArea)
	}
	if capturedTags == nil || len(capturedTags) != 0 {
		t.Fatalf("normalized tags = %v, want empty non-nil slice", capturedTags)
	}

	if _, err := svc.Tasks.Create(ctx, fixtureMemberID, projectID, modelCreateTaskWithArea("Ship it", "manager")); !errors.Is(err, projecterr.ErrInvalidTaskArea) {
		t.Fatalf("Create(invalid area) = %v, want ErrInvalidTaskArea", err)
	}

	// Assignment to a non-participant is refused; the owner is fine.
	assignee := uuid.New()
	if _, err := svc.Tasks.Create(ctx, fixtureMemberID, projectID, modelCreateTaskWithAssignee("Ship it", &assignee)); !errors.Is(err, projecterr.ErrAssigneeNotMember) {
		t.Fatalf("Assign(non-member) = %v, want ErrAssigneeNotMember", err)
	}
	if _, err := svc.Tasks.Create(ctx, fixtureMemberID, projectID, modelCreateTaskWithAssignee("Ship it", &fixtureOwnerID)); err != nil {
		t.Fatalf("Assign(owner) = %v, want nil", err)
	}
}

func TestUpdateTaskPartialSemantics(t *testing.T) {
	ctx := context.Background()
	taskID := uuid.New()
	task := db.Task{ID: taskID, ProjectID: fixtureProject.ID, Title: "Ship it", Area: "backend", Status: "todo"}

	var capturedTags []string
	repo := liveProjectRepo()
	repo.getTaskByIDFn = func(ctx context.Context, id uuid.UUID) (db.Task, error) {
		return task, nil
	}
	repo.updateTaskFn = func(ctx context.Context, id uuid.UUID, title, description, area *string, tags []string) (db.Task, error) {
		capturedTags = tags
		return task, nil
	}
	svc := newXServices(repo, &mockUserLookup{})

	if _, err := svc.Tasks.Update(ctx, fixtureMemberID, taskID, modelUpdateTaskWithTags(nil)); err != nil {
		t.Fatalf("member Update() = %v, want nil", err)
	}
	if capturedTags != nil {
		t.Fatalf("tags = %v, want nil (unchanged)", capturedTags)
	}

	if _, err := svc.Tasks.Update(ctx, uuid.New(), taskID, modelUpdateTaskWithTags(nil)); !errors.Is(err, projecterr.ErrProjectNotFound) {
		t.Fatalf("outsider Update() = %v, want ErrProjectNotFound", err)
	}
}

func TestSetStatusValidations(t *testing.T) {
	ctx := context.Background()
	taskID := uuid.New()
	task := db.Task{ID: taskID, ProjectID: fixtureProject.ID, Title: "Ship it", Area: "backend", Status: "todo"}

	var capturedStatus string
	repo := liveProjectRepo()
	repo.getTaskByIDFn = func(ctx context.Context, id uuid.UUID) (db.Task, error) {
		return task, nil
	}
	repo.updateTaskStatusFn = func(ctx context.Context, id uuid.UUID, status string) (db.Task, error) {
		capturedStatus = status
		return task, nil
	}
	svc := newXServices(repo, &mockUserLookup{})

	if _, err := svc.Tasks.SetStatus(ctx, fixtureOwnerID, taskID, "parked"); !errors.Is(err, projecterr.ErrInvalidTaskStatus) {
		t.Fatalf("SetStatus(parked) = %v, want ErrInvalidTaskStatus", err)
	}
	if _, err := svc.Tasks.SetStatus(ctx, fixtureOwnerID, taskID, "done"); err != nil {
		t.Fatalf("SetStatus(done) = %v, want nil", err)
	}
	if capturedStatus != "done" {
		t.Fatalf("status passed to repo = %q, want done", capturedStatus)
	}

	if _, err := svc.Tasks.SetStatus(ctx, uuid.New(), taskID, "done"); !errors.Is(err, projecterr.ErrProjectNotFound) {
		t.Fatalf("outsider SetStatus() = %v, want ErrProjectNotFound", err)
	}
}
