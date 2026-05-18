import 'package:flutter_riverpod/legacy.dart';

import 'app_state.dart';

class AppController extends  StateNotifier<AppState> {
  AppController() : super(AppState());

}

final appControllerProvider = StateNotifierProvider<AppController, AppState>((ref) {
  var controller = AppController();
  ref.onDispose(controller.dispose);
  return controller;
});
