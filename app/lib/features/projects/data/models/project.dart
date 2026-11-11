import 'package:freezed_annotation/freezed_annotation.dart';

part 'project.freezed.dart';
part 'project.g.dart';

/// ============ ENVELOPES ============

/// Success reply for a single project: `{"data": {project}}`.
@freezed
abstract class ProjectResponse with _$ProjectResponse {
  const factory ProjectResponse({required ProjectData data}) = _ProjectResponse;

  factory ProjectResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectResponseFromJson(json);
}

/// Success reply for `GET /v1/projects`: `{"data": [project, ...]}`.
@freezed
abstract class ProjectListResponse with _$ProjectListResponse {
  const factory ProjectListResponse({required List<ProjectData> data}) =
      _ProjectListResponse;

  factory ProjectListResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectListResponseFromJson(json);
}

/// ============ DATA ============

/// A project as the API returns it. ownerId is the creator (there is no
/// member row for the owner). summary is nullable: it may simply be unset,
/// and setSummary("") clears it rather than hiding it.
@freezed
abstract class ProjectData with _$ProjectData {
  const factory ProjectData({
    required String id,
    @JsonKey(name: 'owner_id') required String ownerId,
    required String name,
    String? summary,
    required String status,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ProjectData;

  factory ProjectData.fromJson(Map<String, dynamic> json) =>
      _$ProjectDataFromJson(json);
}

// ==== MEMBERS ====

/// Success reply for adding one member: `{"data": {member}}`.
@freezed
abstract class ProjectMemberResponse with _$ProjectMemberResponse {
  const factory ProjectMemberResponse({required ProjectMemberData data}) =
      _ProjectMemberResponse;

  factory ProjectMemberResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectMemberResponseFromJson(json);
}

/// Success reply for `GET /v1/projects/:id/members`.
@freezed
abstract class MemberListResponse with _$MemberListResponse {
  const factory MemberListResponse({required List<ProjectMemberData> data}) =
      _MemberListResponse;

  factory MemberListResponse.fromJson(Map<String, dynamic> json) =>
      _$MemberListResponseFromJson(json);
}

/// One membership grant. No roles, no "can edit" flags — being listed here
/// means full access, exactly like the Figma share sheet.
@freezed
abstract class ProjectMemberData with _$ProjectMemberData {
  const factory ProjectMemberData({
    required String id,
    @JsonKey(name: 'project_id') required String projectId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _ProjectMemberData;

  factory ProjectMemberData.fromJson(Map<String, dynamic> json) =>
      _$ProjectMemberDataFromJson(json);
}

// ==== REQUESTS ====

/// POST /v1/projects body. The caller becomes the owner.
@freezed
abstract class CreateProjectRequest with _$CreateProjectRequest {
  const factory CreateProjectRequest({
    required String name,
    @JsonKey(includeIfNull: false) String? summary,
  }) = _CreateProjectRequest;

  factory CreateProjectRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateProjectRequestFromJson(json);
}

/// PATCH /v1/projects/:id body. Everything optional: absent = unchanged.
/// status is one of draft/active/completed (the server 400s anything else).
@freezed
abstract class UpdateProjectRequest with _$UpdateProjectRequest {
  const factory UpdateProjectRequest({
    String? name,
    String? summary,
    String? status,
    @JsonKey(includeIfNull: false) Map<String, dynamic>? metadata,
  }) = _UpdateProjectRequest;

  factory UpdateProjectRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProjectRequestFromJson(json);
}

/// POST /v1/projects/:id/members body — adding is by email. An unknown
/// address answers 404 user_not_found ("sign up first"), a 409 means the
/// person is already on the project.
@freezed
abstract class AddMemberRequest with _$AddMemberRequest {
  const factory AddMemberRequest({required String email}) = _AddMemberRequest;

  factory AddMemberRequest.fromJson(Map<String, dynamic> json) =>
      _$AddMemberRequestFromJson(json);
}
