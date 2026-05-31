// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
  token: json['token'] as String?,
  memberId: (json['memberId'] as num?)?.toInt(),
  name: json['name'] as String?,
  portrait: json['portrait'] as String?,
  gender: (json['gender'] as num?)?.toInt(),
  age: (json['age'] as num?)?.toInt(),
  birthday: json['birthday'] as String?,
  ticket: json['ticket'] as String?,
  activate: (json['activate'] as num?)?.toInt(),
  bind: (json['bind'] as num?)?.toInt(),
  source: json['source'] as String?,
  channel: json['channel'] as String?,
  platform: json['platform'] as String?,
  audit: json['audit'] as String?,
  verify: (json['verify'] as num?)?.toInt(),
  guid: json['guid'] as String?,
  ip: json['ip'] as String?,
  chatLanguage: json['chatLanguage'] as String?,
  createTime: (json['createTime'] as num?)?.toInt(),
  expire: (json['expire'] as num?)?.toInt(),
  time: (json['time'] as num?)?.toInt(),
);

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'memberId': instance.memberId,
      'name': instance.name,
      'portrait': instance.portrait,
      'gender': instance.gender,
      'age': instance.age,
      'birthday': instance.birthday,
      'ticket': instance.ticket,
      'activate': instance.activate,
      'bind': instance.bind,
      'source': instance.source,
      'channel': instance.channel,
      'platform': instance.platform,
      'audit': instance.audit,
      'verify': instance.verify,
      'guid': instance.guid,
      'ip': instance.ip,
      'chatLanguage': instance.chatLanguage,
      'createTime': instance.createTime,
      'expire': instance.expire,
      'time': instance.time,
    };

AuthCheckResponse _$AuthCheckResponseFromJson(Map<String, dynamic> json) =>
    AuthCheckResponse(
      memberId: json['memberId'] as String?,
      name: json['name'] as String?,
      portrait: json['portrait'] as String?,
      gender: (json['gender'] as num?)?.toInt(),
      age: (json['age'] as num?)?.toInt(),
      birthday: json['birthday'] as String?,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$AuthCheckResponseToJson(AuthCheckResponse instance) =>
    <String, dynamic>{
      'memberId': instance.memberId,
      'name': instance.name,
      'portrait': instance.portrait,
      'gender': instance.gender,
      'age': instance.age,
      'birthday': instance.birthday,
      'token': instance.token,
    };
