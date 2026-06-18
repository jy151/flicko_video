import 'package:flicko_video/api/model/video_model.dart';
import 'package:flicko_video/api/api.dart';
import 'package:flicko_video/api/model/member_model.dart';
import 'package:flicko_video/hive/user/user_box.dart';
import 'package:flicko_video/utils/member_access.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'state.dart';

enum EffectsCreateError {
  noTemplate,
  noImage,
  requireMember,
  insufficientCredits,
  submitFailed,
}

class EffectsCreateException implements Exception {
  const EffectsCreateException(this.error, {this.message});

  final EffectsCreateError error;
  final String? message;
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
      final member = await _syncUserInfoBeforeCreate();
      if (!isActiveVipMember(member)) {
        throw const EffectsCreateException(EffectsCreateError.requireMember);
      }

      final creditCost = state.creditCost(isVip: isActiveVipMember(member));
      if (UserBox.credit < creditCost) {
        throw const EffectsCreateException(
          EffectsCreateError.insufficientCredits,
        );
      }

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
        await _syncBalanceAfterCreate();
        return result;
      } on ApiException catch (error) {
        throw EffectsCreateException(
          EffectsCreateError.submitFailed,
          message: error.message,
        );
      }
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> _syncBalanceAfterCreate() async {
    try {
      await UserBox.syncUserInfo();
    } catch (_) {
      // The create task already succeeded; balance will refresh on next sync.
    }
  }

  Future<Member?> _syncUserInfoBeforeCreate() async {
    try {
      return await UserBox.syncUserInfo();
    } catch (_) {
      throw const EffectsCreateException(EffectsCreateError.submitFailed);
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
