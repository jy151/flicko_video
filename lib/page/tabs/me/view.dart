import 'state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/app_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flicko_video/i18n/app_localizations.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';


class MeView extends ConsumerStatefulWidget {
  const MeView({super.key});

  @override
  ConsumerState<MeView> createState() => _MeViewState();
}

class _MeViewState extends ConsumerState<MeView> {
  final RefreshController _refreshController = RefreshController();
  @override
  void initState() {
    super.initState();
    ref.read(meProvider.notifier).init();
  }
  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await ref.read(meProvider.notifier).refreshWorks();
    _refreshController.refreshCompleted();
    _refreshController.resetNoData();
  }

  Future<void> _onLoading() async {
    await ref.read(meProvider.notifier).loadMoreWorks();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(meProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: true,
          header: const WaterDropHeader(
            waterDropColor: Color(0xFF6C63FF),
            complete: Icon(Icons.check, color: Color(0xFF6C63FF)),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildHeader(context, state, l10n),
                const SizedBox(height: 20),
                _buildProfile(state, l10n),
                const SizedBox(height: 16),
                _buildVipCard(state, l10n),
                const SizedBox(height: 24),
                _buildWorksSection(state, l10n),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    MeState state,
    AppLocalizations l10n,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.me,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            const Text('🎁', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => context.push('/recharge'),
              child: Row(
                children: [
                  const Text('💎', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 4),
                  Text(
                    '${state.credits}',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => context.push('/setting'),
              child: const Icon(
                Icons.settings_outlined,
                color: Colors.white70,
                size: 22,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfile(MeState state, AppLocalizations l10n) {
    return Row(
      children: [
        //  跳转进入登录页面
        GestureDetector(
          onTap: () => context.push('/login'),
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFFE53935),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'f\nAI',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      state.email,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.edit_outlined,
                    color: Colors.white54,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '${l10n.idLabel}: ${state.userId}',
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: state.userId));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        l10n.copy,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVipCard(MeState state, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A3A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(
                      '${l10n.expirationDate}: ${state.vipExpiry}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/member'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4A843),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          l10n.upgradeNow,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Text('💎', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      l10n.vip,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      state.vipPlan,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorksSection(MeState state, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.works,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.85,
          ),
          itemCount: state.works.length,
          itemBuilder: (context, index) {
            return _buildWorkCard(state.works[index]);
          },
        ),
      ],
    );
  }

  Widget _buildWorkCard(WorkItem item) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppNetworkImage(
            imageUrl: item.thumbnailUrl,
            fit: BoxFit.cover,
            placeholderColor: const Color(0xFF2A2A4A),
          ),
          Positioned(
            left: 6,
            bottom: 6,
            child: Row(
              children: [
                const Icon(Icons.videocam, color: Colors.white70, size: 12),
                const SizedBox(width: 3),
                Text(
                  item.duration,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
          ),
          Positioned(
            right: 6,
            bottom: 6,
            child: Container(
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.more_horiz,
                color: Colors.white70,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
