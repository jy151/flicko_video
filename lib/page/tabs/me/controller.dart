import 'dart:async';

import 'package:flicko_video/api/api.dart';
import 'package:flicko_video/api/model/member_model.dart';
import 'package:flicko_video/hive/user/user_box.dart';
import 'package:flicko_video/page/tabs/me/state.dart';
import 'package:flutter_riverpod/legacy.dart';

class MeNotifier extends StateNotifier<MeState> {
  MeNotifier() : super(const MeState());

  StreamSubscription<dynamic>? _userBoxSubscription;
  var _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      _initialized = true;
      _userBoxSubscription = UserBox.box.watch().listen((_) {
        _applyUserBox();
      });
    }

    _applyUserBox(reloadWorksOnUserChange: false);
    if (state.userId.isNotEmpty && state.works.isEmpty) {
      await _loadWorks();
    }
  }

  void _applyUserBox({bool reloadWorksOnUserChange = true}) {
    final member = UserBox.member;
    final balance = UserBox.balance;
    final nextUserId = _firstNonEmpty([member?.memberId, balance?.memberId.toString()]);
    final userChanged = state.userId != nextUserId;

    state = state.copyWith(
      name: _firstNonEmpty([member?.name, balance?.name]),
      portrait: _firstNonEmpty([
        member?.portrait,
        member?.aiPortrait,
        balance?.portrait,
        balance?.aiPortrait,
      ]),
      email: _firstNonEmpty([
        member?.email,
        balance?.email,
        member?.mobile,
        balance?.mobile,
      ]),
      userId: nextUserId,
      credits: balance?.credit ?? 0,
      vipPlan: _resolveVipPlan(member, balance),
      works: nextUserId.isEmpty || userChanged ? [] : state.works,
    );

    if (reloadWorksOnUserChange && userChanged && nextUserId.isNotEmpty) {
      unawaited(_loadWorks());
    }
  }

  Future<void> _loadWorks() async {
    try {
      final works = await Api.getVideoWorks();
      if (!mounted) {
        return;
      }
      state = state.copyWith(works: works);
    } catch (_) {
      // Profile data should stay live from Hive even if works loading fails.
    }
  }

  String _resolveVipPlan(Member? member, Balance? balance) {
    return _firstNonEmpty([balance?.roles, member?.roles, state.vipPlan]);
  }

  String _firstNonEmpty(Iterable<String?> values) {
    for (final value in values) {
      final text = value?.trim();
      if (text != null && text.isNotEmpty) {
        return text;
      }
    }
    return '';
  }

  @override
  void dispose() {
    _userBoxSubscription?.cancel();
    super.dispose();
  }
}

final meProvider = StateNotifierProvider.autoDispose<MeNotifier, MeState>((
  ref,
) {
  return MeNotifier();
});
