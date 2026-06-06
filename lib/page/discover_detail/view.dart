import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flicko_video/api/model/video_model.dart';
import 'package:flicko_video/i18n/app_localizations.dart';
import 'package:flicko_video/widgets/app_feedback_dialog.dart';
import 'package:flicko_video/widgets/app_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class DiscoverDetailView extends StatefulWidget {
  const DiscoverDetailView({super.key, required this.work});

  final Work work;

  @override
  State<DiscoverDetailView> createState() => _DiscoverDetailViewState();
}

class _DiscoverDetailViewState extends State<DiscoverDetailView> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  CancelToken? _downloadCancelToken;
  final ValueNotifier<double?> _downloadProgress = ValueNotifier<double?>(0);
  var _videoReady = false;
  var _isDownloading = false;
  var _progressDialogVisible = false;

  Work get work => widget.work;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    final videoUrl = work.video;
    if (videoUrl == null || videoUrl.isEmpty) {
      return;
    }

    try {
      final videoController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
      );
      await videoController.initialize();
      if (!mounted) {
        await videoController.dispose();
        return;
      }

      final chewieController = ChewieController(
        videoPlayerController: videoController,
        autoPlay: false,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControlsOnInitialize: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.white,
          handleColor: Colors.white,
          backgroundColor: Colors.white30,
          bufferedColor: Colors.white54,
        ),
      );

      setState(() {
        _videoController = videoController;
        _chewieController = chewieController;
        _videoReady = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _videoReady = false);
    }
  }

  @override
  void dispose() {
    _downloadCancelToken?.cancel();
    _downloadProgress.dispose();
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(child: _buildVideoSection()),
            _buildInfoSection(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          ),
          const Spacer(),
          IconButton(
            onPressed: _showMoreSheet,
            icon: const Icon(Icons.more_vert, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoSection() {
    return Container(
      width: double.infinity,
      color: Colors.black,
      child: _videoReady && _chewieController != null
          ? Chewie(controller: _chewieController!)
          : Stack(
              fit: StackFit.expand,
              children: [
                AppNetworkImage(
                  imageUrl: work.cover ?? work.image ?? '',
                  fit: BoxFit.cover,
                  placeholderColor: Colors.black,
                ),
                Container(color: Colors.black.withValues(alpha: 0.28)),
                const Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Colors.white,
                    size: 58,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoSection(BuildContext context, AppLocalizations l10n) {
    return Container(
      color: const Color(0xFF101123),
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    work.member?.name ?? 'Flicko',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              _buildSideActions(l10n),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _showDetailsSheet,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.viewDetails,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.open_in_full,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 14,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _buildCreateSimilarButton(l10n),
        ],
      ),
    );
  }

  Widget _buildCreateSimilarButton(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3E5BF2), Color(0xFF7DCBFA)],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            elevation: 0,
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Text(
            l10n.createSimilar,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar({double size = 36}) {
    final portrait = work.member?.portrait;
    if (portrait != null && portrait.isNotEmpty) {
      return AppNetworkImage(
        imageUrl: portrait,
        width: size,
        height: size,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(size / 2),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFFF3158), Color(0xFFFF8A3D)],
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        'fAI',
        style: TextStyle(
          color: Colors.white,
          fontSize: size <= 36 ? 11 : 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildSideActions(AppLocalizations l10n) {
    return Column(
      children: [
        const Icon(Icons.favorite, color: Colors.white, size: 34),
        const SizedBox(height: 4),
        Text(
          '${work.counter?.likeCount ?? 0}',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: _shareVideo,
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              const Icon(Icons.reply, color: Colors.white, size: 34),
              const SizedBox(height: 4),
              Text(
                l10n.share,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDetailsSheet() {
    final l10n = AppLocalizations.of(context);
    final prompt = (work.prompt ?? '').trim().isEmpty
        ? l10n.noPrompt
        : work.prompt!.trim();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight * 0.86,
              ),
              padding: const EdgeInsets.fromLTRB(26, 8, 26, 24),
              decoration: const BoxDecoration(
                color: Color(0xFF252939),
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white70,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _buildAvatar(size: 38),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              work.member?.name ?? 'Flicko',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              l10n.aiModel,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.58),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),
                      Text(
                        l10n.prompt,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 42),
                      Text(
                        prompt,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.42,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 26),
                      Row(
                        children: [
                          Text(
                            l10n.creationTime,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _formatCreationTime(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),
                      Divider(color: Colors.white.withValues(alpha: 0.08)),
                      const SizedBox(height: 30),
                      _buildCreateSimilarButton(l10n),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showMoreSheet() {
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
                    _shareVideo();
                  },
                ),
                const SizedBox(height: 10),
                _buildSheetAction(
                  l10n.report,
                  Icons.warning_rounded,
                  onTap: () {
                    Navigator.of(context).pop();
                    showAppFeedbackDialog(context);
                  },
                ),
                const SizedBox(height: 10),
                _buildDownloadGroup(l10n, context),
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
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Icon(icon, color: Colors.white, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadGroup(AppLocalizations l10n, BuildContext sheetContext) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF46506C),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildDownloadRow(
            l10n.downloadWithWatermark,
            Icons.download,
            onTap: () {
              Navigator.of(sheetContext).pop();
              _downloadVideo(withoutWatermark: false);
            },
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.2)),
          _buildDownloadRow(
            l10n.downloadWithoutWatermark,
            Icons.diamond,
            onTap: () {
              Navigator.of(sheetContext).pop();
              _downloadVideo(withoutWatermark: true);
            },
          ),
        ],
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

  Future<void> _shareVideo() async {
    final filePath = await _downloadVideo(
      withoutWatermark: false,
      showSuccessMessage: false,
    );
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

  Future<String?> _downloadVideo({
    required bool withoutWatermark,
    bool showSuccessMessage = true,
  }) async {
    final l10n = AppLocalizations.of(context);
    final videoUrl = work.video;
    if (videoUrl == null || videoUrl.isEmpty) {
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
      final filePath = await _buildDownloadPath(withoutWatermark);
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

  Future<String> _buildDownloadPath(bool withoutWatermark) async {
    final directory = await getApplicationDocumentsDirectory();
    final suffix = withoutWatermark ? 'clean' : 'watermark';
    final id = work.id ?? DateTime.now().millisecondsSinceEpoch;
    final path = '${directory.path}/flicko_${id}_$suffix.mp4';
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

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  String _formatCreationTime() {
    final timestamp = work.workCreateTime;
    if (timestamp == null || timestamp <= 0) {
      return '-';
    }

    final milliseconds = timestamp > 1000000000000
        ? timestamp
        : timestamp * 1000;
    final date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}:'
        '${date.second.toString().padLeft(2, '0')}';
  }
}
