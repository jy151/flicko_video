import 'package:json_annotation/json_annotation.dart';

part 'config_model.g.dart';

@JsonSerializable()
class AiModelConfig {
  final List<AiModel>? t2i;
  final List<AiModel>? i2i;
  final List<AiModel>? t2v;
  final List<AiModel>? i2v;
  final List<AiModel>? r2v;
  final List<AiModel>? se2v;
  final List<AiModel>? tpl2v;
  final List<ImageStyleGroup>? imageStyles;

  AiModelConfig({
    this.t2i,
    this.i2i,
    this.t2v,
    this.i2v,
    this.r2v,
    this.se2v,
    this.tpl2v,
    this.imageStyles,
  });

  factory AiModelConfig.fromJson(Map<String, dynamic> json) =>
      _$AiModelConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AiModelConfigToJson(this);
}

@JsonSerializable()
class AiModel {
  final int? id;
  final String? title;
  final String? model;
  final String? icon;
  final String? tags;
  final String? intro;
  final int? waitSecond;
  final int? level;
  final String? durations;
  final Map<String, dynamic>? credits;
  final Map<String, dynamic>? vipCredits;
  final List<dynamic>? parameters;
  final int? defaultCredit;
  final int? defaultVipCredit;

  AiModel({
    this.id,
    this.title,
    this.model,
    this.icon,
    this.tags,
    this.intro,
    this.waitSecond,
    this.level,
    this.durations,
    this.credits,
    this.vipCredits,
    this.parameters,
    this.defaultCredit,
    this.defaultVipCredit,
  });

  factory AiModel.fromJson(Map<String, dynamic> json) =>
      _$AiModelFromJson(json);

  Map<String, dynamic> toJson() => _$AiModelToJson(this);
}

@JsonSerializable()
class ImageStyleGroup {
  final int? id;
  final String? title;
  final int? styleCount;
  final String? cover;
  final List<ImageStyle>? styles;
  final dynamic extend;

  ImageStyleGroup({
    this.id,
    this.title,
    this.styleCount,
    this.styles,
    this.cover,
    this.extend,
  });

  factory ImageStyleGroup.fromJson(Map<String, dynamic> json) =>
      _$ImageStyleGroupFromJson(json);

  Map<String, dynamic> toJson() => _$ImageStyleGroupToJson(this);
}

@JsonSerializable()
class ImageStyle {
  final int? id;
  final String? title;
  final String? cover;
  final String? prompt;
  final dynamic extend;

  ImageStyle({
    this.id,
    this.title,
    this.cover,
    this.prompt,
    this.extend,
  });

  factory ImageStyle.fromJson(Map<String, dynamic> json) =>
      _$ImageStyleFromJson(json);

  Map<String, dynamic> toJson() => _$ImageStyleToJson(this);
}

@JsonSerializable()
class OrderCheckResponse {
  final int? code;
  final dynamic data;
  final int? points;
  @JsonKey(name: 'type_m')
  final String? typeM;
  final String? m;

  OrderCheckResponse({
    this.code,
    this.data,
    this.points,
    this.typeM,
    this.m,
  });

  factory OrderCheckResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderCheckResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderCheckResponseToJson(this);
}

@JsonSerializable()
class OrderCreateResponse {
  final int? code;
  final String? msg;
  final String? od;

  OrderCreateResponse({
    this.code,
    this.msg,
    this.od,
  });

  factory OrderCreateResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderCreateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderCreateResponseToJson(this);
}
