import 'package:json_annotation/json_annotation.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthResponse {
  final String? token;
  final int? memberId;
  final String? name;
  final String? portrait;
  final int? gender;
  final int? age;
  final String? birthday;
  final String? ticket;
  final int? activate;
  final int? bind;
  final String? source;
  final String? channel;
  final String? platform;
  final String? audit;
  final int? verify;
  final String? guid;
  final String? ip;
  final String? chatLanguage;
  final int? createTime;
  final int? expire;
  final int? time;

  AuthResponse({
    this.token,
    this.memberId,
    this.name,
    this.portrait,
    this.gender,
    this.age,
    this.birthday,
    this.ticket,
    this.activate,
    this.bind,
    this.source,
    this.channel,
    this.platform,
    this.audit,
    this.verify,
    this.guid,
    this.ip,
    this.chatLanguage,
    this.createTime,
    this.expire,
    this.time,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

@JsonSerializable()
class AuthCheckResponse {
  final String? memberId;
  final String? name;
  final String? portrait;
  final int? gender;
  final int? age;
  final String? birthday;
  final String? token;

  AuthCheckResponse({
    this.memberId,
    this.name,
    this.portrait,
    this.gender,
    this.age,
    this.birthday,
    this.token,
  });

  factory AuthCheckResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthCheckResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthCheckResponseToJson(this);
}
