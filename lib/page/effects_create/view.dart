import 'state.dart';
import 'controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flicko_video/i18n/i18n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flicko_video/widgets/app_network_image.dart';

class EffectsCreateView extends ConsumerWidget {
  const EffectsCreateView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(effectsCreateProvider);
    final controller = ref.read(effectsCreateProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPreviewImage(context, state),
                  const SizedBox(height: 24),
                  _buildUploadImageSection(l10n),
                  const SizedBox(height: 24),
                  _buildVideoEffectsSection(state, controller, l10n),
                ],
              ),
            ),
          ),
          _buildSubmitButton(state, controller, l10n),
        ],
      ),
    );
  }

  Widget _buildPreviewImage(BuildContext context, EffectsCreateState state) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 300,
          child: AppNetworkImage(
            imageUrl: state.previewImageUrl,
            fit: BoxFit.cover,
            placeholderColor: const Color(0xFF1A1A2E),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 40,
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
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadImageSection(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.uploadImage,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  // TODO: Implement image picker
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF2A2A4A),
                      width: 1,
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.add, color: Colors.white54, size: 32),
                  ),
                ),
              ),
              Positioned(
                bottom: -4,
                right: -4,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A4A),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF0D0D1A),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white54,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVideoEffectsSection(
    EffectsCreateState state,
    EffectsCreateController controller,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.selectVideoEffects,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
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
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: state.videoEffects.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final effect = state.videoEffects[index];
                final isSelected = effect.id == state.selectedEffectId;
                return _buildEffectItem(effect, isSelected, controller);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEffectItem(
    VideoEffect effect,
    bool isSelected,
    EffectsCreateController controller,
  ) {
    return GestureDetector(
      onTap: () => controller.selectEffect(effect.id),
      child: SizedBox(
        width: 90,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 90,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: isSelected
                    ? Border.all(color: const Color(0xFF6C63FF), width: 2)
                    : null,
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(isSelected ? 6 : 8),
                    child: AppNetworkImage(
                      imageUrl: effect.thumbnail,
                      width: 90,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholderColor: const Color(0xFF2A2A4A),
                    ),
                  ),
                  if (effect.isVip)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C63FF),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: const Text(
                          'V',
                          style: TextStyle(
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
            const SizedBox(height: 6),
            Text(
              effect.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(
    EffectsCreateState state,
    EffectsCreateController controller,
    AppLocalizations l10n,
  ) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: state.isLoading ? null : () => controller.submit(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A9EF7),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
              elevation: 0,
            ),
            child: state.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.submit,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('💎', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Text(
                        '${state.credits}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
