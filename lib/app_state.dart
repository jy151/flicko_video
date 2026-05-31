
import 'package:flicko_video/api/model/config_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'app_state.freezed.dart';  
@freezed
abstract class AppState with _$AppState {
  const factory AppState({
 @Default(null) AiModelConfig? config
  } 
   
  ) = _AppState;
}