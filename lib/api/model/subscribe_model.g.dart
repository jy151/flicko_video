// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscribe_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscribeInfo _$SubscribeInfoFromJson(Map<String, dynamic> json) =>
    SubscribeInfo(
      goodsId: json['goodsId'] as String?,
      token: json['token'] as String?,
      targetId: json['targetId'] as String?,
      paymentCount: (json['paymentCount'] as num?)?.toInt(),
      memberCreateTime: (json['memberCreateTime'] as num?)?.toInt(),
      credit: (json['credit'] as num?)?.toInt(),
      vip: json['vip'] == null
          ? null
          : VipInfo.fromJson(json['vip'] as Map<String, dynamic>),
      subscribes: (json['subscribes'] as List<dynamic>?)
          ?.map((e) => SubscribeItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubscribeInfoToJson(SubscribeInfo instance) =>
    <String, dynamic>{
      'goodsId': instance.goodsId,
      'token': instance.token,
      'targetId': instance.targetId,
      'paymentCount': instance.paymentCount,
      'memberCreateTime': instance.memberCreateTime,
      'credit': instance.credit,
      'vip': instance.vip,
      'subscribes': instance.subscribes,
    };

VipInfo _$VipInfoFromJson(Map<String, dynamic> json) => VipInfo(
  level: (json['level'] as num?)?.toInt(),
  startDate: (json['startDate'] as num?)?.toInt(),
  endDate: (json['endDate'] as num?)?.toInt(),
  first: (json['first'] as num?)?.toInt(),
  purchase: (json['purchase'] as num?)?.toInt(),
);

Map<String, dynamic> _$VipInfoToJson(VipInfo instance) => <String, dynamic>{
  'level': instance.level,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'first': instance.first,
  'purchase': instance.purchase,
};

SubscribeItem _$SubscribeItemFromJson(Map<String, dynamic> json) =>
    SubscribeItem(
      id: (json['id'] as num?)?.toInt(),
      scene: json['scene'] as String?,
      scope: json['scope'] as String?,
      type: json['type'] as String?,
      google: json['google'] == null
          ? null
          : GoogleSubscribe.fromJson(json['google'] as Map<String, dynamic>),
      apple: json['apple'] == null
          ? null
          : AppleSubscribe.fromJson(json['apple'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SubscribeItemToJson(SubscribeItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'scene': instance.scene,
      'scope': instance.scope,
      'type': instance.type,
      'google': instance.google,
      'apple': instance.apple,
    };

GoogleSubscribe _$GoogleSubscribeFromJson(Map<String, dynamic> json) =>
    GoogleSubscribe(
      id: json['id'] as String?,
      name: json['name'] as String?,
      goodsId: json['goodsId'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      expireDay: (json['expireDay'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toDouble(),
      marketPrice: (json['marketPrice'] as num?)?.toDouble(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$GoogleSubscribeToJson(GoogleSubscribe instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'goodsId': instance.goodsId,
      'amount': instance.amount,
      'expireDay': instance.expireDay,
      'price': instance.price,
      'marketPrice': instance.marketPrice,
      'description': instance.description,
    };

AppleSubscribe _$AppleSubscribeFromJson(Map<String, dynamic> json) =>
    AppleSubscribe(
      id: json['id'] as String?,
      name: json['name'] as String?,
      iosProductId: json['iosProductId'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      currencyUnit: json['currencyUnit'] as String?,
      button: json['button'] as String?,
      isFirstFree: (json['isFirstFree'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AppleSubscribeToJson(AppleSubscribe instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'iosProductId': instance.iosProductId,
      'price': instance.price,
      'currency': instance.currency,
      'currencyUnit': instance.currencyUnit,
      'button': instance.button,
      'isFirstFree': instance.isFirstFree,
    };
