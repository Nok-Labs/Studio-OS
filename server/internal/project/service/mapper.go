package service

import (
	"encoding/json"
	"strings"

	"server/internal/platform/db/generated"
	"server/internal/project/model"
)

// toModelProject maps the generated db.Project to the domain model.
func toModelProject(project db.Project) model.Project {
	metadata := json.RawMessage(project.Metadata)
	if len(metadata) == 0 {
		metadata = json.RawMessage("null")
	}

	return model.Project{
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

// toModelMember maps the generated db.ProjectMember.
func toModelMember(member db.ProjectMember) model.ProjectMember {
	return model.ProjectMember{
		ID:        member.ID,
		ProjectID: member.ProjectID,
		UserID:    member.UserID,
		CreatedAt: member.CreatedAt,
	}
}

// toModelTask maps the generated db.Task.
func toModelTask(task db.Task) model.Task {
	return model.Task{
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

// trim trims surrounding whitespace from caller-supplied single words (names,
// titles) before validation and storage.
func trim(value string) string {
	return strings.TrimSpace(value)
}

// deref safely reads an optional string.
func deref(value *string) string {
	if value == nil {
		return ""
	}
	return *value
}
