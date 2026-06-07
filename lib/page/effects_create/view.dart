import 'dart:convert';
import 'dart:io';

import 'package:flicko_video/api/model/video_model.dart';

import 'state.dart';
import 'controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flicko_video/i18n/i18n.dart';
import 'package:flicko_video/page/create_result/state.dart';
import 'package:flicko_video/page/effects_all/view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flicko_video/widgets/app_network_image.dart';
import 'package:image_picker/image_picker.dart';

class EffectsCreateArgs {
  const EffectsCreateArgs({required this.templates, this.selectedTemplateId});

  final List<Template> templates;
  final int? selectedTemplateId;
}

class EffectsCreateView extends ConsumerStatefulWidget {
  final List<Template> templates;
  final int? selectedTemplateId;

  const EffectsCreateView({
    super.key,
    required this.templates,
    this.selectedTemplateId,
  });

  @override
  ConsumerState<EffectsCreateView> createState() => _EffectsCreateViewState();
}

class _EffectsCreateViewState extends ConsumerState<EffectsCreateView> {
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      ref
          .read(effectsCreateProvider.notifier)
          .setTemplates(
            widget.templates,
            selectedTemplateId: widget.selectedTemplateId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  _buildUploadImageSection(state, controller, l10n),
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
            imageUrl: state.previewAnimationUrl,
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

  Widget _buildUploadImageSection(
    EffectsCreateState state,
    EffectsCreateController controller,
    AppLocalizations l10n,
  ) {
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
                onTap: () => _pickImage(controller),
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
                  clipBehavior: Clip.antiAlias,
                  child: state.selectedImagePath == null
                      ? const Center(
                          child: Icon(
                            Icons.add,
                            color: Colors.white54,
                            size: 32,
                          ),
                        )
                      : Image.file(
                          File(state.selectedImagePath!),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
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
              GestureDetector(
                onTap: () => context.push(
                  '/effects_all',
                  extra: EffectsAllArgs(templates: state.templates),
                ),
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
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: state.templates.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final template = state.templates[index];
                final isSelected = template.id == state.selectedTemplateId;
                return _buildEffectItem(template, isSelected, controller);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEffectItem(
    Template template,
    bool isSelected,
    EffectsCreateController controller,
  ) {
    return GestureDetector(
      onTap: () => controller.selectTemplate(template.id),
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
                      imageUrl: template.animation ?? template.cover ?? '',
                      width: 90,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholderColor: const Color(0xFF2A2A4A),
                    ),
                  ),
                  if ((template.level ?? 0) > 0)
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
              template.title ?? '',
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
            onPressed: state.isLoading
                ? null
                : () => _submitTemplateTask(context, controller, l10n),
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
                        '${state.creditCost}',
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

  Future<void> _submitTemplateTask(
    BuildContext context,
    EffectsCreateController controller,
    AppLocalizations l10n,
  ) async {
    try {
      final result = await controller.submit();
      if (!context.mounted) {
        return;
      }
      _handleSubmitSuccess(context, result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF1A1A2E),
          content: Text(l10n.templateCreateSubmitted),
        ),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF1A1A2E),
          content: Text(_formatSubmitError(error, l10n)),
        ),
      );
    }
  }

  Future<void> _pickImage(EffectsCreateController controller) async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }

    final bytes = await image.readAsBytes();
    controller.setSelectedImage(
      path: image.path,
      base64Image: base64Encode(bytes),
    );
  }

  void _handleSubmitSuccess(BuildContext context, AiCreateResponse? result) {
    context.push('/create_result', extra: CreateResultArgs(task: result));
  }

  String _formatSubmitError(Object error, AppLocalizations l10n) {
    if (error is EffectsCreateException) {
      return switch (error.error) {
        EffectsCreateError.noTemplate => l10n.selectTemplateFirst,
        EffectsCreateError.noImage => l10n.selectImageFirst,
        EffectsCreateError.submitFailed => l10n.templateCreateFailed,
      };
    }
    return error.toString().replaceFirst('Exception: ', '');
  }
}
