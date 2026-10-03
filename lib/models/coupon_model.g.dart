// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CouponModelImpl _$$CouponModelImplFromJson(Map<String, dynamic> json) =>
    _$CouponModelImpl(
      id: json['id'] as String,
      code: json['code'] as String,
      discountType: json['discountType'] as String,
      discountValue: (json['discountValue'] as num).toDouble(),
      minOrderAmount: (json['minOrderAmount'] as num?)?.toDouble() ?? 0.0,
      maxDiscountAmount: (json['maxDiscountAmount'] as num?)?.toDouble(),
      expiryDate: const TimestampConverter().fromJson(json['expiryDate']),
      usageLimit: (json['usageLimit'] as num?)?.toInt() ?? 0,
      timesUsed: (json['timesUsed'] as num?)?.toInt() ?? 0,
      vendorId: json['vendorId'] as String?,
      isFirstOrderOnly: json['isFirstOrderOnly'] as bool? ?? false,
    );

Map<String, dynamic> _$$CouponModelImplToJson(_$CouponModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'discountType': instance.discountType,
      'discountValue': instance.discountValue,
      'minOrderAmount': instance.minOrderAmount,
      'maxDiscountAmount': instance.maxDiscountAmount,
      'expiryDate': const TimestampConverter().toJson(instance.expiryDate),
      'usageLimit': instance.usageLimit,
      'timesUsed': instance.timesUsed,
      'vendorId': instance.vendorId,
      'isFirstOrderOnly': instance.isFirstOrderOnly,
    };
