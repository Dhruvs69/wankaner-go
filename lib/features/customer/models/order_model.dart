// lib/features/customer/models/order_model.dart

class OrderModel {
  final String id;
  final String customerId;
  final String vendorId; 
  final String vendorName;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final String status;
  final DateTime createdAt;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final String? deliveryPartnerId;
  final String? deliveryOtp;
  final double? deliveryLat;
  final double? deliveryLng;

  OrderModel({
    required this.id,
    required this.customerId,
    required this.vendorId,
    this.vendorName = '',
    required this.items,
    required this.totalAmount,
    this.status = 'pending',
    required this.createdAt,
    this.customerName = '',
    this.customerPhone = '',
    this.deliveryAddress = '',
    this.deliveryPartnerId,
    this.deliveryOtp,
    this.deliveryLat,
    this.deliveryLng,
  });

  Map<String, dynamic> toMap() {
    return {
      'customer_id': customerId,
      'vendor_id': vendorId,
      'vendor_name': vendorName,
      'items': items,
      'total_amount': totalAmount,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'delivery_address': deliveryAddress,
      if (deliveryPartnerId != null) 'delivery_partner_id': deliveryPartnerId,
      if (deliveryOtp != null) 'delivery_otp': deliveryOtp,
      if (deliveryLat != null) 'delivery_lat': deliveryLat,
      if (deliveryLng != null) 'delivery_lng': deliveryLng,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String documentId) {
    return OrderModel(
      id: documentId,
      customerId: map['customer_id'] ?? map['customerId'] ?? '',
      vendorId: map['vendor_id'] ?? map['vendorId'] ?? '',
      vendorName: map['vendor_name'] ?? map['vendorName'] ?? '',
      items: List<Map<String, dynamic>>.from(map['items'] ?? []),
      totalAmount: (map['total_amount'] ?? map['totalAmount'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'pending',
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : (map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now()),
      customerName: map['customer_name'] ?? map['customerName'] ?? '',
      customerPhone: map['customer_phone'] ?? map['customerPhone'] ?? '',
      deliveryAddress: map['delivery_address'] ?? map['deliveryAddress'] ?? '',
      deliveryPartnerId: map['delivery_partner_id'] ?? map['deliveryPartnerId'],
      deliveryOtp: map['delivery_otp'] ?? map['deliveryOtp'],
      deliveryLat: map['delivery_lat'] != null ? (map['delivery_lat'] as num).toDouble() : null,
      deliveryLng: map['delivery_lng'] != null ? (map['delivery_lng'] as num).toDouble() : null,
    );
  }
}