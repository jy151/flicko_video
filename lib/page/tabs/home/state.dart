import 'package:flicko_video/api/api.dart';
import 'package:flicko_video/api/model/config_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
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
    @Default('') String promptText,
    @Default(2000) int maxPromptLength,
    @Default([]) List<AiModel> textModels,
    @Default([]) List<AiModel> imageModels,
    @Default([]) List<AiModel> aiModels,
    @Default(false) bool loading,
    @Default([]) List<ImageStyleGroup> imageGroups,
    @Default(null) ImageStyleGroup? selectImageGroup,
    @Default([]) List<ImageStyle> imageStyles,
    @Default(null) ImageStyle? selectImageStyle
    
  }) = _HomeState;
}

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState());
 
  void init() async {
    try {
      state = state.copyWith(loading: true);
      final config = await Api.getAllAiModels();
      if (config != null && mounted) {
        state = state.copyWith(
          textModels: config.t2v ?? [],
          imageModels: config.i2v ?? [],
          imageGroups: config.imageStyles ?? [],
        );
      }
   
      await setModeConfig();
      setImageGroup();
    } finally {
      if (mounted) { 
          state = state.copyWith(loading: false);
      }
    
    }
  }

  void setImageGroup({int index = 0}) {
    /// 默认选中第一个
    if (mounted && state.imageGroups.isNotEmpty  ) {
      final selectImageGroup = state.imageGroups[index];
      final imageStyles = selectImageGroup.styles;
      state = state.copyWith(selectImageGroup:selectImageGroup,imageStyles: imageStyles ?? [],selectImageStyle: imageStyles?.first);
    }
  }

  void setImageStyle({int index = 0}){
    if (state.imageStyles.isNotEmpty && state.imageStyles.isNotEmpty) {
     state = state.copyWith(selectImageStyle: state.imageStyles[index]);
    }


  }



  Future<void> setModeConfig() async {
    try {
     if (!mounted) {
        return;
      }
      state = state.copyWith(loading: true);

      /// 判断当前是textToVideo还是imageToVideo
      if (state.videoMode == VideoMode.textToVideo) {
        state = state.copyWith(aiModels: state.textModels);
      } else {
        state = state.copyWith(aiModels: state.imageModels);
      }

      /// 获取当前模型对应的时长
      if (state.aiModels.isNotEmpty) {
        final aiModel = state.aiModels.first;
        getDurations(aiModel);
      }
    } finally {
      if (!mounted) return;
      
      state = state.copyWith(loading: false);
    }
  }

  void getDurations(AiModel aiModel) {
    state = state.copyWith(
      selectedModelId: aiModel.id ?? 0,
      availableDurations: aiModel.credits ?? {},
      selectedDurationKey: aiModel.credits?.keys.first ?? '',
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setVideoMode(VideoMode mode) async {
    state = state.copyWith(videoMode: mode);
    await setModeConfig();
  }

  void setAiModel(AiModel model) {
    state = state.copyWith(selectedModelId: model.id ?? 0);
    getDurations(model);
  }

  void setDuration(String duration) {
    state = state.copyWith(selectedDurationKey: duration);
  }

  void setPromptText(String text) {
    state = state.copyWith(promptText: text);
  }

  void setSelectedImage(String path) {
    state = state.copyWith(selectedImagePath: path);
  }
}

final homeProvider = StateNotifierProvider.autoDispose<HomeNotifier, HomeState>(
  (ref) {
    final notifier = HomeNotifier();
    notifier.init();
    return notifier;
  },
);
 