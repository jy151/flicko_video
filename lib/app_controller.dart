import 'package:flicko_video/api/api.dart';
import 'package:flicko_video/hive/app/app_box.dart';
import 'package:flicko_video/hive/auth/auth_box.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'app_state.dart';

class AppController extends StateNotifier<AppState> {
  AppController() : super(const AppState());

  @override
  void dispose() {
    super.dispose();
  }

  /// 初始化应用
  Future<void> init() async {
    if (!AuthBox.isLoggedIn) {
      await AuthBox.login(source: 'guest');
    }

  }
}

final appControllerProvider = StateNotifierProvider<AppController, AppState>((
  ref,
) {
  var controller = AppController();

  ref.onDispose(controller.dispose);
  return controller;
});
