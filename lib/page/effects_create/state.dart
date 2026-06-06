import 'package:flicko_video/api/model/video_model.dart';

class EffectsCreateState {
  final String? selectedImagePath;
  final String? selectedImageBase64;
  final int? selectedTemplateId;
  final List<Template> templates;
  final bool isLoading;

  const EffectsCreateState({
    this.selectedImagePath,
    this.selectedImageBase64,
    this.selectedTemplateId,
    this.templates = const [],
    this.isLoading = false,
  });

  Template? get selectedTemplate {
    for (final template in templates) {
      if (template.id == selectedTemplateId) {
        return template;
      }
    }
    return templates.isEmpty ? null : templates.first;
  }

  String get previewAnimationUrl {
    final template = selectedTemplate;
    return template?.animation ?? template?.cover ?? template?.video ?? '';
  }

  int get creditCost => selectedTemplate?.source ?? 48;

  EffectsCreateState copyWith({
    String? selectedImagePath,
    String? selectedImageBase64,
    int? selectedTemplateId,
    List<Template>? templates,
    bool? isLoading,
  }) {
    return EffectsCreateState(
      selectedImagePath: selectedImagePath ?? this.selectedImagePath,
      selectedImageBase64: selectedImageBase64 ?? this.selectedImageBase64,
      selectedTemplateId: selectedTemplateId ?? this.selectedTemplateId,
      templates: templates ?? this.templates,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
