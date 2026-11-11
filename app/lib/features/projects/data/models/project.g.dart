// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectResponse _$ProjectResponseFromJson(Map<String, dynamic> json) =>
    _ProjectResponse(
      data: ProjectData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProjectResponseToJson(_ProjectResponse instance) =>
    <String, dynamic>{'data': instance.data};

_ProjectListResponse _$ProjectListResponseFromJson(Map<String, dynamic> json) =>
    _ProjectListResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => ProjectData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProjectListResponseToJson(
  _ProjectListResponse instance,
) => <String, dynamic>{'data': instance.data};

_ProjectData _$ProjectDataFromJson(Map<String, dynamic> json) => _ProjectData(
  id: json['id'] as String,
  ownerId: json['owner_id'] as String,
  name: json['name'] as String,
  summary: json['summary'] as String?,
  status: json['status'] as String,
  metadata: json['metadata'] as Map<String, dynamic>?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ProjectDataToJson(_ProjectData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'name': instance.name,
      'summary': instance.summary,
      'status': instance.status,
      'metadata': instance.metadata,
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_ProjectMemberResponse _$ProjectMemberResponseFromJson(
  Map<String, dynamic> json,
) => _ProjectMemberResponse(
  data: ProjectMemberData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProjectMemberResponseToJson(
  _ProjectMemberResponse instance,
) => <String, dynamic>{'data': instance.data};

_MemberListResponse _$MemberListResponseFromJson(Map<String, dynamic> json) =>
    _MemberListResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => ProjectMemberData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MemberListResponseToJson(_MemberListResponse instance) =>
    <String, dynamic>{'data': instance.data};

_ProjectMemberData _$ProjectMemberDataFromJson(Map<String, dynamic> json) =>
    _ProjectMemberData(
      id: json['id'] as String,
      projectId: json['project_id'] as String,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ProjectMemberDataToJson(_ProjectMemberData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'project_id': instance.projectId,
      'user_id': instance.userId,
      'created_at': instance.createdAt.toIso8601String(),
    };

_CreateProjectRequest _$CreateProjectRequestFromJson(
  Map<String, dynamic> json,
) => _CreateProjectRequest(
  name: json['name'] as String,
  summary: json['summary'] as String?,
);

Map<String, dynamic> _$CreateProjectRequestToJson(
  _CreateProjectRequest instance,
) => <String, dynamic>{'name': instance.name, 'summary': ?instance.summary};

_UpdateProjectRequest _$UpdateProjectRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateProjectRequest(
  name: json['name'] as String?,
  summary: json['summary'] as String?,
  status: json['status'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$UpdateProjectRequestToJson(
  _UpdateProjectRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'summary': instance.summary,
  'status': instance.status,
  'metadata': ?instance.metadata,
};

_AddMemberRequest _$AddMemberRequestFromJson(Map<String, dynamic> json) =>
    _AddMemberRequest(email: json['email'] as String);

Map<String, dynamic> _$AddMemberRequestToJson(_AddMemberRequest instance) =>
    <String, dynamic>{'email': instance.email};
