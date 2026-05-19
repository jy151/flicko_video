import 'dart:core';
import 'dart:core' as core;

import 'package:flicko_video/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'state.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
              _buildStyleSection(l10n),
              const SizedBox(height: 24),
            ],
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

  Widget _buildPromptArea(WidgetRef ref, HomeState state, AppLocalizations l10n) {
    final showImage = state.videoMode == VideoMode.imageToVideo;

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
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: showImage
                ? Column(
                    key: const ValueKey('image-upload'),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAddImageButton(l10n),
                      const SizedBox(height: 12),
                    ],
                  )
                : const SizedBox.shrink(key: ValueKey('no-image-upload')),
          ),
          AnimatedSwitcher(
            duration: const core.Duration(milliseconds: 220),
            child: TextField( 
              key: ValueKey(showImage),
              onChanged: (text) => ref.read(homeProvider.notifier).setPromptText(text),
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
                '${state.credits}',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  l10n.create,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddImageButton(AppLocalizations l10n) {
    return Container(
      width: 88,
      height: 72,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white54, width: 1),
        borderRadius: BorderRadius.circular(8),
        color: Colors.transparent,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add, color: Colors.white54, size: 22),
          const SizedBox(height: 4),
          Text(
            l10n.addImage,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelector(WidgetRef ref, HomeState state, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () =>
                ref.read(homeProvider.notifier).setVideoMode(VideoMode.imageToVideo),
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
            onTap: () =>
                ref.read(homeProvider.notifier).setVideoMode(VideoMode.textToVideo),
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
    );
  }

  Widget _buildAiModelSection(WidgetRef ref, HomeState state, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.aiModel,
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildModelChip(ref, state, AiModel.wan21, 'Wan 2.1', '30 sec', l10n.hotBadge, l10n),
            const SizedBox(width: 8),
            _buildModelChip(ref, state, AiModel.wan22, 'Wan 2.2', '45 sec', l10n.newBadge, l10n),
            const SizedBox(width: 8),
            _buildModelChip(ref, state, AiModel.wan23, 'Wan 2.3', '60 sec', l10n.hotBadge, l10n),
          ],
        ),
      ],
    );
  }

  Widget _buildModelChip(
    WidgetRef ref,
    HomeState state,
    AiModel model,
   String name,
    String time,
   String badge,
   AppLocalizations l10n,
  ) {
    final isSelected = state.selectedModel == model;
    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(homeProvider.notifier).setAiModel(model),
        child: AnimatedScale( 
          scale: isSelected ? 1.0 : 0.96,
          duration: core.Duration(milliseconds: 220), 
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const core.Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF6C63FF) : const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? const Color(0xFF6C63FF) : const Color(0xFF2A2A4A),
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
                  child: Text(name),
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
                      child: Text(time),
                    ),
                    const SizedBox(width: 4),
                    AnimatedContainer(
                      duration: const core.Duration(milliseconds: 220),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: badge == l10n.newBadge
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFFF5722),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        badge,
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

  Widget _buildDurationSection(WidgetRef ref, HomeState state, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.duration,
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildDurationChip(ref, state, Duration.s5, '5s'),
            const SizedBox(width: 8),
            _buildDurationChip(ref, state, Duration.s10, '10s'),
            const SizedBox(width: 8),
            _buildDurationChip(ref, state, Duration.s15, '15s'),
          ],
        ),
      ],
    );
  }

  Widget _buildDurationChip(
    WidgetRef ref,
    HomeState state,
    Duration duration,
    core.String label,
  ) {
    final isSelected = state.selectedDuration == duration;
    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(homeProvider.notifier).setDuration(duration),
        child: AnimatedScale(
          scale: isSelected ? 1.0 : 0.97,
          duration: const core.Duration(milliseconds: 220),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const core.Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF6C63FF) : const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? const Color(0xFF6C63FF) : const Color(0xFF2A2A4A),
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

  Widget _buildStyleSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.styleGuide,
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.auto,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }
}
