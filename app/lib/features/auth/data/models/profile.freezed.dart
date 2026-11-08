// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileResponse {

 ProfileData get data;
/// Create a copy of ProfileResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileResponseCopyWith<ProfileResponse> get copyWith => _$ProfileResponseCopyWithImpl<ProfileResponse>(this as ProfileResponse, _$identity);

  /// Serializes this ProfileResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileResponse&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'ProfileResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class $ProfileResponseCopyWith<$Res>  {
  factory $ProfileResponseCopyWith(ProfileResponse value, $Res Function(ProfileResponse) _then) = _$ProfileResponseCopyWithImpl;
@useResult
$Res call({
 ProfileData data
});


$ProfileDataCopyWith<$Res> get data;

}
/// @nodoc
class _$ProfileResponseCopyWithImpl<$Res>
    implements $ProfileResponseCopyWith<$Res> {
  _$ProfileResponseCopyWithImpl(this._self, this._then);

  final ProfileResponse _self;
  final $Res Function(ProfileResponse) _then;

/// Create a copy of ProfileResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ProfileData,
  ));
}
/// Create a copy of ProfileResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileDataCopyWith<$Res> get data {
  
  return $ProfileDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProfileResponse].
extension ProfileResponsePatterns on ProfileResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProfileResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProfileData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileResponse() when $default != null:
return $default(_that.data);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProfileData data)  $default,) {final _that = this;
switch (_that) {
case _ProfileResponse():
return $default(_that.data);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProfileData data)?  $default,) {final _that = this;
switch (_that) {
case _ProfileResponse() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileResponse implements ProfileResponse {
  const _ProfileResponse({required this.data});
  factory _ProfileResponse.fromJson(Map<String, dynamic> json) => _$ProfileResponseFromJson(json);

@override final  ProfileData data;

/// Create a copy of ProfileResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileResponseCopyWith<_ProfileResponse> get copyWith => __$ProfileResponseCopyWithImpl<_ProfileResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileResponse&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'ProfileResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class _$ProfileResponseCopyWith<$Res> implements $ProfileResponseCopyWith<$Res> {
  factory _$ProfileResponseCopyWith(_ProfileResponse value, $Res Function(_ProfileResponse) _then) = __$ProfileResponseCopyWithImpl;
@override @useResult
$Res call({
 ProfileData data
});


@override $ProfileDataCopyWith<$Res> get data;

}
/// @nodoc
class __$ProfileResponseCopyWithImpl<$Res>
    implements _$ProfileResponseCopyWith<$Res> {
  __$ProfileResponseCopyWithImpl(this._self, this._then);

  final _ProfileResponse _self;
  final $Res Function(_ProfileResponse) _then;

/// Create a copy of ProfileResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_ProfileResponse(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ProfileData,
  ));
}

/// Create a copy of ProfileResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileDataCopyWith<$Res> get data {
  
  return $ProfileDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$ProfileData {

 String get id; String get email;@JsonKey(name: 'first_name') String? get firstName;@JsonKey(name: 'last_name') String? get lastName; String? get username;@JsonKey(name: 'display_name') String? get displayName;@JsonKey(name: 'avatar_url') String? get avatarUrl;@JsonKey(name: 'is_verified') bool get isVerified;
/// Create a copy of ProfileData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileDataCopyWith<ProfileData> get copyWith => _$ProfileDataCopyWithImpl<ProfileData>(this as ProfileData, _$identity);

  /// Serializes this ProfileData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileData&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,firstName,lastName,username,displayName,avatarUrl,isVerified);

@override
String toString() {
  return 'ProfileData(id: $id, email: $email, firstName: $firstName, lastName: $lastName, username: $username, displayName: $displayName, avatarUrl: $avatarUrl, isVerified: $isVerified)';
}


}

/// @nodoc
abstract mixin class $ProfileDataCopyWith<$Res>  {
  factory $ProfileDataCopyWith(ProfileData value, $Res Function(ProfileData) _then) = _$ProfileDataCopyWithImpl;
@useResult
$Res call({
 String id, String email,@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'last_name') String? lastName, String? username,@JsonKey(name: 'display_name') String? displayName,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'is_verified') bool isVerified
});




}
/// @nodoc
class _$ProfileDataCopyWithImpl<$Res>
    implements $ProfileDataCopyWith<$Res> {
  _$ProfileDataCopyWithImpl(this._self, this._then);

  final ProfileData _self;
  final $Res Function(ProfileData) _then;

/// Create a copy of ProfileData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? firstName = freezed,Object? lastName = freezed,Object? username = freezed,Object? displayName = freezed,Object? avatarUrl = freezed,Object? isVerified = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileData].
extension ProfileDataPatterns on ProfileData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileData value)  $default,){
final _that = this;
switch (_that) {
case _ProfileData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileData value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String? username, @JsonKey(name: 'display_name')  String? displayName, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'is_verified')  bool isVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileData() when $default != null:
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.username,_that.displayName,_that.avatarUrl,_that.isVerified);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String? username, @JsonKey(name: 'display_name')  String? displayName, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'is_verified')  bool isVerified)  $default,) {final _that = this;
switch (_that) {
case _ProfileData():
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.username,_that.displayName,_that.avatarUrl,_that.isVerified);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String? username, @JsonKey(name: 'display_name')  String? displayName, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'is_verified')  bool isVerified)?  $default,) {final _that = this;
switch (_that) {
case _ProfileData() when $default != null:
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.username,_that.displayName,_that.avatarUrl,_that.isVerified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileData implements ProfileData {
  const _ProfileData({required this.id, required this.email, @JsonKey(name: 'first_name') this.firstName, @JsonKey(name: 'last_name') this.lastName, this.username, @JsonKey(name: 'display_name') this.displayName, @JsonKey(name: 'avatar_url') this.avatarUrl, @JsonKey(name: 'is_verified') required this.isVerified});
  factory _ProfileData.fromJson(Map<String, dynamic> json) => _$ProfileDataFromJson(json);

@override final  String id;
@override final  String email;
@override@JsonKey(name: 'first_name') final  String? firstName;
@override@JsonKey(name: 'last_name') final  String? lastName;
@override final  String? username;
@override@JsonKey(name: 'display_name') final  String? displayName;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override@JsonKey(name: 'is_verified') final  bool isVerified;

/// Create a copy of ProfileData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileDataCopyWith<_ProfileData> get copyWith => __$ProfileDataCopyWithImpl<_ProfileData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileData&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,firstName,lastName,username,displayName,avatarUrl,isVerified);

@override
String toString() {
  return 'ProfileData(id: $id, email: $email, firstName: $firstName, lastName: $lastName, username: $username, displayName: $displayName, avatarUrl: $avatarUrl, isVerified: $isVerified)';
}


}

/// @nodoc
abstract mixin class _$ProfileDataCopyWith<$Res> implements $ProfileDataCopyWith<$Res> {
  factory _$ProfileDataCopyWith(_ProfileData value, $Res Function(_ProfileData) _then) = __$ProfileDataCopyWithImpl;
@override @useResult
$Res call({
 String id, String email,@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'last_name') String? lastName, String? username,@JsonKey(name: 'display_name') String? displayName,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'is_verified') bool isVerified
});




}
/// @nodoc
class __$ProfileDataCopyWithImpl<$Res>
    implements _$ProfileDataCopyWith<$Res> {
  __$ProfileDataCopyWithImpl(this._self, this._then);

  final _ProfileData _self;
  final $Res Function(_ProfileData) _then;

/// Create a copy of ProfileData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? firstName = freezed,Object? lastName = freezed,Object? username = freezed,Object? displayName = freezed,Object? avatarUrl = freezed,Object? isVerified = null,}) {
  return _then(_ProfileData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ProfileUpdateRequest {

@JsonKey(name: 'first_name', includeIfNull: false) String? get firstName;@JsonKey(name: 'last_name', includeIfNull: false) String? get lastName;@JsonKey(name: 'display_name', includeIfNull: false) String? get displayName;@JsonKey(name: 'avatar_url', includeIfNull: false) String? get avatarUrl;
/// Create a copy of ProfileUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileUpdateRequestCopyWith<ProfileUpdateRequest> get copyWith => _$ProfileUpdateRequestCopyWithImpl<ProfileUpdateRequest>(this as ProfileUpdateRequest, _$identity);

  /// Serializes this ProfileUpdateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileUpdateRequest&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,displayName,avatarUrl);

@override
String toString() {
  return 'ProfileUpdateRequest(firstName: $firstName, lastName: $lastName, displayName: $displayName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $ProfileUpdateRequestCopyWith<$Res>  {
  factory $ProfileUpdateRequestCopyWith(ProfileUpdateRequest value, $Res Function(ProfileUpdateRequest) _then) = _$ProfileUpdateRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'first_name', includeIfNull: false) String? firstName,@JsonKey(name: 'last_name', includeIfNull: false) String? lastName,@JsonKey(name: 'display_name', includeIfNull: false) String? displayName,@JsonKey(name: 'avatar_url', includeIfNull: false) String? avatarUrl
});




}
/// @nodoc
class _$ProfileUpdateRequestCopyWithImpl<$Res>
    implements $ProfileUpdateRequestCopyWith<$Res> {
  _$ProfileUpdateRequestCopyWithImpl(this._self, this._then);

  final ProfileUpdateRequest _self;
  final $Res Function(ProfileUpdateRequest) _then;

/// Create a copy of ProfileUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? firstName = freezed,Object? lastName = freezed,Object? displayName = freezed,Object? avatarUrl = freezed,}) {
  return _then(_self.copyWith(
firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileUpdateRequest].
extension ProfileUpdateRequestPatterns on ProfileUpdateRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileUpdateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileUpdateRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileUpdateRequest value)  $default,){
final _that = this;
switch (_that) {
case _ProfileUpdateRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileUpdateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileUpdateRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'first_name', includeIfNull: false)  String? firstName, @JsonKey(name: 'last_name', includeIfNull: false)  String? lastName, @JsonKey(name: 'display_name', includeIfNull: false)  String? displayName, @JsonKey(name: 'avatar_url', includeIfNull: false)  String? avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileUpdateRequest() when $default != null:
return $default(_that.firstName,_that.lastName,_that.displayName,_that.avatarUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'first_name', includeIfNull: false)  String? firstName, @JsonKey(name: 'last_name', includeIfNull: false)  String? lastName, @JsonKey(name: 'display_name', includeIfNull: false)  String? displayName, @JsonKey(name: 'avatar_url', includeIfNull: false)  String? avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _ProfileUpdateRequest():
return $default(_that.firstName,_that.lastName,_that.displayName,_that.avatarUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'first_name', includeIfNull: false)  String? firstName, @JsonKey(name: 'last_name', includeIfNull: false)  String? lastName, @JsonKey(name: 'display_name', includeIfNull: false)  String? displayName, @JsonKey(name: 'avatar_url', includeIfNull: false)  String? avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _ProfileUpdateRequest() when $default != null:
return $default(_that.firstName,_that.lastName,_that.displayName,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileUpdateRequest implements ProfileUpdateRequest {
  const _ProfileUpdateRequest({@JsonKey(name: 'first_name', includeIfNull: false) this.firstName, @JsonKey(name: 'last_name', includeIfNull: false) this.lastName, @JsonKey(name: 'display_name', includeIfNull: false) this.displayName, @JsonKey(name: 'avatar_url', includeIfNull: false) this.avatarUrl});
  factory _ProfileUpdateRequest.fromJson(Map<String, dynamic> json) => _$ProfileUpdateRequestFromJson(json);

@override@JsonKey(name: 'first_name', includeIfNull: false) final  String? firstName;
@override@JsonKey(name: 'last_name', includeIfNull: false) final  String? lastName;
@override@JsonKey(name: 'display_name', includeIfNull: false) final  String? displayName;
@override@JsonKey(name: 'avatar_url', includeIfNull: false) final  String? avatarUrl;

/// Create a copy of ProfileUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileUpdateRequestCopyWith<_ProfileUpdateRequest> get copyWith => __$ProfileUpdateRequestCopyWithImpl<_ProfileUpdateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileUpdateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileUpdateRequest&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,displayName,avatarUrl);

@override
String toString() {
  return 'ProfileUpdateRequest(firstName: $firstName, lastName: $lastName, displayName: $displayName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$ProfileUpdateRequestCopyWith<$Res> implements $ProfileUpdateRequestCopyWith<$Res> {
  factory _$ProfileUpdateRequestCopyWith(_ProfileUpdateRequest value, $Res Function(_ProfileUpdateRequest) _then) = __$ProfileUpdateRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'first_name', includeIfNull: false) String? firstName,@JsonKey(name: 'last_name', includeIfNull: false) String? lastName,@JsonKey(name: 'display_name', includeIfNull: false) String? displayName,@JsonKey(name: 'avatar_url', includeIfNull: false) String? avatarUrl
});




}
/// @nodoc
class __$ProfileUpdateRequestCopyWithImpl<$Res>
    implements _$ProfileUpdateRequestCopyWith<$Res> {
  __$ProfileUpdateRequestCopyWithImpl(this._self, this._then);

  final _ProfileUpdateRequest _self;
  final $Res Function(_ProfileUpdateRequest) _then;

/// Create a copy of ProfileUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? firstName = freezed,Object? lastName = freezed,Object? displayName = freezed,Object? avatarUrl = freezed,}) {
  return _then(_ProfileUpdateRequest(
firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
