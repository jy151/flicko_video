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
mixin _$DiscoverState {

 List<Work> get items; List<ShowcaseCategory> get categories; int get lastId; bool get loading;
/// Create a copy of DiscoverState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoverStateCopyWith<DiscoverState> get copyWith => _$DiscoverStateCopyWithImpl<DiscoverState>(this as DiscoverState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoverState&&const DeepCollectionEquality().equals(other.items, items)&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.lastId, lastId) || other.lastId == lastId)&&(identical(other.loading, loading) || other.loading == loading));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),const DeepCollectionEquality().hash(categories),lastId,loading);

@override
String toString() {
  return 'DiscoverState(items: $items, categories: $categories, lastId: $lastId, loading: $loading)';
}


}

/// @nodoc
abstract mixin class $DiscoverStateCopyWith<$Res>  {
  factory $DiscoverStateCopyWith(DiscoverState value, $Res Function(DiscoverState) _then) = _$DiscoverStateCopyWithImpl;
@useResult
$Res call({
 List<Work> items, List<ShowcaseCategory> categories, int lastId, bool loading
});




}
/// @nodoc
class _$DiscoverStateCopyWithImpl<$Res>
    implements $DiscoverStateCopyWith<$Res> {
  _$DiscoverStateCopyWithImpl(this._self, this._then);

  final DiscoverState _self;
  final $Res Function(DiscoverState) _then;

/// Create a copy of DiscoverState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? categories = null,Object? lastId = null,Object? loading = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Work>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<ShowcaseCategory>,lastId: null == lastId ? _self.lastId : lastId // ignore: cast_nullable_to_non_nullable
as int,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DiscoverState].
extension DiscoverStatePatterns on DiscoverState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscoverState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscoverState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscoverState value)  $default,){
final _that = this;
switch (_that) {
case _DiscoverState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscoverState value)?  $default,){
final _that = this;
switch (_that) {
case _DiscoverState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Work> items,  List<ShowcaseCategory> categories,  int lastId,  bool loading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscoverState() when $default != null:
return $default(_that.items,_that.categories,_that.lastId,_that.loading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Work> items,  List<ShowcaseCategory> categories,  int lastId,  bool loading)  $default,) {final _that = this;
switch (_that) {
case _DiscoverState():
return $default(_that.items,_that.categories,_that.lastId,_that.loading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Work> items,  List<ShowcaseCategory> categories,  int lastId,  bool loading)?  $default,) {final _that = this;
switch (_that) {
case _DiscoverState() when $default != null:
return $default(_that.items,_that.categories,_that.lastId,_that.loading);case _:
  return null;

}
}

}

/// @nodoc


class _DiscoverState implements DiscoverState {
  const _DiscoverState({final  List<Work> items = const [], final  List<ShowcaseCategory> categories = const [], this.lastId = 0, this.loading = true}): _items = items,_categories = categories;
  

 final  List<Work> _items;
@override@JsonKey() List<Work> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  List<ShowcaseCategory> _categories;
@override@JsonKey() List<ShowcaseCategory> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

@override@JsonKey() final  int lastId;
@override@JsonKey() final  bool loading;

/// Create a copy of DiscoverState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscoverStateCopyWith<_DiscoverState> get copyWith => __$DiscoverStateCopyWithImpl<_DiscoverState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscoverState&&const DeepCollectionEquality().equals(other._items, _items)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.lastId, lastId) || other.lastId == lastId)&&(identical(other.loading, loading) || other.loading == loading));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_categories),lastId,loading);

@override
String toString() {
  return 'DiscoverState(items: $items, categories: $categories, lastId: $lastId, loading: $loading)';
}


}

/// @nodoc
abstract mixin class _$DiscoverStateCopyWith<$Res> implements $DiscoverStateCopyWith<$Res> {
  factory _$DiscoverStateCopyWith(_DiscoverState value, $Res Function(_DiscoverState) _then) = __$DiscoverStateCopyWithImpl;
@override @useResult
$Res call({
 List<Work> items, List<ShowcaseCategory> categories, int lastId, bool loading
});




}
/// @nodoc
class __$DiscoverStateCopyWithImpl<$Res>
    implements _$DiscoverStateCopyWith<$Res> {
  __$DiscoverStateCopyWithImpl(this._self, this._then);

  final _DiscoverState _self;
  final $Res Function(_DiscoverState) _then;

/// Create a copy of DiscoverState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? categories = null,Object? lastId = null,Object? loading = null,}) {
  return _then(_DiscoverState(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Work>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<ShowcaseCategory>,lastId: null == lastId ? _self.lastId : lastId // ignore: cast_nullable_to_non_nullable
as int,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
