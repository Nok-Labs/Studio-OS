// Package model defines the projects domain's view of data: the shapes
// services return to handlers and the inputs callers supply. It is free of
// database specifics — the service maps from the generated db structs.
package model

import (
	"encoding/json"
	"time"

	"github.com/google/uuid"
)

// Vocabulary kept here so services and (later) handlers validate against the
// same lists the schema's CHECK constraints enforce.
var (
	ProjectStatuses = []string{"draft", "active", "completed"}
	TaskStatuses    = []string{"todo", "in_progress", "done"}
	TaskAreas       = []string{"backend", "frontend", "design", "doc"}
)

// Project is a unit of work in the studio: owned by one person, worked on by
// members, composed of tasks. DeletedAt non-nil means soft-deleted; its tasks
// and members are hidden rather than destroyed. Metadata is the escape hatch
// for anything not yet worth a column.
type Project struct {
	ID        uuid.UUID
	OwnerID   uuid.UUID
	Name      string
	Summary   *string
	Status    string
	Metadata  json.RawMessage
	DeletedAt *time.Time
	CreatedAt time.Time
	UpdatedAt time.Time
}

// ProjectMember records a plain membership grant: a row means the user can
// work on the project. No roles — the team is flat; only ownership is special.
type ProjectMember struct {
	ID        uuid.UUID
	ProjectID uuid.UUID
	UserID    uuid.UUID
	CreatedAt time.Time
}

// Task is a unit of deliverable work inside a project. Area is the
// discipline; Tags are free-form labels; AssigneeID nil means unassigned.
type Task struct {
	ID          uuid.UUID
	ProjectID   uuid.UUID
	Title       string
	Description *string
	Area        string
	Tags        []string
	Status      string
	AssigneeID  *uuid.UUID
	DueDate     *time.Time
	CreatedAt   time.Time
	UpdatedAt   time.Time
}
