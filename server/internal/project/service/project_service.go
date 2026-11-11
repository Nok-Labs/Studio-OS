package service

import (
	"context"

	"github.com/google/uuid"

	"server/internal/project/model"
	"server/internal/project/projecterr"
	prepo "server/internal/project/repository"
)

// ProjectService handles the project lifecycle: create, view, update, soft
// delete, and the members of each project.
type ProjectService struct {
	repo prepo.ProjectRepository
}

// CreateProject creates a project owned by userID. The owner is not added as
// a member row: ownership is recorded by owner_id and membership is implied.
func (service *ProjectService) CreateProject(ctx context.Context, userID uuid.UUID, input model.CreateProjectInput) (model.Project, error) {
	name := trim(input.Name)
	if name == "" || len(name) > 255 {
		return model.Project{}, projecterr.ErrInvalidProjectName
	}

	project, err := service.repo.CreateProject(ctx, userID, name, input.Summary)
	if err != nil {
		return model.Project{}, err
	}
	return toModelProject(project), nil
}

// GetProject returns a project the caller owns or is a member of.
func (service *ProjectService) GetProject(ctx context.Context, userID, projectID uuid.UUID) (model.Project, error) {
	project, err := loadVisibleProject(ctx, service.repo, userID, projectID)
	if err != nil {
		return model.Project{}, err
	}
	return toModelProject(project), nil
}

// ListProjects returns every project the caller owns or is a member of, with
// deleted ones filtered out by the query.
func (service *ProjectService) ListProjects(ctx context.Context, userID uuid.UUID) ([]model.Project, error) {
	projects, err := service.repo.ListProjectsForUser(ctx, userID)
	if err != nil {
		return nil, err
	}
	out := make([]model.Project, 0, len(projects))
	for _, project := range projects {
		out = append(out, toModelProject(project))
	}
	return out, nil
}

// UpdateProject applies a partial update. Owner-only: members cannot change
// the project itself.
func (service *ProjectService) UpdateProject(ctx context.Context, userID, projectID uuid.UUID, input model.UpdateProjectInput) (model.Project, error) {
	project, err := loadOwnedProject(ctx, service.repo, userID, projectID)
	if err != nil {
		return model.Project{}, err
	}

	if input.Status != nil && !contains(model.ProjectStatuses, *input.Status) {
		return model.Project{}, projecterr.ErrInvalidProjectStatus
	}

	updated, err := service.repo.UpdateProject(
		ctx,
		project.ID,
		input.Name,
		input.Summary,
		input.Status,
		[]byte(input.Metadata),
	)
	if err != nil {
		return model.Project{}, err
	}
	return toModelProject(updated), nil
}

// DeleteProject soft-deletes a project. Owner-only. Tasks and members are
// hidden (not destroyed) — restoring is a single UPDATE away.
func (service *ProjectService) DeleteProject(ctx context.Context, userID, projectID uuid.UUID) error {
	project, err := loadOwnedProject(ctx, service.repo, userID, projectID)
	if err != nil {
		return err
	}
	return service.repo.SoftDeleteProject(ctx, project.ID)
}
