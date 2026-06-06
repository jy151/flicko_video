import 'package:flicko_video/api/api.dart';
import 'package:flicko_video/hive/user/user_box.dart';
import 'package:flicko_video/page/tabs/me/state.dart';
import 'package:flutter_riverpod/legacy.dart';

class MeNotifier extends StateNotifier<MeState> {
  MeNotifier() : super(const MeState());

  Future<void> init() async {
    final member = await UserBox.syncUserInfo();
    final balance = await UserBox.syncBalance(memberId: member?.memberId);
    final works = await Api.getVideoWorks();

    state = state.copyWith(
      email: member?.email ?? 'guest@flicko.com',
      userId: member?.memberId?.toString() ?? '',
      credits: balance?.credit ?? UserBox.credit,
      works: works,
    );
  }
}

final meProvider = StateNotifierProvider<MeNotifier, MeState>((ref) {
  return MeNotifier();
});
