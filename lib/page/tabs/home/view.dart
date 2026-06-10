import 'dart:core';
import 'dart:core' as core;
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flicko_video/api/model/video_model.dart';
import 'package:flicko_video/api/model/config_model.dart';
import 'package:flicko_video/i18n/app_localizations.dart';
import 'package:flicko_video/page/create_result/state.dart';
import 'package:flicko_video/page/tabs/home/controller.dart';
import 'package:flicko_video/page/tabs/home/widgets/image_style_dialog.dart';
import 'package:flicko_video/utils/image_data_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'state.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key, this.initialPrompt});

  final String? initialPrompt;

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final _imagePicker = ImagePicker();
  final _promptController = TextEditingController();
  String? _appliedInitialPrompt;

  // Mock 数据，让骨架屏在 loading 时有内容可渲染
  static final _mockAiModels = List.generate(
    3,
    (i) => AiModel(
      id: i,
      title: 'Model Name',
      waitSecond: 60,
      tags: 'NEW',
      credits: {'5': 10, '10': 20},
    ),
  );

  static const _mockDurations = <String, dynamic>{'5': 10, '10': 20, '15': 30};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyInitialPrompt();
    });
  }

  @override
  void didUpdateWidget(covariant HomeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialPrompt != widget.initialPrompt) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _applyInitialPrompt();
      });
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeProvider);
    _syncPromptController(state);

    final l10n = AppLocalizations.of(context);

    return KeyboardDismisser(
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0D1A),
        body: SafeArea(
          child: Skeletonizer(
            containersColor: Colors.white12,
            enableSwitchAnimation: true,
            enabled: state.loading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AbsorbPointer(
                    absorbing: state.isSubmitting,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildHeader(state, l10n),
                        const SizedBox(height: 16),
                        _buildPromptArea(ref, state, l10n),
                        const SizedBox(height: 12),
                        _buildModeSelector(ref, state, l10n),
                        const SizedBox(height: 20),
                        _buildAiModelSection(ref, state, l10n),
                        const SizedBox(height: 20),
                        _buildDurationSection(ref, state, l10n),
                        const SizedBox(height: 20),
                        _buildStyleSection(l10n, state),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(HomeState state, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.create,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            const Text('💎', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 4),
            Text(
              '${state.credits}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPromptArea(
    WidgetRef ref,
    HomeState state,
    AppLocalizations l10n,
  ) {
    final showImage = state.videoMode == VideoMode.imageToVideo;
    final credits = state.availableDurations[state.selectedDurationKey];

    return AnimatedContainer(
      duration: const core.Duration(milliseconds: 260),
      curve: Curves.easeInOut,
      width: core.double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSwitcher(
            duration: const core.Duration(milliseconds: 260),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              return SizeTransition(
                sizeFactor: animation,
                axisAlignment: -1,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: showImage
                ? Column(
                    key: const ValueKey('image-upload'),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAddImageButton(state, l10n),
                      const SizedBox(height: 12),
                    ],
                  )
                : const SizedBox.shrink(key: ValueKey('no-image-upload')),
          ),
          AnimatedSwitcher(
            duration: const core.Duration(milliseconds: 220),
            child: TextField(
              key: ValueKey(showImage),
              controller: _promptController,
              readOnly: state.isSubmitting,
              onChanged: (text) =>
                  ref.read(homeProvider.notifier).setPromptText(text),
              maxLines: showImage ? 5 : 3,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: l10n.describeYourVideo,
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${state.promptText.length}/${state.maxPromptLength}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('💎', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Text(
                '${credits ?? 0}',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: state.isSubmitting
                    ? null
                    : () => _submitCreateTask(context, ref, l10n),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: state.isSubmitting
                        ? const Color(0xFF4D4D68)
                        : const Color(0xFF6C63FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: state.isSubmitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          l10n.create,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddImageButton(HomeState state, AppLocalizations l10n) {
    return GestureDetector(
      onTap: () => _pickImage(ref.read(homeProvider.notifier)),
      child: Container(
        width: 88,
        height: 72,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white54, width: 1),
          borderRadius: BorderRadius.circular(8),
          color: Colors.transparent,
        ),
        clipBehavior: Clip.antiAlias,
        child: state.selectedImagePath == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, color: Colors.white54, size: 22),
                  const SizedBox(height: 4),
                  Text(
                    l10n.addImage,
                    style: const TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ],
              )
            : Image.file(
                File(state.selectedImagePath!),
                width: 88,
                height: 72,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget _buildModeSelector(
    WidgetRef ref,
    HomeState state,
    AppLocalizations l10n,
  ) {
    return Skeletonizer(
      containersColor: Colors.white12,
      enabled: state.loading,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => ref
                  .read(homeProvider.notifier)
                  .setVideoMode(VideoMode.imageToVideo),
              child: AnimatedContainer(
                duration: const core.Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: state.videoMode == VideoMode.imageToVideo
                      ? const Color(0xFF2A2A4A)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF2A2A4A)),
                  boxShadow: state.videoMode == VideoMode.imageToVideo
                      ? const [
                          BoxShadow(
                            color: Color(0x226C63FF),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ]
                      : const [],
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const core.Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    style: TextStyle(
                      color: state.videoMode == VideoMode.imageToVideo
                          ? Colors.white
                          : Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    child: Text(l10n.imageToVideo),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => ref
                  .read(homeProvider.notifier)
                  .setVideoMode(VideoMode.textToVideo),
              child: AnimatedContainer(
                duration: const core.Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: state.videoMode == VideoMode.textToVideo
                      ? const Color(0xFF2A2A4A)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF2A2A4A)),
                  boxShadow: state.videoMode == VideoMode.textToVideo
                      ? const [
                          BoxShadow(
                            color: Color(0x226C63FF),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ]
                      : const [],
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const core.Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    style: TextStyle(
                      color: state.videoMode == VideoMode.textToVideo
                          ? Colors.white
                          : Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    child: Text(l10n.textToVideo),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiModelSection(
    WidgetRef ref,
    HomeState state,
    AppLocalizations l10n,
  ) {
    final models = state.loading ? _mockAiModels : state.aiModels;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.aiModel,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 60,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemCount: models.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              return _buildModelChip(ref, state, models[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModelChip(WidgetRef ref, HomeState state, AiModel model) {
    final isSelected = state.selectedModelId == model.id;
    return GestureDetector(
      onTap: () => ref.read(homeProvider.notifier).setAiModel(model),
      child: SizedBox(
        width: 150,
        child: AnimatedScale(
          scale: isSelected ? 1.0 : 0.96,
          duration: core.Duration(milliseconds: 220),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const core.Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF6C63FF)
                  : const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF6C63FF)
                    : const Color(0xFF2A2A4A),
              ),
              boxShadow: isSelected
                  ? const [
                      BoxShadow(
                        color: Color(0x336C63FF),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ]
                  : const [],
            ),
            child: Column(
              children: [
                AnimatedDefaultTextStyle(
                  duration: const core.Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[300],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  child: Text(model.title ?? ''),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const core.Duration(milliseconds: 220),
                      curve: Curves.easeInOut,
                      style: TextStyle(
                        color: isSelected ? Colors.white70 : Colors.grey,
                        fontSize: 11,
                      ),
                      child: Text("${model.waitSecond}s"),
                    ),
                    const SizedBox(width: 4),
                    AnimatedContainer(
                      duration: const core.Duration(milliseconds: 220),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: model.tags == 'NEW'
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFFF5722),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        model.tags ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDurationSection(
    WidgetRef ref,
    HomeState state,
    AppLocalizations l10n,
  ) {
    final durations = state.loading ? _mockDurations : state.availableDurations;
    final keys = durations.keys.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.duration,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: keys.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final key = keys[index];
              return _buildDurationChip(ref, state, key, '${key}s');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDurationChip(
    WidgetRef ref,
    HomeState state,
    String duration,
    core.String label,
  ) {
    final isSelected = state.selectedDurationKey == duration;
    return GestureDetector(
      onTap: () => ref.read(homeProvider.notifier).setDuration(duration),
      child: SizedBox(
        width: 120,
        child: AnimatedScale(
          scale: isSelected ? 1.0 : 0.97,
          duration: const core.Duration(milliseconds: 220),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const core.Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF6C63FF)
                  : const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF6C63FF)
                    : const Color(0xFF2A2A4A),
              ),
              boxShadow: isSelected
                  ? const [
                      BoxShadow(
                        color: Color(0x336C63FF),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ]
                  : const [],
            ),
            child: Center(
              child: AnimatedDefaultTextStyle(
                duration: const core.Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                child: Text(label),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStyleSection(AppLocalizations l10n, HomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.styleGuide,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Skeletonizer(
          enabled: state.loading,
          child: Builder(
            builder: (context) {
              if (state.selectImageStyle == null || state.loading) {
                return Container(
                  height: 80,
                  width: double.infinity,
                  color: Color(0xff1a1a2e),
                );
              }
              final selectImageStyle = state.selectImageStyle!;
              return GestureDetector(
                onTap: () => showImageStyleDialog(
                  context: context,
                  initGroupIndex: state.imageGroups.indexWhere(
                    (item) => item.id == state.selectImageGroup?.id,
                  ),
                  list: state.imageGroups,
                  onSelect: (imageGroupIndex, imageStyleIndex) {
                    ref
                        .read(homeProvider.notifier)
                        .setImageGroup(index: imageGroupIndex);
                    ref
                        .read(homeProvider.notifier)
                        .setImageStyle(index: imageStyleIndex);
                  },
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              selectImageStyle.cover ?? '',
                            ),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        selectImageStyle.title ?? '暂无名称',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage(HomeNotifier controller) async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }

    final bytes = await image.readAsBytes();
    controller.setSelectedImage(
      path: image.path,
      base64Image: imageDataUrl(
        bytes: bytes,
        path: image.path,
        mimeType: image.mimeType,
      ),
    );
  }

  Future<void> _submitCreateTask(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    try {
      final result = await ref.read(homeProvider.notifier).submitCreateTask();
      if (!context.mounted) {
        return;
      }
      _handleSubmitSuccess(context, result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF1A1A2E),
          content: Text(l10n.createTaskSubmitted),
        ),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      if (_handleCreateGuardRedirect(context, error)) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF1A1A2E),
          content: Text(_formatCreateError(error, l10n)),
        ),
      );
    }
  }

  void _handleSubmitSuccess(BuildContext context, AiCreateResponse? result) {
    context.push('/create_result', extra: CreateResultArgs(task: result));
  }

  bool _handleCreateGuardRedirect(BuildContext context, Object error) {
    if (error is! HomeCreateException) {
      return false;
    }

    switch (error.error) {
      case HomeCreateError.requireMember:
        context.push('/member');
        return true;
      case HomeCreateError.insufficientCredits:
        context.push('/recharge');
        return true;
      case HomeCreateError.noImage:
      case HomeCreateError.noPrompt:
      case HomeCreateError.noDuration:
      case HomeCreateError.submitFailed:
        return false;
    }
  }

  String _formatCreateError(Object error, AppLocalizations l10n) {
    if (error is HomeCreateException) {
      return switch (error.error) {
        HomeCreateError.noImage => l10n.selectImageFirst,
        HomeCreateError.noPrompt => l10n.enterPromptFirst,
        HomeCreateError.noDuration => l10n.selectDurationFirst,
        HomeCreateError.requireMember => '请先开通会员',
        HomeCreateError.insufficientCredits => '积分不足',
        HomeCreateError.submitFailed => l10n.createTaskFailed,
      };
    }
    return error.toString().replaceFirst('Exception: ', '');
  }

  void _applyInitialPrompt() {
    final prompt = widget.initialPrompt?.trim();
    if (!mounted ||
        prompt == null ||
        prompt.isEmpty ||
        prompt == _appliedInitialPrompt) {
      return;
    }

    _appliedInitialPrompt = prompt;
    ref.read(homeProvider.notifier).applyInitialPrompt(prompt);
  }

  void _syncPromptController(HomeState state) {
    if (_promptController.text == state.promptText) {
      return;
    }

    _promptController.value = TextEditingValue(
      text: state.promptText,
      selection: TextSelection.collapsed(offset: state.promptText.length),
    );
  }
}
