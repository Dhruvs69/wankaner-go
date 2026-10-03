import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import 'global_notification_provider.dart';
import '../repositories/order_repository.dart';
import 'vendor_provider.dart';

final aggregatedNotificationsProvider = Provider<List<dynamic>>((ref) {
  final userAsync = ref.watch(currentUserStreamProvider);
  final user = userAsync.value;
  if (user == null) return [];

  final List<dynamic> allNotifications = [];
  
  // 1. If Customer, add Global Notifications (Marketing/Admin blasts)
  if (user.role == 'customer' || user.role == 'admin') {
    final global = ref.watch(globalNotificationsProvider).value ?? [];
    allNotifications.addAll(global);
  }

  // 2. Add module-specific notifications derived from latest orders
  if (user.role == 'customer') {
    final orders = ref.watch(customerOrdersProvider(user.id)).value ?? [];
    for (var order in orders.take(10)) {
       allNotifications.add({
         'id': 'cust_${order.id}',
         'title': 'Order Status: ${order.status.toUpperCase()}',
         'message': 'Your order #${order.id.length > 8 ? order.id.substring(0,8) : order.id} is currently ${order.status}.',
         'created_at': order.createdAt.toIso8601String(),
       });
    }
  } else if (user.role == 'vendor') {
    final shops = ref.watch(myOwnedShopsProvider(user.id)).value ?? [];
    for (final shop in shops) {
      final orders = ref.watch(vendorOrdersProvider(shop.id)).value ?? [];
      for (var order in orders.take(10)) {
         allNotifications.add({
           'id': 'vend_${order.id}',
           'title': order.status == 'pending' ? '🔔 New Order Received!' : 'Order ${order.status}',
           'message': 'Order #${order.id.length > 8 ? order.id.substring(0,8) : order.id} for Rs. ${order.totalAmount} is ${order.status}',
           'created_at': order.createdAt.toIso8601String(),
         });
      }
    }
  } else if (user.role == 'delivery') {
    final orders = ref.watch(deliveryOrdersProvider(user.id)).value ?? [];
    for (var order in orders.take(10)) {
       allNotifications.add({
         'id': 'del_${order.id}',
         'title': '📦 Delivery Assignment',
         'message': 'You are assigned to Order #${order.id.length > 8 ? order.id.substring(0,8) : order.id} (${order.status})',
         'created_at': order.createdAt.toIso8601String(),
       });
    }
  }

  // Sort all notifications by created_at descending
  allNotifications.sort((a, b) {
    final dateA = DateTime.tryParse(a['created_at']?.toString() ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
    final dateB = DateTime.tryParse(b['created_at']?.toString() ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
    return dateB.compareTo(dateA);
  });

  return allNotifications;
});
