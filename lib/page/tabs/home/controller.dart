import 'dart:async';

import 'package:flicko_video/api/api.dart';
import 'package:flicko_video/api/model/config_model.dart';
import 'package:flicko_video/api/model/member_model.dart';
import 'package:flicko_video/api/model/video_model.dart';
import 'package:flicko_video/app_controller.dart';
import 'package:flicko_video/hive/user/user_box.dart';
import 'package:flicko_video/page/tabs/home/state.dart';
import 'package:flicko_video/utils/member_access.dart';
import 'package:flutter_riverpod/legacy.dart';

enum HomeCreateError {
  noImage,
  noPrompt,
  noDuration,
  requireMember,
  insufficientCredits,
  submitFailed,
}

class HomeCreateException implements Exception {
  const HomeCreateException(this.error);

  final HomeCreateError error;
}

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(HomeState(credits: UserBox.credit)) {
    _watchUserCredit();
  }

  StreamSubscription<dynamic>? _userBoxSubscription;

  void init({
    AiModelConfig? cachedConfig,
    required Future<AiModelConfig?> Function() loadConfig,
  }) async {
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
    await UserBox.syncUserInfo();
    _applyUserFromCache();
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
    final durations = _durationCreditsForModel(aiModel);
    state = state.copyWith(
      selectedModelId: aiModel.id ?? 0,
      availableDurations: durations,
      selectedDurationKey: _resolveDurationKey(durations),
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

  Future<void> applyInitialPrompt(String prompt) async {
    state = state.copyWith(
      videoMode: VideoMode.textToVideo,
      selectedImagePath: null,
      selectedImageBase64: null,
      promptText: prompt,
    );
    await setModeConfig();
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
      final member = await _syncUserInfoBeforeCreate();
      _applyUserFromCache();

      if (!isActiveVipMember(member)) {
        throw const HomeCreateException(HomeCreateError.requireMember);
      }

      if (UserBox.credit < _selectedCreditCost) {
        throw const HomeCreateException(HomeCreateError.insufficientCredits);
      }

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
      await _syncBalanceAfterCreate();
      return result;
    } catch (e) {
      rethrow;
    } finally {
      if (mounted) {
        state = state.copyWith(isSubmitting: false);
      }
    }
  }

  void _watchUserCredit() {
    _userBoxSubscription = UserBox.box.watch().listen((_) {
      _applyUserFromCache();
    });
  }

  void _applyUserFromCache() {
    final credit = UserBox.credit;
    final selectedModel = _selectedModel;
    final durations = selectedModel == null
        ? state.availableDurations
        : _durationCreditsForModel(selectedModel);

    if (mounted) {
      state = state.copyWith(
        credits: credit,
        availableDurations: durations,
        selectedDurationKey: _resolveDurationKey(
          durations,
          fallbackKey: state.selectedDurationKey,
        ),
      );
    }
  }

  Future<void> _syncBalanceAfterCreate() async {
    try {
      await UserBox.syncUserInfo();
    } catch (_) {
      // The create task already succeeded; balance will refresh on next sync.
    }
  }

  Future<Member?> _syncUserInfoBeforeCreate() async {
    try {
      return await UserBox.syncUserInfo();
    } catch (_) {
      throw const HomeCreateException(HomeCreateError.submitFailed);
    }
  }

  int get _selectedCreditCost {
    final value = state.availableDurations[state.selectedDurationKey];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  AiModel? get _selectedModel {
    for (final model in state.aiModels) {
      if (model.id == state.selectedModelId) {
        return model;
      }
    }
    return state.aiModels.isEmpty ? null : state.aiModels.first;
  }

  Map<String, dynamic> _durationCreditsForModel(AiModel model) {
    final vipCredits = model.vipCredits;
    if (isActiveVipMember(UserBox.member) &&
        vipCredits != null &&
        vipCredits.isNotEmpty) {
      return vipCredits;
    }
    return model.credits ?? {};
  }

  String _resolveDurationKey(
    Map<String, dynamic> durations, {
    String? fallbackKey,
  }) {
    if (fallbackKey != null && durations.containsKey(fallbackKey)) {
      return fallbackKey;
    }
    return durations.keys.isEmpty ? '' : durations.keys.first;
  }

  @override
  void dispose() {
    _userBoxSubscription?.cancel();
    super.dispose();
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
