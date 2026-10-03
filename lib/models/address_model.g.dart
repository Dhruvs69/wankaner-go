// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddressModelImpl _$$AddressModelImplFromJson(Map<String, dynamic> json) =>
    _$AddressModelImpl(
      id: json['id'] as String,
      label: json['label'] as String,
      fullAddress: json['fullAddress'] as String,
      city: json['city'] as String,
      pincode: json['pincode'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$AddressModelImplToJson(_$AddressModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'fullAddress': instance.fullAddress,
      'city': instance.city,
      'pincode': instance.pincode,
      'isDefault': instance.isDefault,
      'lat': instance.lat,
      'lng': instance.lng,
    };
