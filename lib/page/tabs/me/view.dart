import 'package:flicko_video/api/model/video_model.dart';
import 'package:flicko_video/gen/assets.gen.dart';
import 'package:flicko_video/page/create_result/state.dart';
import 'package:flicko_video/page/tabs/me/controller.dart';
import 'package:flicko_video/utils/paywall_navigation.dart';
import 'package:flicko_video/utils/work_status_messages.dart';

import 'state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../widgets/app_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flicko_video/i18n/app_localizations.dart';

class MeView extends ConsumerStatefulWidget {
  const MeView({super.key});

  @override
  ConsumerState<MeView> createState() => _MeViewState();
}

class _MeViewState extends ConsumerState<MeView> {
  final RefreshController _refreshController = RefreshController();
  final Set<int> _deletingWorkIds = <int>{};
  static final _mockWorks = List.generate(
    6,
    (index) => Work(
      id: index,
      cover: 'https://example.com/work-$index.jpg',
      video: 'https://example.com/work-$index.mp4',
    ),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      ref.read(meProvider.notifier).init();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    try {
      await ref.read(meProvider.notifier).reloadWorks();
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    } catch (_) {
      _refreshController.refreshFailed();
    }
  }

  Future<void> _onLoading() async {
    try {
      await ref.read(meProvider.notifier).reloadWorks();
      _refreshController.loadComplete();
    } catch (_) {
      _refreshController.loadFailed();
    }
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
          header: const WaterDropMaterialHeader(
            color: Color(0xFF6C63FF),
            backgroundColor: Color(0xFF0D0D1A),
          ),
          footer: CustomFooter(
            builder: (context, mode) {
              if (mode == LoadStatus.loading) {
                return const SizedBox(
                  height: 56,
                  child: Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox(height: 56);
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
            GestureDetector(
              onTap: () => _openMemberOrWebPay(context),
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Text('🎁', style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => openRechargePage(context),
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
    final profileTitle = state.name.isNotEmpty
        ? state.name
        : state.email.isNotEmpty
        ? state.email
        : 'guest@flicko.com';

    return Row(
      children: [
        GestureDetector(
          onTap: () => context.push('/login'),
          child: _buildAvatar(state),
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
                      profileTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => context.push('/login'),
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.edit_outlined,
                        color: Colors.white54,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '${l10n.idLabel}: ${state.userId.isEmpty ? '--' : state.userId}',
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  const SizedBox(width: 6),
                  if (state.userId.isNotEmpty)
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

  Widget _buildAvatar(MeState state) {
    if (state.portrait.isNotEmpty) {
      return AppNetworkImage(
        imageUrl: state.portrait,
        width: 60,
        height: 60,
        borderRadius: BorderRadius.circular(30),
        placeholderColor: const Color(0xFF2A2A4A),
      );
    }

    return Container(
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
    );
  }

  Widget _buildVipCard(MeState state, AppLocalizations l10n) {
    final vipPlan = state.vipPlan.trim().isEmpty ? '暂无会员' : state.vipPlan;
    final vipExpiry = state.vipExpiry.trim().isEmpty ? '--' : state.vipExpiry;

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
                      '${l10n.expirationDate}: $vipExpiry',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: () => _openMemberOrWebPay(context),
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
                      vipPlan,
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
        if (state.worksLoading && state.works.isEmpty)
          _buildWorksSkeleton()
        else if (state.works.isEmpty)
          _buildEmptyWorks(l10n)
        else
          Skeletonizer(
            containersColor: Colors.white12,
            enableSwitchAnimation: true,
            enabled: state.worksLoading,
            child: _buildWorkGrid(state.works),
          ),
      ],
    );
  }

  Widget _buildWorksSkeleton() {
    return Skeletonizer(
      containersColor: Colors.white12,
      enableSwitchAnimation: true,
      enabled: true,
      child: _buildWorkGrid(_mockWorks),
    );
  }

  Widget _buildEmptyWorks(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      height: 220,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: Center(
              child: Assets.images.video.image(width: 64, height: 64),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.noWorks,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: () => context.go('/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                l10n.startCreating,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkGrid(List<Work> works) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: works.length,
      itemBuilder: (context, index) {
        return _buildWorkCard(works[index]);
      },
    );
  }

  Widget _buildWorkCard(Work item) {
    final thumbnailUrl = item.cover ?? item.image ?? item.video ?? '';
    final isFailed = item.jobStatus == 3;
    final isLoading = !isFailed && (item.video?.trim().isEmpty ?? true);
    final workId = item.id;
    final isDeleting = workId != null && _deletingWorkIds.contains(workId);

    return GestureDetector(
      onTap: () {
        context.push('/create_result', extra: CreateResultArgs(work: item));
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Builder(
              builder: (context) {
                if (isFailed) {
                  return const Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Color(0xFFFF6B6B),
                          size: 22,
                        ),
                        Center(
                          child: Text(
                            generationFailedRefundedMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 8,
                              height: 1.25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (item.video != null && item.video!.isNotEmpty) {
                  return AppNetworkImage(
                    imageUrl: thumbnailUrl,
                    fit: BoxFit.cover,
                    placeholderColor: const Color(0xFF2A2A4A),
                  );
                }
                // 加载
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                );
              },
            ),

            if (!isLoading)
              Positioned(
                left: 6,
                right: 6,
                bottom: 6,
                child: Row(
                  children: [
                    if (!isFailed) ...[
                      const Icon(
                        Icons.videocam,
                        color: Colors.white70,
                        size: 12,
                      ),
                      const SizedBox(width: 3),
                      const Text(
                        '00:05',
                        style: TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                    ],
                    const Spacer(),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: workId == null || isDeleting
                          ? null
                          : () => _confirmDeleteWork(item),
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: Center(
                          child: isDeleting
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white70,
                                  ),
                                )
                              : const Icon(
                                  Icons.delete_outline,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDeleteWork(Work item) async {
    final workId = item.id;
    if (workId == null || _deletingWorkIds.contains(workId)) {
      return;
    }

    final l10n = AppLocalizations.of(context);
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF252939),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text(
            l10n.deleteVideoTitle,
            style: const TextStyle(color: Colors.white, fontSize: 17),
          ),
          content: Text(
            l10n.deleteVideoContent,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                l10n.delete,
                style: const TextStyle(color: Color(0xFFFF5C75)),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await _deleteWork(workId);
    }
  }

  Future<void> _deleteWork(int workId) async {
    if (_deletingWorkIds.contains(workId)) {
      return;
    }

    final l10n = AppLocalizations.of(context);
    setState(() => _deletingWorkIds.add(workId));
    try {
      final success = await ref.read(meProvider.notifier).deleteWork(workId);
      if (!mounted) {
        return;
      }
      _showMessage(success ? l10n.deleteComplete : l10n.deleteFailed);
    } finally {
      if (mounted) {
        setState(() => _deletingWorkIds.remove(workId));
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _openMemberOrWebPay(BuildContext context) {
    openMemberPage(context);
  }
}
