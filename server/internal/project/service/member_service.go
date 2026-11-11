package service

import (
	"context"
	"errors"
	"fmt"

	"github.com/google/uuid"

	"server/internal/project/model"
	"server/internal/project/projecterr"
	prepo "server/internal/project/repository"
)

// MemberService manages project membership: who is on the team. Changes are
// owner-only, which is why every method routes through loadOwnedProject.
type MemberService struct {
	repo  prepo.ProjectRepository
	users UserLookup
}

// Add resolves the email an owner typed into a user and grants membership.
// An email that belongs to no account returns ErrUserNotFound — the teammate
// simply creates an account first; nothing is pre-created, which is exactly
// why the invitations flow was skipped.
func (service *MemberService) Add(ctx context.Context, userID, projectID uuid.UUID, email string) (model.ProjectMember, error) {
	project, err := loadOwnedProject(ctx, service.repo, userID, projectID)
	if err != nil {
		return model.ProjectMember{}, err
	}

	normalized := normalizeEmail(email)
	if normalized == "" {
		return model.ProjectMember{}, fmt.Errorf("%w: email is required", projecterr.ErrUserNotFound)
	}

	user, err := service.users.GetUserByEmail(ctx, normalized)
	if err != nil {
		if errors.Is(err, prepo.ErrNotFound) {
			return model.ProjectMember{}, fmt.Errorf("%w: have them create an account first", projecterr.ErrUserNotFound)
		}
		return model.ProjectMember{}, err
	}

	member, err := service.repo.AddProjectMember(ctx, project.ID, user.ID)
	if err != nil {
		if errors.Is(err, prepo.ErrAlreadyExists) {
			return model.ProjectMember{}, projecterr.ErrAlreadyMember
		}
		return model.ProjectMember{}, err
	}
	return toModelMember(member), nil
}

// Remove revokes a membership grant. Revoking a grant that isn't there is
// ErrMemberNotFound, not silence, since the caller is naming a person.
func (service *MemberService) Remove(ctx context.Context, userID, projectID, targetUserID uuid.UUID) error {
	project, err := loadOwnedProject(ctx, service.repo, userID, projectID)
	if err != nil {
		return err
	}

	if _, err := service.repo.GetProjectMember(ctx, project.ID, targetUserID); err != nil {
		if errors.Is(err, prepo.ErrNotFound) {
			return projecterr.ErrMemberNotFound
		}
		return err
	}
	return service.repo.RemoveProjectMember(ctx, project.ID, targetUserID)
}

// List returns the project's members. Any participant may list.
func (service *MemberService) List(ctx context.Context, userID, projectID uuid.UUID) ([]model.ProjectMember, error) {
	project, err := loadVisibleProject(ctx, service.repo, userID, projectID)
	if err != nil {
		return nil, err
	}

	members, err := service.repo.ListProjectMembers(ctx, project.ID)
	if err != nil {
		return nil, err
	}

	out := make([]model.ProjectMember, 0, len(members))
	for _, member := range members {
		out = append(out, toModelMember(member))
	}
	return out, nil
}
