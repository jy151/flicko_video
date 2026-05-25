import 'package:flutter_riverpod/legacy.dart';

import 'state.dart';

class EffectsCreateController extends StateNotifier<EffectsCreateState> {
  EffectsCreateController() : super(EffectsCreateState.initial());

  void selectEffect(String effectId) {
    state = state.copyWith(selectedEffectId: effectId);
  }

  void setSelectedImage(String path) {
    state = state.copyWith(selectedImagePath: path);
  }

  Future<void> submit() async {
    state = state.copyWith(isLoading: true);
    try {
      // TODO: Implement submit logic
      await Future.delayed(const Duration(seconds: 1));
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final effectsCreateProvider =
    StateNotifierProvider<EffectsCreateController, EffectsCreateState>((ref) {
  return EffectsCreateController();
});
