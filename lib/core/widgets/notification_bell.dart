import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../features/customer/providers/aggregated_notifications_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

final seenNotificationCountProvider = StateNotifierProvider<SeenCountNotifier, int>((ref) {
  return SeenCountNotifier();
});

class SeenCountNotifier extends StateNotifier<int> {
  SeenCountNotifier() : super(0) {
    _load();
  }
  void _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getInt('seen_notif_count') ?? 0;
  }
  void markSeen(int count) async {
    state = count;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('seen_notif_count', count);
  }
}

class NotificationBell extends ConsumerWidget {
  const NotificationBell({super.key});

  void _showNotificationsSheet(BuildContext context, List<dynamic> notifications) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.notifications, color: Colors.deepOrange),
                  const SizedBox(width: 8),
                  const Text('Notifications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              if (notifications.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: Text('No new notifications.', style: TextStyle(color: Colors.grey))),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notif = notifications[index];
                      final date = DateTime.tryParse(notif['created_at']?.toString() ?? '') ?? DateTime.now();
                      return Material(type: MaterialType.transparency, child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepOrange.withValues(alpha: 0.1),
                          child: const Icon(Icons.notifications_active, color: Colors.deepOrange, size: 20),
                        ),
                        title: Text(notif['title'] ?? 'Notice', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(notif['message'] ?? ''),
                            const SizedBox(height: 4),
                            Text(timeago.format(date), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ));
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(aggregatedNotificationsProvider);
    final seenCount = ref.watch(seenNotificationCountProvider);
    final unreadCount = (list.length - seenCount).clamp(0, 999);

    return CircleAvatar(
      backgroundColor: Colors.grey.shade100,
      child: IconButton(
        icon: Badge(
          isLabelVisible: unreadCount > 0,
          label: Text(unreadCount > 9 ? '9+' : unreadCount.toString()),
          child: const Icon(Icons.notifications, color: Colors.black87),
        ),
        onPressed: () {
          ref.read(seenNotificationCountProvider.notifier).markSeen(list.length);
          _showNotificationsSheet(context, list);
        },
      ),
    );
  }
}
