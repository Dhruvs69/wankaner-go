// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_partner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeliveryPartnerModelImpl _$$DeliveryPartnerModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DeliveryPartnerModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      profileImage: json['profileImage'] as String?,
      isOnline: json['isOnline'] as bool? ?? false,
      isApproved: json['isApproved'] as bool? ?? false,
      currentOrderId: json['currentOrderId'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      totalDeliveries: (json['totalDeliveries'] as num?)?.toInt() ?? 0,
      totalEarnings: (json['totalEarnings'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$DeliveryPartnerModelImplToJson(
        _$DeliveryPartnerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'profileImage': instance.profileImage,
      'isOnline': instance.isOnline,
      'isApproved': instance.isApproved,
      'currentOrderId': instance.currentOrderId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'totalDeliveries': instance.totalDeliveries,
      'totalEarnings': instance.totalEarnings,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
