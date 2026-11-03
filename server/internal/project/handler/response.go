package handler

import (
	"encoding/json"
	"time"

	"github.com/google/uuid"

	"server/internal/project/model"
)

// Response envelopes for the projects domain. Every success reply is
// {"data": ...}; failures are the shared ErrorEnvelope from
// internal/platform/apiresponse, chosen by internal/project/httperr.

// ProjectResponse is the wire shape of a project. deleted_at is omitted
// unless actually deleted (clients should never normally see it).
type ProjectResponse struct {
	ID        uuid.UUID       `json:"id"`
	OwnerID   uuid.UUID       `json:"owner_id"`
	Name      string          `json:"name"`
	Summary   *string         `json:"summary"`
	Status    string          `json:"status"`
	Metadata  json.RawMessage `json:"metadata" swaggertype:"object"`
	DeletedAt *time.Time      `json:"deleted_at,omitempty"`
	CreatedAt time.Time       `json:"created_at"`
	UpdatedAt time.Time       `json:"updated_at"`
}

// ProjectMemberResponse is the wire shape of a membership grant.
type ProjectMemberResponse struct {
	ID        uuid.UUID `json:"id"`
	ProjectID uuid.UUID `json:"project_id"`
	UserID    uuid.UUID `json:"user_id"`
	CreatedAt time.Time `json:"created_at"`
}

// TaskResponse is the wire shape of a task.
type TaskResponse struct {
	ID          uuid.UUID  `json:"id"`
	ProjectID   uuid.UUID  `json:"project_id"`
	Title       string     `json:"title"`
	Description *string    `json:"description"`
	Area        string     `json:"area"`
	Tags        []string   `json:"tags"`
	Status      string     `json:"status"`
	AssigneeID  *uuid.UUID `json:"assignee_id"`
	DueDate     *time.Time `json:"due_date"`
	CreatedAt   time.Time  `json:"created_at"`
	UpdatedAt   time.Time  `json:"updated_at"`
}

type ProjectEnvelope struct {
	Data ProjectResponse `json:"data"`
}

type ProjectListEnvelope struct {
	Data []ProjectResponse `json:"data"`
}

type MembersEnvelope struct {
	Data []ProjectMemberResponse `json:"data"`
}

type MemberEnvelope struct {
	Data ProjectMemberResponse `json:"data"`
}

type TaskEnvelope struct {
	Data TaskResponse `json:"data"`
}

type TaskListEnvelope struct {
	Data []TaskResponse `json:"data"`
}

// project builds the wire DTO from the domain model. An empty metadata value
// is normalised to a JSON object so clients always read an object, not null.
func toProjectResponse(project model.Project) ProjectResponse {
	metadata := project.Metadata
	if len(metadata) == 0 || string(metadata) == "null" {
		metadata = json.RawMessage("{}")
	}
	return ProjectResponse{
		ID:        project.ID,
		OwnerID:   project.OwnerID,
		Name:      project.Name,
		Summary:   project.Summary,
		Status:    project.Status,
		Metadata:  metadata,
		DeletedAt: project.DeletedAt,
		CreatedAt: project.CreatedAt,
		UpdatedAt: project.UpdatedAt,
	}
}

func projectListResponse(projects []model.Project) []ProjectResponse {
	out := make([]ProjectResponse, 0, len(projects))
	for _, project := range projects {
		out = append(out, toProjectResponse(project))
	}
	return out
}

func toMemberResponse(member model.ProjectMember) ProjectMemberResponse {
	return ProjectMemberResponse{
		ID:        member.ID,
		ProjectID: member.ProjectID,
		UserID:    member.UserID,
		CreatedAt: member.CreatedAt,
	}
}

func memberListResponse(members []model.ProjectMember) []ProjectMemberResponse {
	out := make([]ProjectMemberResponse, 0, len(members))
	for _, member := range members {
		out = append(out, toMemberResponse(member))
	}
	return out
}

func toTaskResponse(task model.Task) TaskResponse {
	return TaskResponse{
		ID:          task.ID,
		ProjectID:   task.ProjectID,
		Title:       task.Title,
		Description: task.Description,
		Area:        task.Area,
		Tags:        task.Tags,
		Status:      task.Status,
		AssigneeID:  task.AssigneeID,
		DueDate:     task.DueDate,
		CreatedAt:   task.CreatedAt,
		UpdatedAt:   task.UpdatedAt,
	}
}

func taskListResponse(tasks []model.Task) []TaskResponse {
	out := make([]TaskResponse, 0, len(tasks))
	for _, task := range tasks {
		out = append(out, toTaskResponse(task))
	}
	return out
}
