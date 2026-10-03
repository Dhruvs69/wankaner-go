import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/notification_service.dart';
import '../../auth/providers/auth_provider.dart';
import '../repositories/order_repository.dart';
import '../models/order_model.dart';

import '../providers/vendor_provider.dart';
import '../providers/global_notification_provider.dart';

final orderNotificationProvider = Provider<void>((ref) {
  // Listen to global notifications
  ref.listen<AsyncValue<List<dynamic>>>(
    globalNotificationsProvider,
    (previous, next) async {
      final prevList = previous?.value ?? [];
      final nextList = next.value ?? [];
      
      if (prevList.isEmpty && nextList.isNotEmpty) {
        // If it's the very first load after app start, don't blast old notifications.
        return;
      }
      
      final prevIds = prevList.map((e) => e['id']).toSet();
      for (final notif in nextList) {
        if (!prevIds.contains(notif['id'])) {
           NotificationService().showNotification(
             id: notif['id'],
             title: notif['title'] ?? 'New Notification',
             body: notif['message'] ?? '',
           );
        }
      }
    },
  );

  final userAsyncValue = ref.watch(currentUserStreamProvider);
  final user = userAsyncValue.value;

  if (user == null) {
    return;
  }

  if (user.role == 'customer') {
    ref.listen<AsyncValue<List<OrderModel>>>(
      customerOrdersProvider(user.id),
      (previous, next) {
        _handleOrderUpdates(previous?.value, next.value, user.role);
      },
    );
  } else if (user.role == 'vendor') {
    final shopsAsyncValue = ref.watch(myOwnedShopsProvider(user.id));
    final shops = shopsAsyncValue.value ?? [];
    for (final shop in shops) {
      ref.listen<AsyncValue<List<OrderModel>>>(
        vendorOrdersProvider(shop.id),
        (previous, next) {
          _handleOrderUpdates(previous?.value, next.value, user.role);
        },
      );
    }
  } else if (user.role == 'delivery') {
    ref.listen<AsyncValue<List<OrderModel>>>(
      deliveryOrdersProvider(user.id),
      (previous, next) {
        _handleOrderUpdates(previous?.value, next.value, user.role);
      },
    );
  } else if (user.role == 'admin') {
    ref.listen<AsyncValue<List<OrderModel>>>(
      activeOrdersProvider,
      (previous, next) {
        _handleOrderUpdates(previous?.value, next.value, user.role);
      },
    );
  }
});

void _handleOrderUpdates(
    List<OrderModel>? previous, List<OrderModel>? next, String role) {
  if (previous == null || next == null) return;

  final previousMap = {for (var o in previous) o.id: o};

  for (final newOrder in next) {
    final oldOrder = previousMap[newOrder.id];

    if (oldOrder == null) {
      // New order appeared!
      if (role == 'vendor') {
        NotificationService().showNotification(
          id: newOrder.id.hashCode,
          title: 'New Order Received!',
          body: 'You have a new order for ₹${newOrder.totalAmount}',
        );
      } else if (role == 'admin') {
        NotificationService().showNotification(
          id: newOrder.id.hashCode,
          title: 'New Global Order!',
          body: 'Order #${newOrder.id.substring(0, 5)} placed.',
        );
      } else if (role == 'delivery') {
        NotificationService().showNotification(
          id: newOrder.id.hashCode,
          title: 'New Delivery Assigned!',
          body: 'You have been assigned to deliver order #${newOrder.id.substring(0, 5)}',
        );
      }
    } else if (oldOrder.status != newOrder.status) {
      // Status changed
      if (role == 'customer') {
        NotificationService().showNotification(
          id: newOrder.id.hashCode,
          title: 'Order Status Updated',
          body: 'Your order is now: ${newOrder.status.toUpperCase()}',
        );
      }
    }
  }
}
