import 'package:flicko_video/api/model/video_model.dart';
import 'package:flicko_video/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import 'controller.dart';
import 'state.dart';

class CreateResultView extends ConsumerStatefulWidget {
  const CreateResultView({super.key, this.task});

  final AiCreateResponse? task;

  @override
  ConsumerState<CreateResultView> createState() => _CreateResultViewState();
}

class _CreateResultViewState extends ConsumerState<CreateResultView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _loadingController;
  VideoPlayerController? _videoController;
  String? _activeVideoUrl;

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
      ref.read(createResultProvider.notifier).setTask(widget.task);
    });
  }

  @override
  void didUpdateWidget(covariant CreateResultView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.task != widget.task) {
      ref.read(createResultProvider.notifier).setTask(widget.task);
    }
  }

  @override
  void dispose() {
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
            _buildHeader(context),
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

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 54,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'Create AI Video',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: IconButton(
              onPressed: () => _goBack(context),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 21,
              ),
            ),
          ),
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
            const SizedBox(height: 16),
            _buildProgress(state),
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

  Widget _buildProgress(CreateResultState state) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 198,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: state.progress,
              minHeight: 4,
              backgroundColor: const Color(0xFF5B5D69),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFE7E9F4),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${state.progressPercent}%',
          style: const TextStyle(
            color: Color(0xFF8A8C98),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
