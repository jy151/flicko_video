import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flicko_video/api/api.dart';
import 'package:flicko_video/gen/assets.gen.dart';
import 'package:flicko_video/i18n/app_localizations.dart';
import 'package:flicko_video/page/tabs/me/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import 'controller.dart';
import 'state.dart';

class CreateResultView extends ConsumerStatefulWidget {
  const CreateResultView({super.key, this.args});

  final CreateResultArgs? args;

  @override
  ConsumerState<CreateResultView> createState() => _CreateResultViewState();
}

class _CreateResultViewState extends ConsumerState<CreateResultView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _loadingController;
  VideoPlayerController? _videoController;
  String? _activeVideoUrl;
  CancelToken? _downloadCancelToken;
  final ValueNotifier<double?> _downloadProgress = ValueNotifier<double?>(0);
  var _isDownloading = false;
  var _isDeleting = false;
  var _progressDialogVisible = false;

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      ref
          .read(createResultProvider.notifier)
          .setArgs(widget.args ?? const CreateResultArgs());
    });
  }

  @override
  void didUpdateWidget(covariant CreateResultView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.args != widget.args) {
      ref
          .read(createResultProvider.notifier)
          .setArgs(widget.args ?? const CreateResultArgs());
    }
  }

  @override
  void dispose() {
    _downloadCancelToken?.cancel();
    _downloadProgress.dispose();
    _loadingController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createResultProvider);
    _syncVideoController(state.videoUrl);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context, state),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(26, 14, 26, 24),
                child: Column(
                  children: [
                    _buildResultCard(state),
                    const SizedBox(height: 10),
                    _buildActionRow(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(CreateResultState state) {
    if (state.isCompleted) {
      return _buildVideoCard();
    }

    if (state.isFailed) {
      return _buildErrorCard(state);
    }

    return _buildLoadingCard(state);
  }

  Widget _buildHeader(BuildContext context, CreateResultState state) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          const SizedBox(width: 4),
          IconButton(
            onPressed: () => _goBack(context),
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Create AI Video',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 52,
            child: state.isCompleted
                ? IconButton(
                    onPressed: () => _showMoreSheet(state),
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 24,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildLoadingCard(CreateResultState state) {
    return Container(
      width: double.infinity,
      height: 354,
      decoration: BoxDecoration(
        color: const Color(0xFF252735),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RotationTransition(
              turns: _loadingController,
              child: SvgPicture.asset(
                Assets.images.loading,
                width: 86,
                height: 72,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              _buildStatusText(state),
              style: const TextStyle(
                color: Color(0xFF7C7D88),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard() {
    final controller = _videoController;
    return Container(
      width: double.infinity,
      height: 354,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: controller != null && controller.value.isInitialized
          ? Stack(
              fit: StackFit.expand,
              children: [
                FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: controller.value.size.width,
                    height: controller.value.size.height,
                    child: VideoPlayer(controller),
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: VideoProgressIndicator(
                    controller,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: Colors.white,
                      bufferedColor: Colors.white54,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (controller.value.isPlaying) {
                        controller.pause();
                      } else {
                        controller.play();
                      }
                      setState(() {});
                    },
                    child: AnimatedOpacity(
                      opacity: controller.value.isPlaying ? 0 : 1,
                      duration: const Duration(milliseconds: 180),
                      child: const Icon(
                        Icons.play_circle_fill,
                        color: Colors.white,
                        size: 58,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
    );
  }

  Widget _buildErrorCard(CreateResultState state) {
    return Container(
      width: double.infinity,
      height: 354,
      decoration: BoxDecoration(
        color: const Color(0xFF252735),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFFFF6B6B),
                size: 44,
              ),
              const SizedBox(height: 16),
              Text(
                state.errorMessage ?? 'Video generation failed',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildStatusText(CreateResultState state) {
    if (state.status == 'running') {
      return 'Generating video...';
    }
    if (state.status == 'pending' && state.queuePosition != null) {
      return 'Queue position: ${state.queuePosition}';
    }
    return 'Estimated wait: ${state.estimatedWaitLabel}';
  }

  Widget _buildActionRow(BuildContext context) {
    return Row(
      children: [
        _buildActionButton(
          icon: Icons.refresh,
          label: 'Re-edit',
          onTap: () => _goBack(context),
        ),
        const SizedBox(width: 10),
        _buildActionButton(
          icon: Icons.edit_outlined,
          label: 'Continue\nCreating',
          onTap: () => context.go('/home'),
        ),
        const SizedBox(width: 10),
        _buildActionButton(
          icon: Icons.photo_library_outlined,
          label: 'My Creations',
          onTap: () => context.go('/me'),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF252838),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.08,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMoreSheet(CreateResultState state) {
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          decoration: const BoxDecoration(
            color: Color(0xFF252939),
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
                const SizedBox(height: 8),
                _buildSheetAction(
                  l10n.share,
                  Icons.reply,
                  onTap: () {
                    Navigator.of(context).pop();
                    _shareVideo(state);
                  },
                ),
                const SizedBox(height: 10),
                _buildDownloadGroup(l10n, context, state),
                const SizedBox(height: 10),
                _buildSheetAction(
                  l10n.delete,
                  Icons.delete_outline,
                  color: const Color(0xFFFF5C75),
                  onTap: () {
                    Navigator.of(context).pop();
                    _confirmDelete(state);
                  },
                ),
                const SizedBox(height: 10),
                _buildCancelAction(context, l10n),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSheetAction(
    String title,
    IconData icon, {
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF46506C),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(title, style: TextStyle(color: color, fontSize: 16)),
            ),
            Icon(icon, color: color, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadGroup(
    AppLocalizations l10n,
    BuildContext sheetContext,
    CreateResultState state,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF46506C),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _buildDownloadRow(
        l10n.download,
        Icons.download,
        onTap: () {
          Navigator.of(sheetContext).pop();
          _downloadVideo(state);
        },
      ),
    );
  }

  Widget _buildDownloadRow(
    String title,
    IconData icon, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 46,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              Icon(icon, color: Colors.white, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCancelAction(BuildContext context, AppLocalizations l10n) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF46506C),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          l10n.cancel,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Future<void> _shareVideo(CreateResultState state) async {
    final filePath = await _downloadVideo(state, showSuccessMessage: false);
    if (filePath == null || !mounted) return;

    final box = context.findRenderObject() as RenderBox?;
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(filePath, mimeType: 'video/mp4')],
        text: AppLocalizations.of(context).shareVideoText,
        subject: AppLocalizations.of(context).appTitle,
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }

  Future<String?> _downloadVideo(
    CreateResultState state, {
    bool showSuccessMessage = true,
  }) async {
    final l10n = AppLocalizations.of(context);
    final videoUrl = _resolveDownloadUrl(state);
    if (videoUrl == null) {
      _showMessage(l10n.videoUnavailable);
      return null;
    }

    if (_isDownloading) {
      return null;
    }

    _isDownloading = true;
    _downloadProgress.value = 0;
    _downloadCancelToken = CancelToken();
    _showDownloadDialog();

    try {
      final filePath = await _buildDownloadPath(state);
      await Dio().download(
        videoUrl,
        filePath,
        cancelToken: _downloadCancelToken,
        onReceiveProgress: (received, total) {
          if (total <= 0) {
            _downloadProgress.value = null;
            return;
          }
          _downloadProgress.value = received / total;
        },
      );

      if (!mounted) return null;
      _hideDownloadDialog();
      if (showSuccessMessage) {
        _showMessage(l10n.downloadComplete);
      }
      return filePath;
    } catch (_) {
      if (!mounted) return null;
      _hideDownloadDialog();
      _showMessage(l10n.downloadFailed);
      return null;
    } finally {
      _isDownloading = false;
      _downloadCancelToken = null;
    }
  }

  String? _resolveDownloadUrl(CreateResultState state) {
    final work = state.work;
    return _firstNonEmpty([state.videoUrl, work?.video, work?.watermarked]);
  }

  String? _firstNonEmpty(Iterable<String?> values) {
    for (final value in values) {
      final text = value?.trim();
      if (text != null && text.isNotEmpty) {
        return text;
      }
    }
    return null;
  }

  Future<String> _buildDownloadPath(CreateResultState state) async {
    final directory = await getApplicationDocumentsDirectory();
    final id =
        state.work?.id ??
        int.tryParse(state.task?.id ?? '') ??
        DateTime.now().millisecondsSinceEpoch;
    final path = '${directory.path}/flicko_$id.mp4';
    await File(path).parent.create(recursive: true);
    return path;
  }

  void _showDownloadDialog() {
    final l10n = AppLocalizations.of(context);
    _progressDialogVisible = true;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF252939),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text(
            l10n.downloadingVideo,
            style: const TextStyle(color: Colors.white, fontSize: 17),
          ),
          content: ValueListenableBuilder<double?>(
            valueListenable: _downloadProgress,
            builder: (context, progress, child) {
              final label = progress == null
                  ? '--'
                  : '${(progress.clamp(0, 1) * 100).toStringAsFixed(0)}%';
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    color: const Color(0xFF7DCBFA),
                    backgroundColor: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    label,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              );
            },
          ),
        );
      },
    ).whenComplete(() => _progressDialogVisible = false);
  }

  void _hideDownloadDialog() {
    if (!_progressDialogVisible || !mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> _confirmDelete(CreateResultState state) async {
    final workId = state.work?.id ?? int.tryParse(state.task?.id ?? '');
    if (workId == null || _isDeleting) {
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
    if (_isDeleting) {
      return;
    }

    _isDeleting = true;
    final l10n = AppLocalizations.of(context);
    try {
      final res = await Api.deleteWork(workId);
      if (!mounted) return;
      if (res.isSuccess) {
        await ref.read(meProvider.notifier).reloadWorks();
        if (!mounted) return;
        _showMessage(l10n.deleteComplete);
        context.go('/me');
      } else {
        _showMessage(res.message.isEmpty ? l10n.deleteFailed : res.message);
      }
    } catch (_) {
      if (!mounted) return;
      _showMessage(l10n.deleteFailed);
    } finally {
      _isDeleting = false;
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go('/home');
  }

  void _syncVideoController(String? videoUrl) {
    if (videoUrl == null || videoUrl.isEmpty || videoUrl == _activeVideoUrl) {
      return;
    }

    _activeVideoUrl = videoUrl;
    final oldController = _videoController;
    _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    oldController?.dispose();
    _videoController!
      ..setLooping(true)
      ..initialize().then((_) {
        if (!mounted) {
          return;
        }
        _videoController?.play();
        setState(() {});
      });
  }
}
