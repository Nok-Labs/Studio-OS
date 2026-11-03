// Package service implements the projects domain's business rules on top of
// its repository: who may touch what (owner vs member), how inputs are
// validated, and how database errors become domain sentinel errors.
//
// There are no roles. The domain has two access levels baked in:
//
//   - owner: full control — update/delete the project, manage members,
//     everything a member can do;
//   - member: work on the project — see it, and create, update, assign and
//     delete its tasks.
//
// A caller who is neither gets ErrProjectNotFound: existence is not revealed
// to non-participants. A member attempting an owner-only action gets
// ErrNotProjectOwner.
package service

import (
	"context"
	"errors"
	"strings"

	"github.com/google/uuid"

	db "server/internal/platform/db/generated"
	perr "server/internal/project/projecterr"
	prepo "server/internal/project/repository"
)

// UserLookup is the slice of the auth domain the projects domain needs: it
// resolves the email an owner typed into a real user. *authrepository.AuthRepository
// satisfies it, so production wiring just passes the auth repo.
type UserLookup interface {
	GetUserByEmail(ctx context.Context, email string) (db.User, error)
}

// Services bundles the projects domain's services.
type Services struct {
	Project *ProjectService
	Members *MemberService
	Tasks   *TaskService
}

// NewServices instantiates and wires the domain services.
func NewServices(repo prepo.ProjectRepository, users UserLookup) *Services {
	return &Services{
		Project: &ProjectService{repo: repo},
		Members: &MemberService{repo: repo, users: users},
		Tasks:   &TaskService{repo: repo},
	}
}

// ===================================
// ACCESS HELPERS
// ===================================

// loadVisibleProject loads a project — but only if the caller owns it or is a
// member. Unknown, soft-deleted, and invisibility all collapse into
// ErrProjectNotFound: a caller with no access sees exactly what a caller
// naming an id that doesn't exist sees.
func loadVisibleProject(ctx context.Context, repo prepo.ProjectRepository, callerID, projectID uuid.UUID) (db.Project, error) {
	project, err := repo.GetProjectByID(ctx, projectID)
	if err != nil {
		if errors.Is(err, prepo.ErrNotFound) {
			return db.Project{}, perr.ErrProjectNotFound
		}
		return db.Project{}, err
	}
	if project.DeletedAt != nil {
		return db.Project{}, perr.ErrProjectNotFound
	}
	if project.OwnerID == callerID {
		return project, nil
	}
	if _, err := repo.GetProjectMember(ctx, project.ID, callerID); err != nil {
		if errors.Is(err, prepo.ErrNotFound) {
			return db.Project{}, perr.ErrProjectNotFound
		}
		return db.Project{}, err
	}
	return project, nil
}

// loadOwnedProject is loadVisibleProject plus the owner requirement. Order
// matters: a member gets ErrNotProjectOwner (they can see the project); a
// non-member still gets ErrProjectNotFound (they cannot).
func loadOwnedProject(ctx context.Context, repo prepo.ProjectRepository, callerID, projectID uuid.UUID) (db.Project, error) {
	project, err := loadVisibleProject(ctx, repo, callerID, projectID)
	if err != nil {
		return db.Project{}, err
	}
	if project.OwnerID != callerID {
		return db.Project{}, perr.ErrNotProjectOwner
	}
	return project, nil
}

// ensureMember checks userID is a participant of the project (owner or a
// member row). Used when validating task assignment.
func ensureAssignee(ctx context.Context, repo prepo.ProjectRepository, project db.Project, assigneeID uuid.UUID) error {
	if project.OwnerID == assigneeID {
		return nil
	}
	if _, err := repo.GetProjectMember(ctx, project.ID, assigneeID); err != nil {
		if errors.Is(err, prepo.ErrNotFound) {
			return perr.ErrAssigneeNotMember
		}
		return err
	}
	return nil
}

// normalizeEmail canonicalizes an email the same way the auth domain does
// before any lookup or storage: lowercase, trimmed.
func normalizeEmail(email string) string {
	return strings.ToLower(strings.TrimSpace(email))
}

// contains is the whitelist membership test used for statuses and areas.
func contains(allowed []string, value string) bool {
	for _, a := range allowed {
		if a == value {
			return true
		}
	}
	return false
}
