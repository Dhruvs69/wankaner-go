import 'package:freezed_annotation/freezed_annotation.dart';
import 'timestamp_converter.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String productId,
    required String name,
    required int quantity,
    required double price,
    String? variant,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);
}

@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    required String id,
    required String customerId,
    required String vendorId,
    String? deliveryPartnerId,
    required List<OrderItem> items,
    required double subtotal,
    @Default(0.0) double discount,
    required double deliveryFee,
    required double total,
    @Default('COD') String paymentMethod,
    @Default('PENDING') String paymentStatus,
    @Default('PLACED') String orderStatus, // PLACED, ACCEPTED, PREPARING, READY, PICKED_UP, OUT_FOR_DELIVERY, DELIVERED, CANCELLED
    required String customerAddress,
    required double customerLatitude,
    required double customerLongitude,
    required double vendorLatitude,
    required double vendorLongitude,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? acceptedAt,
    @TimestampConverter() DateTime? readyAt,
    @TimestampConverter() DateTime? pickedUpAt,
    @TimestampConverter() DateTime? deliveredAt,
    @TimestampConverter() DateTime? cancelledAt,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
}