import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

enum VideoMode { imageToVideo, textToVideo }

enum AiModel { wan21, wan22, wan23 }

enum Duration { s5, s10, s15 }

class HomeState {
  final VideoMode videoMode;
  final AiModel selectedModel;
  final Duration selectedDuration;
  final String? selectedImagePath;
  final String promptText;
  final int credits;
  final int maxPromptLength;

  const HomeState({
    this.videoMode = VideoMode.imageToVideo,
    this.selectedModel = AiModel.wan22,
    this.selectedDuration = Duration.s5,
    this.selectedImagePath,
    this.promptText = '',
    this.credits = 59,
    this.maxPromptLength = 2000,
  });

  HomeState copyWith({
    VideoMode? videoMode,
    AiModel? selectedModel,
    Duration? selectedDuration,
    String? selectedImagePath,
    String? promptText,
    int? credits,
  }) {
    return HomeState(
      videoMode: videoMode ?? this.videoMode,
      selectedModel: selectedModel ?? this.selectedModel,
      selectedDuration: selectedDuration ?? this.selectedDuration,
      selectedImagePath: selectedImagePath ?? this.selectedImagePath,
      promptText: promptText ?? this.promptText,
      credits: credits ?? this.credits,
      maxPromptLength: maxPromptLength,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState());

  void setVideoMode(VideoMode mode) {
    state = state.copyWith(videoMode: mode);
  }

  void setAiModel(AiModel model) {
    state = state.copyWith(selectedModel: model);
  }

  void setDuration(Duration duration) {
    state = state.copyWith(selectedDuration: duration);
  }

  void setPromptText(String text) {
    state = state.copyWith(promptText: text);
  }

  void setSelectedImage(String path) {
    state = state.copyWith(selectedImagePath: path);
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});
