// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
  memberId: json['memberId'] as String?,
  name: json['name'] as String?,
  portrait: json['portrait'] as String?,
  aiPortrait: json['aiPortrait'] as String?,
  cover: json['cover'] as String?,
  gender: (json['gender'] as num?)?.toInt(),
  age: (json['age'] as num?)?.toInt(),
  audit: json['audit'] as String?,
  birthday: json['birthday'] as String?,
  voice: json['voice'] as String?,
  voiceDuration: (json['voiceDuration'] as num?)?.toInt(),
  address: json['address'] as String?,
  city: json['city'] as String?,
  ic: json['ic'] as String?,
  email: json['email'] as String?,
  mobile: json['mobile'] as String?,
  signature: json['signature'] as String?,
  tags: json['tags'] as String?,
  source: json['source'] as String?,
  uid: json['uid'] as String?,
  recommend: (json['recommend'] as num?)?.toInt(),
  assistant: json['assistant'] as String?,
  purposeChatTime: json['purposeChatTime'] as String?,
  inviterCode: json['inviterCode'] as String?,
  roles: json['roles'] as String?,
);

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
  'memberId': instance.memberId,
  'name': instance.name,
  'portrait': instance.portrait,
  'aiPortrait': instance.aiPortrait,
  'cover': instance.cover,
  'gender': instance.gender,
  'age': instance.age,
  'audit': instance.audit,
  'birthday': instance.birthday,
  'voice': instance.voice,
  'voiceDuration': instance.voiceDuration,
  'address': instance.address,
  'city': instance.city,
  'ic': instance.ic,
  'email': instance.email,
  'mobile': instance.mobile,
  'signature': instance.signature,
  'tags': instance.tags,
  'source': instance.source,
  'uid': instance.uid,
  'recommend': instance.recommend,
  'assistant': instance.assistant,
  'purposeChatTime': instance.purposeChatTime,
  'inviterCode': instance.inviterCode,
  'roles': instance.roles,
};

MemberAudit _$MemberAuditFromJson(Map<String, dynamic> json) => MemberAudit(
  loop: (json['loop'] as num?)?.toInt(),
  interval: (json['interval'] as num?)?.toInt(),
  audit: json['audit'] as String?,
);

Map<String, dynamic> _$MemberAuditToJson(MemberAudit instance) =>
    <String, dynamic>{
      'loop': instance.loop,
      'interval': instance.interval,
      'audit': instance.audit,
    };
