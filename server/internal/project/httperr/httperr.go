// Package httperr maps the projects domain's sentinel errors to the HTTP
// status, wire code and human message the API returns for each — the same
// discipline as the auth domain's httperr package.
//
// Default branch is the information-disclosure guard: an unrecognised error
// must never reach the client as anything but a fixed string.
package httperr

import (
	"errors"
	"net/http"

	"server/internal/platform/apiresponse"
	perr "server/internal/project/projecterr"

	"github.com/labstack/echo/v4"
)

// Fail writes the envelope error reply for a domain error, letting Classify
// choose the status and code.
func Fail(c echo.Context, err error) error {
	status, code, message := Classify(err)
	return apiresponse.Reject(c, status, code, message)
}

// InvalidBody is the reply for a body that cannot be parsed, so every Bind
// failure produces an identical reply.
func InvalidBody(c echo.Context) error {
	return apiresponse.Reject(c, http.StatusBadRequest, "invalid_body", "Could not read the request.")
}

// Classify maps a projects-domain error to its HTTP status and wire code.
func Classify(err error) (status int, code, message string) {
	switch {
	// 400 — the client can fix the request.
	case errors.Is(err, perr.ErrInvalidProjectName):
		return http.StatusBadRequest, "invalid_project_name", "Project name is required (max 255 characters)."
	case errors.Is(err, perr.ErrInvalidTaskTitle):
		return http.StatusBadRequest, "invalid_task_title", "Task title is required (max 255 characters)."
	case errors.Is(err, perr.ErrInvalidTaskArea):
		return http.StatusBadRequest, "invalid_task_area", "Area must be backend, frontend, design or doc."
	case errors.Is(err, perr.ErrInvalidTaskStatus):
		return http.StatusBadRequest, "invalid_task_status", "Status must be todo, in_progress or done."
	case errors.Is(err, perr.ErrInvalidProjectStatus):
		return http.StatusBadRequest, "invalid_project_status", "Status must be draft, active or completed."
	case errors.Is(err, perr.ErrTooManyTags):
		return http.StatusBadRequest, "too_many_tags", "A task can have at most 20 tags."
	case errors.Is(err, perr.ErrAssigneeNotMember):
		return http.StatusBadRequest, "assignee_not_member", "Assignee must be a member of the project."

	// 404 — not found, or deliberately invisible to the caller.
	case errors.Is(err, perr.ErrProjectNotFound), errors.Is(err, perr.ErrNoProjectAccess):
		return http.StatusNotFound, "project_not_found", "Project not found."
	case errors.Is(err, perr.ErrTaskNotFound), errors.Is(err, perr.ErrTaskNotAccessible):
		return http.StatusNotFound, "task_not_found", "Task not found."
	case errors.Is(err, perr.ErrMemberNotFound):
		return http.StatusNotFound, "member_not_found", "That user is not a member of this project."
	case errors.Is(err, perr.ErrUserNotFound):
		return http.StatusNotFound, "user_not_found", "No Studio account with that email. Have them sign up first."

	// 403 — the caller can see the resource but may not act on it.
	case errors.Is(err, perr.ErrNotProjectOwner):
		return http.StatusForbidden, "project_owner_required", "Only the project owner can do that."

	// 409 — a state conflict the client can resolve.
	case errors.Is(err, perr.ErrAlreadyMember):
		return http.StatusConflict, "already_member", "That user is already a member of this project."

	// 500 — anything unrecognised: never leak an unknown error.
	default:
		return http.StatusInternalServerError, "internal_error", "Something went wrong. Please try again."
	}
}
