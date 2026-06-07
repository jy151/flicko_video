// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreativeHome _$CreativeHomeFromJson(Map<String, dynamic> json) => CreativeHome(
  guides: (json['guides'] as List<dynamic>?)
      ?.map((e) => Template.fromJson(e as Map<String, dynamic>))
      .toList(),
  banners: (json['banners'] as List<dynamic>?)
      ?.map((e) => Banner.fromJson(e as Map<String, dynamic>))
      .toList(),
  categories: (json['categories'] as List<dynamic>?)
      ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
      .toList(),
  recommends: (json['recommends'] as List<dynamic>?)
      ?.map((e) => Template.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CreativeHomeToJson(CreativeHome instance) =>
    <String, dynamic>{
      'guides': instance.guides,
      'banners': instance.banners,
      'categories': instance.categories,
      'recommends': instance.recommends,
    };

Banner _$BannerFromJson(Map<String, dynamic> json) => Banner(
  type: (json['type'] as num?)?.toInt(),
  banner: json['banner'] as String?,
  animation: json['animation'] as String?,
  template: json['template'] == null
      ? null
      : Template.fromJson(json['template'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BannerToJson(Banner instance) => <String, dynamic>{
  'type': instance.type,
  'banner': instance.banner,
  'animation': instance.animation,
  'template': instance.template,
};

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
  id: (json['id'] as num?)?.toInt(),
  style: (json['style'] as num?)?.toInt(),
  title: json['title'] as String?,
  templates: (json['templates'] as List<dynamic>?)
      ?.map((e) => Template.fromJson(e as Map<String, dynamic>))
      .toList(),
  extend: (json['extend'] as num?)?.toInt(),
);

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
  'id': instance.id,
  'style': instance.style,
  'title': instance.title,
  'templates': instance.templates,
  'extend': instance.extend,
};

Template _$TemplateFromJson(Map<String, dynamic> json) => Template(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  cover: json['cover'] as String?,
  video: json['video'] as String?,
  prompt: json['prompt'] as String?,
  animation: json['animation'] as String?,
  level: (json['level'] as num?)?.toInt(),
  extend: json['extend'],
  tags: json['tags'] as String?,
  source: (json['source'] as num?)?.toInt(),
  score: (json['score'] as num?)?.toInt(),
  vipScore: (json['vipScore'] as num?)?.toInt(),
);

Map<String, dynamic> _$TemplateToJson(Template instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'cover': instance.cover,
  'video': instance.video,
  'prompt': instance.prompt,
  'level': instance.level,
  'animation': instance.animation,
  'extend': instance.extend,
  'tags': instance.tags,
  'source': instance.source,
  'score': instance.score,
  'vipScore': instance.vipScore,
};

Work _$WorkFromJson(Map<String, dynamic> json) => Work(
  id: (json['id'] as num?)?.toInt(),
  hot: (json['hot'] as num?)?.toInt(),
  workCreateTime: (json['workCreateTime'] as num?)?.toInt(),
  type: json['type'] as String?,
  mediaType: json['mediaType'] as String?,
  cover: json['cover'] as String?,
  video: json['video'] as String?,
  image: json['image'] as String?,
  prompt: json['prompt'] as String?,
  member: json['member'] == null
      ? null
      : WorkMember.fromJson(json['member'] as Map<String, dynamic>),
  counter: json['counter'] == null
      ? null
      : WorkCounter.fromJson(json['counter'] as Map<String, dynamic>),
);

Map<String, dynamic> _$WorkToJson(Work instance) => <String, dynamic>{
  'id': instance.id,
  'hot': instance.hot,
  'workCreateTime': instance.workCreateTime,
  'type': instance.type,
  'mediaType': instance.mediaType,
  'cover': instance.cover,
  'video': instance.video,
  'image': instance.image,
  'prompt': instance.prompt,
  'member': instance.member,
  'counter': instance.counter,
};

WorkMember _$WorkMemberFromJson(Map<String, dynamic> json) => WorkMember(
  memberId: (json['memberId'] as num?)?.toInt(),
  name: json['name'] as String?,
  portrait: json['portrait'] as String?,
);

Map<String, dynamic> _$WorkMemberToJson(WorkMember instance) =>
    <String, dynamic>{
      'memberId': instance.memberId,
      'name': instance.name,
      'portrait': instance.portrait,
    };

WorkCounter _$WorkCounterFromJson(Map<String, dynamic> json) => WorkCounter(
  likeCount: (json['likeCount'] as num?)?.toInt(),
  shareCount: (json['shareCount'] as num?)?.toInt(),
  commentCount: (json['commentCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$WorkCounterToJson(WorkCounter instance) =>
    <String, dynamic>{
      'likeCount': instance.likeCount,
      'shareCount': instance.shareCount,
      'commentCount': instance.commentCount,
    };

AiCreateResponse _$AiCreateResponseFromJson(Map<String, dynamic> json) =>
    AiCreateResponse(
      audit: json['audit'] as String?,
      batchSize: (json['batchSize'] as num?)?.toInt(),
      credit: (json['credit'] as num?)?.toInt(),
      finishTime: (json['finishTime'] as num?)?.toInt(),
      id: json['id'] as String?,
      image: json['image'] as String?,
      jobStatus: (json['jobStatus'] as num?)?.toInt(),
      key: json['key'] as String?,
      mediaType: json['mediaType'] as String?,
      memberId: (json['memberId'] as num?)?.toInt(),
      parameters: json['parameters'] as Map<String, dynamic>?,
      prompt: json['prompt'] as String?,
      queuingTime: (json['queuingTime'] as num?)?.toInt(),
      templateId: (json['templateId'] as num?)?.toInt(),
      terminated: json['terminated'] as bool?,
      type: json['type'],
      workSize: (json['workSize'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AiCreateResponseToJson(AiCreateResponse instance) =>
    <String, dynamic>{
      'audit': instance.audit,
      'batchSize': instance.batchSize,
      'credit': instance.credit,
      'finishTime': instance.finishTime,
      'id': instance.id,
      'image': instance.image,
      'jobStatus': instance.jobStatus,
      'key': instance.key,
      'mediaType': instance.mediaType,
      'memberId': instance.memberId,
      'parameters': instance.parameters,
      'prompt': instance.prompt,
      'queuingTime': instance.queuingTime,
      'templateId': instance.templateId,
      'terminated': instance.terminated,
      'type': instance.type,
      'workSize': instance.workSize,
    };

AiStatusResponse _$AiStatusResponseFromJson(Map<String, dynamic> json) =>
    AiStatusResponse(
      status: json['status'] as String?,
      videoUrls: (json['video_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      queuePosition: (json['queue_position'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AiStatusResponseToJson(AiStatusResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'video_urls': instance.videoUrls,
      'queue_position': instance.queuePosition,
    };

ShowcaseCategory _$ShowcaseCategoryFromJson(Map<String, dynamic> json) =>
    ShowcaseCategory(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      extend: json['extend'],
    );

Map<String, dynamic> _$ShowcaseCategoryToJson(ShowcaseCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'extend': instance.extend,
    };
