import 'package:freezed_annotation/freezed_annotation.dart';

part 'vendor_model.freezed.dart';
part 'vendor_model.g.dart';

@freezed
class VendorModel with _$VendorModel {
  const factory VendorModel({
    required String id,
    required String ownerId,
    required String name,
    required String type, // 'restaurant', 'grocery', 'general'
    String? description,
    required String phone,
    required String address,
    required double latitude,
    required double longitude,
    String? image,
    @Default(false) bool isOpen,
    String? openingTime,
    String? closingTime,
    @Default(0.0) double minimumOrder,
    @Default(10.0) double commissionPercentage,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
    @Default(false) bool isApproved,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _VendorModel;

  factory VendorModel.fromJson(Map<String, dynamic> json) => _$VendorModelFromJson(json);
}