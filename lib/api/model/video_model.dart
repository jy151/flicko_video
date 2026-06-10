import 'package:json_annotation/json_annotation.dart';

part 'video_model.g.dart';

@JsonSerializable()
class CreativeHome {
  final List<Template>? guides;
  final List<Banner>? banners;
  final List<Category>? categories;
  final List<Template>? recommends;

  CreativeHome({this.guides, this.banners, this.categories, this.recommends});

  factory CreativeHome.fromJson(Map<String, dynamic> json) =>
      _$CreativeHomeFromJson(json);

  Map<String, dynamic> toJson() => _$CreativeHomeToJson(this);
}

@JsonSerializable()
class Banner {
  final int? type;
  final String? banner;
  final String? animation;
  final Template? template;

  Banner({this.type, this.banner, this.animation, this.template});

  factory Banner.fromJson(Map<String, dynamic> json) => _$BannerFromJson(json);

  Map<String, dynamic> toJson() => _$BannerToJson(this);
}

@JsonSerializable()
class Category {
  final int? id;
  final int? style;
  final String? title;
  final List<Template>? templates;
  final int? extend;

  Category({this.id, this.style, this.title, this.templates, this.extend});

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class Template {
  final int? id;
  final String? title;
  final String? cover;
  final String? video;
  final String? prompt;
  final int? level;
  final String? animation;
  final dynamic extend;
  final String? tags;
  final int? source;
  final int? score;
  final int? vipScore;

  Template({
    this.id,
    this.title,
    this.cover,
    this.video,
    this.prompt,
    this.animation,
    this.level,
    this.extend,
    this.tags,
    this.source,
    this.score,
    this.vipScore,
  });

  factory Template.fromJson(Map<String, dynamic> json) =>
      _$TemplateFromJson(json);

  Map<String, dynamic> toJson() => _$TemplateToJson(this);
}

@JsonSerializable()
class Work {
  final int? id;
  final int? hot;
  final int? workCreateTime;
  final int? jobStatus;
  final String? type;
  final String? mediaType;
  final String? cover;
  final String? video;
  final String? watermarked;
  final String? image;
  final String? prompt;
  final WorkMember? member;
  final WorkCounter? counter;

  Work({
    this.id,
    this.hot,
    this.workCreateTime,
    this.jobStatus,
    this.type,
    this.mediaType,
    this.cover,
    this.video,
    this.watermarked,
    this.image,
    this.prompt,
    this.member,
    this.counter,
  });

  factory Work.fromJson(Map<String, dynamic> json) => _$WorkFromJson(json);

  Map<String, dynamic> toJson() => _$WorkToJson(this);
}

@JsonSerializable()
class WorkMember {
  final int? memberId;
  final String? name;
  final String? portrait;

  WorkMember({this.memberId, this.name, this.portrait});

  factory WorkMember.fromJson(Map<String, dynamic> json) =>
      _$WorkMemberFromJson(json);

  Map<String, dynamic> toJson() => _$WorkMemberToJson(this);
}

@JsonSerializable()
class WorkCounter {
  final int? likeCount;
  final int? shareCount;
  final int? commentCount;

  WorkCounter({this.likeCount, this.shareCount, this.commentCount});

  factory WorkCounter.fromJson(Map<String, dynamic> json) =>
      _$WorkCounterFromJson(json);

  Map<String, dynamic> toJson() => _$WorkCounterToJson(this);
}

@JsonSerializable()
class AiCreateResponse {
  final String? audit;
  final int? batchSize;
  final int? credit;
  final int? finishTime;
  @JsonKey(fromJson: _stringFromJson)
  final String? id;
  final String? image;
  final int? jobStatus;
  final String? key;
  final String? mediaType;
  final int? memberId;
  final Map<String, dynamic>? parameters;
  final String? prompt;
  final int? queuingTime;
  final int? templateId;
  final bool? terminated;
  final dynamic type;
  final int? workSize;

  AiCreateResponse({
    this.audit,
    this.batchSize,
    this.credit,
    this.finishTime,
    this.id,
    this.image,
    this.jobStatus,
    this.key,
    this.mediaType,
    this.memberId,
    this.parameters,
    this.prompt,
    this.queuingTime,
    this.templateId,
    this.terminated,
    this.type,
    this.workSize,
  });

  factory AiCreateResponse.fromJson(Map<String, dynamic> json) =>
      _$AiCreateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AiCreateResponseToJson(this);
}

String? _stringFromJson(dynamic value) => value?.toString();

@JsonSerializable()
class AiStatusResponse {
  final String? status;
  @JsonKey(name: 'video_urls')
  final List<String>? videoUrls;
  @JsonKey(name: 'queue_position')
  final int? queuePosition;

  AiStatusResponse({this.status, this.videoUrls, this.queuePosition});

  factory AiStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$AiStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AiStatusResponseToJson(this);
}

@JsonSerializable()
class ShowcaseCategory {
  final int? id;
  final String? title;
  final dynamic extend;

  ShowcaseCategory({this.id, this.title, this.extend});

  factory ShowcaseCategory.fromJson(Map<String, dynamic> json) =>
      _$ShowcaseCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$ShowcaseCategoryToJson(this);
}
