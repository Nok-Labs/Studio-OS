package handler

// Request bodies accepted by the projects handlers. Response envelopes live
// in response.go; errors are mapped in internal/project/httperr.

import (
	"encoding/json"
	"time"

	"github.com/google/uuid"
)

// CreateProjectRequest starts a project; the caller becomes its owner.
type CreateProjectRequest struct {
	Name    string  `json:"name"`
	Summary *string `json:"summary"`
}

// UpdateProjectRequest is a partial update: omitted fields stay unchanged.
// Metadata: omitted = unchanged, `{}` replaces (clears) it.
type UpdateProjectRequest struct {
	Name     *string         `json:"name"`
	Summary  *string         `json:"summary"`
	Status   *string         `json:"status"`
	Metadata json.RawMessage `json:"metadata"`
}

// AddMemberRequest grants project membership by email. Unknown accounts are
// 404 — nothing is pre-created; the teammate signs up first.
type AddMemberRequest struct {
	Email string `json:"email"`
}

// CreateTaskRequest creates a task. Empty area defaults to backend and empty
// status to todo; nil assignee_id creates an unassigned task.
type CreateTaskRequest struct {
	Title       string     `json:"title"`
	Description *string    `json:"description"`
	Area        string     `json:"area"`
	Tags        []string   `json:"tags"`
	Status      string     `json:"status"`
	AssigneeID  *uuid.UUID `json:"assignee_id"`
	DueDate     *time.Time `json:"due_date"`
}

// UpdateTaskRequest is a partial update. Tags tri-state: omitted = unchanged,
// `[]` = clear.
type UpdateTaskRequest struct {
	Title       *string  `json:"title"`
	Description *string  `json:"description"`
	Area        *string  `json:"area"`
	Tags        []string `json:"tags"`
	Status      *string  `json:"status"`
}

// SetTaskStatusRequest moves the task along todo → in_progress → done.
type SetTaskStatusRequest struct {
	Status string `json:"status"`
}

// SetTaskAssigneeRequest assigns (value) or unassigns (null / omitted) a
// task. The assignee must be a project participant.
type SetTaskAssigneeRequest struct {
	AssigneeID *uuid.UUID `json:"assignee_id"`
}

// SetTaskDueDateRequest sets (value) or clears (null / omitted) a due date.
type SetTaskDueDateRequest struct {
	DueDate *time.Time `json:"due_date"`
}
