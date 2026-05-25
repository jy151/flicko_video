import 'package:flutter_riverpod/legacy.dart';

import 'state.dart';

class RechargeController extends StateNotifier<RechargeState> {
  RechargeController() : super(RechargeState.initial());

  void selectPackage(String packageId) {
    state = state.copyWith(selectedPackageId: packageId);
  }

  Future<void> recharge() async {
    if (state.selectedPackageId == null) return;

    state = state.copyWith(isLoading: true);
    try {
      await Future<void>.delayed(const Duration(seconds: 1));
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final rechargeControllerProvider =
    StateNotifierProvider<RechargeController, RechargeState>((ref) {
  return RechargeController();
});
