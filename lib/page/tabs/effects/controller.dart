import 'package:flicko_video/api/api.dart';
import 'package:flicko_video/hive/user/user_box.dart';
import 'package:flicko_video/page/tabs/effects/state.dart';
import 'package:flutter_riverpod/legacy.dart';

class EffectsNotifier extends StateNotifier<EffectsState> {
  EffectsNotifier() : super(EffectsState());

  void setBannerIndex(int index) {
    state = state.copyWith(currentBannerIndex: index);
  }

  Future<void> refresh() async {
    // await Future<void>.delayed(const Duration(milliseconds: 900));
    await syncBalance();
    final resp = await Api.getCreativeHome();
    state = state.copyWith(creativeHome: resp);
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

  Future<void> loadMore() async {
    // await Future<void>.delayed(const Duration(milliseconds: 900));
    // final nextPage = state.page + 1;
    // final newCategory = EffectCategory(
    //   name: 'Trending Pack $nextPage',
    //   items: List.generate(3, (index) {
    //     final seed = (nextPage - 1) * 10 + index + 30;
    //     return EffectItem(
    //       title: 'Effect Pack $seed',
    //       thumbnail: 'https://picsum.photos/300/200?random=$seed',
    //       isVip: index != 1,
    //     );
    //   }),
    // );

    // state = state.copyWith(
    //   page: nextPage,
    //   categories: [...state.categories, newCategory],
    // );
  }
}

final effectsProvider = StateNotifierProvider<EffectsNotifier, EffectsState>((
  ref,
) {
  return EffectsNotifier();
});
