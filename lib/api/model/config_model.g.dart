// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiModelConfig _$AiModelConfigFromJson(Map<String, dynamic> json) =>
    AiModelConfig(
      t2i: (json['t2i'] as List<dynamic>?)
          ?.map((e) => AiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      i2i: (json['i2i'] as List<dynamic>?)
          ?.map((e) => AiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      t2v: (json['t2v'] as List<dynamic>?)
          ?.map((e) => AiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      i2v: (json['i2v'] as List<dynamic>?)
          ?.map((e) => AiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      r2v: (json['r2v'] as List<dynamic>?)
          ?.map((e) => AiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      se2v: (json['se2v'] as List<dynamic>?)
          ?.map((e) => AiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      tpl2v: (json['tpl2v'] as List<dynamic>?)
          ?.map((e) => AiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageStyles: (json['imageStyles'] as List<dynamic>?)
          ?.map((e) => ImageStyleGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AiModelConfigToJson(AiModelConfig instance) =>
    <String, dynamic>{
      't2i': instance.t2i,
      'i2i': instance.i2i,
      't2v': instance.t2v,
      'i2v': instance.i2v,
      'r2v': instance.r2v,
      'se2v': instance.se2v,
      'tpl2v': instance.tpl2v,
      'imageStyles': instance.imageStyles,
    };

AiModel _$AiModelFromJson(Map<String, dynamic> json) => AiModel(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  model: json['model'] as String?,
  icon: json['icon'] as String?,
  tags: json['tags'] as String?,
  intro: json['intro'] as String?,
  waitSecond: (json['waitSecond'] as num?)?.toInt(),
  level: (json['level'] as num?)?.toInt(),
  durations: json['durations'] as String?,
  credits: json['credits'] as Map<String, dynamic>?,
  vipCredits: json['vipCredits'] as Map<String, dynamic>?,
  parameters: json['parameters'] as List<dynamic>?,
  defaultCredit: (json['defaultCredit'] as num?)?.toInt(),
  defaultVipCredit: (json['defaultVipCredit'] as num?)?.toInt(),
);

Map<String, dynamic> _$AiModelToJson(AiModel instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'model': instance.model,
  'icon': instance.icon,
  'tags': instance.tags,
  'intro': instance.intro,
  'waitSecond': instance.waitSecond,
  'level': instance.level,
  'durations': instance.durations,
  'credits': instance.credits,
  'vipCredits': instance.vipCredits,
  'parameters': instance.parameters,
  'defaultCredit': instance.defaultCredit,
  'defaultVipCredit': instance.defaultVipCredit,
};

ImageStyleGroup _$ImageStyleGroupFromJson(Map<String, dynamic> json) =>
    ImageStyleGroup(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      styleCount: (json['styleCount'] as num?)?.toInt(),
      styles: (json['styles'] as List<dynamic>?)
          ?.map((e) => ImageStyle.fromJson(e as Map<String, dynamic>))
          .toList(),
      cover: json['cover'] as String?,
      extend: json['extend'],
    );

Map<String, dynamic> _$ImageStyleGroupToJson(ImageStyleGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'styleCount': instance.styleCount,
      'cover': instance.cover,
      'styles': instance.styles,
      'extend': instance.extend,
    };

ImageStyle _$ImageStyleFromJson(Map<String, dynamic> json) => ImageStyle(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  cover: json['cover'] as String?,
  prompt: json['prompt'] as String?,
  extend: json['extend'],
);

Map<String, dynamic> _$ImageStyleToJson(ImageStyle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'cover': instance.cover,
      'prompt': instance.prompt,
      'extend': instance.extend,
    };

OrderCheckResponse _$OrderCheckResponseFromJson(Map<String, dynamic> json) =>
    OrderCheckResponse(
      code: (json['code'] as num?)?.toInt(),
      data: json['data'],
      points: (json['points'] as num?)?.toInt(),
      typeM: json['type_m'] as String?,
      m: json['m'] as String?,
    );

Map<String, dynamic> _$OrderCheckResponseToJson(OrderCheckResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'points': instance.points,
      'type_m': instance.typeM,
      'm': instance.m,
    };

OrderCreateResponse _$OrderCreateResponseFromJson(Map<String, dynamic> json) =>
    OrderCreateResponse(
      code: (json['code'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      od: json['od'] as String?,
    );

Map<String, dynamic> _$OrderCreateResponseToJson(
  OrderCreateResponse instance,
) => <String, dynamic>{
  'code': instance.code,
  'msg': instance.msg,
  'od': instance.od,
};
