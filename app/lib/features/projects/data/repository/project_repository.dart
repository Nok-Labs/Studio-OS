import 'package:dart_either/dart_either.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studio_os/core/errors/error_mapper.dart';
import 'package:studio_os/features/projects/data/models/project.dart';
import 'package:studio_os/features/projects/data/models/task.dart';
import 'package:studio_os/features/projects/data/remote/project_remote.dart';

part 'project_repository.g.dart';

/// The translator layer for the projects domain. Like AuthRepository, it
/// mostly forwards to the remote — the interesting work (business rules,
/// "can this caller do this") already happened on the server. What it does
/// own is shape: methods here take and return typed models, so controllers
/// never see a raw envelope.
class ProjectRepository {
  final ProjectRemote _remote;

  ProjectRepository(this._remote);

  // ==== PROJECTS ====

  Future<Either<Failure, ProjectResponse>> createProject(
    CreateProjectRequest request,
  ) {
    return _remote.createProject(request);
  }

  Future<Either<Failure, ProjectListResponse>> listProjects() {
    return _remote.listProjects();
  }

  Future<Either<Failure, ProjectResponse>> getProject(String projectId) {
    return _remote.getProject(projectId);
  }

  Future<Either<Failure, ProjectResponse>> updateProject(
    String projectId,
    UpdateProjectRequest request,
  ) {
    return _remote.updateProject(projectId, request);
  }

  /// 403 project_owner_required lands here for non-owners — show it, don't
  /// even render destructive controls for non-owners (check data.ownerId
  /// against the profile id instead).
  Future<Either<Failure, void>> deleteProject(String projectId) {
    return _remote.deleteProject(projectId);
  }

  // ==== MEMBERS ====

  Future<Either<Failure, MemberListResponse>> listMembers(String projectId) {
    return _remote.listMembers(projectId);
  }

  Future<Either<Failure, ProjectMemberResponse>> addMember(
    String projectId,
    AddMemberRequest request,
  ) {
    return _remote.addMember(projectId, request);
  }

  Future<Either<Failure, void>> removeMember(String projectId, String userId) {
    return _remote.removeMember(projectId, userId);
  }

  // ==== TASKS ====

  Future<Either<Failure, TaskResponse>> createTask(
    String projectId,
    CreateTaskRequest request,
  ) {
    return _remote.createTask(projectId, request);
  }

  Future<Either<Failure, TaskListResponse>> listProjectTasks(String projectId) {
    return _remote.listProjectTasks(projectId);
  }

  Future<Either<Failure, TaskListResponse>> listMyTasks() {
    return _remote.listMyTasks();
  }

  Future<Either<Failure, TaskResponse>> getTask(String taskId) {
    return _remote.getTask(taskId);
  }

  Future<Either<Failure, TaskResponse>> updateTask(
    String taskId,
    UpdateTaskRequest request,
  ) {
    return _remote.updateTask(taskId, request);
  }

  Future<Either<Failure, TaskResponse>> setTaskStatus(
    String taskId,
    SetTaskStatusRequest request,
  ) {
    return _remote.setTaskStatus(taskId, request);
  }

  /// [request.assigneeId] == null unassigns.
  Future<Either<Failure, TaskResponse>> setTaskAssignee(
    String taskId,
    SetTaskAssigneeRequest request,
  ) {
    return _remote.setTaskAssignee(taskId, request);
  }

  /// [request.dueDate] == null clears the due date.
  Future<Either<Failure, TaskResponse>> setTaskDueDate(
    String taskId,
    SetTaskDueDateRequest request,
  ) {
    return _remote.setTaskDueDate(taskId, request);
  }

  Future<Either<Failure, void>> deleteTask(String taskId) {
    return _remote.deleteTask(taskId);
  }
}

@riverpod
ProjectRepository projectRepository(Ref ref) {
  return ProjectRepository(ref.watch(projectRemoteProvider));
}
