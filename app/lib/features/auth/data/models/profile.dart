import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

/// GET /v1/users/me reply: the shared success envelope with the profile.
@freezed
abstract class ProfileResponse with _$ProfileResponse {
  const factory ProfileResponse({required ProfileData data}) = _ProfileResponse;

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);
}

/// The caller's identity. firstName/lastName/username/displayName/avatarUrl
/// are all nullable because a brand-new account has none of them yet — that
/// emptiness is exactly what the onboarding gate keys off.
@freezed
abstract class ProfileData with _$ProfileData {
  const factory ProfileData({
    required String id,
    required String email,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    String? username,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'is_verified') required bool isVerified,
  }) = _ProfileData;

  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);
}

/// PATCH /v1/users/me body. Server semantics: absent field = unchanged.
/// Field-level [includeIfNull: false] keeps omitted Dart fields out of the
/// JSON so that same rule applies with zero mapping code in the controller.
@freezed
abstract class ProfileUpdateRequest with _$ProfileUpdateRequest {
  const factory ProfileUpdateRequest({
    @JsonKey(name: 'first_name', includeIfNull: false) String? firstName,
    @JsonKey(name: 'last_name', includeIfNull: false) String? lastName,
    @JsonKey(name: 'display_name', includeIfNull: false) String? displayName,
    @JsonKey(name: 'avatar_url', includeIfNull: false) String? avatarUrl,
  }) = _ProfileUpdateRequest;

  factory ProfileUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ProfileUpdateRequestFromJson(json);
}
