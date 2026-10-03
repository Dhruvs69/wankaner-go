// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VendorModelImpl _$$VendorModelImplFromJson(Map<String, dynamic> json) =>
    _$VendorModelImpl(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      description: json['description'] as String?,
      phone: json['phone'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      image: json['image'] as String?,
      isOpen: json['isOpen'] as bool? ?? false,
      openingTime: json['openingTime'] as String?,
      closingTime: json['closingTime'] as String?,
      minimumOrder: (json['minimumOrder'] as num?)?.toDouble() ?? 0.0,
      commissionPercentage:
          (json['commissionPercentage'] as num?)?.toDouble() ?? 10.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      isApproved: json['isApproved'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$VendorModelImplToJson(_$VendorModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'name': instance.name,
      'type': instance.type,
      'description': instance.description,
      'phone': instance.phone,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'image': instance.image,
      'isOpen': instance.isOpen,
      'openingTime': instance.openingTime,
      'closingTime': instance.closingTime,
      'minimumOrder': instance.minimumOrder,
      'commissionPercentage': instance.commissionPercentage,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'isApproved': instance.isApproved,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
