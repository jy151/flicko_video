import 'package:card_swiper/card_swiper.dart';
import 'package:flicko_video/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../widgets/app_network_image.dart';
import 'state.dart';

class EffectsView extends ConsumerStatefulWidget {
  const EffectsView({super.key});

  @override
  ConsumerState<EffectsView> createState() => _EffectsViewState();
}

class _EffectsViewState extends ConsumerState<EffectsView> {
  final RefreshController _refreshController = RefreshController();

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await ref.read(effectsProvider.notifier).refresh();
    _refreshController.refreshCompleted();
    _refreshController.resetNoData();
  }

  Future<void> _onLoading() async {
    await ref.read(effectsProvider.notifier).loadMore();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(effectsProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        header: const WaterDropMaterialHeader(
          color: Color(0xFF6C63FF),
          backgroundColor: Color(0xFF0D0D1A),
        ),
        footer: CustomFooter(
          builder: (context, mode) {
            Widget body = Text(
              l10n.pullUpToLoadMore,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            );

            if (mode == LoadStatus.loading) {
              body = const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF6C63FF),
                ),
              );
            } else if (mode == LoadStatus.failed) {
              body = Text(
                l10n.loadFailed,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              );
            } else if (mode == LoadStatus.canLoading) {
              body = Text(
                l10n.releaseToLoadMore,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              );
            }

            return SizedBox(
              height: 56,
              child: Center(child: body),
            );
          },
        ),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBannerWithHeader(ref, state, l10n),
              const SizedBox(height: 16),
              ...state.categories.map(
                (category) => Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _buildCategorySection(category, l10n),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerWithHeader(
    WidgetRef ref,
    EffectsState state,
    AppLocalizations l10n,
  ) {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: 380,
              child: Swiper(
                itemCount: state.bannerImages.length,
                autoplay: true,
                autoplayDelay: 4000,
                onIndexChanged: (index) {
                  ref.read(effectsProvider.notifier).setBannerIndex(index);
                },
                pagination: SwiperPagination(
                  alignment: Alignment.bottomLeft,
                  margin: const EdgeInsets.only(left: 16, bottom: 16),
                  builder: DotSwiperPaginationBuilder(
                    activeColor: const Color(0xFF6C63FF),
                    color: Colors.grey[600]!,
                    size: 6,
                    activeSize: 8,
                    space: 4,
                  ),
                ),
                itemBuilder: (context, index) {
                  return AppNetworkImage(
                    imageUrl: state.bannerImages[index],
                    fit: BoxFit.cover,
                    placeholderColor: const Color(0xFF1A1A2E),
                  );
                },
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 60,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xFF0D0D1A)],
              ),
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Flicko',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('\u{1F451}', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        l10n.pro,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(EffectCategory category, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    l10n.all,
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey[400], size: 18),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(
              category.items.length > 3 ? 3 : category.items.length,
              (index) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : 5,
                    right: index == 2 ? 0 : 5,
                  ),
                  child: _buildEffectCard(category.items[index], l10n),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEffectCard(EffectItem item, AppLocalizations l10n) {
    return GestureDetector(
      onTap: () => context.push('/effects_create'),
      child: AspectRatio(
        aspectRatio: 0.8,
        child: Stack(
          children: [
            AppNetworkImage(
              imageUrl: item.thumbnail,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(8),
              placeholderColor: const Color(0xFF2A2A4A),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(8),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ),
            ),
            if (item.isVip)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    l10n.vip,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
