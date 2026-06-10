import 'dart:async';

import 'package:flicko_video/api/api.dart';
import 'package:flicko_video/api/model/video_model.dart';
import 'package:flicko_video/hive/user/user_box.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
abstract class DiscoverState with _$DiscoverState {
  const factory DiscoverState({
    @Default([]) List<Work> items,
    @Default([]) List<ShowcaseCategory> categories,
    @Default(0) int lastId,
    @Default(0) int credits,
    @Default(true) bool loading,
  }) = _DiscoverState;
}

class DiscoverNotifier extends StateNotifier<DiscoverState> {
  DiscoverNotifier() : super(DiscoverState(credits: UserBox.credit)) {
    _watchUserCredit();
  }

  StreamSubscription<dynamic>? _userBoxSubscription;

  Future<bool> loadMore() async {
    final resp = await Api.getShowcaseWorks(lastId: state.lastId);
    if (state.loading) {
      state = state.copyWith(loading: false);
    }
    if (resp.isEmpty) {
      return false;
    }
    final lastId = resp.last.id;
    state = state.copyWith(
      lastId: lastId ?? 0,
      items: [...state.items, ...resp],
    );
    return true;
  }

  Future<void> refresh() async {
    state = state.copyWith(lastId: 0, items: [], credits: UserBox.credit);
    await loadMore();
  }

  Future<void> init() async {
    // await getShowcaseCategories();
  }

  Future<void> getShowcaseCategories() async {
    try {
      /// TODO 获取分类接口 404
      final categories = await Api.getShowcaseCategories();
      state = state.copyWith(categories: categories);
    } catch (e) {
      state = state.copyWith(categories: []);
    }
  }

  void _watchUserCredit() {
    _userBoxSubscription = UserBox.box.watch().listen((_) {
      _applyCreditFromCache();
    });
  }

  void _applyCreditFromCache() {
    final credit = UserBox.credit;
    if (mounted && credit != state.credits) {
      state = state.copyWith(credits: credit);
    }
  }

  @override
  void dispose() {
    _userBoxSubscription?.cancel();
    super.dispose();
  }
}

final discoverProvider = StateNotifierProvider<DiscoverNotifier, DiscoverState>(
  (ref) {
    final notifire = DiscoverNotifier();
    notifire.refresh();
    return notifire;
  },
);
