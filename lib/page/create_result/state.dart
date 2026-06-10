import 'package:flicko_video/api/model/video_model.dart';

class CreateResultArgs {
  const CreateResultArgs({this.task, this.work});

  final AiCreateResponse? task;
  final Work? work;
}

const _unset = Object();

class CreateResultState {
  const CreateResultState({
    this.task,
    this.work,
    this.progress = 0.01,
    this.estimatedWaitSeconds = 120,
    this.status = 'pending',
    this.videoUrl,
    this.errorMessage,
    this.queuePosition,
  });

  final AiCreateResponse? task;
  final Work? work;
  final double progress;
  final int estimatedWaitSeconds;
  final String status;
  final String? videoUrl;
  final String? errorMessage;
  final int? queuePosition;

  bool get isCompleted =>
      status == 'completed' && videoUrl != null && videoUrl!.isNotEmpty;

  bool get isFailed => status == 'error';

  int get progressPercent => (progress * 100).clamp(1, 99).round();

  String get estimatedWaitLabel {
    if (estimatedWaitSeconds < 60) {
      return '$estimatedWaitSeconds sec';
    }

    final minutes = (estimatedWaitSeconds / 60).ceil();
    return '$minutes min';
  }

  CreateResultState copyWith({
    Object? task = _unset,
    Object? work = _unset,
    double? progress,
    int? estimatedWaitSeconds,
    String? status,
    Object? videoUrl = _unset,
    Object? errorMessage = _unset,
    Object? queuePosition = _unset,
  }) {
    return CreateResultState(
      task: task == _unset ? this.task : task as AiCreateResponse?,
      work: work == _unset ? this.work : work as Work?,
      progress: progress ?? this.progress,
      estimatedWaitSeconds: estimatedWaitSeconds ?? this.estimatedWaitSeconds,
      status: status ?? this.status,
      videoUrl: videoUrl == _unset ? this.videoUrl : videoUrl as String?,
      errorMessage: errorMessage == _unset
          ? this.errorMessage
          : errorMessage as String?,
      queuePosition: queuePosition == _unset
          ? this.queuePosition
          : queuePosition as int?,
    );
  }

  CreateResultState clearResult({
    AiCreateResponse? task,
    Work? work,
    required int estimatedWaitSeconds,
  }) {
    return CreateResultState(
      task: task,
      work: work,
      progress: 0.01,
      estimatedWaitSeconds: estimatedWaitSeconds,
      status: 'pending',
    );
  }

  static int estimateWaitSecondsFor(AiCreateResponse? task) {
    final queuingTime = task?.queuingTime;
    if (queuingTime == null || queuingTime <= 0) {
      return 120;
    }

    return queuingTime > 600 ? (queuingTime / 1000).round() : queuingTime;
  }
}
