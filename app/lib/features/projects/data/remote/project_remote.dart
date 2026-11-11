import 'package:dio/dio.dart';
import 'package:dart_either/dart_either.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studio_os/core/errors/error_mapper.dart';
import 'package:studio_os/core/network/dio_client.dart';
import 'package:studio_os/features/projects/data/models/project.dart';
import 'package:studio_os/features/projects/data/models/task.dart';

part 'project_remote.g.dart';

/// The "phone calls" for the projects domain. Mirrors AuthRemote exactly:
/// every call either returns Right(envelope-model) or Left(Failure) — the
/// server's `{error:{code,message}}` envelope is turned into Failure by
/// mapDioException, so nothing here touches status codes.
///
/// One remote for projects, members and tasks. Tasks live inside projects
/// today; if this file ever feels chunky, lift the task methods verbatim
/// into a task_remote.dart in the same folder.
class ProjectRemote {
  final Dio _dio;

  ProjectRemote(this._dio);

  // ==== PROJECTS ====

  Future<Either<Failure, ProjectResponse>> createProject(
    CreateProjectRequest request,
  ) async {
    try {
      final response = await _dio.post('/v1/projects', data: request.toJson());
      return Right(ProjectResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(mapException(e));
    }
  }

  /// Projects the caller owns or was added to; deleted ones never appear.
  Future<Either<Failure, ProjectListResponse>> listProjects() async {
    try {
      final response = await _dio.get('/v1/projects');
      return Right(ProjectListResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(mapException(e));
    }
  }

  Future<Either<Failure, ProjectResponse>> getProject(String projectId) async {
    try {
      final response = await _dio.get('/v1/projects/$projectId');
      return Right(ProjectResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(mapException(e));
    }
  }

  Future<Either<Failure, ProjectResponse>> updateProject(
    String projectId,
    UpdateProjectRequest request,
  ) async {
    try {
      final response = await _dio.patch(
        '/v1/projects/$projectId',
        data: request.toJson(),
      );
      return Right(ProjectResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(mapException(e));
    }
  }

  /// Soft-delete: 204 on success, 403 unless the caller is the owner.
  Future<Either<Failure, void>> deleteProject(String projectId) async {
    try {
      await _dio.delete('/v1/projects/$projectId');
      return const Right(null);
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(mapException(e));
    }
  }

  // ==== MEMBERS ====

  /// Owner-only. Listing who can edit is for everyone on the project.
  Future<Either<Failure, MemberListResponse>> listMembers(
    String projectId,
  ) async {
    try {
      final response = await _dio.get('/v1/projects/$projectId/members');
      return Right(MemberListResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(mapException(e));
    }
  }

  /// Adds by email. Watch for 404 (no account at that address — have them
  /// sign up first) and 409 (already a member) in the controller.
  Future<Either<Failure, ProjectMemberResponse>> addMember(
    String projectId,
    AddMemberRequest request,
  ) async {
    try {
      final response = await _dio.post(
        '/v1/projects/$projectId/members',
        data: request.toJson(),
      );
      return Right(ProjectMemberResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(mapException(e));
    }
  }

  /// Owner-only; the removed member is [userId], taken from the member id's
  /// userId field, not from an email. 204 on success.
  Future<Either<Failure, void>> removeMember(
    String projectId,
    String userId,
  ) async {
    try {
      await _dio.delete('/v1/projects/$projectId/members/$userId');
      return const Right(null);
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(mapException(e));
    }
  }

  // ==== TASKS ====

  Future<Either<Failure, TaskResponse>> createTask(
    String projectId,
    CreateTaskRequest request,
  ) async {
    try {
      final response = await _dio.post(
        '/v1/projects/$projectId/tasks',
        data: request.toJson(),
      );
      return Right(TaskResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(mapException(e));
    }
  }

  Future<Either<Failure, TaskListResponse>> listProjectTasks(
    String projectId,
  ) async {
    try {
      final response = await _dio.get('/v1/projects/$projectId/tasks');
      return Right(TaskListResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(mapException(e));
    }
  }

  /// The login board: every task assigned to the caller across all projects.
  Future<Either<Failure, TaskListResponse>> listMyTasks() async {
    try {
      final response = await _dio.get('/v1/tasks/me');
      return Right(TaskListResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(mapException(e));
    }
  }

  Future<Either<Failure, TaskResponse>> getTask(String taskId) async {
    try {
      final response = await _dio.get('/v1/tasks/$taskId');
      return Right(TaskResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(mapException(e));
    }
  }

  /// Partial update (title/description/area/tags/status). Watch 400
  /// invalid_task_status / invalid_task_area in the controller.
  Future<Either<Failure, TaskResponse>> updateTask(
    String taskId,
    UpdateTaskRequest request,
  ) async {
    try {
      final response = await _dio.patch(
        '/v1/tasks/$taskId',
        data: request.toJson(),
      );
      return Right(TaskResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(mapException(e));
    }
  }

  Future<Either<Failure, TaskResponse>> setTaskStatus(
    String taskId,
    SetTaskStatusRequest request,
  ) async {
    try {
      final response = await _dio.patch(
        '/v1/tasks/$taskId/status',
        data: request.toJson(),
      );
      return Right(TaskResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(mapException(e));
    }
  }

  /// Pass a userId to assign; pass `null` in [request.assigneeId] to unassign
  /// (the model serializes the null on purpose — it is the contract).
  Future<Either<Failure, TaskResponse>> setTaskAssignee(
    String taskId,
    SetTaskAssigneeRequest request,
  ) async {
    try {
      final response = await _dio.patch(
        '/v1/tasks/$taskId/assignee',
        data: request.toJson(),
      );
      return Right(TaskResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(mapException(e));
    }
  }

  /// Pass a date to set it; pass `null` in [request.dueDate] to clear it.
  Future<Either<Failure, TaskResponse>> setTaskDueDate(
    String taskId,
    SetTaskDueDateRequest request,
  ) async {
    try {
      final response = await _dio.patch(
        '/v1/tasks/$taskId/due-date',
        data: request.toJson(),
      );
      return Right(TaskResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(mapException(e));
    }
  }

  /// Hard delete, unlike the project. 204 on success.
  Future<Either<Failure, void>> deleteTask(String taskId) async {
    try {
      await _dio.delete('/v1/tasks/$taskId');
      return const Right(null);
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(mapException(e));
    }
  }
}

@riverpod
ProjectRemote projectRemote(Ref ref) {
  return ProjectRemote(ref.watch(dioProvider));
}
