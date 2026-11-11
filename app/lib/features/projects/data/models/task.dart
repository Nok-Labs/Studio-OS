import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

/// ============ ENVELOPES ============

/// Success reply for a single task: `{"data": {task}}`.
@freezed
abstract class TaskResponse with _$TaskResponse {
  const factory TaskResponse({required TaskData data}) = _TaskResponse;

  factory TaskResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskResponseFromJson(json);
}

/// Success reply for the two task lists (project tasks and the
/// login-time board `GET /v1/tasks/me`): `{"data": [task, ...]}`.
@freezed
abstract class TaskListResponse with _$TaskListResponse {
  const factory TaskListResponse({required List<TaskData> data}) =
      _TaskListResponse;

  factory TaskListResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskListResponseFromJson(json);
}

/// ============ DATA ============

/// A task. area is backend/frontend/design/doc; tags is always a list
/// (possibly empty); assigneeId/dueDate are null when nothing is set.
@freezed
abstract class TaskData with _$TaskData {
  const factory TaskData({
    required String id,
    @JsonKey(name: 'project_id') required String projectId,
    required String title,
    String? description,
    required String area,
    required List<String> tags,
    required String status,
    @JsonKey(name: 'assignee_id') String? assigneeId,
    @JsonKey(name: 'due_date') DateTime? dueDate,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _TaskData;

  factory TaskData.fromJson(Map<String, dynamic> json) =>
      _$TaskDataFromJson(json);
}

// ==== REQUESTS ====

/// POST /v1/projects/:id/tasks body. The server defaults area to backend,
/// status to todo, tags to [] and assignee to none, so pass only what you have.
@freezed
abstract class CreateTaskRequest with _$CreateTaskRequest {
  const factory CreateTaskRequest({
    required String title,
    @JsonKey(includeIfNull: false) String? description,
    required String area,
    required List<String> tags,
    required String status,
    @JsonKey(name: 'assignee_id', includeIfNull: false) String? assigneeId,
    @JsonKey(name: 'due_date', includeIfNull: false) DateTime? dueDate,
  }) = _CreateTaskRequest;

  factory CreateTaskRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskRequestFromJson(json);
}

/// PATCH /v1/tasks/:taskId body. Everything optional, absent = unchanged.
/// tags is tri-state on the server: omit the field = unchanged, send `[]` = clear.
@freezed
abstract class UpdateTaskRequest with _$UpdateTaskRequest {
  const factory UpdateTaskRequest({
    String? title,
    String? description,
    String? area,
    @JsonKey(includeIfNull: false) List<String>? tags,
    String? status,
  }) = _UpdateTaskRequest;

  factory UpdateTaskRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskRequestFromJson(json);
}

/// PATCH /v1/tasks/:taskId/status body. Values: todo / in_progress / done.
@freezed
abstract class SetTaskStatusRequest with _$SetTaskStatusRequest {
  const factory SetTaskStatusRequest({required String status}) =
      _SetTaskStatusRequest;

  factory SetTaskStatusRequest.fromJson(Map<String, dynamic> json) =>
      _$SetTaskStatusRequestFromJson(json);
}

/// PATCH /v1/tasks/:taskId/assignee body. NOTE the null semantics: a value
/// assigns, and `{"assignee_id": null}` unassigns — so unlike the other
/// request models, a missing field must STAY in the JSON as null. Leave
/// includeIfNull at its default (true); never mark it false on this one.
/// The assignee must be a project participant (owner or member).
@freezed
abstract class SetTaskAssigneeRequest with _$SetTaskAssigneeRequest {
  const factory SetTaskAssigneeRequest({
    @JsonKey(name: 'assignee_id') String? assigneeId,
  }) = _SetTaskAssigneeRequest;

  factory SetTaskAssigneeRequest.fromJson(Map<String, dynamic> json) =>
      _$SetTaskAssigneeRequestFromJson(json);
}

/// PATCH /v1/tasks/:taskId/due-date body. Same null = clear semantics as
/// the assignee request — see that note.
@freezed
abstract class SetTaskDueDateRequest with _$SetTaskDueDateRequest {
  const factory SetTaskDueDateRequest({
    @JsonKey(name: 'due_date') DateTime? dueDate,
  }) = _SetTaskDueDateRequest;

  factory SetTaskDueDateRequest.fromJson(Map<String, dynamic> json) =>
      _$SetTaskDueDateRequestFromJson(json);
}
