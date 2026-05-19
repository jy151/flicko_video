import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class DiscoverItem {
  final String username;
  final int likes;
  final String imageUrl;
  final double aspectRatio;

  const DiscoverItem({
    required this.username,
    required this.likes,
    required this.imageUrl,
    this.aspectRatio = 1.0,
  });
}

class DiscoverState {
  final List<DiscoverItem> items;
  final int page;

  const DiscoverState({
    this.items = const [
      DiscoverItem(
        username: 'Evan',
        likes: 454,
        imageUrl: 'https://picsum.photos/300/200?random=1',
        aspectRatio: 1.2,
      ),
      DiscoverItem(
        username: 'Nolan',
        likes: 648,
        imageUrl: 'https://picsum.photos/300/200?random=2',
        aspectRatio: 0.9,
      ),
      DiscoverItem(
        username: 'Blake',
        likes: 792,
        imageUrl: 'https://picsum.photos/300/200?random=3',
        aspectRatio: 1.0,
      ),
      DiscoverItem(
        username: 'Owen',
        likes: 578,
        imageUrl: 'https://picsum.photos/300/200?random=4',
        aspectRatio: 1.1,
      ),
      DiscoverItem(
        username: 'Gavin',
        likes: 109,
        imageUrl: 'https://picsum.photos/300/200?random=5',
        aspectRatio: 1.3,
      ),
      DiscoverItem(
        username: 'Hunter',
        likes: 854,
        imageUrl: 'https://picsum.photos/300/200?random=6',
        aspectRatio: 0.85,
      ),
      DiscoverItem(
        username: 'Lily',
        likes: 321,
        imageUrl: 'https://picsum.photos/300/200?random=7',
        aspectRatio: 1.0,
      ),
      DiscoverItem(
        username: 'Max',
        likes: 567,
        imageUrl: 'https://picsum.photos/300/200?random=8',
        aspectRatio: 0.9,
      ),
    ],
    this.page = 1,
  });

  DiscoverState copyWith({
    List<DiscoverItem>? items,
    int? page,
  }) {
    return DiscoverState(
      items: items ?? this.items,
      page: page ?? this.page,
    );
  }
}

class DiscoverNotifier extends StateNotifier<DiscoverState> {
  DiscoverNotifier() : super(const DiscoverState());

  Future<void> refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    state = const DiscoverState();
  }

  Future<void> loadMore() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final nextPage = state.page + 1;
    final moreItems = List.generate(6, (index) {
      final seed = (nextPage - 1) * 10 + index + 1;
      return DiscoverItem(
        username: 'User $seed',
        likes: 100 + seed * 13,
        imageUrl: 'https://picsum.photos/300/200?random=$seed',
        aspectRatio: index.isEven ? 1.0 : 0.9,
      );
    });

    state = state.copyWith(
      page: nextPage,
      items: [...state.items, ...moreItems],
    );
  }
}

final discoverProvider =
    StateNotifierProvider<DiscoverNotifier, DiscoverState>((ref) {
  return DiscoverNotifier();
});
