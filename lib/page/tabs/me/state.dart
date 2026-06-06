import 'package:flicko_video/api/model/video_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
abstract class MeState with _$MeState {
  const factory MeState({
    @Default('') String email,
    @Default('1') String userId,
    @Default(0) int credits,
    @Default('Diamond SVIP Weekly') String vipPlan,
    @Default('') String vipExpiry,
    @Default([]) List<Work> works,
  }) = _MeState;
}
