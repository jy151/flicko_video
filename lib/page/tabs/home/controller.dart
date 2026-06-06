import 'package:flicko_video/api/api.dart';
import 'package:flicko_video/api/model/config_model.dart';
import 'package:flicko_video/api/model/video_model.dart';
import 'package:flicko_video/app_controller.dart';
import 'package:flicko_video/hive/user/user_box.dart';
import 'package:flicko_video/page/tabs/home/state.dart';
import 'package:flutter_riverpod/legacy.dart';

enum HomeCreateError { noImage, noPrompt, noDuration, submitFailed }

class HomeCreateException implements Exception {
  const HomeCreateException(this.error);

  final HomeCreateError error;
}

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState());

  void init({
    AiModelConfig? cachedConfig,
    required Future<AiModelConfig?> Function() loadConfig,
  }) async {
    // await syncBalance();
    if (cachedConfig != null) {
      _applyConfig(cachedConfig);
      return;
    }

    try {
      state = state.copyWith(loading: true);
      final config = await loadConfig();
      if (config != null) {
        _applyConfig(config);
      }
    } finally {
      if (mounted) {
        state = state.copyWith(loading: false);
      }
    }
  }

  Future<void> syncBalance() async {
    final cachedCredit = UserBox.credit;
    if (cachedCredit != state.credits) {
      state = state.copyWith(credits: cachedCredit);
    }

    final balance = await UserBox.syncBalance();
    if (mounted && balance != null) {
      state = state.copyWith(credits: balance.credit ?? 0);
    }
  }

  void _applyConfig(AiModelConfig config) {
    if (!mounted) {
      return;
    }

    state = state.copyWith(
      textModels: config.t2v ?? [],
      imageModels: config.i2v ?? [],
      imageGroups: config.imageStyles ?? [],
    );

    setModeConfig(showLoading: false);
    setImageGroup();
  }

  void setImageGroup({int index = 0}) {
    /// 默认选中第一个
    if (mounted && state.imageGroups.isNotEmpty) {
      final selectImageGroup = state.imageGroups[index];
      final imageStyles = selectImageGroup.styles;
      state = state.copyWith(
        selectImageGroup: selectImageGroup,
        imageStyles: imageStyles ?? [],
        selectImageStyle: imageStyles?.first,
      );
    }
  }

  void setImageStyle({int index = 0}) {
    if (state.imageStyles.isNotEmpty && state.imageStyles.isNotEmpty) {
      state = state.copyWith(selectImageStyle: state.imageStyles[index]);
    }
  }

  Future<void> setModeConfig({bool showLoading = true}) async {
    try {
      if (!mounted) {
        return;
      }
      if (showLoading) {
        state = state.copyWith(loading: true);
      }

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
      if (mounted && showLoading) {
        state = state.copyWith(loading: false);
      }
    }
  }

  void getDurations(AiModel aiModel) {
    state = state.copyWith(
      selectedModelId: aiModel.id ?? 0,
      availableDurations: aiModel.credits ?? {},
      selectedDurationKey: aiModel.credits?.keys.first ?? '',
    );
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

  void setSelectedImage({required String path, required String base64Image}) {
    state = state.copyWith(
      selectedImagePath: path,
      selectedImageBase64: base64Image,
    );
  }

  Future<AiCreateResponse?> submitCreateTask() async {
    final isImageToVideo = state.videoMode == VideoMode.imageToVideo;
    final duration = int.tryParse(state.selectedDurationKey);
    final prompt = state.promptText.trim();

    if (duration == null) {
      throw const HomeCreateException(HomeCreateError.noDuration);
    }

    if (isImageToVideo && state.selectedImageBase64 == null) {
      throw const HomeCreateException(HomeCreateError.noImage);
    }

    if (!isImageToVideo && prompt.isEmpty) {
      throw const HomeCreateException(HomeCreateError.noPrompt);
    }

    state = state.copyWith(isSubmitting: true);
    try {
      final result = await Api.createAiTask(
        type: isImageToVideo ? 'i2v' : 't2v',
        prompt: prompt.isEmpty ? null : prompt,
        image: isImageToVideo ? state.selectedImageBase64 : null,
        styleId: state.selectImageStyle?.id,
        duration: duration,
      );
      if (result == null) {
        throw const HomeCreateException(HomeCreateError.submitFailed);
      }
      return result;
    } finally {
      if (mounted) {
        state = state.copyWith(isSubmitting: false);
      }
    }
  }
}

final homeProvider = StateNotifierProvider.autoDispose<HomeNotifier, HomeState>(
  (ref) {
    final notifier = HomeNotifier();
    notifier.init(
      cachedConfig: ref.read(appControllerProvider).config,
      loadConfig: ref.read(appControllerProvider.notifier).loadAiModelConfig,
    );
    return notifier;
  },
);
