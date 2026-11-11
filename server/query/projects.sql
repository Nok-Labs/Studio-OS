-- ===================================
-- PROJECTS
-- ===================================

-- name: CreateProject :one
INSERT INTO projects (owner_id, name, summary)
VALUES ($1, $2, $3)
RETURNING *;

-- name: GetProjectByID :one
SELECT * FROM projects
WHERE id = $1;

-- name: ListProjectsForUser :many
-- Projects the user can touch: owned by them or shared with them as a member.
-- The LEFT JOIN keeps owner-only projects that have no member rows yet.
SELECT DISTINCT p.*
FROM projects p
LEFT JOIN project_members m ON m.project_id = p.id AND m.user_id = $1
WHERE p.deleted_at IS NULL
  AND (p.owner_id = $1 OR m.user_id IS NOT NULL);

-- name: UpdateProject :one
-- Partial update: NULLs for a field leave it unchanged. Passing an empty JSON
-- object to metadata clears it; sqlc.narg cannot express an explicit NULL.
UPDATE projects SET
  name     = COALESCE(sqlc.narg('name'), name),
  summary  = COALESCE(sqlc.narg('summary'), summary),
  status   = COALESCE(sqlc.narg('status'), status),
  metadata = COALESCE(sqlc.narg('metadata'), metadata)
WHERE id = sqlc.arg('id')
  AND deleted_at IS NULL
RETURNING *;

-- name: SoftDeleteProject :exec
UPDATE projects
SET deleted_at = now()
WHERE id = $1;

-- ===================================
-- PROJECT MEMBERS
-- ===================================

-- name: AddProjectMember :one
INSERT INTO project_members (project_id, user_id)
VALUES ($1, $2)
RETURNING *;

-- name: GetProjectMember :one
SELECT * FROM project_members
WHERE project_id = $1
  AND user_id = $2;

-- name: ListProjectMembers :many
SELECT * FROM project_members
WHERE project_id = $1;

-- name: RemoveProjectMember :exec
DELETE FROM project_members
WHERE project_id = $1
  AND user_id = $2;

-- ===================================
-- TASKS
-- ===================================

-- name: CreateTask :one
INSERT INTO tasks (project_id, title, description, area, tags, status, assignee_id, due_date)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
RETURNING *;

-- name: GetTaskByID :one
SELECT * FROM tasks
WHERE id = $1;

-- name: ListTasksByProject :many
SELECT * FROM tasks
WHERE project_id = $1;

-- name: ListTasksByAssignee :many
-- The login-time "my tasks" board: assigned to me, in projects still alive.
SELECT t.*
FROM tasks t
JOIN projects p ON p.id = t.project_id
WHERE t.assignee_id = $1
  AND p.deleted_at IS NULL;

-- name: UpdateTask :one
-- Partial update: NULLs for a field leave it unchanged.
UPDATE tasks SET
  title       = COALESCE(sqlc.narg('title'), title),
  description = COALESCE(sqlc.narg('description'), description),
  area        = COALESCE(sqlc.narg('area'), area),
  tags        = COALESCE(sqlc.narg('tags'), tags)
WHERE id = sqlc.arg('id')
RETURNING *;

-- name: UpdateTaskStatus :one
UPDATE tasks
SET status = $1
WHERE id = $2
RETURNING *;

-- name: SetTaskAssignee :one
-- Pass NULL to unassign.
UPDATE tasks
SET assignee_id = $1
WHERE id = $2
RETURNING *;

-- name: SetTaskDueDate :one
-- Pass NULL to clear.
UPDATE tasks
SET due_date = $1
WHERE id = $2
RETURNING *;

-- name: DeleteTask :exec
DELETE FROM tasks
WHERE id = $1;
