// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskResponse {

 TaskData get data;
/// Create a copy of TaskResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskResponseCopyWith<TaskResponse> get copyWith => _$TaskResponseCopyWithImpl<TaskResponse>(this as TaskResponse, _$identity);

  /// Serializes this TaskResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskResponse&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'TaskResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class $TaskResponseCopyWith<$Res>  {
  factory $TaskResponseCopyWith(TaskResponse value, $Res Function(TaskResponse) _then) = _$TaskResponseCopyWithImpl;
@useResult
$Res call({
 TaskData data
});


$TaskDataCopyWith<$Res> get data;

}
/// @nodoc
class _$TaskResponseCopyWithImpl<$Res>
    implements $TaskResponseCopyWith<$Res> {
  _$TaskResponseCopyWithImpl(this._self, this._then);

  final TaskResponse _self;
  final $Res Function(TaskResponse) _then;

/// Create a copy of TaskResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as TaskData,
  ));
}
/// Create a copy of TaskResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskDataCopyWith<$Res> get data {
  
  return $TaskDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [TaskResponse].
extension TaskResponsePatterns on TaskResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TaskData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TaskData data)  $default,) {final _that = this;
switch (_that) {
case _TaskResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TaskData data)?  $default,) {final _that = this;
switch (_that) {
case _TaskResponse() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskResponse implements TaskResponse {
  const _TaskResponse({required this.data});
  factory _TaskResponse.fromJson(Map<String, dynamic> json) => _$TaskResponseFromJson(json);

@override final  TaskData data;

/// Create a copy of TaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskResponseCopyWith<_TaskResponse> get copyWith => __$TaskResponseCopyWithImpl<_TaskResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskResponse&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'TaskResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class _$TaskResponseCopyWith<$Res> implements $TaskResponseCopyWith<$Res> {
  factory _$TaskResponseCopyWith(_TaskResponse value, $Res Function(_TaskResponse) _then) = __$TaskResponseCopyWithImpl;
@override @useResult
$Res call({
 TaskData data
});


@override $TaskDataCopyWith<$Res> get data;

}
/// @nodoc
class __$TaskResponseCopyWithImpl<$Res>
    implements _$TaskResponseCopyWith<$Res> {
  __$TaskResponseCopyWithImpl(this._self, this._then);

  final _TaskResponse _self;
  final $Res Function(_TaskResponse) _then;

/// Create a copy of TaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_TaskResponse(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as TaskData,
  ));
}

/// Create a copy of TaskResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskDataCopyWith<$Res> get data {
  
  return $TaskDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$TaskListResponse {

 List<TaskData> get data;
/// Create a copy of TaskListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskListResponseCopyWith<TaskListResponse> get copyWith => _$TaskListResponseCopyWithImpl<TaskListResponse>(this as TaskListResponse, _$identity);

  /// Serializes this TaskListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskListResponse&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'TaskListResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class $TaskListResponseCopyWith<$Res>  {
  factory $TaskListResponseCopyWith(TaskListResponse value, $Res Function(TaskListResponse) _then) = _$TaskListResponseCopyWithImpl;
@useResult
$Res call({
 List<TaskData> data
});




}
/// @nodoc
class _$TaskListResponseCopyWithImpl<$Res>
    implements $TaskListResponseCopyWith<$Res> {
  _$TaskListResponseCopyWithImpl(this._self, this._then);

  final TaskListResponse _self;
  final $Res Function(TaskListResponse) _then;

/// Create a copy of TaskListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<TaskData>,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskListResponse].
extension TaskListResponsePatterns on TaskListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskListResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TaskData> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskListResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TaskData> data)  $default,) {final _that = this;
switch (_that) {
case _TaskListResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TaskData> data)?  $default,) {final _that = this;
switch (_that) {
case _TaskListResponse() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskListResponse implements TaskListResponse {
  const _TaskListResponse({required final  List<TaskData> data}): _data = data;
  factory _TaskListResponse.fromJson(Map<String, dynamic> json) => _$TaskListResponseFromJson(json);

 final  List<TaskData> _data;
@override List<TaskData> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of TaskListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskListResponseCopyWith<_TaskListResponse> get copyWith => __$TaskListResponseCopyWithImpl<_TaskListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskListResponse&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'TaskListResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class _$TaskListResponseCopyWith<$Res> implements $TaskListResponseCopyWith<$Res> {
  factory _$TaskListResponseCopyWith(_TaskListResponse value, $Res Function(_TaskListResponse) _then) = __$TaskListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<TaskData> data
});




}
/// @nodoc
class __$TaskListResponseCopyWithImpl<$Res>
    implements _$TaskListResponseCopyWith<$Res> {
  __$TaskListResponseCopyWithImpl(this._self, this._then);

  final _TaskListResponse _self;
  final $Res Function(_TaskListResponse) _then;

/// Create a copy of TaskListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_TaskListResponse(
data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<TaskData>,
  ));
}


}


/// @nodoc
mixin _$TaskData {

 String get id;@JsonKey(name: 'project_id') String get projectId; String get title; String? get description; String get area; List<String> get tags; String get status;@JsonKey(name: 'assignee_id') String? get assigneeId;@JsonKey(name: 'due_date') DateTime? get dueDate;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of TaskData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDataCopyWith<TaskData> get copyWith => _$TaskDataCopyWithImpl<TaskData>(this as TaskData, _$identity);

  /// Serializes this TaskData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskData&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.area, area) || other.area == area)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.status, status) || other.status == status)&&(identical(other.assigneeId, assigneeId) || other.assigneeId == assigneeId)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,title,description,area,const DeepCollectionEquality().hash(tags),status,assigneeId,dueDate,createdAt,updatedAt);

@override
String toString() {
  return 'TaskData(id: $id, projectId: $projectId, title: $title, description: $description, area: $area, tags: $tags, status: $status, assigneeId: $assigneeId, dueDate: $dueDate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TaskDataCopyWith<$Res>  {
  factory $TaskDataCopyWith(TaskData value, $Res Function(TaskData) _then) = _$TaskDataCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'project_id') String projectId, String title, String? description, String area, List<String> tags, String status,@JsonKey(name: 'assignee_id') String? assigneeId,@JsonKey(name: 'due_date') DateTime? dueDate,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$TaskDataCopyWithImpl<$Res>
    implements $TaskDataCopyWith<$Res> {
  _$TaskDataCopyWithImpl(this._self, this._then);

  final TaskData _self;
  final $Res Function(TaskData) _then;

/// Create a copy of TaskData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? projectId = null,Object? title = null,Object? description = freezed,Object? area = null,Object? tags = null,Object? status = null,Object? assigneeId = freezed,Object? dueDate = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,assigneeId: freezed == assigneeId ? _self.assigneeId : assigneeId // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskData].
extension TaskDataPatterns on TaskData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskData value)  $default,){
final _that = this;
switch (_that) {
case _TaskData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskData value)?  $default,){
final _that = this;
switch (_that) {
case _TaskData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'project_id')  String projectId,  String title,  String? description,  String area,  List<String> tags,  String status, @JsonKey(name: 'assignee_id')  String? assigneeId, @JsonKey(name: 'due_date')  DateTime? dueDate, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskData() when $default != null:
return $default(_that.id,_that.projectId,_that.title,_that.description,_that.area,_that.tags,_that.status,_that.assigneeId,_that.dueDate,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'project_id')  String projectId,  String title,  String? description,  String area,  List<String> tags,  String status, @JsonKey(name: 'assignee_id')  String? assigneeId, @JsonKey(name: 'due_date')  DateTime? dueDate, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _TaskData():
return $default(_that.id,_that.projectId,_that.title,_that.description,_that.area,_that.tags,_that.status,_that.assigneeId,_that.dueDate,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'project_id')  String projectId,  String title,  String? description,  String area,  List<String> tags,  String status, @JsonKey(name: 'assignee_id')  String? assigneeId, @JsonKey(name: 'due_date')  DateTime? dueDate, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _TaskData() when $default != null:
return $default(_that.id,_that.projectId,_that.title,_that.description,_that.area,_that.tags,_that.status,_that.assigneeId,_that.dueDate,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskData implements TaskData {
  const _TaskData({required this.id, @JsonKey(name: 'project_id') required this.projectId, required this.title, this.description, required this.area, required final  List<String> tags, required this.status, @JsonKey(name: 'assignee_id') this.assigneeId, @JsonKey(name: 'due_date') this.dueDate, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt}): _tags = tags;
  factory _TaskData.fromJson(Map<String, dynamic> json) => _$TaskDataFromJson(json);

@override final  String id;
@override@JsonKey(name: 'project_id') final  String projectId;
@override final  String title;
@override final  String? description;
@override final  String area;
 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  String status;
@override@JsonKey(name: 'assignee_id') final  String? assigneeId;
@override@JsonKey(name: 'due_date') final  DateTime? dueDate;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of TaskData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskDataCopyWith<_TaskData> get copyWith => __$TaskDataCopyWithImpl<_TaskData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskData&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.area, area) || other.area == area)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.status, status) || other.status == status)&&(identical(other.assigneeId, assigneeId) || other.assigneeId == assigneeId)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,title,description,area,const DeepCollectionEquality().hash(_tags),status,assigneeId,dueDate,createdAt,updatedAt);

@override
String toString() {
  return 'TaskData(id: $id, projectId: $projectId, title: $title, description: $description, area: $area, tags: $tags, status: $status, assigneeId: $assigneeId, dueDate: $dueDate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TaskDataCopyWith<$Res> implements $TaskDataCopyWith<$Res> {
  factory _$TaskDataCopyWith(_TaskData value, $Res Function(_TaskData) _then) = __$TaskDataCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'project_id') String projectId, String title, String? description, String area, List<String> tags, String status,@JsonKey(name: 'assignee_id') String? assigneeId,@JsonKey(name: 'due_date') DateTime? dueDate,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$TaskDataCopyWithImpl<$Res>
    implements _$TaskDataCopyWith<$Res> {
  __$TaskDataCopyWithImpl(this._self, this._then);

  final _TaskData _self;
  final $Res Function(_TaskData) _then;

/// Create a copy of TaskData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projectId = null,Object? title = null,Object? description = freezed,Object? area = null,Object? tags = null,Object? status = null,Object? assigneeId = freezed,Object? dueDate = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_TaskData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,assigneeId: freezed == assigneeId ? _self.assigneeId : assigneeId // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$CreateTaskRequest {

 String get title;@JsonKey(includeIfNull: false) String? get description; String get area; List<String> get tags; String get status;@JsonKey(name: 'assignee_id', includeIfNull: false) String? get assigneeId;@JsonKey(name: 'due_date', includeIfNull: false) DateTime? get dueDate;
/// Create a copy of CreateTaskRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTaskRequestCopyWith<CreateTaskRequest> get copyWith => _$CreateTaskRequestCopyWithImpl<CreateTaskRequest>(this as CreateTaskRequest, _$identity);

  /// Serializes this CreateTaskRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTaskRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.area, area) || other.area == area)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.status, status) || other.status == status)&&(identical(other.assigneeId, assigneeId) || other.assigneeId == assigneeId)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,area,const DeepCollectionEquality().hash(tags),status,assigneeId,dueDate);

@override
String toString() {
  return 'CreateTaskRequest(title: $title, description: $description, area: $area, tags: $tags, status: $status, assigneeId: $assigneeId, dueDate: $dueDate)';
}


}

/// @nodoc
abstract mixin class $CreateTaskRequestCopyWith<$Res>  {
  factory $CreateTaskRequestCopyWith(CreateTaskRequest value, $Res Function(CreateTaskRequest) _then) = _$CreateTaskRequestCopyWithImpl;
@useResult
$Res call({
 String title,@JsonKey(includeIfNull: false) String? description, String area, List<String> tags, String status,@JsonKey(name: 'assignee_id', includeIfNull: false) String? assigneeId,@JsonKey(name: 'due_date', includeIfNull: false) DateTime? dueDate
});




}
/// @nodoc
class _$CreateTaskRequestCopyWithImpl<$Res>
    implements $CreateTaskRequestCopyWith<$Res> {
  _$CreateTaskRequestCopyWithImpl(this._self, this._then);

  final CreateTaskRequest _self;
  final $Res Function(CreateTaskRequest) _then;

/// Create a copy of CreateTaskRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = freezed,Object? area = null,Object? tags = null,Object? status = null,Object? assigneeId = freezed,Object? dueDate = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,assigneeId: freezed == assigneeId ? _self.assigneeId : assigneeId // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateTaskRequest].
extension CreateTaskRequestPatterns on CreateTaskRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTaskRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTaskRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTaskRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateTaskRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTaskRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTaskRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title, @JsonKey(includeIfNull: false)  String? description,  String area,  List<String> tags,  String status, @JsonKey(name: 'assignee_id', includeIfNull: false)  String? assigneeId, @JsonKey(name: 'due_date', includeIfNull: false)  DateTime? dueDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTaskRequest() when $default != null:
return $default(_that.title,_that.description,_that.area,_that.tags,_that.status,_that.assigneeId,_that.dueDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title, @JsonKey(includeIfNull: false)  String? description,  String area,  List<String> tags,  String status, @JsonKey(name: 'assignee_id', includeIfNull: false)  String? assigneeId, @JsonKey(name: 'due_date', includeIfNull: false)  DateTime? dueDate)  $default,) {final _that = this;
switch (_that) {
case _CreateTaskRequest():
return $default(_that.title,_that.description,_that.area,_that.tags,_that.status,_that.assigneeId,_that.dueDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title, @JsonKey(includeIfNull: false)  String? description,  String area,  List<String> tags,  String status, @JsonKey(name: 'assignee_id', includeIfNull: false)  String? assigneeId, @JsonKey(name: 'due_date', includeIfNull: false)  DateTime? dueDate)?  $default,) {final _that = this;
switch (_that) {
case _CreateTaskRequest() when $default != null:
return $default(_that.title,_that.description,_that.area,_that.tags,_that.status,_that.assigneeId,_that.dueDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTaskRequest implements CreateTaskRequest {
  const _CreateTaskRequest({required this.title, @JsonKey(includeIfNull: false) this.description, required this.area, required final  List<String> tags, required this.status, @JsonKey(name: 'assignee_id', includeIfNull: false) this.assigneeId, @JsonKey(name: 'due_date', includeIfNull: false) this.dueDate}): _tags = tags;
  factory _CreateTaskRequest.fromJson(Map<String, dynamic> json) => _$CreateTaskRequestFromJson(json);

@override final  String title;
@override@JsonKey(includeIfNull: false) final  String? description;
@override final  String area;
 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  String status;
@override@JsonKey(name: 'assignee_id', includeIfNull: false) final  String? assigneeId;
@override@JsonKey(name: 'due_date', includeIfNull: false) final  DateTime? dueDate;

/// Create a copy of CreateTaskRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTaskRequestCopyWith<_CreateTaskRequest> get copyWith => __$CreateTaskRequestCopyWithImpl<_CreateTaskRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTaskRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTaskRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.area, area) || other.area == area)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.status, status) || other.status == status)&&(identical(other.assigneeId, assigneeId) || other.assigneeId == assigneeId)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,area,const DeepCollectionEquality().hash(_tags),status,assigneeId,dueDate);

@override
String toString() {
  return 'CreateTaskRequest(title: $title, description: $description, area: $area, tags: $tags, status: $status, assigneeId: $assigneeId, dueDate: $dueDate)';
}


}

/// @nodoc
abstract mixin class _$CreateTaskRequestCopyWith<$Res> implements $CreateTaskRequestCopyWith<$Res> {
  factory _$CreateTaskRequestCopyWith(_CreateTaskRequest value, $Res Function(_CreateTaskRequest) _then) = __$CreateTaskRequestCopyWithImpl;
@override @useResult
$Res call({
 String title,@JsonKey(includeIfNull: false) String? description, String area, List<String> tags, String status,@JsonKey(name: 'assignee_id', includeIfNull: false) String? assigneeId,@JsonKey(name: 'due_date', includeIfNull: false) DateTime? dueDate
});




}
/// @nodoc
class __$CreateTaskRequestCopyWithImpl<$Res>
    implements _$CreateTaskRequestCopyWith<$Res> {
  __$CreateTaskRequestCopyWithImpl(this._self, this._then);

  final _CreateTaskRequest _self;
  final $Res Function(_CreateTaskRequest) _then;

/// Create a copy of CreateTaskRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? area = null,Object? tags = null,Object? status = null,Object? assigneeId = freezed,Object? dueDate = freezed,}) {
  return _then(_CreateTaskRequest(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,assigneeId: freezed == assigneeId ? _self.assigneeId : assigneeId // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$UpdateTaskRequest {

 String? get title; String? get description; String? get area;@JsonKey(includeIfNull: false) List<String>? get tags; String? get status;
/// Create a copy of UpdateTaskRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateTaskRequestCopyWith<UpdateTaskRequest> get copyWith => _$UpdateTaskRequestCopyWithImpl<UpdateTaskRequest>(this as UpdateTaskRequest, _$identity);

  /// Serializes this UpdateTaskRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateTaskRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.area, area) || other.area == area)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,area,const DeepCollectionEquality().hash(tags),status);

@override
String toString() {
  return 'UpdateTaskRequest(title: $title, description: $description, area: $area, tags: $tags, status: $status)';
}


}

/// @nodoc
abstract mixin class $UpdateTaskRequestCopyWith<$Res>  {
  factory $UpdateTaskRequestCopyWith(UpdateTaskRequest value, $Res Function(UpdateTaskRequest) _then) = _$UpdateTaskRequestCopyWithImpl;
@useResult
$Res call({
 String? title, String? description, String? area,@JsonKey(includeIfNull: false) List<String>? tags, String? status
});




}
/// @nodoc
class _$UpdateTaskRequestCopyWithImpl<$Res>
    implements $UpdateTaskRequestCopyWith<$Res> {
  _$UpdateTaskRequestCopyWithImpl(this._self, this._then);

  final UpdateTaskRequest _self;
  final $Res Function(UpdateTaskRequest) _then;

/// Create a copy of UpdateTaskRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? description = freezed,Object? area = freezed,Object? tags = freezed,Object? status = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateTaskRequest].
extension UpdateTaskRequestPatterns on UpdateTaskRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateTaskRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateTaskRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateTaskRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateTaskRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? description,  String? area, @JsonKey(includeIfNull: false)  List<String>? tags,  String? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateTaskRequest() when $default != null:
return $default(_that.title,_that.description,_that.area,_that.tags,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? description,  String? area, @JsonKey(includeIfNull: false)  List<String>? tags,  String? status)  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskRequest():
return $default(_that.title,_that.description,_that.area,_that.tags,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? description,  String? area, @JsonKey(includeIfNull: false)  List<String>? tags,  String? status)?  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskRequest() when $default != null:
return $default(_that.title,_that.description,_that.area,_that.tags,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateTaskRequest implements UpdateTaskRequest {
  const _UpdateTaskRequest({this.title, this.description, this.area, @JsonKey(includeIfNull: false) final  List<String>? tags, this.status}): _tags = tags;
  factory _UpdateTaskRequest.fromJson(Map<String, dynamic> json) => _$UpdateTaskRequestFromJson(json);

@override final  String? title;
@override final  String? description;
@override final  String? area;
 final  List<String>? _tags;
@override@JsonKey(includeIfNull: false) List<String>? get tags {
  final value = _tags;
  if (value == null) return null;
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? status;

/// Create a copy of UpdateTaskRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateTaskRequestCopyWith<_UpdateTaskRequest> get copyWith => __$UpdateTaskRequestCopyWithImpl<_UpdateTaskRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateTaskRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateTaskRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.area, area) || other.area == area)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,area,const DeepCollectionEquality().hash(_tags),status);

@override
String toString() {
  return 'UpdateTaskRequest(title: $title, description: $description, area: $area, tags: $tags, status: $status)';
}


}

/// @nodoc
abstract mixin class _$UpdateTaskRequestCopyWith<$Res> implements $UpdateTaskRequestCopyWith<$Res> {
  factory _$UpdateTaskRequestCopyWith(_UpdateTaskRequest value, $Res Function(_UpdateTaskRequest) _then) = __$UpdateTaskRequestCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? description, String? area,@JsonKey(includeIfNull: false) List<String>? tags, String? status
});




}
/// @nodoc
class __$UpdateTaskRequestCopyWithImpl<$Res>
    implements _$UpdateTaskRequestCopyWith<$Res> {
  __$UpdateTaskRequestCopyWithImpl(this._self, this._then);

  final _UpdateTaskRequest _self;
  final $Res Function(_UpdateTaskRequest) _then;

/// Create a copy of UpdateTaskRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? description = freezed,Object? area = freezed,Object? tags = freezed,Object? status = freezed,}) {
  return _then(_UpdateTaskRequest(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SetTaskStatusRequest {

 String get status;
/// Create a copy of SetTaskStatusRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetTaskStatusRequestCopyWith<SetTaskStatusRequest> get copyWith => _$SetTaskStatusRequestCopyWithImpl<SetTaskStatusRequest>(this as SetTaskStatusRequest, _$identity);

  /// Serializes this SetTaskStatusRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetTaskStatusRequest&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status);

@override
String toString() {
  return 'SetTaskStatusRequest(status: $status)';
}


}

/// @nodoc
abstract mixin class $SetTaskStatusRequestCopyWith<$Res>  {
  factory $SetTaskStatusRequestCopyWith(SetTaskStatusRequest value, $Res Function(SetTaskStatusRequest) _then) = _$SetTaskStatusRequestCopyWithImpl;
@useResult
$Res call({
 String status
});




}
/// @nodoc
class _$SetTaskStatusRequestCopyWithImpl<$Res>
    implements $SetTaskStatusRequestCopyWith<$Res> {
  _$SetTaskStatusRequestCopyWithImpl(this._self, this._then);

  final SetTaskStatusRequest _self;
  final $Res Function(SetTaskStatusRequest) _then;

/// Create a copy of SetTaskStatusRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SetTaskStatusRequest].
extension SetTaskStatusRequestPatterns on SetTaskStatusRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetTaskStatusRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetTaskStatusRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetTaskStatusRequest value)  $default,){
final _that = this;
switch (_that) {
case _SetTaskStatusRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetTaskStatusRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SetTaskStatusRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetTaskStatusRequest() when $default != null:
return $default(_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status)  $default,) {final _that = this;
switch (_that) {
case _SetTaskStatusRequest():
return $default(_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status)?  $default,) {final _that = this;
switch (_that) {
case _SetTaskStatusRequest() when $default != null:
return $default(_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SetTaskStatusRequest implements SetTaskStatusRequest {
  const _SetTaskStatusRequest({required this.status});
  factory _SetTaskStatusRequest.fromJson(Map<String, dynamic> json) => _$SetTaskStatusRequestFromJson(json);

@override final  String status;

/// Create a copy of SetTaskStatusRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetTaskStatusRequestCopyWith<_SetTaskStatusRequest> get copyWith => __$SetTaskStatusRequestCopyWithImpl<_SetTaskStatusRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetTaskStatusRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetTaskStatusRequest&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status);

@override
String toString() {
  return 'SetTaskStatusRequest(status: $status)';
}


}

/// @nodoc
abstract mixin class _$SetTaskStatusRequestCopyWith<$Res> implements $SetTaskStatusRequestCopyWith<$Res> {
  factory _$SetTaskStatusRequestCopyWith(_SetTaskStatusRequest value, $Res Function(_SetTaskStatusRequest) _then) = __$SetTaskStatusRequestCopyWithImpl;
@override @useResult
$Res call({
 String status
});




}
/// @nodoc
class __$SetTaskStatusRequestCopyWithImpl<$Res>
    implements _$SetTaskStatusRequestCopyWith<$Res> {
  __$SetTaskStatusRequestCopyWithImpl(this._self, this._then);

  final _SetTaskStatusRequest _self;
  final $Res Function(_SetTaskStatusRequest) _then;

/// Create a copy of SetTaskStatusRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,}) {
  return _then(_SetTaskStatusRequest(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SetTaskAssigneeRequest {

@JsonKey(name: 'assignee_id') String? get assigneeId;
/// Create a copy of SetTaskAssigneeRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetTaskAssigneeRequestCopyWith<SetTaskAssigneeRequest> get copyWith => _$SetTaskAssigneeRequestCopyWithImpl<SetTaskAssigneeRequest>(this as SetTaskAssigneeRequest, _$identity);

  /// Serializes this SetTaskAssigneeRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetTaskAssigneeRequest&&(identical(other.assigneeId, assigneeId) || other.assigneeId == assigneeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assigneeId);

@override
String toString() {
  return 'SetTaskAssigneeRequest(assigneeId: $assigneeId)';
}


}

/// @nodoc
abstract mixin class $SetTaskAssigneeRequestCopyWith<$Res>  {
  factory $SetTaskAssigneeRequestCopyWith(SetTaskAssigneeRequest value, $Res Function(SetTaskAssigneeRequest) _then) = _$SetTaskAssigneeRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'assignee_id') String? assigneeId
});




}
/// @nodoc
class _$SetTaskAssigneeRequestCopyWithImpl<$Res>
    implements $SetTaskAssigneeRequestCopyWith<$Res> {
  _$SetTaskAssigneeRequestCopyWithImpl(this._self, this._then);

  final SetTaskAssigneeRequest _self;
  final $Res Function(SetTaskAssigneeRequest) _then;

/// Create a copy of SetTaskAssigneeRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assigneeId = freezed,}) {
  return _then(_self.copyWith(
assigneeId: freezed == assigneeId ? _self.assigneeId : assigneeId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SetTaskAssigneeRequest].
extension SetTaskAssigneeRequestPatterns on SetTaskAssigneeRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetTaskAssigneeRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetTaskAssigneeRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetTaskAssigneeRequest value)  $default,){
final _that = this;
switch (_that) {
case _SetTaskAssigneeRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetTaskAssigneeRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SetTaskAssigneeRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'assignee_id')  String? assigneeId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetTaskAssigneeRequest() when $default != null:
return $default(_that.assigneeId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'assignee_id')  String? assigneeId)  $default,) {final _that = this;
switch (_that) {
case _SetTaskAssigneeRequest():
return $default(_that.assigneeId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'assignee_id')  String? assigneeId)?  $default,) {final _that = this;
switch (_that) {
case _SetTaskAssigneeRequest() when $default != null:
return $default(_that.assigneeId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SetTaskAssigneeRequest implements SetTaskAssigneeRequest {
  const _SetTaskAssigneeRequest({@JsonKey(name: 'assignee_id') this.assigneeId});
  factory _SetTaskAssigneeRequest.fromJson(Map<String, dynamic> json) => _$SetTaskAssigneeRequestFromJson(json);

@override@JsonKey(name: 'assignee_id') final  String? assigneeId;

/// Create a copy of SetTaskAssigneeRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetTaskAssigneeRequestCopyWith<_SetTaskAssigneeRequest> get copyWith => __$SetTaskAssigneeRequestCopyWithImpl<_SetTaskAssigneeRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetTaskAssigneeRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetTaskAssigneeRequest&&(identical(other.assigneeId, assigneeId) || other.assigneeId == assigneeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assigneeId);

@override
String toString() {
  return 'SetTaskAssigneeRequest(assigneeId: $assigneeId)';
}


}

/// @nodoc
abstract mixin class _$SetTaskAssigneeRequestCopyWith<$Res> implements $SetTaskAssigneeRequestCopyWith<$Res> {
  factory _$SetTaskAssigneeRequestCopyWith(_SetTaskAssigneeRequest value, $Res Function(_SetTaskAssigneeRequest) _then) = __$SetTaskAssigneeRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'assignee_id') String? assigneeId
});




}
/// @nodoc
class __$SetTaskAssigneeRequestCopyWithImpl<$Res>
    implements _$SetTaskAssigneeRequestCopyWith<$Res> {
  __$SetTaskAssigneeRequestCopyWithImpl(this._self, this._then);

  final _SetTaskAssigneeRequest _self;
  final $Res Function(_SetTaskAssigneeRequest) _then;

/// Create a copy of SetTaskAssigneeRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assigneeId = freezed,}) {
  return _then(_SetTaskAssigneeRequest(
assigneeId: freezed == assigneeId ? _self.assigneeId : assigneeId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SetTaskDueDateRequest {

@JsonKey(name: 'due_date') DateTime? get dueDate;
/// Create a copy of SetTaskDueDateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetTaskDueDateRequestCopyWith<SetTaskDueDateRequest> get copyWith => _$SetTaskDueDateRequestCopyWithImpl<SetTaskDueDateRequest>(this as SetTaskDueDateRequest, _$identity);

  /// Serializes this SetTaskDueDateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetTaskDueDateRequest&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dueDate);

@override
String toString() {
  return 'SetTaskDueDateRequest(dueDate: $dueDate)';
}


}

/// @nodoc
abstract mixin class $SetTaskDueDateRequestCopyWith<$Res>  {
  factory $SetTaskDueDateRequestCopyWith(SetTaskDueDateRequest value, $Res Function(SetTaskDueDateRequest) _then) = _$SetTaskDueDateRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'due_date') DateTime? dueDate
});




}
/// @nodoc
class _$SetTaskDueDateRequestCopyWithImpl<$Res>
    implements $SetTaskDueDateRequestCopyWith<$Res> {
  _$SetTaskDueDateRequestCopyWithImpl(this._self, this._then);

  final SetTaskDueDateRequest _self;
  final $Res Function(SetTaskDueDateRequest) _then;

/// Create a copy of SetTaskDueDateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dueDate = freezed,}) {
  return _then(_self.copyWith(
dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SetTaskDueDateRequest].
extension SetTaskDueDateRequestPatterns on SetTaskDueDateRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetTaskDueDateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetTaskDueDateRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetTaskDueDateRequest value)  $default,){
final _that = this;
switch (_that) {
case _SetTaskDueDateRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetTaskDueDateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SetTaskDueDateRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'due_date')  DateTime? dueDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetTaskDueDateRequest() when $default != null:
return $default(_that.dueDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'due_date')  DateTime? dueDate)  $default,) {final _that = this;
switch (_that) {
case _SetTaskDueDateRequest():
return $default(_that.dueDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'due_date')  DateTime? dueDate)?  $default,) {final _that = this;
switch (_that) {
case _SetTaskDueDateRequest() when $default != null:
return $default(_that.dueDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SetTaskDueDateRequest implements SetTaskDueDateRequest {
  const _SetTaskDueDateRequest({@JsonKey(name: 'due_date') this.dueDate});
  factory _SetTaskDueDateRequest.fromJson(Map<String, dynamic> json) => _$SetTaskDueDateRequestFromJson(json);

@override@JsonKey(name: 'due_date') final  DateTime? dueDate;

/// Create a copy of SetTaskDueDateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetTaskDueDateRequestCopyWith<_SetTaskDueDateRequest> get copyWith => __$SetTaskDueDateRequestCopyWithImpl<_SetTaskDueDateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetTaskDueDateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetTaskDueDateRequest&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dueDate);

@override
String toString() {
  return 'SetTaskDueDateRequest(dueDate: $dueDate)';
}


}

/// @nodoc
abstract mixin class _$SetTaskDueDateRequestCopyWith<$Res> implements $SetTaskDueDateRequestCopyWith<$Res> {
  factory _$SetTaskDueDateRequestCopyWith(_SetTaskDueDateRequest value, $Res Function(_SetTaskDueDateRequest) _then) = __$SetTaskDueDateRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'due_date') DateTime? dueDate
});




}
/// @nodoc
class __$SetTaskDueDateRequestCopyWithImpl<$Res>
    implements _$SetTaskDueDateRequestCopyWith<$Res> {
  __$SetTaskDueDateRequestCopyWithImpl(this._self, this._then);

  final _SetTaskDueDateRequest _self;
  final $Res Function(_SetTaskDueDateRequest) _then;

/// Create a copy of SetTaskDueDateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dueDate = freezed,}) {
  return _then(_SetTaskDueDateRequest(
dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
