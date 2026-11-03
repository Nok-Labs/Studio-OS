// Package handler exposes the projects domain over HTTP. It binds requests,
// calls the service, and maps domain errors through internal/project/httperr;
// it contains no business rules.
package handler

import (
	"errors"
	"net/http"

	"github.com/google/uuid"

	"server/internal/auth/middleware"
	"server/internal/platform/apiresponse"
	phttperr "server/internal/project/httperr"
	"server/internal/project/model"
	"server/internal/project/service"

	"github.com/labstack/echo/v4"
)

// ProjectHandler serves the /v1/projects and /v1/tasks endpoints.
type ProjectHandler struct {
	svc *service.Services
}

// NewProjectHandler constructs the HTTP handler for the projects module.
func NewProjectHandler(svc *service.Services) *ProjectHandler {
	return &ProjectHandler{svc: svc}
}

// pathID parses a UUID from a route parameter, rejecting anything else with
// the envelope so param errors look exactly like body errors.
//
// Subtlety: apiresponse.Reject returns nil once the envelope is on the wire,
// so reporting success-after-writing needs a non-nil signal the handler can
// pass up. apiresponse.ErrorHandler ignores committed responses, so the
// sentinel is never double-written.
var errReplyAlreadyWritten = errors.New("handler: response already written")

func pathID(c echo.Context, name string) (uuid.UUID, error) {
	value := c.Param(name)
	id, err := uuid.Parse(value)
	if err != nil {
		if rejectErr := apiresponse.Reject(c, http.StatusBadRequest, "invalid_id", "That is not a valid identifier."); rejectErr != nil {
			return uuid.UUID{}, rejectErr
		}
		return uuid.UUID{}, errReplyAlreadyWritten
	}
	return id, nil
}

// ===================================
// PROJECTS
// ===================================

// CreateProject godoc
// @Summary      Create a project
// @Description  Creates a project owned by the caller. No member row is
// @Description  written for the owner; ownership is implied by owner_id.
// @Tags         projects
// @Produce      json
// @Security     BearerAuth
// @Success      201 {object} ProjectEnvelope "created"
// @Failure      400 {object} apiresponse.ErrorEnvelope "invalid_project_name"
// @Router       /v1/projects [post]
func (h *ProjectHandler) CreateProject(c echo.Context) error {
	var req CreateProjectRequest
	if err := c.Bind(&req); err != nil {
		return phttperr.InvalidBody(c)
	}

	out, err := h.svc.Project.CreateProject(c.Request().Context(), middleware.GetUserID(c), model.CreateProjectInput{
		Name:    req.Name,
		Summary: req.Summary,
	})
	if err != nil {
		return phttperr.Fail(c, err)
	}
	return c.JSON(http.StatusCreated, ProjectEnvelope{Data: toProjectResponse(out)})
}

// ListProjects godoc
// @Summary      List my projects
// @Description  Projects the caller owns or was added to, deleted ones hidden.
// @Tags         projects
// @Produce      json
// @Security     BearerAuth
// @Success      200 {object} ProjectListEnvelope
// @Router       /v1/projects [get]
func (h *ProjectHandler) ListProjects(c echo.Context) error {
	projects, err := h.svc.Project.ListProjects(c.Request().Context(), middleware.GetUserID(c))
	if err != nil {
		return phttperr.Fail(c, err)
	}
	return c.JSON(http.StatusOK, ProjectListEnvelope{Data: projectListResponse(projects)})
}

// GetProject godoc
// @Summary      Get a project
// @Tags         projects
// @Produce      json
// @Security     BearerAuth
// @Success      200 {object} ProjectEnvelope
// @Failure      404 {object} apiresponse.ErrorEnvelope "project_not_found"
// @Router       /v1/projects/{id} [get]
func (h *ProjectHandler) GetProject(c echo.Context) error {
	id, err := pathID(c, "id")
	if err != nil {
		return err
	}

	project, err := h.svc.Project.GetProject(c.Request().Context(), middleware.GetUserID(c), id)
	if err != nil {
		return phttperr.Fail(c, err)
	}
	return c.JSON(http.StatusOK, ProjectEnvelope{Data: toProjectResponse(project)})
}

// UpdateProject godoc
// @Summary      Update a project (owner-only)
// @Tags         projects
// @Produce      json
// @Security     BearerAuth
// @Success      200 {object} ProjectEnvelope
// @Failure      403 {object} apiresponse.ErrorEnvelope "project_owner_required"
// @Router       /v1/projects/{id} [patch]
func (h *ProjectHandler) UpdateProject(c echo.Context) error {
	id, err := pathID(c, "id")
	if err != nil {
		return err
	}

	var req UpdateProjectRequest
	if err := c.Bind(&req); err != nil {
		return phttperr.InvalidBody(c)
	}

	project, err := h.svc.Project.UpdateProject(c.Request().Context(), middleware.GetUserID(c), id, model.UpdateProjectInput{
		Name:     req.Name,
		Summary:  req.Summary,
		Status:   req.Status,
		Metadata: req.Metadata,
	})
	if err != nil {
		return phttperr.Fail(c, err)
	}
	return c.JSON(http.StatusOK, ProjectEnvelope{Data: toProjectResponse(project)})
}

// DeleteProject godoc
// @Summary      Soft-delete a project (owner-only)
// @Description  Marks the project deleted; its tasks and members are hidden,
// @Description  not destroyed.
// @Tags         projects
// @Produce      json
// @Security     BearerAuth
// @Success      204 "No Content"
// @Failure      404 {object} apiresponse.ErrorEnvelope "project_not_found"
// @Router       /v1/projects/{id} [delete]
func (h *ProjectHandler) DeleteProject(c echo.Context) error {
	id, err := pathID(c, "id")
	if err != nil {
		return err
	}

	if err := h.svc.Project.DeleteProject(c.Request().Context(), middleware.GetUserID(c), id); err != nil {
		return phttperr.Fail(c, err)
	}
	return c.NoContent(http.StatusNoContent)
}

// ===================================
// PROJECT MEMBERS
// ===================================

// AddMember godoc
// @Summary      Add a member by email (owner-only)
// @Tags         projects
// @Produce      json
// @Security     BearerAuth
// @Success      201 {object} MemberEnvelope
// @Failure      404 {object} apiresponse.ErrorEnvelope "user_not_found — no account with that email"
// @Failure      409 {object} apiresponse.ErrorEnvelope "already_member"
// @Router       /v1/projects/{id}/members [post]
func (h *ProjectHandler) AddMember(c echo.Context) error {
	id, err := pathID(c, "id")
	if err != nil {
		return err
	}

	var req AddMemberRequest
	if err := c.Bind(&req); err != nil {
		return phttperr.InvalidBody(c)
	}

	member, err := h.svc.Members.Add(c.Request().Context(), middleware.GetUserID(c), id, req.Email)
	if err != nil {
		return phttperr.Fail(c, err)
	}
	return c.JSON(http.StatusCreated, MemberEnvelope{Data: toMemberResponse(member)})
}

// ListMembers godoc
// @Summary      List a project's members
// @Tags         projects
// @Produce      json
// @Security     BearerAuth
// @Success      200 {object} MembersEnvelope
// @Router       /v1/projects/{id}/members [get]
func (h *ProjectHandler) ListMembers(c echo.Context) error {
	id, err := pathID(c, "id")
	if err != nil {
		return err
	}

	members, err := h.svc.Members.List(c.Request().Context(), middleware.GetUserID(c), id)
	if err != nil {
		return phttperr.Fail(c, err)
	}
	return c.JSON(http.StatusOK, MembersEnvelope{Data: memberListResponse(members)})
}

// RemoveMember godoc
// @Summary      Remove a member (owner-only)
// @Tags         projects
// @Produce      json
// @Security     BearerAuth
// @Success      204 "No Content"
// @Failure      404 {object} apiresponse.ErrorEnvelope "member_not_found"
// @Router       /v1/projects/{id}/members/{userId} [delete]
func (h *ProjectHandler) RemoveMember(c echo.Context) error {
	projectID, err := pathID(c, "id")
	if err != nil {
		return err
	}
	userID, err := pathID(c, "userId")
	if err != nil {
		return err
	}

	if err := h.svc.Members.Remove(c.Request().Context(), middleware.GetUserID(c), projectID, userID); err != nil {
		return phttperr.Fail(c, err)
	}
	return c.NoContent(http.StatusNoContent)
}

// ===================================
// TASKS
// ===================================

// CreateTask godoc
// @Summary      Create a task in a project
// @Tags         tasks
// @Produce      json
// @Security     BearerAuth
// @Success      201 {object} TaskEnvelope
// @Router       /v1/projects/{id}/tasks [post]
func (h *ProjectHandler) CreateTask(c echo.Context) error {
	projectID, err := pathID(c, "id")
	if err != nil {
		return err
	}

	var req CreateTaskRequest
	if err := c.Bind(&req); err != nil {
		return phttperr.InvalidBody(c)
	}

	task, err := h.svc.Tasks.Create(c.Request().Context(), middleware.GetUserID(c), projectID, model.CreateTaskInput{
		Title:       req.Title,
		Description: req.Description,
		Area:        req.Area,
		Tags:        req.Tags,
		Status:      req.Status,
		AssigneeID:  req.AssigneeID,
		DueDate:     req.DueDate,
	})
	if err != nil {
		return phttperr.Fail(c, err)
	}
	return c.JSON(http.StatusCreated, TaskEnvelope{Data: toTaskResponse(task)})
}

// ListProjectTasks godoc
// @Summary      List a project's tasks
// @Tags         tasks
// @Produce      json
// @Security     BearerAuth
// @Success      200 {object} TaskListEnvelope
// @Router       /v1/projects/{id}/tasks [get]
func (h *ProjectHandler) ListProjectTasks(c echo.Context) error {
	projectID, err := pathID(c, "id")
	if err != nil {
		return err
	}

	tasks, err := h.svc.Tasks.ListForProject(c.Request().Context(), middleware.GetUserID(c), projectID)
	if err != nil {
		return phttperr.Fail(c, err)
	}
	return c.JSON(http.StatusOK, TaskListEnvelope{Data: taskListResponse(tasks)})
}

// GetTask godoc
// @Summary      Get a task
// @Tags         tasks
// @Produce      json
// @Security     BearerAuth
// @Success      200 {object} TaskEnvelope
// @Router       /v1/tasks/{taskId} [get]
func (h *ProjectHandler) GetTask(c echo.Context) error {
	taskID, err := pathID(c, "taskId")
	if err != nil {
		return err
	}

	task, err := h.svc.Tasks.Get(c.Request().Context(), middleware.GetUserID(c), taskID)
	if err != nil {
		return phttperr.Fail(c, err)
	}
	return c.JSON(http.StatusOK, TaskEnvelope{Data: toTaskResponse(task)})
}

// ListMyTasks godoc
// @Summary      List the caller's assigned tasks
// @Description  The login-time board: tasks assigned to the caller across all
// @Description  live projects.
// @Tags         tasks
// @Produce      json
// @Security     BearerAuth
// @Success      200 {object} TaskListEnvelope
// @Router       /v1/tasks/me [get]
func (h *ProjectHandler) ListMyTasks(c echo.Context) error {
	tasks, err := h.svc.Tasks.ListMine(c.Request().Context(), middleware.GetUserID(c))
	if err != nil {
		return phttperr.Fail(c, err)
	}
	return c.JSON(http.StatusOK, TaskListEnvelope{Data: taskListResponse(tasks)})
}

// UpdateTask godoc
// @Summary      Update a task
// @Description  All fields are optional and act as partial updates; tags
// @Description  follow the tri-state (omitted = unchanged, [] = clear).
// @Tags         tasks
// @Produce      json
// @Security     BearerAuth
// @Success      200 {object} TaskEnvelope
// @Router       /v1/tasks/{taskId} [patch]
func (h *ProjectHandler) UpdateTask(c echo.Context) error {
	taskID, err := pathID(c, "taskId")
	if err != nil {
		return err
	}

	var req UpdateTaskRequest
	if err := c.Bind(&req); err != nil {
		return phttperr.InvalidBody(c)
	}

	task, err := h.svc.Tasks.Update(c.Request().Context(), middleware.GetUserID(c), taskID, model.UpdateTaskInput{
		Title:       req.Title,
		Description: req.Description,
		Area:        req.Area,
		Tags:        req.Tags,
		Status:      req.Status,
	})
	if err != nil {
		return phttperr.Fail(c, err)
	}
	return c.JSON(http.StatusOK, TaskEnvelope{Data: toTaskResponse(task)})
}

// SetTaskStatus godoc
// @Summary      Move a task's status
// @Tags         tasks
// @Produce      json
// @Security     BearerAuth
// @Success      200 {object} TaskEnvelope
// @Router       /v1/tasks/{taskId}/status [patch]
func (h *ProjectHandler) SetTaskStatus(c echo.Context) error {
	taskID, err := pathID(c, "taskId")
	if err != nil {
		return err
	}

	var req SetTaskStatusRequest
	if err := c.Bind(&req); err != nil {
		return phttperr.InvalidBody(c)
	}

	task, err := h.svc.Tasks.SetStatus(c.Request().Context(), middleware.GetUserID(c), taskID, req.Status)
	if err != nil {
		return phttperr.Fail(c, err)
	}
	return c.JSON(http.StatusOK, TaskEnvelope{Data: toTaskResponse(task)})
}

// SetTaskAssignee godoc
// @Summary      Assign or unassign ({"assignee_id": null}) a task
// @Tags         tasks
// @Produce      json
// @Security     BearerAuth
// @Success      200 {object} TaskEnvelope
// @Router       /v1/tasks/{taskId}/assignee [patch]
func (h *ProjectHandler) SetTaskAssignee(c echo.Context) error {
	taskID, err := pathID(c, "taskId")
	if err != nil {
		return err
	}

	var req SetTaskAssigneeRequest
	if err := c.Bind(&req); err != nil {
		return phttperr.InvalidBody(c)
	}

	task, err := h.svc.Tasks.SetAssignee(c.Request().Context(), middleware.GetUserID(c), taskID, req.AssigneeID)
	if err != nil {
		return phttperr.Fail(c, err)
	}
	return c.JSON(http.StatusOK, TaskEnvelope{Data: toTaskResponse(task)})
}

// SetTaskDueDate godoc
// @Summary      Set or clear (null) a task's due date
// @Tags         tasks
// @Produce      json
// @Security     BearerAuth
// @Success      200 {object} TaskEnvelope
// @Router       /v1/tasks/{taskId}/due-date [patch]
func (h *ProjectHandler) SetTaskDueDate(c echo.Context) error {
	taskID, err := pathID(c, "taskId")
	if err != nil {
		return err
	}

	var req SetTaskDueDateRequest
	if err := c.Bind(&req); err != nil {
		return phttperr.InvalidBody(c)
	}

	task, err := h.svc.Tasks.SetDueDate(c.Request().Context(), middleware.GetUserID(c), taskID, req.DueDate)
	if err != nil {
		return phttperr.Fail(c, err)
	}
	return c.JSON(http.StatusOK, TaskEnvelope{Data: toTaskResponse(task)})
}

// DeleteTask godoc
// @Summary      Delete a task
// @Tags         tasks
// @Produce      json
// @Security     BearerAuth
// @Success      204 "No Content"
// @Router       /v1/tasks/{taskId} [delete]
func (h *ProjectHandler) DeleteTask(c echo.Context) error {
	taskID, err := pathID(c, "taskId")
	if err != nil {
		return err
	}

	if err := h.svc.Tasks.Delete(c.Request().Context(), middleware.GetUserID(c), taskID); err != nil {
		return phttperr.Fail(c, err)
	}
	return c.NoContent(http.StatusNoContent)
}
