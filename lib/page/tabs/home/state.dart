import 'package:flicko_video/api/model/config_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

enum VideoMode { imageToVideo, textToVideo }

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(VideoMode.imageToVideo) VideoMode videoMode,
    @Default(0) int selectedModelId,
    @Default('') String selectedDurationKey,
    @Default({}) Map<String, dynamic> availableDurations,
    @Default(null) String? selectedImagePath,
    @Default(null) String? selectedImageBase64,
    @Default('') String promptText,
    @Default(2000) int maxPromptLength,
    @Default([]) List<AiModel> textModels,
    @Default([]) List<AiModel> imageModels,
    @Default([]) List<AiModel> aiModels,
    @Default(0) int credits,
    @Default(false) bool loading,
    @Default(false) bool isSubmitting,
    @Default([]) List<ImageStyleGroup> imageGroups,
    @Default(null) ImageStyleGroup? selectImageGroup,
    @Default([]) List<ImageStyle> imageStyles,
    @Default(null) ImageStyle? selectImageStyle,
  }) = _HomeState;
}
