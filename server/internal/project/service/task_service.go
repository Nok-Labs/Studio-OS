package service

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"

	"server/internal/project/model"
	"server/internal/project/projecterr"
	prepo "server/internal/project/repository"
)

// TaskService handles the work items inside a project: creation, updates,
// status transitions, assignment and deletion. Every task operation is
// member-level — ownership of the project is not required to work on it.
type TaskService struct {
	repo prepo.ProjectRepository
}

// loadAccessibleTask fetches a task and applies the project visibility rule:
// if the caller cannot see the task's project, the task does not exist for
// them.
func (service *TaskService) loadAccessibleTask(ctx context.Context, callerID, taskID uuid.UUID) (model.Task, error) {
	task, err := service.repo.GetTaskByID(ctx, taskID)
	if err != nil {
		if errors.Is(err, prepo.ErrNotFound) {
			return model.Task{}, projecterr.ErrTaskNotFound
		}
		return model.Task{}, err
	}

	if _, err := loadVisibleProject(ctx, service.repo, callerID, task.ProjectID); err != nil {
		return model.Task{}, err
	}
	return toModelTask(task), nil
}

// validateTaskShape validates fields shared by create and update: title is
// checked by callers (create requires it, update allows nil), while area,
// status and tag count follow these rules: empty defaults are applied by the
// callers, "" for update means "not changing this field".
func validateTaskShape(area, status string, tags []string, checkStatus bool) error {
	if area != "" && !contains(model.TaskAreas, area) {
		return projecterr.ErrInvalidTaskArea
	}
	if checkStatus && status != "" && !contains(model.TaskStatuses, status) {
		return projecterr.ErrInvalidTaskStatus
	}
	if len(tags) > 20 {
		return projecterr.ErrTooManyTags
	}
	return nil
}

// Create creates a task in a project the caller participates in. Assigning is
// allowed only to participants. Nil tags become an empty slice so the NOT
// NULL column receives '{}' rather than SQL NULL.
func (service *TaskService) Create(ctx context.Context, userID, projectID uuid.UUID, input model.CreateTaskInput) (model.Task, error) {
	project, err := loadVisibleProject(ctx, service.repo, userID, projectID)
	if err != nil {
		return model.Task{}, err
	}

	title := trim(input.Title)
	if title == "" || len(title) > 255 {
		return model.Task{}, projecterr.ErrInvalidTaskTitle
	}

	area := input.Area
	if area == "" {
		area = "backend"
	}
	status := input.Status
	if status == "" {
		status = "todo"
	}
	if err := validateTaskShape(area, status, input.Tags, true); err != nil {
		return model.Task{}, err
	}

	tags := input.Tags
	if tags == nil {
		tags = []string{}
	}

	if input.AssigneeID != nil {
		if err := ensureAssignee(ctx, service.repo, project, *input.AssigneeID); err != nil {
			return model.Task{}, err
		}
	}

	task, err := service.repo.CreateTask(
		ctx,
		project.ID,
		title,
		input.Description,
		area,
		tags,
		status,
		input.AssigneeID,
		input.DueDate,
	)
	if err != nil {
		return model.Task{}, err
	}
	return toModelTask(task), nil
}

// Get returns one task the caller can see.
func (service *TaskService) Get(ctx context.Context, userID, taskID uuid.UUID) (model.Task, error) {
	return service.loadAccessibleTask(ctx, userID, taskID)
}

// ListForProject returns a project's tasks. Member-level.
func (service *TaskService) ListForProject(ctx context.Context, userID, projectID uuid.UUID) ([]model.Task, error) {
	if _, err := loadVisibleProject(ctx, service.repo, userID, projectID); err != nil {
		return nil, err
	}

	tasks, err := service.repo.ListTasksByProject(ctx, projectID)
	if err != nil {
		return nil, err
	}

	out := make([]model.Task, 0, len(tasks))
	for _, task := range tasks {
		out = append(out, toModelTask(task))
	}
	return out, nil
}

// ListMine returns the caller's assigned tasks across all live projects — the
// login-time board. Known MVP edge: tasks stay visible for a member who was
// removed from the project until they are reassigned.
func (service *TaskService) ListMine(ctx context.Context, userID uuid.UUID) ([]model.Task, error) {
	tasks, err := service.repo.ListTasksByAssignee(ctx, userID)
	if err != nil {
		return nil, err
	}

	out := make([]model.Task, 0, len(tasks))
	for _, task := range tasks {
		out = append(out, toModelTask(task))
	}
	return out, nil
}

// Update applies a partial task update. Tags: nil = unchanged, non-nil =
// replace (empty slice clears).
func (service *TaskService) Update(ctx context.Context, userID, taskID uuid.UUID, input model.UpdateTaskInput) (model.Task, error) {
	task, err := service.loadAccessibleTask(ctx, userID, taskID)
	if err != nil {
		return model.Task{}, err
	}

	if err := validateTaskShape(deref(input.Area), deref(input.Status), input.Tags, input.Status != nil); err != nil {
		return model.Task{}, err
	}

	updated, err := service.repo.UpdateTask(ctx, task.ID, input.Title, input.Description, input.Area, input.Tags)
	if err != nil {
		return model.Task{}, err
	}
	return toModelTask(updated), nil
}

// SetStatus moves a task along todo → in_progress → done.
func (service *TaskService) SetStatus(ctx context.Context, userID, taskID uuid.UUID, status string) (model.Task, error) {
	if status == "" || !contains(model.TaskStatuses, status) {
		return model.Task{}, projecterr.ErrInvalidTaskStatus
	}

	task, err := service.loadAccessibleTask(ctx, userID, taskID)
	if err != nil {
		return model.Task{}, err
	}

	updated, err := service.repo.UpdateTaskStatus(ctx, task.ID, status)
	if err != nil {
		return model.Task{}, err
	}
	return toModelTask(updated), nil
}

// SetAssignee assigns or unassigns (nil). The assignee must participate in
// the task's project.
func (service *TaskService) SetAssignee(ctx context.Context, userID, taskID uuid.UUID, assigneeID *uuid.UUID) (model.Task, error) {
	task, err := service.loadAccessibleTask(ctx, userID, taskID)
	if err != nil {
		return model.Task{}, err
	}

	if assigneeID != nil {
		project, err := loadVisibleProject(ctx, service.repo, userID, task.ProjectID)
		if err != nil {
			return model.Task{}, err
		}
		if err := ensureAssignee(ctx, service.repo, project, *assigneeID); err != nil {
			return model.Task{}, err
		}
	}

	updated, err := service.repo.SetTaskAssignee(ctx, task.ID, assigneeID)
	if err != nil {
		return model.Task{}, err
	}
	return toModelTask(updated), nil
}

// SetDueDate sets or clears (nil) a task's due date.
func (service *TaskService) SetDueDate(ctx context.Context, userID, taskID uuid.UUID, dueDate *time.Time) (model.Task, error) {
	task, err := service.loadAccessibleTask(ctx, userID, taskID)
	if err != nil {
		return model.Task{}, err
	}

	updated, err := service.repo.SetTaskDueDate(ctx, task.ID, dueDate)
	if err != nil {
		return model.Task{}, err
	}
	return toModelTask(updated), nil
}

// Delete removes a task entirely (no soft delete at task level — a project
// deletion hides them anyway). Member-level.
func (service *TaskService) Delete(ctx context.Context, userID, taskID uuid.UUID) error {
	task, err := service.loadAccessibleTask(ctx, userID, taskID)
	if err != nil {
		return err
	}
	return service.repo.DeleteTask(ctx, task.ID)
}
