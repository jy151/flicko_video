import 'package:json_annotation/json_annotation.dart';

part 'member_model.g.dart';

@JsonSerializable()
class Member {
  final String? memberId;
  final String? name;
  final String? portrait;
  final String? aiPortrait;
  final String? cover;
  final int? gender;
  final int? age;
  final String? audit;
  final String? birthday;
  final String? voice;
  final int? voiceDuration;
  final String? address;
  final String? city;
  final String? ic;
  final String? email;
  final String? mobile;
  final String? signature;
  final String? tags;
  final String? source;
  final String? uid;
  final int? recommend;
  final String? assistant;
  final String? purposeChatTime;
  final String? inviterCode;
  final String? roles;

  Member({
    this.memberId,
    this.name,
    this.portrait,
    this.aiPortrait,
    this.cover,
    this.gender,
    this.age,
    this.audit,
    this.birthday,
    this.voice,
    this.voiceDuration,
    this.address,
    this.city,
    this.ic,
    this.email,
    this.mobile,
    this.signature,
    this.tags,
    this.source,
    this.uid,
    this.recommend,
    this.assistant,
    this.purposeChatTime,
    this.inviterCode,
    this.roles,
  });

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

  Map<String, dynamic> toJson() => _$MemberToJson(this);
}

@JsonSerializable()
class MemberAudit {
  final int? loop;
  final int? interval;
  final String? audit;

  MemberAudit({this.loop, this.interval, this.audit});

  factory MemberAudit.fromJson(Map<String, dynamic> json) =>
      _$MemberAuditFromJson(json);

  Map<String, dynamic> toJson() => _$MemberAuditToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Balance {
  final int? id;
  final int? memberId; 
  final String? name;
  final String? portrait;
  final String? aiPortrait;
  final String? cover;
  final int? gender;
  final int? age;
  final String? birthday;
  final String? voice;
  final int? voiceDuration;
  final String? address;
  final String? city;
  final String? ic;
  final String? email;
  final String? mobile;
  final String? signature;
  final String? tags;
  final String? source;
  final String? uid;
  final int? recommend;
  final String? assistant;
  final String? purposeChatTime;
  final String? inviterCode;
  final String? roles;
  final String? channel;
  final String? platform;
  final String? guid;
  final String? ip;
  final String? chatLanguage;
  final int? credit;
  final String? password;
  final int? activate;
  final String? audit;
  final String? verify;
  final int? createTime;
  final int? updateTime;
  final String? stripeCustomerId;
  final int? webId;
  final String? px;
  final String? fcid;
  final String? adUkey;
  final String? gpsAdid;
  final String? adId;
  final String? country;
  final String? network;
  final int? payId;
  final int? sourceType;
  final String? adName;

  Balance({
    this.id,
    this.memberId,
    this.name,
    this.portrait,
    this.aiPortrait,
    this.cover,
    this.gender,
    this.age,
    this.birthday,
    this.voice,
    this.voiceDuration,
    this.address,
    this.city,
    this.ic,
    this.email,
    this.mobile,
    this.signature,
    this.tags,
    this.source,
    this.uid,
    this.recommend,
    this.assistant,
    this.purposeChatTime,
    this.inviterCode,
    this.roles,
    this.channel,
    this.platform,
    this.guid,
    this.ip,
    this.chatLanguage,
    this.credit,
    this.password,
    this.activate,
    this.audit,
    this.verify,
    this.createTime,
    this.updateTime,
    this.stripeCustomerId,
    this.webId,
    this.px,
    this.fcid,
    this.adUkey,
    this.gpsAdid,
    this.adId,
    this.country,
    this.network,
    this.payId,
    this.sourceType,
    this.adName,
  });

  factory Balance.fromJson(Map<String, dynamic> json) =>
      _$BalanceFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceToJson(this);
}
