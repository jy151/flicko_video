import 'package:flicko_video/api/model/video_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'state.freezed.dart';

@freezed
abstract class EffectsState with _$EffectsState {
  const factory EffectsState({
    @Default(null) CreativeHome? creativeHome,
    @Default(0) int currentBannerIndex,
    @Default(0) int credits,
  }) = _EffectsState;
}
