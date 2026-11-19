import 'package:dart_either/dart_either.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studio_os/core/errors/error_mapper.dart';
import 'package:studio_os/features/projects/data/models/project.dart';
import 'package:studio_os/features/projects/data/models/task.dart';
import 'package:studio_os/features/projects/data/remote/project_remote.dart';

part 'project_repository.g.dart';

/// The translator layer for the projects domain. The remote speaks the wire
/// contract — envelopes like {"data": ...} — and this layer turns that into
/// the domain shapes the app works with: a list is a List, a project is a
/// ProjectData. Controllers never see an envelope or a `response.data`.
class ProjectRepository {
  final ProjectRemote _remote;

  ProjectRepository(this._remote);

  /// Unwraps one success envelope, forwarding the failure untouched.
  Future<Either<Failure, T>> _unwrap<T, R>(
    Future<Either<Failure, R>> call,
    T Function(R response) extract,
  ) async {
    final result = await call;
    return result.fold(
      ifLeft: (failure) => Left(failure),
      ifRight: (response) => Right(extract(response)),
    );
  }

  // ==== PROJECTS ====

  Future<Either<Failure, ProjectData>> createProject(
    CreateProjectRequest request,
  ) {
    return _unwrap(_remote.createProject(request), (r) => r.data);
  }

  Future<Either<Failure, List<ProjectData>>> listProjects() {
    return _unwrap(_remote.listProjects(), (r) => r.data);
  }

  Future<Either<Failure, ProjectData>> getProject(String projectId) {
    return _unwrap(_remote.getProject(projectId), (r) => r.data);
  }

  Future<Either<Failure, ProjectData>> updateProject(
    String projectId,
    UpdateProjectRequest request,
  ) {
    return _unwrap(_remote.updateProject(projectId, request), (r) => r.data);
  }

  /// 403 project_owner_required lands here for non-owners — show it, don't
  /// even render destructive controls for non-owners (check data.ownerId
  /// against the profile id instead).
  Future<Either<Failure, void>> deleteProject(String projectId) {
    return _remote.deleteProject(projectId);
  }

  // ==== MEMBERS ====

  Future<Either<Failure, List<ProjectMemberData>>> listMembers(
    String projectId,
  ) {
    return _unwrap(_remote.listMembers(projectId), (r) => r.data);
  }

  Future<Either<Failure, ProjectMemberData>> addMember(
    String projectId,
    AddMemberRequest request,
  ) {
    return _unwrap(_remote.addMember(projectId, request), (r) => r.data);
  }

  Future<Either<Failure, void>> removeMember(String projectId, String userId) {
    return _remote.removeMember(projectId, userId);
  }

  // ==== TASKS ====

  Future<Either<Failure, TaskData>> createTask(
    String projectId,
    CreateTaskRequest request,
  ) {
    return _unwrap(_remote.createTask(projectId, request), (r) => r.data);
  }

  Future<Either<Failure, List<TaskData>>> listProjectTasks(String projectId) {
    return _unwrap(_remote.listProjectTasks(projectId), (r) => r.data);
  }

  Future<Either<Failure, List<TaskData>>> listMyTasks() {
    return _unwrap(_remote.listMyTasks(), (r) => r.data);
  }

  Future<Either<Failure, TaskData>> getTask(String taskId) {
    return _unwrap(_remote.getTask(taskId), (r) => r.data);
  }

  Future<Either<Failure, TaskData>> updateTask(
    String taskId,
    UpdateTaskRequest request,
  ) {
    return _unwrap(_remote.updateTask(taskId, request), (r) => r.data);
  }

  Future<Either<Failure, TaskData>> setTaskStatus(
    String taskId,
    SetTaskStatusRequest request,
  ) {
    return _unwrap(_remote.setTaskStatus(taskId, request), (r) => r.data);
  }

  /// [request.assigneeId] == null unassigns.
  Future<Either<Failure, TaskData>> setTaskAssignee(
    String taskId,
    SetTaskAssigneeRequest request,
  ) {
    return _unwrap(_remote.setTaskAssignee(taskId, request), (r) => r.data);
  }

  /// [request.dueDate] == null clears the due date.
  Future<Either<Failure, TaskData>> setTaskDueDate(
    String taskId,
    SetTaskDueDateRequest request,
  ) {
    return _unwrap(_remote.setTaskDueDate(taskId, request), (r) => r.data);
  }

  Future<Either<Failure, void>> deleteTask(String taskId) {
    return _remote.deleteTask(taskId);
  }
}

@riverpod
ProjectRepository projectRepository(Ref ref) {
  return ProjectRepository(ref.watch(projectRemoteProvider));
}
