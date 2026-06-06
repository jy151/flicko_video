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
mixin _$EffectsState {

 CreativeHome? get creativeHome; int get currentBannerIndex; int get credits;
/// Create a copy of EffectsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EffectsStateCopyWith<EffectsState> get copyWith => _$EffectsStateCopyWithImpl<EffectsState>(this as EffectsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EffectsState&&(identical(other.creativeHome, creativeHome) || other.creativeHome == creativeHome)&&(identical(other.currentBannerIndex, currentBannerIndex) || other.currentBannerIndex == currentBannerIndex)&&(identical(other.credits, credits) || other.credits == credits));
}


@override
int get hashCode => Object.hash(runtimeType,creativeHome,currentBannerIndex,credits);

@override
String toString() {
  return 'EffectsState(creativeHome: $creativeHome, currentBannerIndex: $currentBannerIndex, credits: $credits)';
}


}

/// @nodoc
abstract mixin class $EffectsStateCopyWith<$Res>  {
  factory $EffectsStateCopyWith(EffectsState value, $Res Function(EffectsState) _then) = _$EffectsStateCopyWithImpl;
@useResult
$Res call({
 CreativeHome? creativeHome, int currentBannerIndex, int credits
});




}
/// @nodoc
class _$EffectsStateCopyWithImpl<$Res>
    implements $EffectsStateCopyWith<$Res> {
  _$EffectsStateCopyWithImpl(this._self, this._then);

  final EffectsState _self;
  final $Res Function(EffectsState) _then;

/// Create a copy of EffectsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? creativeHome = freezed,Object? currentBannerIndex = null,Object? credits = null,}) {
  return _then(_self.copyWith(
creativeHome: freezed == creativeHome ? _self.creativeHome : creativeHome // ignore: cast_nullable_to_non_nullable
as CreativeHome?,currentBannerIndex: null == currentBannerIndex ? _self.currentBannerIndex : currentBannerIndex // ignore: cast_nullable_to_non_nullable
as int,credits: null == credits ? _self.credits : credits // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EffectsState].
extension EffectsStatePatterns on EffectsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EffectsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EffectsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EffectsState value)  $default,){
final _that = this;
switch (_that) {
case _EffectsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EffectsState value)?  $default,){
final _that = this;
switch (_that) {
case _EffectsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CreativeHome? creativeHome,  int currentBannerIndex,  int credits)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EffectsState() when $default != null:
return $default(_that.creativeHome,_that.currentBannerIndex,_that.credits);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CreativeHome? creativeHome,  int currentBannerIndex,  int credits)  $default,) {final _that = this;
switch (_that) {
case _EffectsState():
return $default(_that.creativeHome,_that.currentBannerIndex,_that.credits);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CreativeHome? creativeHome,  int currentBannerIndex,  int credits)?  $default,) {final _that = this;
switch (_that) {
case _EffectsState() when $default != null:
return $default(_that.creativeHome,_that.currentBannerIndex,_that.credits);case _:
  return null;

}
}

}

/// @nodoc


class _EffectsState implements EffectsState {
  const _EffectsState({this.creativeHome = null, this.currentBannerIndex = 0, this.credits = 0});
  

@override@JsonKey() final  CreativeHome? creativeHome;
@override@JsonKey() final  int currentBannerIndex;
@override@JsonKey() final  int credits;

/// Create a copy of EffectsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EffectsStateCopyWith<_EffectsState> get copyWith => __$EffectsStateCopyWithImpl<_EffectsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EffectsState&&(identical(other.creativeHome, creativeHome) || other.creativeHome == creativeHome)&&(identical(other.currentBannerIndex, currentBannerIndex) || other.currentBannerIndex == currentBannerIndex)&&(identical(other.credits, credits) || other.credits == credits));
}


@override
int get hashCode => Object.hash(runtimeType,creativeHome,currentBannerIndex,credits);

@override
String toString() {
  return 'EffectsState(creativeHome: $creativeHome, currentBannerIndex: $currentBannerIndex, credits: $credits)';
}


}

/// @nodoc
abstract mixin class _$EffectsStateCopyWith<$Res> implements $EffectsStateCopyWith<$Res> {
  factory _$EffectsStateCopyWith(_EffectsState value, $Res Function(_EffectsState) _then) = __$EffectsStateCopyWithImpl;
@override @useResult
$Res call({
 CreativeHome? creativeHome, int currentBannerIndex, int credits
});




}
/// @nodoc
class __$EffectsStateCopyWithImpl<$Res>
    implements _$EffectsStateCopyWith<$Res> {
  __$EffectsStateCopyWithImpl(this._self, this._then);

  final _EffectsState _self;
  final $Res Function(_EffectsState) _then;

/// Create a copy of EffectsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? creativeHome = freezed,Object? currentBannerIndex = null,Object? credits = null,}) {
  return _then(_EffectsState(
creativeHome: freezed == creativeHome ? _self.creativeHome : creativeHome // ignore: cast_nullable_to_non_nullable
as CreativeHome?,currentBannerIndex: null == currentBannerIndex ? _self.currentBannerIndex : currentBannerIndex // ignore: cast_nullable_to_non_nullable
as int,credits: null == credits ? _self.credits : credits // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
