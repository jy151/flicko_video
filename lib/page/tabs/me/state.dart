import 'package:flicko_video/api/model/video_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
abstract class MeState with _$MeState {
  const factory MeState({
    @Default('') String name,
    @Default('') String portrait,
    @Default('') String email,
    @Default('') String userId,
    @Default(0) int credits,
    @Default('暂无会员') String vipPlan,
    @Default('') String vipExpiry,
    @Default([]) List<Work> works,
    @Default(false) bool worksLoading,
  }) = _MeState;
}
