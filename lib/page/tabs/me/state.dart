import 'dart:async';

import 'package:flicko_video/api/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class WorkItem {
  final String duration;
  final String thumbnailUrl;

  const WorkItem({
    required this.duration,
    this.thumbnailUrl = '',
  });
}

class MeState {
  final String email;
  final String userId;
  final int credits;
  final String vipPlan;
  final String vipExpiry;
  final List<WorkItem> works;
  final int page;

  const MeState({
    this.email = 'test001_account@flicko.com',
    this.userId = '1699008749397872640',
    this.credits = 518,
    this.vipPlan = 'Diamond SVIP Weekly',
    this.vipExpiry = '2026/08/07',
    this.works = const [
      WorkItem(
        duration: '00:05',
        thumbnailUrl: 'https://picsum.photos/300/200?random=10',
      ),
      WorkItem(
        duration: '00:05',
        thumbnailUrl: 'https://picsum.photos/300/200?random=11',
      ),
      WorkItem(
        duration: '00:05',
        thumbnailUrl: 'https://picsum.photos/300/200?random=12',
      ),
      WorkItem(
        duration: '00:05',
        thumbnailUrl: 'https://picsum.photos/300/200?random=13',
      ),
      WorkItem(
        duration: '00:05',
        thumbnailUrl: 'https://picsum.photos/300/200?random=14',
      ),
      WorkItem(
        duration: '00:05',
        thumbnailUrl: 'https://picsum.photos/300/200?random=15',
      ),
    ],
    this.page = 1,
  });

  MeState copyWith({
    String? email,
    String? userId,
    int? credits,
    String? vipPlan,
    String? vipExpiry,
    List<WorkItem>? works,
    int? page,
  }) {
    return MeState(
      email: email ?? this.email,
      userId: userId ?? this.userId,
      credits: credits ?? this.credits,
      vipPlan: vipPlan ?? this.vipPlan,
      vipExpiry: vipExpiry ?? this.vipExpiry,
      works: works ?? this.works,
      page: page ?? this.page,
    );
  }
}

class MeNotifier extends StateNotifier<MeState> {
  MeNotifier() : super(const MeState());

  Future<void> refreshWorks() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    state = const MeState();
  }

  Future<void> loadMoreWorks() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final nextPage = state.page + 1;
    final moreWorks = List.generate(6, (index) {
      final seed = 20 + (nextPage - 2) * 10 + index;
      return WorkItem(
        duration: '00:05',
        thumbnailUrl: 'https://picsum.photos/300/200?random=$seed',
      );
    });

    state = state.copyWith(
      page: nextPage,
      works: [...state.works, ...moreWorks],
    );
  }

  Future<void> init() async {
    final member = await Api.getMember();
    state = state.copyWith(
      email: member?.email ?? 'guest@flicko.com',
      userId: member?.memberId?.toString() ?? '',
      credits: member?.voiceDuration ?? 0,
    );
  }
}

final meProvider = StateNotifierProvider<MeNotifier, MeState>((ref) {
  return MeNotifier();
});
