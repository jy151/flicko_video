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
mixin _$HomeState {

 VideoMode get videoMode; int get selectedModelId; String get selectedDurationKey; Map<String, dynamic> get availableDurations; String? get selectedImagePath; String? get selectedImageBase64; String get promptText; int get maxPromptLength; List<AiModel> get textModels; List<AiModel> get imageModels; List<AiModel> get aiModels; int get credits; bool get loading; bool get isSubmitting; List<ImageStyleGroup> get imageGroups; ImageStyleGroup? get selectImageGroup; List<ImageStyle> get imageStyles; ImageStyle? get selectImageStyle;
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStateCopyWith<HomeState> get copyWith => _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState&&(identical(other.videoMode, videoMode) || other.videoMode == videoMode)&&(identical(other.selectedModelId, selectedModelId) || other.selectedModelId == selectedModelId)&&(identical(other.selectedDurationKey, selectedDurationKey) || other.selectedDurationKey == selectedDurationKey)&&const DeepCollectionEquality().equals(other.availableDurations, availableDurations)&&(identical(other.selectedImagePath, selectedImagePath) || other.selectedImagePath == selectedImagePath)&&(identical(other.selectedImageBase64, selectedImageBase64) || other.selectedImageBase64 == selectedImageBase64)&&(identical(other.promptText, promptText) || other.promptText == promptText)&&(identical(other.maxPromptLength, maxPromptLength) || other.maxPromptLength == maxPromptLength)&&const DeepCollectionEquality().equals(other.textModels, textModels)&&const DeepCollectionEquality().equals(other.imageModels, imageModels)&&const DeepCollectionEquality().equals(other.aiModels, aiModels)&&(identical(other.credits, credits) || other.credits == credits)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&const DeepCollectionEquality().equals(other.imageGroups, imageGroups)&&(identical(other.selectImageGroup, selectImageGroup) || other.selectImageGroup == selectImageGroup)&&const DeepCollectionEquality().equals(other.imageStyles, imageStyles)&&(identical(other.selectImageStyle, selectImageStyle) || other.selectImageStyle == selectImageStyle));
}


@override
int get hashCode => Object.hash(runtimeType,videoMode,selectedModelId,selectedDurationKey,const DeepCollectionEquality().hash(availableDurations),selectedImagePath,selectedImageBase64,promptText,maxPromptLength,const DeepCollectionEquality().hash(textModels),const DeepCollectionEquality().hash(imageModels),const DeepCollectionEquality().hash(aiModels),credits,loading,isSubmitting,const DeepCollectionEquality().hash(imageGroups),selectImageGroup,const DeepCollectionEquality().hash(imageStyles),selectImageStyle);

@override
String toString() {
  return 'HomeState(videoMode: $videoMode, selectedModelId: $selectedModelId, selectedDurationKey: $selectedDurationKey, availableDurations: $availableDurations, selectedImagePath: $selectedImagePath, selectedImageBase64: $selectedImageBase64, promptText: $promptText, maxPromptLength: $maxPromptLength, textModels: $textModels, imageModels: $imageModels, aiModels: $aiModels, credits: $credits, loading: $loading, isSubmitting: $isSubmitting, imageGroups: $imageGroups, selectImageGroup: $selectImageGroup, imageStyles: $imageStyles, selectImageStyle: $selectImageStyle)';
}


}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res>  {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) = _$HomeStateCopyWithImpl;
@useResult
$Res call({
 VideoMode videoMode, int selectedModelId, String selectedDurationKey, Map<String, dynamic> availableDurations, String? selectedImagePath, String? selectedImageBase64, String promptText, int maxPromptLength, List<AiModel> textModels, List<AiModel> imageModels, List<AiModel> aiModels, int credits, bool loading, bool isSubmitting, List<ImageStyleGroup> imageGroups, ImageStyleGroup? selectImageGroup, List<ImageStyle> imageStyles, ImageStyle? selectImageStyle
});




}
/// @nodoc
class _$HomeStateCopyWithImpl<$Res>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? videoMode = null,Object? selectedModelId = null,Object? selectedDurationKey = null,Object? availableDurations = null,Object? selectedImagePath = freezed,Object? selectedImageBase64 = freezed,Object? promptText = null,Object? maxPromptLength = null,Object? textModels = null,Object? imageModels = null,Object? aiModels = null,Object? credits = null,Object? loading = null,Object? isSubmitting = null,Object? imageGroups = null,Object? selectImageGroup = freezed,Object? imageStyles = null,Object? selectImageStyle = freezed,}) {
  return _then(_self.copyWith(
videoMode: null == videoMode ? _self.videoMode : videoMode // ignore: cast_nullable_to_non_nullable
as VideoMode,selectedModelId: null == selectedModelId ? _self.selectedModelId : selectedModelId // ignore: cast_nullable_to_non_nullable
as int,selectedDurationKey: null == selectedDurationKey ? _self.selectedDurationKey : selectedDurationKey // ignore: cast_nullable_to_non_nullable
as String,availableDurations: null == availableDurations ? _self.availableDurations : availableDurations // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,selectedImagePath: freezed == selectedImagePath ? _self.selectedImagePath : selectedImagePath // ignore: cast_nullable_to_non_nullable
as String?,selectedImageBase64: freezed == selectedImageBase64 ? _self.selectedImageBase64 : selectedImageBase64 // ignore: cast_nullable_to_non_nullable
as String?,promptText: null == promptText ? _self.promptText : promptText // ignore: cast_nullable_to_non_nullable
as String,maxPromptLength: null == maxPromptLength ? _self.maxPromptLength : maxPromptLength // ignore: cast_nullable_to_non_nullable
as int,textModels: null == textModels ? _self.textModels : textModels // ignore: cast_nullable_to_non_nullable
as List<AiModel>,imageModels: null == imageModels ? _self.imageModels : imageModels // ignore: cast_nullable_to_non_nullable
as List<AiModel>,aiModels: null == aiModels ? _self.aiModels : aiModels // ignore: cast_nullable_to_non_nullable
as List<AiModel>,credits: null == credits ? _self.credits : credits // ignore: cast_nullable_to_non_nullable
as int,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,imageGroups: null == imageGroups ? _self.imageGroups : imageGroups // ignore: cast_nullable_to_non_nullable
as List<ImageStyleGroup>,selectImageGroup: freezed == selectImageGroup ? _self.selectImageGroup : selectImageGroup // ignore: cast_nullable_to_non_nullable
as ImageStyleGroup?,imageStyles: null == imageStyles ? _self.imageStyles : imageStyles // ignore: cast_nullable_to_non_nullable
as List<ImageStyle>,selectImageStyle: freezed == selectImageStyle ? _self.selectImageStyle : selectImageStyle // ignore: cast_nullable_to_non_nullable
as ImageStyle?,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeState value)  $default,){
final _that = this;
switch (_that) {
case _HomeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeState value)?  $default,){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VideoMode videoMode,  int selectedModelId,  String selectedDurationKey,  Map<String, dynamic> availableDurations,  String? selectedImagePath,  String? selectedImageBase64,  String promptText,  int maxPromptLength,  List<AiModel> textModels,  List<AiModel> imageModels,  List<AiModel> aiModels,  int credits,  bool loading,  bool isSubmitting,  List<ImageStyleGroup> imageGroups,  ImageStyleGroup? selectImageGroup,  List<ImageStyle> imageStyles,  ImageStyle? selectImageStyle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.videoMode,_that.selectedModelId,_that.selectedDurationKey,_that.availableDurations,_that.selectedImagePath,_that.selectedImageBase64,_that.promptText,_that.maxPromptLength,_that.textModels,_that.imageModels,_that.aiModels,_that.credits,_that.loading,_that.isSubmitting,_that.imageGroups,_that.selectImageGroup,_that.imageStyles,_that.selectImageStyle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VideoMode videoMode,  int selectedModelId,  String selectedDurationKey,  Map<String, dynamic> availableDurations,  String? selectedImagePath,  String? selectedImageBase64,  String promptText,  int maxPromptLength,  List<AiModel> textModels,  List<AiModel> imageModels,  List<AiModel> aiModels,  int credits,  bool loading,  bool isSubmitting,  List<ImageStyleGroup> imageGroups,  ImageStyleGroup? selectImageGroup,  List<ImageStyle> imageStyles,  ImageStyle? selectImageStyle)  $default,) {final _that = this;
switch (_that) {
case _HomeState():
return $default(_that.videoMode,_that.selectedModelId,_that.selectedDurationKey,_that.availableDurations,_that.selectedImagePath,_that.selectedImageBase64,_that.promptText,_that.maxPromptLength,_that.textModels,_that.imageModels,_that.aiModels,_that.credits,_that.loading,_that.isSubmitting,_that.imageGroups,_that.selectImageGroup,_that.imageStyles,_that.selectImageStyle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VideoMode videoMode,  int selectedModelId,  String selectedDurationKey,  Map<String, dynamic> availableDurations,  String? selectedImagePath,  String? selectedImageBase64,  String promptText,  int maxPromptLength,  List<AiModel> textModels,  List<AiModel> imageModels,  List<AiModel> aiModels,  int credits,  bool loading,  bool isSubmitting,  List<ImageStyleGroup> imageGroups,  ImageStyleGroup? selectImageGroup,  List<ImageStyle> imageStyles,  ImageStyle? selectImageStyle)?  $default,) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.videoMode,_that.selectedModelId,_that.selectedDurationKey,_that.availableDurations,_that.selectedImagePath,_that.selectedImageBase64,_that.promptText,_that.maxPromptLength,_that.textModels,_that.imageModels,_that.aiModels,_that.credits,_that.loading,_that.isSubmitting,_that.imageGroups,_that.selectImageGroup,_that.imageStyles,_that.selectImageStyle);case _:
  return null;

}
}

}

/// @nodoc


class _HomeState implements HomeState {
  const _HomeState({this.videoMode = VideoMode.imageToVideo, this.selectedModelId = 0, this.selectedDurationKey = '', final  Map<String, dynamic> availableDurations = const {}, this.selectedImagePath = null, this.selectedImageBase64 = null, this.promptText = '', this.maxPromptLength = 2000, final  List<AiModel> textModels = const [], final  List<AiModel> imageModels = const [], final  List<AiModel> aiModels = const [], this.credits = 0, this.loading = false, this.isSubmitting = false, final  List<ImageStyleGroup> imageGroups = const [], this.selectImageGroup = null, final  List<ImageStyle> imageStyles = const [], this.selectImageStyle = null}): _availableDurations = availableDurations,_textModels = textModels,_imageModels = imageModels,_aiModels = aiModels,_imageGroups = imageGroups,_imageStyles = imageStyles;
  

@override@JsonKey() final  VideoMode videoMode;
@override@JsonKey() final  int selectedModelId;
@override@JsonKey() final  String selectedDurationKey;
 final  Map<String, dynamic> _availableDurations;
@override@JsonKey() Map<String, dynamic> get availableDurations {
  if (_availableDurations is EqualUnmodifiableMapView) return _availableDurations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_availableDurations);
}

@override@JsonKey() final  String? selectedImagePath;
@override@JsonKey() final  String? selectedImageBase64;
@override@JsonKey() final  String promptText;
@override@JsonKey() final  int maxPromptLength;
 final  List<AiModel> _textModels;
@override@JsonKey() List<AiModel> get textModels {
  if (_textModels is EqualUnmodifiableListView) return _textModels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_textModels);
}

 final  List<AiModel> _imageModels;
@override@JsonKey() List<AiModel> get imageModels {
  if (_imageModels is EqualUnmodifiableListView) return _imageModels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageModels);
}

 final  List<AiModel> _aiModels;
@override@JsonKey() List<AiModel> get aiModels {
  if (_aiModels is EqualUnmodifiableListView) return _aiModels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_aiModels);
}

@override@JsonKey() final  int credits;
@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool isSubmitting;
 final  List<ImageStyleGroup> _imageGroups;
@override@JsonKey() List<ImageStyleGroup> get imageGroups {
  if (_imageGroups is EqualUnmodifiableListView) return _imageGroups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageGroups);
}

@override@JsonKey() final  ImageStyleGroup? selectImageGroup;
 final  List<ImageStyle> _imageStyles;
@override@JsonKey() List<ImageStyle> get imageStyles {
  if (_imageStyles is EqualUnmodifiableListView) return _imageStyles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageStyles);
}

@override@JsonKey() final  ImageStyle? selectImageStyle;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeStateCopyWith<_HomeState> get copyWith => __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeState&&(identical(other.videoMode, videoMode) || other.videoMode == videoMode)&&(identical(other.selectedModelId, selectedModelId) || other.selectedModelId == selectedModelId)&&(identical(other.selectedDurationKey, selectedDurationKey) || other.selectedDurationKey == selectedDurationKey)&&const DeepCollectionEquality().equals(other._availableDurations, _availableDurations)&&(identical(other.selectedImagePath, selectedImagePath) || other.selectedImagePath == selectedImagePath)&&(identical(other.selectedImageBase64, selectedImageBase64) || other.selectedImageBase64 == selectedImageBase64)&&(identical(other.promptText, promptText) || other.promptText == promptText)&&(identical(other.maxPromptLength, maxPromptLength) || other.maxPromptLength == maxPromptLength)&&const DeepCollectionEquality().equals(other._textModels, _textModels)&&const DeepCollectionEquality().equals(other._imageModels, _imageModels)&&const DeepCollectionEquality().equals(other._aiModels, _aiModels)&&(identical(other.credits, credits) || other.credits == credits)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&const DeepCollectionEquality().equals(other._imageGroups, _imageGroups)&&(identical(other.selectImageGroup, selectImageGroup) || other.selectImageGroup == selectImageGroup)&&const DeepCollectionEquality().equals(other._imageStyles, _imageStyles)&&(identical(other.selectImageStyle, selectImageStyle) || other.selectImageStyle == selectImageStyle));
}


@override
int get hashCode => Object.hash(runtimeType,videoMode,selectedModelId,selectedDurationKey,const DeepCollectionEquality().hash(_availableDurations),selectedImagePath,selectedImageBase64,promptText,maxPromptLength,const DeepCollectionEquality().hash(_textModels),const DeepCollectionEquality().hash(_imageModels),const DeepCollectionEquality().hash(_aiModels),credits,loading,isSubmitting,const DeepCollectionEquality().hash(_imageGroups),selectImageGroup,const DeepCollectionEquality().hash(_imageStyles),selectImageStyle);

@override
String toString() {
  return 'HomeState(videoMode: $videoMode, selectedModelId: $selectedModelId, selectedDurationKey: $selectedDurationKey, availableDurations: $availableDurations, selectedImagePath: $selectedImagePath, selectedImageBase64: $selectedImageBase64, promptText: $promptText, maxPromptLength: $maxPromptLength, textModels: $textModels, imageModels: $imageModels, aiModels: $aiModels, credits: $credits, loading: $loading, isSubmitting: $isSubmitting, imageGroups: $imageGroups, selectImageGroup: $selectImageGroup, imageStyles: $imageStyles, selectImageStyle: $selectImageStyle)';
}


}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(_HomeState value, $Res Function(_HomeState) _then) = __$HomeStateCopyWithImpl;
@override @useResult
$Res call({
 VideoMode videoMode, int selectedModelId, String selectedDurationKey, Map<String, dynamic> availableDurations, String? selectedImagePath, String? selectedImageBase64, String promptText, int maxPromptLength, List<AiModel> textModels, List<AiModel> imageModels, List<AiModel> aiModels, int credits, bool loading, bool isSubmitting, List<ImageStyleGroup> imageGroups, ImageStyleGroup? selectImageGroup, List<ImageStyle> imageStyles, ImageStyle? selectImageStyle
});




}
/// @nodoc
class __$HomeStateCopyWithImpl<$Res>
    implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? videoMode = null,Object? selectedModelId = null,Object? selectedDurationKey = null,Object? availableDurations = null,Object? selectedImagePath = freezed,Object? selectedImageBase64 = freezed,Object? promptText = null,Object? maxPromptLength = null,Object? textModels = null,Object? imageModels = null,Object? aiModels = null,Object? credits = null,Object? loading = null,Object? isSubmitting = null,Object? imageGroups = null,Object? selectImageGroup = freezed,Object? imageStyles = null,Object? selectImageStyle = freezed,}) {
  return _then(_HomeState(
videoMode: null == videoMode ? _self.videoMode : videoMode // ignore: cast_nullable_to_non_nullable
as VideoMode,selectedModelId: null == selectedModelId ? _self.selectedModelId : selectedModelId // ignore: cast_nullable_to_non_nullable
as int,selectedDurationKey: null == selectedDurationKey ? _self.selectedDurationKey : selectedDurationKey // ignore: cast_nullable_to_non_nullable
as String,availableDurations: null == availableDurations ? _self._availableDurations : availableDurations // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,selectedImagePath: freezed == selectedImagePath ? _self.selectedImagePath : selectedImagePath // ignore: cast_nullable_to_non_nullable
as String?,selectedImageBase64: freezed == selectedImageBase64 ? _self.selectedImageBase64 : selectedImageBase64 // ignore: cast_nullable_to_non_nullable
as String?,promptText: null == promptText ? _self.promptText : promptText // ignore: cast_nullable_to_non_nullable
as String,maxPromptLength: null == maxPromptLength ? _self.maxPromptLength : maxPromptLength // ignore: cast_nullable_to_non_nullable
as int,textModels: null == textModels ? _self._textModels : textModels // ignore: cast_nullable_to_non_nullable
as List<AiModel>,imageModels: null == imageModels ? _self._imageModels : imageModels // ignore: cast_nullable_to_non_nullable
as List<AiModel>,aiModels: null == aiModels ? _self._aiModels : aiModels // ignore: cast_nullable_to_non_nullable
as List<AiModel>,credits: null == credits ? _self.credits : credits // ignore: cast_nullable_to_non_nullable
as int,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,imageGroups: null == imageGroups ? _self._imageGroups : imageGroups // ignore: cast_nullable_to_non_nullable
as List<ImageStyleGroup>,selectImageGroup: freezed == selectImageGroup ? _self.selectImageGroup : selectImageGroup // ignore: cast_nullable_to_non_nullable
as ImageStyleGroup?,imageStyles: null == imageStyles ? _self._imageStyles : imageStyles // ignore: cast_nullable_to_non_nullable
as List<ImageStyle>,selectImageStyle: freezed == selectImageStyle ? _self.selectImageStyle : selectImageStyle // ignore: cast_nullable_to_non_nullable
as ImageStyle?,
  ));
}


}

// dart format on
