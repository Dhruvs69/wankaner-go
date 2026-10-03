import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String id,
    required String vendorId,
    required String categoryId,
    required String name,
    String? description,
    String? image,
    required double price,
    double? discountPrice,
    @Default([]) List<String> variants,
    @Default(true) bool isAvailable,
    @Default(false) bool isVeg,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);
}