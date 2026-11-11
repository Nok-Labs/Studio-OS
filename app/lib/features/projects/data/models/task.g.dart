// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskResponse _$TaskResponseFromJson(Map<String, dynamic> json) =>
    _TaskResponse(
      data: TaskData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TaskResponseToJson(_TaskResponse instance) =>
    <String, dynamic>{'data': instance.data};

_TaskListResponse _$TaskListResponseFromJson(Map<String, dynamic> json) =>
    _TaskListResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => TaskData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TaskListResponseToJson(_TaskListResponse instance) =>
    <String, dynamic>{'data': instance.data};

_TaskData _$TaskDataFromJson(Map<String, dynamic> json) => _TaskData(
  id: json['id'] as String,
  projectId: json['project_id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  area: json['area'] as String,
  tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
  status: json['status'] as String,
  assigneeId: json['assignee_id'] as String?,
  dueDate: json['due_date'] == null
      ? null
      : DateTime.parse(json['due_date'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$TaskDataToJson(_TaskData instance) => <String, dynamic>{
  'id': instance.id,
  'project_id': instance.projectId,
  'title': instance.title,
  'description': instance.description,
  'area': instance.area,
  'tags': instance.tags,
  'status': instance.status,
  'assignee_id': instance.assigneeId,
  'due_date': instance.dueDate?.toIso8601String(),
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

_CreateTaskRequest _$CreateTaskRequestFromJson(Map<String, dynamic> json) =>
    _CreateTaskRequest(
      title: json['title'] as String,
      description: json['description'] as String?,
      area: json['area'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      status: json['status'] as String,
      assigneeId: json['assignee_id'] as String?,
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
    );

Map<String, dynamic> _$CreateTaskRequestToJson(_CreateTaskRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': ?instance.description,
      'area': instance.area,
      'tags': instance.tags,
      'status': instance.status,
      'assignee_id': ?instance.assigneeId,
      'due_date': ?instance.dueDate?.toIso8601String(),
    };

_UpdateTaskRequest _$UpdateTaskRequestFromJson(Map<String, dynamic> json) =>
    _UpdateTaskRequest(
      title: json['title'] as String?,
      description: json['description'] as String?,
      area: json['area'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$UpdateTaskRequestToJson(_UpdateTaskRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'area': instance.area,
      'tags': ?instance.tags,
      'status': instance.status,
    };

_SetTaskStatusRequest _$SetTaskStatusRequestFromJson(
  Map<String, dynamic> json,
) => _SetTaskStatusRequest(status: json['status'] as String);

Map<String, dynamic> _$SetTaskStatusRequestToJson(
  _SetTaskStatusRequest instance,
) => <String, dynamic>{'status': instance.status};

_SetTaskAssigneeRequest _$SetTaskAssigneeRequestFromJson(
  Map<String, dynamic> json,
) => _SetTaskAssigneeRequest(assigneeId: json['assignee_id'] as String?);

Map<String, dynamic> _$SetTaskAssigneeRequestToJson(
  _SetTaskAssigneeRequest instance,
) => <String, dynamic>{'assignee_id': instance.assigneeId};

_SetTaskDueDateRequest _$SetTaskDueDateRequestFromJson(
  Map<String, dynamic> json,
) => _SetTaskDueDateRequest(
  dueDate: json['due_date'] == null
      ? null
      : DateTime.parse(json['due_date'] as String),
);

Map<String, dynamic> _$SetTaskDueDateRequestToJson(
  _SetTaskDueDateRequest instance,
) => <String, dynamic>{'due_date': instance.dueDate?.toIso8601String()};
