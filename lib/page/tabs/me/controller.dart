import 'dart:async';

import 'package:flicko_video/api/api.dart';
import 'package:flicko_video/api/model/member_model.dart';
import 'package:flicko_video/hive/user/user_box.dart';
import 'package:flicko_video/page/tabs/me/state.dart';
import 'package:flicko_video/utils/member_access.dart';
import 'package:flutter_riverpod/legacy.dart';

const _noVipPlan = '暂无会员';

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

  Future<void> reloadWorks() => _loadWorks();

  void _applyUserBox({bool reloadWorksOnUserChange = true}) {
    final member = UserBox.member;
    final balance = UserBox.balance;
    final nextUserId = _firstNonEmpty([
      member?.memberId,
      balance?.memberId.toString(),
    ]);
    final userChanged = state.userId != nextUserId;
    final vipDisplay = _resolveVipDisplay(member);

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
      credits: member?.credit ?? balance?.credit ?? 0,
      vipPlan: vipDisplay.plan,
      vipExpiry: vipDisplay.expiry,
      works: nextUserId.isEmpty || userChanged ? [] : state.works,
    );

    if (reloadWorksOnUserChange && userChanged && nextUserId.isNotEmpty) {
      unawaited(_loadWorks());
    }
  }

  Future<void> _loadWorks() async {
    if (state.worksLoading) {
      return;
    }

    state = state.copyWith(worksLoading: true);
    try {
      final works = await Api.getVideoWorks();
      if (!mounted) {
        return;
      }
      state = state.copyWith(works: works);
    } catch (_) {
      // Profile data should stay live from Hive even if works loading fails.
    } finally {
      if (mounted) {
        state = state.copyWith(worksLoading: false);
      }
    }
  }

  ({String plan, String expiry}) _resolveVipDisplay(Member? member) {
    final endDate = vipEndDateTime(member?.vipEndDate);
    if (!isActiveVipMember(member) || endDate == null) {
      return (plan: _noVipPlan, expiry: '');
    }

    return (plan: _resolveVipPlan(member!), expiry: _formatDate(endDate));
  }

  String _resolveVipPlan(Member member) {
    final role = _firstNonEmpty([member.roles]);
    if (role.isNotEmpty) {
      return role;
    }

    return switch (member.vipLevel) {
      1 => '月度会员',
      2 => '季度会员',
      3 => '年度会员',
      final level? when level > 0 => 'VIP $level',
      _ => '会员',
    };
  }

  String _formatDate(DateTime dateTime) {
    final year = dateTime.year.toString().padLeft(4, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
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
