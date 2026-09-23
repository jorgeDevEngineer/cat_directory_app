// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaginatedResponse<T> {

@JsonKey(name: 'current_page') int get currentPage; List<T> get data;@JsonKey(name: 'last_page') int get lastPage;@JsonKey(name: 'per_page') dynamic get perPage; int get total;
/// Create a copy of PaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedResponseCopyWith<T, PaginatedResponse<T>> get copyWith => _$PaginatedResponseCopyWithImpl<T, PaginatedResponse<T>>(this as PaginatedResponse<T>, _$identity);

  /// Serializes this PaginatedResponse to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT);


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedResponse<T>&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&const DeepCollectionEquality().equals(other.perPage, perPage)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPage,const DeepCollectionEquality().hash(data),lastPage,const DeepCollectionEquality().hash(perPage),total);

@override
String toString() {
  return 'PaginatedResponse<$T>(currentPage: $currentPage, data: $data, lastPage: $lastPage, perPage: $perPage, total: $total)';
}


}

/// @nodoc
abstract mixin class $PaginatedResponseCopyWith<T,$Res>  {
  factory $PaginatedResponseCopyWith(PaginatedResponse<T> value, $Res Function(PaginatedResponse<T>) _then) = _$PaginatedResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'current_page') int currentPage, List<T> data,@JsonKey(name: 'last_page') int lastPage,@JsonKey(name: 'per_page') dynamic perPage, int total
});




}
/// @nodoc
class _$PaginatedResponseCopyWithImpl<T,$Res>
    implements $PaginatedResponseCopyWith<T, $Res> {
  _$PaginatedResponseCopyWithImpl(this._self, this._then);

  final PaginatedResponse<T> _self;
  final $Res Function(PaginatedResponse<T>) _then;

/// Create a copy of PaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentPage = null,Object? data = null,Object? lastPage = null,Object? perPage = freezed,Object? total = null,}) {
  return _then(_self.copyWith(
currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<T>,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,perPage: freezed == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as dynamic,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PaginatedResponse].
extension PaginatedResponsePatterns<T> on PaginatedResponse<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginatedResponse<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginatedResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginatedResponse<T> value)  $default,){
final _that = this;
switch (_that) {
case _PaginatedResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginatedResponse<T> value)?  $default,){
final _that = this;
switch (_that) {
case _PaginatedResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'current_page')  int currentPage,  List<T> data, @JsonKey(name: 'last_page')  int lastPage, @JsonKey(name: 'per_page')  dynamic perPage,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginatedResponse() when $default != null:
return $default(_that.currentPage,_that.data,_that.lastPage,_that.perPage,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'current_page')  int currentPage,  List<T> data, @JsonKey(name: 'last_page')  int lastPage, @JsonKey(name: 'per_page')  dynamic perPage,  int total)  $default,) {final _that = this;
switch (_that) {
case _PaginatedResponse():
return $default(_that.currentPage,_that.data,_that.lastPage,_that.perPage,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'current_page')  int currentPage,  List<T> data, @JsonKey(name: 'last_page')  int lastPage, @JsonKey(name: 'per_page')  dynamic perPage,  int total)?  $default,) {final _that = this;
switch (_that) {
case _PaginatedResponse() when $default != null:
return $default(_that.currentPage,_that.data,_that.lastPage,_that.perPage,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)

class _PaginatedResponse<T> implements PaginatedResponse<T> {
  const _PaginatedResponse({@JsonKey(name: 'current_page') required this.currentPage, required final  List<T> data, @JsonKey(name: 'last_page') required this.lastPage, @JsonKey(name: 'per_page') this.perPage, required this.total}): _data = data;
  factory _PaginatedResponse.fromJson(Map<String, dynamic> json,T Function(Object?) fromJsonT) => _$PaginatedResponseFromJson(json,fromJsonT);

@override@JsonKey(name: 'current_page') final  int currentPage;
 final  List<T> _data;
@override List<T> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override@JsonKey(name: 'last_page') final  int lastPage;
@override@JsonKey(name: 'per_page') final  dynamic perPage;
@override final  int total;

/// Create a copy of PaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginatedResponseCopyWith<T, _PaginatedResponse<T>> get copyWith => __$PaginatedResponseCopyWithImpl<T, _PaginatedResponse<T>>(this, _$identity);

@override
Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
  return _$PaginatedResponseToJson<T>(this, toJsonT);
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginatedResponse<T>&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&const DeepCollectionEquality().equals(other.perPage, perPage)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPage,const DeepCollectionEquality().hash(_data),lastPage,const DeepCollectionEquality().hash(perPage),total);

@override
String toString() {
  return 'PaginatedResponse<$T>(currentPage: $currentPage, data: $data, lastPage: $lastPage, perPage: $perPage, total: $total)';
}


}

/// @nodoc
abstract mixin class _$PaginatedResponseCopyWith<T,$Res> implements $PaginatedResponseCopyWith<T, $Res> {
  factory _$PaginatedResponseCopyWith(_PaginatedResponse<T> value, $Res Function(_PaginatedResponse<T>) _then) = __$PaginatedResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'current_page') int currentPage, List<T> data,@JsonKey(name: 'last_page') int lastPage,@JsonKey(name: 'per_page') dynamic perPage, int total
});




}
/// @nodoc
class __$PaginatedResponseCopyWithImpl<T,$Res>
    implements _$PaginatedResponseCopyWith<T, $Res> {
  __$PaginatedResponseCopyWithImpl(this._self, this._then);

  final _PaginatedResponse<T> _self;
  final $Res Function(_PaginatedResponse<T>) _then;

/// Create a copy of PaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentPage = null,Object? data = null,Object? lastPage = null,Object? perPage = freezed,Object? total = null,}) {
  return _then(_PaginatedResponse<T>(
currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<T>,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,perPage: freezed == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as dynamic,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
