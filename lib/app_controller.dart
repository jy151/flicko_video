import 'package:flicko_video/api/api.dart';
import 'package:flicko_video/api/model/config_model.dart';
import 'package:flicko_video/hive/auth/auth_box.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'app_state.dart';

class AppController extends StateNotifier<AppState> {
  AppController() : super(const AppState());

  Future<void>? _initRequest;
  Future<void>? _loginRequest;
  Future<AiModelConfig?>? _aiModelConfigRequest;

  /// 初始化应用
  Future<void> init() async {
    _initRequest ??= _init();
    await _initRequest;
  }

  Future<void> _init() async {
    await _ensureLoggedIn();
    await loadAiModelConfig();
  }

  Future<void> _ensureLoggedIn() async {
    if (!AuthBox.isLoggedIn) {
      _loginRequest ??= AuthBox.login(source: 'guest').whenComplete(() {
        _loginRequest = null;
      });
      await _loginRequest;
    }
  }

  Future<AiModelConfig?> loadAiModelConfig() async {
    final cachedConfig = state.config;
    if (cachedConfig != null) {
      return cachedConfig;
    }

    await _ensureLoggedIn();
    final pendingRequest = _aiModelConfigRequest;
    if (pendingRequest != null) {
      return pendingRequest;
    }

    final request = _fetchAiModelConfig();
    _aiModelConfigRequest = request;
    try {
      final config = await request;
      if (config == null) {
        _aiModelConfigRequest = null;
      }
      return config;
    } catch (_) {
      if (identical(_aiModelConfigRequest, request)) {
        _aiModelConfigRequest = null;
      }
      return null;
    }
  }

  Future<AiModelConfig?> _fetchAiModelConfig() async {
    final config = await Api.getAllAiModels();
    if (config != null && mounted) {
      state = state.copyWith(config: config);
    }
    return config;
  }
}

final appControllerProvider = StateNotifierProvider<AppController, AppState>((
  ref,
) {
  var controller = AppController();
  return controller;
});
