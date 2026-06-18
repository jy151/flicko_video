import 'dart:async';

import 'package:flicko_video/api/api.dart';
import 'package:flicko_video/api/model/config_model.dart';
import 'package:flicko_video/core/attribution_reporter.dart';
import 'package:flicko_video/hive/auth/auth_box.dart';
import 'package:flicko_video/hive/user/user_box.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'app_state.dart';

class AppController extends StateNotifier<AppState> {
  AppController() : super(const AppState());

  Future<void>? _initRequest;
  Future<void>? _loginRequest;
  Future<void>? _userSyncRequest;
  Future<AiModelConfig?>? _aiModelConfigRequest;
  int _aiModelConfigRequestVersion = 0;

  /// 初始化应用
  Future<void> init() async {
    _initRequest ??= _init();
    await _initRequest;
  }

  Future<void> _init() async {


    
    await _ensureLoggedIn();
    unawaited(AttributionReporter.reportAdjustClient());
    await syncUserData();
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

  Future<void> syncUserData() async {
    final pendingRequest = _userSyncRequest;
    if (pendingRequest != null) {
      await pendingRequest;
      return;
    }

    final request = _syncUserData();
    _userSyncRequest = request;
    try {
      await request;
    } finally {
      if (identical(_userSyncRequest, request)) {
        _userSyncRequest = null;
      }
    }
  }

  Future<void> _syncUserData() async {
    if (!AuthBox.isLoggedIn) {
      return;
    }

    try {
      await UserBox.syncUserInfo();
    } catch (_) {
      try {
        await UserBox.syncBalance();
      } catch (_) {
        // App startup should continue even if user refresh fails.
      }
    }
  }

  Future<AiModelConfig?> loadAiModelConfig() async {
    final cachedConfig = state.config;
    if (cachedConfig != null) {
      return cachedConfig;
    }

    return _requestAiModelConfig();
  }

  Future<AiModelConfig?> refreshAiModelConfig() async {
    return _requestAiModelConfig(forceRefresh: true);
  }

  Future<AiModelConfig?> _requestAiModelConfig({
    bool forceRefresh = false,
  }) async {
    await _ensureLoggedIn();
    final pendingRequest = _aiModelConfigRequest;
    if (!forceRefresh && pendingRequest != null) {
      return pendingRequest;
    }

    final requestVersion = ++_aiModelConfigRequestVersion;
    final request = _fetchAiModelConfig(requestVersion);
    _aiModelConfigRequest = request;
    try {
      return await request;
    } catch (_) {
      return null;
    } finally {
      if (identical(_aiModelConfigRequest, request)) {
        _aiModelConfigRequest = null;
      }
    }
  }

  Future<AiModelConfig?> _fetchAiModelConfig(int requestVersion) async {
    final config = await Api.getAllAiModels();
    if (config != null &&
        mounted &&
        requestVersion == _aiModelConfigRequestVersion) {
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
