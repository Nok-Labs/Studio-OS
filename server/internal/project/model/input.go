package model

import (
	"encoding/json"
	"time"

	"github.com/google/uuid"
)

// CreateProjectInput carries what a caller may set at creation. The owner and
// the lifecycle fields are not caller choices: the caller becomes the owner,
// status starts at draft.
type CreateProjectInput struct {
	Name    string
	Summary *string
}

// UpdateProjectInput is a partial update — nil fields are left unchanged.
// Metadata semantics: nil = unchanged, non-null JSON replaces (so an explicit
// `{}` clears it, matching the repository contract).
type UpdateProjectInput struct {
	Name     *string
	Summary  *string
	Status   *string
	Metadata json.RawMessage
}

// CreateTaskInput carries what a caller may set at creation. Titles are
// required; area defaults to backend and status to todo when empty.
type CreateTaskInput struct {
	Title       string
	Description *string
	Area        string
	Tags        []string
	Status      string
	AssigneeID  *uuid.UUID
	DueDate     *time.Time
}

// UpdateTaskInput is a partial update — nil fields are left unchanged. Tags
// keep the repository's tri-state: nil = unchanged, non-nil = replace (an
// empty slice clears). Status and area take effect only when non-nil.
type UpdateTaskInput struct {
	Title       *string
	Description *string
	Area        *string
	Tags        []string
	Status      *string
}
