import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';

class EffectItem {
  final String title;
  final String thumbnail;
  final bool isVip;

  const EffectItem({
    required this.title,
    this.thumbnail = '',
    this.isVip = false,
  });
}

class EffectCategory {
  final String name;
  final List<EffectItem> items;

  const EffectCategory({required this.name, required this.items});
}

class EffectsState {
  final List<String> bannerImages;
  final List<EffectCategory> categories;
  final int currentBannerIndex;
  final int page;

  const EffectsState({
    this.bannerImages = const [
      'https://picsum.photos/600/300?random=20',
      'https://picsum.photos/600/300?random=21',
      'https://picsum.photos/600/300?random=22',
    ],
    this.categories = const [
      EffectCategory(
        name: 'Morphing into Plushtoy',
        items: [
          EffectItem(
            title: '20260319_010926\n_Wan2.2_00001\n(1)',
            isVip: true,
            thumbnail: 'https://picsum.photos/300/200?random=1',
          ),
          EffectItem(
            title: '450x_auto_ (1)',
            isVip: true,
            thumbnail: 'https://picsum.photos/300/200?random=2',
          ),
          EffectItem(
            title: '450x_auto_',
            isVip: true,
            thumbnail: 'https://picsum.photos/300/200?random=3',
          ),
        ],
      ),
      EffectCategory(
        name: 'Miraconstruction',
        items: [
          EffectItem(
            title: '20260319_010051_\nWan2.2_00001',
            isVip: true,
            thumbnail: 'https://picsum.photos/300/200?random=4',
          ),
          EffectItem(
            title: '20260319_010116_\nWan2.2_00001',
            isVip: true,
            thumbnail: 'https://picsum.photos/300/200?random=5',
          ),
          EffectItem(
            title: '20260319_011519_\nWan2.2_00001',
            isVip: true,
            thumbnail: 'https://picsum.photos/300/200?random=6',
          ),
        ],
      ),
    ],
    this.currentBannerIndex = 0,
    this.page = 1,
  });

  EffectsState copyWith({
    List<String>? bannerImages,
    List<EffectCategory>? categories,
    int? currentBannerIndex,
    int? page,
  }) {
    return EffectsState(
      bannerImages: bannerImages ?? this.bannerImages,
      categories: categories ?? this.categories,
      currentBannerIndex: currentBannerIndex ?? this.currentBannerIndex,
      page: page ?? this.page,
    );
  }
}

class EffectsNotifier extends StateNotifier<EffectsState> {
  EffectsNotifier() : super(const EffectsState());

  void setBannerIndex(int index) {
    state = state.copyWith(currentBannerIndex: index);
  }

  Future<void> refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    state = const EffectsState();
  }

  Future<void> loadMore() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final nextPage = state.page + 1;
    final newCategory = EffectCategory(
      name: 'Trending Pack $nextPage',
      items: List.generate(3, (index) {
        final seed = (nextPage - 1) * 10 + index + 30;
        return EffectItem(
          title: 'Effect Pack $seed',
          thumbnail: 'https://picsum.photos/300/200?random=$seed',
          isVip: index != 1,
        );
      }),
    );

    state = state.copyWith(
      page: nextPage,
      categories: [...state.categories, newCategory],
    );
  }
}

final effectsProvider =
    StateNotifierProvider<EffectsNotifier, EffectsState>((ref) {
  return EffectsNotifier();
});
