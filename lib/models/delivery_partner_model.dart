import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery_partner_model.freezed.dart';
part 'delivery_partner_model.g.dart';

@freezed
class DeliveryPartnerModel with _$DeliveryPartnerModel {
  const factory DeliveryPartnerModel({
    required String id,
    required String name,
    required String phone,
    String? profileImage,
    @Default(false) bool isOnline,
    @Default(false) bool isApproved,
    String? currentOrderId,
    double? latitude,
    double? longitude,
    @Default(0) int totalDeliveries,
    @Default(0.0) double totalEarnings,
    DateTime? createdAt,
  }) = _DeliveryPartnerModel;

  factory DeliveryPartnerModel.fromJson(Map<String, dynamic> json) => _$DeliveryPartnerModelFromJson(json);
}