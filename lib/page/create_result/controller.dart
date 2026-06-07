import 'dart:async';

import 'package:flicko_video/api/api.dart';
import 'package:flicko_video/api/model/video_model.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'state.dart';

class CreateResultController extends StateNotifier<CreateResultState> {
  CreateResultController() : super(const CreateResultState()) {
    _startProgressTimer();
  }

  Timer? _progressTimer;
  Timer? _pollingTimer;
  var _isPolling = false;

  void setTask(AiCreateResponse? task) {
    if (_isSameTask(task)) {
      return;
    }

    state = const CreateResultState().clearResult(
      task: task,
      estimatedWaitSeconds: CreateResultState.estimateWaitSecondsFor(task),
    );
    _startProgressTimer();
    _startPolling(task);
  }

  bool _isSameTask(AiCreateResponse? task) {
    final current = state.task;
    if (identical(current, task)) {
      return true;
    }
    if (current == null || task == null) {
      return false;
    }
    if (current.id != null && task.id != null) {
      return current.id == task.id;
    }
    if (current.key != null && task.key != null) {
      return current.key == task.key;
    }
    return false;
  }

  void _startProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 1200), (_) {
      final progress = state.progress;
      if (progress >= 0.98) {
        return;
      }

      final nextStep = progress < 0.2
          ? 0.018
          : progress < 0.65
          ? 0.01
          : 0.004;
      state = state.copyWith(progress: (progress + nextStep).clamp(0.01, 0.98));
    });
  }

  void _startPolling(AiCreateResponse? task) {
    _pollingTimer?.cancel();
    final promptId = task?.key;
    final type = _resolveStatusType(task?.type);
    if (promptId == null || promptId.isEmpty || type == null) {
      return;
    }

    _pollTaskStatus(promptId: promptId, type: type);
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _pollTaskStatus(promptId: promptId, type: type);
    });
  }

  Future<void> _pollTaskStatus({
    required String promptId,
    required int type,
  }) async {
    if (_isPolling) {
      return;
    }

    _isPolling = true;
    try {
      final result = await Api.getAiTaskStatus(promptId: promptId, type: type);
      if (!mounted || result == null) {
        return;
      }

      final status = result.status ?? 'unknown';
      if (status == 'completed') {
        final videoUrl = result.videoUrls?.isNotEmpty == true
            ? result.videoUrls!.first
            : null;
        if (videoUrl == null || videoUrl.isEmpty) {
          state = state.copyWith(status: 'unknown');
          return;
        }

        _pollingTimer?.cancel();
        _progressTimer?.cancel();
        state = state.copyWith(
          status: status,
          videoUrl: videoUrl,
          progress: 1,
          errorMessage: null,
        );
        return;
      }

      if (status == 'error') {
        _pollingTimer?.cancel();
        _progressTimer?.cancel();
        state = state.copyWith(
          status: status,
          errorMessage: 'Video generation failed',
        );
        return;
      }

      state = state.copyWith(
        status: status,
        queuePosition: result.queuePosition,
      );
    } finally {
      _isPolling = false;
    }
  }

  int? _resolveStatusType(dynamic taskType) {
    if (taskType is int) {
      return taskType;
    }

    final value = taskType?.toString();
    return switch (value) {
      'i2v' => 1,
      't2v' => 2,
      'tpl2v' => 1,
      _ => int.tryParse(value ?? ''),
    };
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _pollingTimer?.cancel();
    super.dispose();
  }
}

final createResultProvider =
    StateNotifierProvider.autoDispose<
      CreateResultController,
      CreateResultState
    >((ref) {
      return CreateResultController();
    });
