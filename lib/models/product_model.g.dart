// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      id: json['id'] as String,
      vendorId: json['vendorId'] as String,
      categoryId: json['categoryId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      image: json['image'] as String?,
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discountPrice'] as num?)?.toDouble(),
      variants: (json['variants'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isAvailable: json['isAvailable'] as bool? ?? true,
      isVeg: json['isVeg'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vendorId': instance.vendorId,
      'categoryId': instance.categoryId,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'price': instance.price,
      'discountPrice': instance.discountPrice,
      'variants': instance.variants,
      'isAvailable': instance.isAvailable,
      'isVeg': instance.isVeg,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
