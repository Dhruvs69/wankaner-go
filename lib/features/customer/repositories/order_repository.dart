// lib/features/customer/repositories/order_repository.dart
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order_model.dart';
import '../../../core/api_service.dart';

final orderRepositoryProvider = Provider((ref) {
  return OrderRepository();
});

final customerOrdersProvider = StreamProvider.family<List<OrderModel>, String>((ref, customerId) {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.getCustomerOrders(customerId);
});

final vendorOrdersProvider = StreamProvider.family<List<OrderModel>, String>((ref, vendorId) {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.getVendorOrders(vendorId);
});

final activeOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.getActiveOrders();
});

final deliveryOrdersProvider = StreamProvider.family<List<OrderModel>, String>((ref, partnerId) {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.getDeliveryOrders(partnerId);
});

class OrderRepository {
  OrderRepository();

  Future<void> placeOrder(OrderModel order) async {
    try {
      final response = await ApiService.post('/orders', order.toMap());
      if (response.statusCode != 201) {
        throw Exception('Failed to place order');
      }
    } catch (e) {
      throw Exception('Failed to place order: $e');
    }
  }

  Stream<List<OrderModel>> _pollOrders(String endpoint) async* {
    while (true) {
      try {
        final response = await ApiService.get(endpoint);
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          yield data.map((doc) => OrderModel.fromMap(doc, doc['id'])).toList();
        } else {
          yield [];
        }
      } catch (e) {
        yield [];
      }
      await Future.delayed(const Duration(seconds: 10));
    }
  }

  Stream<List<OrderModel>> getCustomerOrders(String customerId) {
    return _pollOrders('/orders/customer/$customerId');
  }

  Stream<List<OrderModel>> getVendorOrders(String vendorId) {
    return _pollOrders('/orders/vendor/$vendorId');
  }

  Stream<List<OrderModel>> getActiveOrders() {
    return _pollOrders('/orders/active');
  }

  Stream<List<OrderModel>> getDeliveryOrders(String deliveryPartnerId) {
    return _pollOrders('/orders/delivery/$deliveryPartnerId');
  }

  Future<void> updateOrderStatus(String orderId, String newStatus, {String? proofImageUrl, String? deliveryOtp}) async {
    try {
      final body = <String, dynamic>{'status': newStatus};
      if (proofImageUrl != null) {
        body['proof_image_url'] = proofImageUrl;
      }
      if (deliveryOtp != null) {
        body['delivery_otp'] = deliveryOtp;
      }
      final response = await ApiService.put('/orders/$orderId', body);
      if (response.statusCode == 400) {
        throw Exception('Invalid OTP');
      } else if (response.statusCode != 200) {
        throw Exception('Failed to update order status');
      }
    } catch (e) {
      if (e.toString().contains('Invalid OTP')) {
        rethrow;
      }
      throw Exception('Failed to update order status: $e');
    }
  }

  Future<void> assignDeliveryPartner(String orderId, String deliveryPartnerId) async {
    try {
      final response = await ApiService.put('/orders/$orderId', {
        'deliveryPartnerId': deliveryPartnerId,
        'status': 'out for delivery',
      });
      if (response.statusCode != 200) {
        throw Exception('Failed to assign delivery partner');
      }
    } catch (e) {
      throw Exception('Failed to assign delivery partner: $e');
    }
  }
}