import 'package:flicko_video/api/model/video_model.dart';

class CreateResultArgs {
  const CreateResultArgs({this.task});

  final AiCreateResponse? task;
}

class CreateResultState {
  const CreateResultState({
    this.task,
    this.progress = 0.01,
    this.estimatedWaitSeconds = 120,
    this.status = 'pending',
    this.videoUrl,
    this.errorMessage,
    this.queuePosition,
  });

  final AiCreateResponse? task;
  final double progress;
  final int estimatedWaitSeconds;
  final String status;
  final String? videoUrl;
  final String? errorMessage;
  final int? queuePosition;

  bool get isCompleted => status == 'completed' && videoUrl != null;

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
    AiCreateResponse? task,
    double? progress,
    int? estimatedWaitSeconds,
    String? status,
    String? videoUrl,
    String? errorMessage,
    int? queuePosition,
  }) {
    return CreateResultState(
      task: task ?? this.task,
      progress: progress ?? this.progress,
      estimatedWaitSeconds: estimatedWaitSeconds ?? this.estimatedWaitSeconds,
      status: status ?? this.status,
      videoUrl: videoUrl ?? this.videoUrl,
      errorMessage: errorMessage ?? this.errorMessage,
      queuePosition: queuePosition ?? this.queuePosition,
    );
  }

  CreateResultState clearResult({
    AiCreateResponse? task,
    required int estimatedWaitSeconds,
  }) {
    return CreateResultState(
      task: task,
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
