import 'package:json_annotation/json_annotation.dart';

part 'subscribe_model.g.dart';

@JsonSerializable()
class SubscribeInfo {
  final String? goodsId;
  final String? token;
  final String? targetId;
  final int? paymentCount;
  final int? memberCreateTime;
  final int? credit;
  final VipInfo? vip;
  final List<SubscribeItem>? subscribes;

  SubscribeInfo({
    this.goodsId,
    this.token,
    this.targetId,
    this.paymentCount,
    this.memberCreateTime,
    this.credit,
    this.vip,
    this.subscribes,
  });

  factory SubscribeInfo.fromJson(Map<String, dynamic> json) =>
      _$SubscribeInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SubscribeInfoToJson(this);
}

@JsonSerializable()
class VipInfo {
  final int? level;
  final int? startDate;
  final int? endDate;
  final int? first;
  final int? purchase;

  VipInfo({
    this.level,
    this.startDate,
    this.endDate,
    this.first,
    this.purchase,
  });

  factory VipInfo.fromJson(Map<String, dynamic> json) =>
      _$VipInfoFromJson(json);

  Map<String, dynamic> toJson() => _$VipInfoToJson(this);
}

@JsonSerializable()
class SubscribeItem {
  final int? id;
  final int? scene;
  final int? scope;
  final int? type;
  final GoogleSubscribe? google;
  final AppleSubscribe? apple;

  SubscribeItem({
    this.id,
    this.scene,
    this.scope,
    this.type,
    this.google,
    this.apple,
  });

  factory SubscribeItem.fromJson(Map<String, dynamic> json) =>
      _$SubscribeItemFromJson(json);

  Map<String, dynamic> toJson() => _$SubscribeItemToJson(this);
}

@JsonSerializable()
class GoogleSubscribe {
  final String? id;
  final String? name;
  final String? goodsId;
  final String? amount;
  final int? expireDay;
  final double? price;
  final double? marketPrice;
  final String? description;

  GoogleSubscribe({
    this.id,
    this.name,
    this.goodsId,
    this.amount,
    this.expireDay,
    this.price,
    this.marketPrice,
    this.description,
  });

  factory GoogleSubscribe.fromJson(Map<String, dynamic> json) =>
      _$GoogleSubscribeFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleSubscribeToJson(this);
}

@JsonSerializable()
class AppleSubscribe {
  final String? id;
  final String? name;
  final String? iosProductId;
  final double? price;
  final String? currency;
  final String? currencyUnit;
  final String? button;
  final int? isFirstFree;

  AppleSubscribe({
    this.id,
    this.name,
    this.iosProductId,
    this.price,
    this.currency,
    this.currencyUnit,
    this.button,
    this.isFirstFree,
  });

  factory AppleSubscribe.fromJson(Map<String, dynamic> json) =>
      _$AppleSubscribeFromJson(json);

  Map<String, dynamic> toJson() => _$AppleSubscribeToJson(this);
}
