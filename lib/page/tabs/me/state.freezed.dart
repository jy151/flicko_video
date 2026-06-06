// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MeState {

 String get email; String get userId; int get credits; String get vipPlan; String get vipExpiry; List<Work> get works;
/// Create a copy of MeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeStateCopyWith<MeState> get copyWith => _$MeStateCopyWithImpl<MeState>(this as MeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeState&&(identical(other.email, email) || other.email == email)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.credits, credits) || other.credits == credits)&&(identical(other.vipPlan, vipPlan) || other.vipPlan == vipPlan)&&(identical(other.vipExpiry, vipExpiry) || other.vipExpiry == vipExpiry)&&const DeepCollectionEquality().equals(other.works, works));
}


@override
int get hashCode => Object.hash(runtimeType,email,userId,credits,vipPlan,vipExpiry,const DeepCollectionEquality().hash(works));

@override
String toString() {
  return 'MeState(email: $email, userId: $userId, credits: $credits, vipPlan: $vipPlan, vipExpiry: $vipExpiry, works: $works)';
}


}

/// @nodoc
abstract mixin class $MeStateCopyWith<$Res>  {
  factory $MeStateCopyWith(MeState value, $Res Function(MeState) _then) = _$MeStateCopyWithImpl;
@useResult
$Res call({
 String email, String userId, int credits, String vipPlan, String vipExpiry, List<Work> works
});




}
/// @nodoc
class _$MeStateCopyWithImpl<$Res>
    implements $MeStateCopyWith<$Res> {
  _$MeStateCopyWithImpl(this._self, this._then);

  final MeState _self;
  final $Res Function(MeState) _then;

/// Create a copy of MeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? userId = null,Object? credits = null,Object? vipPlan = null,Object? vipExpiry = null,Object? works = null,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,credits: null == credits ? _self.credits : credits // ignore: cast_nullable_to_non_nullable
as int,vipPlan: null == vipPlan ? _self.vipPlan : vipPlan // ignore: cast_nullable_to_non_nullable
as String,vipExpiry: null == vipExpiry ? _self.vipExpiry : vipExpiry // ignore: cast_nullable_to_non_nullable
as String,works: null == works ? _self.works : works // ignore: cast_nullable_to_non_nullable
as List<Work>,
  ));
}

}


/// Adds pattern-matching-related methods to [MeState].
extension MeStatePatterns on MeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeState value)  $default,){
final _that = this;
switch (_that) {
case _MeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeState value)?  $default,){
final _that = this;
switch (_that) {
case _MeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String userId,  int credits,  String vipPlan,  String vipExpiry,  List<Work> works)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeState() when $default != null:
return $default(_that.email,_that.userId,_that.credits,_that.vipPlan,_that.vipExpiry,_that.works);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String userId,  int credits,  String vipPlan,  String vipExpiry,  List<Work> works)  $default,) {final _that = this;
switch (_that) {
case _MeState():
return $default(_that.email,_that.userId,_that.credits,_that.vipPlan,_that.vipExpiry,_that.works);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String userId,  int credits,  String vipPlan,  String vipExpiry,  List<Work> works)?  $default,) {final _that = this;
switch (_that) {
case _MeState() when $default != null:
return $default(_that.email,_that.userId,_that.credits,_that.vipPlan,_that.vipExpiry,_that.works);case _:
  return null;

}
}

}

/// @nodoc


class _MeState implements MeState {
  const _MeState({this.email = '', this.userId = '1', this.credits = 0, this.vipPlan = 'Diamond SVIP Weekly', this.vipExpiry = '', final  List<Work> works = const []}): _works = works;
  

@override@JsonKey() final  String email;
@override@JsonKey() final  String userId;
@override@JsonKey() final  int credits;
@override@JsonKey() final  String vipPlan;
@override@JsonKey() final  String vipExpiry;
 final  List<Work> _works;
@override@JsonKey() List<Work> get works {
  if (_works is EqualUnmodifiableListView) return _works;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_works);
}


/// Create a copy of MeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeStateCopyWith<_MeState> get copyWith => __$MeStateCopyWithImpl<_MeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeState&&(identical(other.email, email) || other.email == email)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.credits, credits) || other.credits == credits)&&(identical(other.vipPlan, vipPlan) || other.vipPlan == vipPlan)&&(identical(other.vipExpiry, vipExpiry) || other.vipExpiry == vipExpiry)&&const DeepCollectionEquality().equals(other._works, _works));
}


@override
int get hashCode => Object.hash(runtimeType,email,userId,credits,vipPlan,vipExpiry,const DeepCollectionEquality().hash(_works));

@override
String toString() {
  return 'MeState(email: $email, userId: $userId, credits: $credits, vipPlan: $vipPlan, vipExpiry: $vipExpiry, works: $works)';
}


}

/// @nodoc
abstract mixin class _$MeStateCopyWith<$Res> implements $MeStateCopyWith<$Res> {
  factory _$MeStateCopyWith(_MeState value, $Res Function(_MeState) _then) = __$MeStateCopyWithImpl;
@override @useResult
$Res call({
 String email, String userId, int credits, String vipPlan, String vipExpiry, List<Work> works
});




}
/// @nodoc
class __$MeStateCopyWithImpl<$Res>
    implements _$MeStateCopyWith<$Res> {
  __$MeStateCopyWithImpl(this._self, this._then);

  final _MeState _self;
  final $Res Function(_MeState) _then;

/// Create a copy of MeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? userId = null,Object? credits = null,Object? vipPlan = null,Object? vipExpiry = null,Object? works = null,}) {
  return _then(_MeState(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,credits: null == credits ? _self.credits : credits // ignore: cast_nullable_to_non_nullable
as int,vipPlan: null == vipPlan ? _self.vipPlan : vipPlan // ignore: cast_nullable_to_non_nullable
as String,vipExpiry: null == vipExpiry ? _self.vipExpiry : vipExpiry // ignore: cast_nullable_to_non_nullable
as String,works: null == works ? _self._works : works // ignore: cast_nullable_to_non_nullable
as List<Work>,
  ));
}


}

// dart format on
