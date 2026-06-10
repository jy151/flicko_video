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

  void setArgs(CreateResultArgs args) {
    if (args.work != null) {
      setWork(args.work!);
      return;
    }

    if (args.task == null) {
      return;
    }

    setTask(args.task);
  }

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

  void setWork(Work work) {
    if (_isSameWork(work)) {
      return;
    }

    final videoUrl = work.video?.trim();
    final completed =
        work.jobStatus == 1 && videoUrl != null && videoUrl.isNotEmpty;
    _pollingTimer?.cancel();
    _progressTimer?.cancel();
    _isPolling = false;
    state = CreateResultState(
      work: work,
      progress: completed ? 1 : 0.01,
      status: completed ? 'completed' : 'running',
      videoUrl: completed ? videoUrl : null,
      estimatedWaitSeconds: 120,
    );

    if (!completed && work.id != null) {
      _startProgressTimer();
      _pollWorkDetail(work.id!);
      _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
        _pollWorkDetail(work.id!);
      });
    }
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

  bool _isSameWork(Work work) {
    final current = state.work;
    if (identical(current, work)) {
      return true;
    }
    return current?.id != null && work.id != null && current?.id == work.id;
  }

  void _startProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(seconds: 5), (_) {
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
    _isPolling = false;
    final workId = _resolveWorkId(task?.id);
    if (workId == null) {
      _progressTimer?.cancel();
      state = state.copyWith(
        status: 'error',
        errorMessage: 'Video task id is missing',
      );
      return;
    }

    _pollWorkDetail(workId);
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _pollWorkDetail(workId);
    });
  }

  Future<void> _pollWorkDetail(int workId) async {
    if (_isPolling) {
      return;
    }

    _isPolling = true;
    try {
      final work = await Api.getVideoWorkDetail(workId);
      if (!mounted || work == null) {
        return;
      }

      _applyWorkDetail(work);
    } finally {
      _isPolling = false;
    }
  }

  void _applyWorkDetail(Work work) {
    final jobStatus = work.jobStatus;
    if (jobStatus == 1) {
      final videoUrl = work.video?.trim();
      if (videoUrl == null || videoUrl.isEmpty) {
        state = state.copyWith(status: 'running', queuePosition: null);
        return;
      }

      _pollingTimer?.cancel();
      _progressTimer?.cancel();
      state = state.copyWith(
        work: work,
        status: 'completed',
        videoUrl: videoUrl,
        progress: 1,
        errorMessage: null,
        queuePosition: null,
      );
      return;
    }

    if (jobStatus == 0) {
      state = state.copyWith(
        work: work,
        status: 'running',
        queuePosition: null,
      );
      return;
    }

    _pollingTimer?.cancel();
    _progressTimer?.cancel();
    state = state.copyWith(
      work: work,
      status: 'error',
      errorMessage: 'Video generation failed',
    );
  }

  int? _resolveWorkId(String? id) {
    if (id == null || id.isEmpty) {
      return null;
    }
    return int.tryParse(id);
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
