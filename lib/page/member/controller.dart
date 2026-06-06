import 'package:flicko_video/api/api.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'state.dart';

class MemberController extends StateNotifier<MemberState> {
  MemberController() : super(MemberState.initial());

  void selectPlan(String planId) {
    String paymentAmount = 'US\$99.99';
    String bonusDiamonds = '1,600';

    switch (planId) {
      case 'quarterly':
        paymentAmount = 'US\$39.99';
        bonusDiamonds = '700';
      case 'annual':
        paymentAmount = 'US\$99.99';
        bonusDiamonds = '1,600';
      case 'lifetime':
        paymentAmount = 'US\$199.99';
        bonusDiamonds = '3,000';
    }

    state = state.copyWith(
      selectedPlanId: planId,
      paymentAmount: paymentAmount,
      bonusDiamonds: bonusDiamonds,
    );
  }

  Future<void> unlockVipService() async {
    state = state.copyWith(isLoading: true);
    try {
      await Future<void>.delayed(const Duration(seconds: 1));
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> init() async {
   final resp = await Api.getSubscribeInfo();

  }

  

}

final memberControllerProvider =
    StateNotifierProvider<MemberController, MemberState>((ref) {
  return MemberController();
    });
