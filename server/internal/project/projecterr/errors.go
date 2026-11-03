// Package projecterr holds the sentinel errors the projects domain returns.
// Services wrap database details into these so handlers can map them onto
// HTTP status codes without knowing anything about SQL.
//
// Error-hiding principle, carried over from auth: a caller who cannot see a
// project gets the same ErrProjectNotFound as a query for a project that
// truly does not exist — existence is never revealed to non-participants.
// ErrNotProjectOwner is the one deliberate leak: a member attempting an
// owner-only action on a project they can see gets a distinguishable 403.
package projecterr

import "errors"

var (
	// ErrProjectNotFound covers unknown, soft-deleted, and invisible projects.
	ErrProjectNotFound = errors.New("project not found")

	// ErrTaskNotFound covers unknown and invisible tasks.
	ErrTaskNotFound = errors.New("task not found")

	// ErrNoProjectAccess — the caller is neither owner nor member. Handlers
	// should map this to the same response as ErrProjectNotFound.
	ErrNoProjectAccess = errors.New("you do not have access to this project")

	// ErrNotProjectOwner — the caller can see the project but the action is
	// owner-only. Maps to 403.
	ErrNotProjectOwner = errors.New("only the project owner can do that")

	// ErrTaskNotAccessible — unknown, soft-deleted project behind it, or an
	// invisible task.
	ErrTaskNotAccessible = errors.New("task not found")

	// ERR_USER
	ErrUserNotFound = errors.New("no account with that email")

	// MEMBER
	ErrMemberNotFound = errors.New("that user is not a member of this project")
	ErrAlreadyMember  = errors.New("that user is already a member of this project")

	// ErrAssigneeNotMember — a task may only be assigned to someone who
	// participates in its project (owner or member).
	ErrAssigneeNotMember = errors.New("assignee must be a member of the project")

	// VALIDATION
	ErrInvalidProjectName   = errors.New("project name is required (max 255 characters)")
	ErrInvalidTaskTitle     = errors.New("task title is required (max 255 characters)")
	ErrInvalidProjectStatus = errors.New("invalid project status")
	ErrInvalidTaskStatus    = errors.New("invalid task status")
	ErrInvalidTaskArea      = errors.New("invalid task area")
	ErrTooManyTags          = errors.New("too many tags")
)
