-- +goose Up
-- +goose StatementBegin

-- ============================================================================
-- PROJECTS
-- Lifecycle = status (work state) + deleted_at (existence). No flags.
-- Anything not yet earned as a column lives in `metadata`.
-- ============================================================================
CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    name VARCHAR(255) NOT NULL,
    summary TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'draft'
        CHECK (status IN ('draft', 'active', 'completed')),
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    deleted_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_projects_owner_id ON projects(owner_id);

-- ============================================================================
-- PROJECT MEMBERS
-- Plain membership: a row means the user can work on the project. No roles —
-- the team of five all get the same access. The owner is implied by
-- projects.owner_id and does not need a row here.
-- ============================================================================
CREATE TABLE project_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(project_id, user_id)
);

CREATE INDEX idx_project_members_user_id ON project_members(user_id);

-- ============================================================================
-- TASKS
-- `area` is the discipline the work belongs to. `tags` are free-form labels,
-- Postgres array style — filter with @> / && like GitHub labels.
-- ============================================================================
CREATE TABLE tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    area VARCHAR(50) NOT NULL DEFAULT 'backend'
        CHECK (area IN ('backend', 'frontend', 'design', 'doc')),
    tags TEXT[] NOT NULL DEFAULT '{}',
    status VARCHAR(50) NOT NULL DEFAULT 'todo'
        CHECK (status IN ('todo', 'in_progress', 'done')),
    assignee_id UUID REFERENCES users(id) ON DELETE SET NULL,
    due_date TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_tasks_project_id ON tasks(project_id);
CREATE INDEX idx_tasks_tags ON tasks USING gin (tags);
-- "my tasks on login" — this is the lookup that makes assignee_id worth having.
CREATE INDEX idx_tasks_assignee_id ON tasks(assignee_id);

-- ============================================================================
-- TRIGGERS (Reusing set_updated_at from 00001_auth_schema.sql)
-- ============================================================================
CREATE TRIGGER projects_updated_at BEFORE UPDATE ON projects FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER tasks_updated_at BEFORE UPDATE ON tasks FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS tasks CASCADE;
DROP TABLE IF EXISTS project_members CASCADE;
DROP TABLE IF EXISTS projects CASCADE;
-- +goose StatementEnd
