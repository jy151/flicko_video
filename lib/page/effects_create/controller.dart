import 'package:flicko_video/api/model/video_model.dart';
import 'package:flicko_video/api/api.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'state.dart';

enum EffectsCreateError { noTemplate, noImage, submitFailed }

class EffectsCreateException implements Exception {
  const EffectsCreateException(this.error);

  final EffectsCreateError error;
}

class EffectsCreateController extends StateNotifier<EffectsCreateState> {
  EffectsCreateController() : super(const EffectsCreateState());

  void setTemplates(List<Template> templates, {int? selectedTemplateId}) {
    final fallbackTemplateId = templates.isEmpty ? null : templates.first.id;
    final hasSelectedTemplate = templates.any(
      (template) => template.id == selectedTemplateId,
    );

    state = state.copyWith(
      templates: templates,
      selectedTemplateId: hasSelectedTemplate
          ? selectedTemplateId
          : fallbackTemplateId,
    );
  }

  void selectTemplate(int? templateId) {
    state = state.copyWith(selectedTemplateId: templateId);
  }

  void setSelectedImage({required String path, required String base64Image}) {
    state = state.copyWith(
      selectedImagePath: path,
      selectedImageBase64: base64Image,
    ); 
  }

  Future<AiCreateResponse?> submit() async { 
    final template = state.selectedTemplate;
    final templateId = template?.id;
    if (templateId == null) {
      throw const EffectsCreateException(EffectsCreateError.noTemplate);
    }

    if (state.selectedImageBase64 == null) {
      throw const EffectsCreateException(EffectsCreateError.noImage);
    }

    state = state.copyWith(isLoading: true);
    try {
      final result = await Api.createAiTask(
        type: 'tpl2v',
        prompt: template?.prompt ?? '',
        image: state.selectedImageBase64,
        templateId: templateId,
      );
      if (result == null) {
        throw const EffectsCreateException(EffectsCreateError.submitFailed);
      }
      return result;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final effectsCreateProvider =
    StateNotifierProvider.autoDispose<
      EffectsCreateController,
      EffectsCreateState
    >((ref) {
      return EffectsCreateController();
    });
