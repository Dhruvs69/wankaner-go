import 'package:freezed_annotation/freezed_annotation.dart';
import 'timestamp_converter.dart';

part 'coupon_model.freezed.dart';
part 'coupon_model.g.dart';

@freezed
class CouponModel with _$CouponModel {
  const factory CouponModel({
    required String id,
    required String code,
    required String discountType, // 'percentage' or 'fixed'
    required double discountValue,
    @Default(0.0) double minOrderAmount,
    double? maxDiscountAmount,
    @TimestampConverter() DateTime? expiryDate,
    @Default(0) int usageLimit,
    @Default(0) int timesUsed,
    String? vendorId, // If null, applies to all vendors
    @Default(false) bool isFirstOrderOnly,
  }) = _CouponModel;

  factory CouponModel.fromJson(Map<String, dynamic> json) => _$CouponModelFromJson(json);
}