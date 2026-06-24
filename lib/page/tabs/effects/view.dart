import 'package:card_swiper/card_swiper.dart';
import 'package:flicko_video/api/model/video_model.dart';
import 'package:flicko_video/i18n/app_localizations.dart';
import 'package:flicko_video/page/effects_create/view.dart';
import 'package:flicko_video/page/tabs/effects/controller.dart';
import 'package:flicko_video/utils/paywall_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../widgets/app_network_image.dart';

class EffectsView extends ConsumerStatefulWidget {
  const EffectsView({super.key});

  @override
  ConsumerState<EffectsView> createState() => _EffectsViewState();
}

class _EffectsViewState extends ConsumerState<EffectsView> {
  final RefreshController _refreshController = RefreshController();
  var _initialLoading = false;

  static final _mockCreativeHome = CreativeHome.fromJson({
    'banners': List.generate(
      3,
      (index) => {'animation': 'https://example.com/banner-$index.jpg'},
    ),
    'categories': List.generate(
      3,
      (categoryIndex) => {
        'title': 'Category Name',
        'templates': List.generate(
          3,
          (templateIndex) => {
            'title': 'Template Name',
            'cover':
                'https://example.com/template-$categoryIndex-$templateIndex.jpg',
            'tags': 'NEW',
          },
        ),
      },
    ),
  });

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || ref.read(effectsProvider).creativeHome != null) {
        return;
      }
      _loadInitialData();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _initialLoading = true;
    });

    try {
      await ref.read(effectsProvider.notifier).refresh();
    } catch (_) {
      // Keep the page usable if the initial request fails.
    } finally {
      if (mounted) {
        setState(() {
          _initialLoading = false;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    try {
      await ref.read(effectsProvider.notifier).refresh();
    } finally {
      _refreshController.refreshCompleted();
      _refreshController.resetNoData();
    }
  }

  Future<void> _onLoading() async {
    await ref.read(effectsProvider.notifier).loadMore();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(effectsProvider);
    final l10n = AppLocalizations.of(context);
    final showSkeleton = _initialLoading && state.creativeHome == null;
    final creativeHome = showSkeleton ? _mockCreativeHome : state.creativeHome;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: false,
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

            return SizedBox(height: 56, child: Center(child: body));
          },
        ),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Skeletonizer(
          containersColor: Colors.white12,
          enableSwitchAnimation: true,
          enabled: showSkeleton,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBannerWithHeader(
                  ref,
                  creativeHome,
                  l10n,
                  skeletonEnabled: showSkeleton,
                ),
                const SizedBox(height: 16),
                ...creativeHome?.categories?.map(
                      (category) => Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: _buildCategorySection(
                          category,
                          l10n,
                          skeletonEnabled: showSkeleton,
                        ),
                      ),
                    ) ??
                    [],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBannerWithHeader(
    WidgetRef ref,
    CreativeHome? creativeHome,
    AppLocalizations l10n, {
    required bool skeletonEnabled,
  }) {
    if (creativeHome == null) {
      return const SizedBox();
    }
    final banners = creativeHome.banners ?? [];

    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: 380,
              child: Swiper(
                itemCount: banners.length,
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
                  if (skeletonEnabled) {
                    return Container(color: const Color(0xFF1A1A2E));
                  }

                  final banner = banners[index];
                  return GestureDetector(
                    onTap: () => _openBannerEffectsCreate(
                      creativeHome,
                      selectedTemplateId: banner.template?.id,
                    ),
                    child: AppNetworkImage(
                      imageUrl: banner.animation ?? '',
                      fit: BoxFit.cover,
                      placeholderColor: const Color(0xFF1A1A2E),
                    ),
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
                  'Aivaro',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => openMemberPage(context),
                  child: Container(
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
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(
    Category category,
    AppLocalizations l10n, {
    required bool skeletonEnabled,
  }) {
    final templates = category.templates ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.title ?? '暂无分类',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () => _openEffectsAll(category.id),
                child: Row(
                  children: [
                    Text(
                      l10n.all,
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey[400],
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(
              templates.length > 3 ? 3 : templates.length,
              (index) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : 5,
                    right: index == 2 ? 0 : 5,
                  ),
                  child: _buildEffectCard(
                    templates[index],
                    category,
                    l10n,
                    skeletonEnabled: skeletonEnabled,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEffectCard(
    Template item,
    Category category,
    AppLocalizations l10n, {
    required bool skeletonEnabled,
  }) {
    return GestureDetector(
      onTap: () => _openEffectsCreate(category, selectedTemplateId: item.id),
      child: AspectRatio(
        aspectRatio: 0.8,
        child: Stack(
          children: [
            if (skeletonEnabled)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(color: const Color(0xFF2A2A4A)),
              )
            else
              AppNetworkImage(
                imageUrl: item.animation ?? item.cover ?? '',
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
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: Text(
                  item.title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ),
            ),
            if (item.tags != null)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.tags ?? '',
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

  void _openEffectsCreate(Category category, {int? selectedTemplateId}) {
    context.push(
      '/effects_create',
      extra: EffectsCreateArgs(
        templates: category.templates ?? [],
        selectedTemplateId: selectedTemplateId,
      ),
    );
  }

  void _openEffectsAll(int? categoryId) {
    context.push(
      Uri(
        path: '/effects_all',
        queryParameters: {
          if (categoryId != null) 'categoryId': categoryId.toString(),
        },
      ).toString(),
    );
  }

  void _openBannerEffectsCreate(
    CreativeHome creativeHome, {
    int? selectedTemplateId,
  }) {
    final bannerTemplates = (creativeHome.banners ?? [])
        .map((banner) => banner.template)
        .whereType<Template>();
    final templates = [
      ...bannerTemplates,
      ...creativeHome.recommends ?? const <Template>[],
    ];

    context.push(
      '/effects_create',
      extra: EffectsCreateArgs(
        templates: templates,
        selectedTemplateId: selectedTemplateId,
      ),
    );
  }
}
