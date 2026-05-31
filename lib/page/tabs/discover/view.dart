import 'package:flicko_video/api/model/video_model.dart';
import 'package:flicko_video/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../widgets/app_network_image.dart';
import 'state.dart';

class DiscoverView extends ConsumerStatefulWidget {
  const DiscoverView({super.key});

  @override
  ConsumerState<DiscoverView> createState() => _DiscoverViewState();
}

class _DiscoverViewState extends ConsumerState<DiscoverView> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  @override
  void initState() {
    ref.read(discoverProvider.notifier).init();
    super.initState();
  }
  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await ref.read(discoverProvider.notifier).refresh();
    _refreshController.refreshCompleted();
    _refreshController.resetNoData();
  }

  Future<void> _onLoading() async {
    final hasMore = await ref.read(discoverProvider.notifier).loadMore();
    if (!hasMore) {
      _refreshController.loadNoData();
      return;
    }
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(discoverProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(state, l10n),
            Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: true,
                header: const WaterDropHeader(
                  waterDropColor: Color(0xFF6C63FF),
                  complete: Icon(Icons.check, color: Color(0xFF6C63FF)),
                ),
              
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: CustomScrollView( 
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverMasonryGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childCount: state.items.length,
                        itemBuilder: (context, index) {
                          return _buildCard(state.items[index], index);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(DiscoverState state, AppLocalizations l10n) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.explore,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
        SizedBox(
          height: 16,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              return Text(state.categories[index].title ?? '',style: TextStyle(color: 
              Colors.white),);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCard(Work item, int index) {
    final heights = [180.0, 220.0, 200.0, 240.0, 210.0, 190.0, 200.0, 230.0];
    final height = heights[index % heights.length];

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF1A1A2E),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppNetworkImage(
            imageUrl: item.cover ?? '',
            fit: BoxFit.cover,
            placeholderColor: const Color(0xFF2A2A4A),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.member?.name ?? ' 暂无名称',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.favorite_border,
                    color: Colors.white70,
                    size: 14,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '${item.hot}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
