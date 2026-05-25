class VideoEffect {
  final String id;
  final String title;
  final String thumbnail;
  final bool isVip;

  const VideoEffect({
    required this.id,
    required this.title,
    required this.thumbnail,
    this.isVip = false,
  });
}

class EffectsCreateState {
  final String? selectedImagePath;
  final String? selectedEffectId;
  final List<VideoEffect> videoEffects;
  final String previewImageUrl;
  final int credits;
  final bool isLoading;

  const EffectsCreateState({
    this.selectedImagePath,
    this.selectedEffectId,
    this.videoEffects = const [],
    this.previewImageUrl = 'https://picsum.photos/800/600?random=100',
    this.credits = 59,
    this.isLoading = false,
  });

  factory EffectsCreateState.initial() {
    return EffectsCreateState(
      videoEffects: [
        const VideoEffect(
          id: '1',
          title: '20260319...',
          thumbnail: 'https://picsum.photos/200/200?random=10',
          isVip: true,
        ),
        const VideoEffect(
          id: '2',
          title: '450x_aut...',
          thumbnail: 'https://picsum.photos/200/200?random=11',
          isVip: true,
        ),
        const VideoEffect(
          id: '3',
          title: '450x_aut...',
          thumbnail: 'https://picsum.photos/200/200?random=12',
          isVip: true,
        ),
      ],
      selectedEffectId: '1',
    );
  }

  EffectsCreateState copyWith({
    String? selectedImagePath,
    String? selectedEffectId,
    List<VideoEffect>? videoEffects,
    String? previewImageUrl,
    int? credits,
    bool? isLoading,
  }) {
    return EffectsCreateState(
      selectedImagePath: selectedImagePath ?? this.selectedImagePath,
      selectedEffectId: selectedEffectId ?? this.selectedEffectId,
      videoEffects: videoEffects ?? this.videoEffects,
      previewImageUrl: previewImageUrl ?? this.previewImageUrl,
      credits: credits ?? this.credits,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
