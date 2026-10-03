import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/services/notification_service.dart';
import 'features/customer/providers/order_notification_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'core/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().initialize();
  
  // Sync FCM token on every app start so backend is never out of sync!
  try {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    if (userId != null) {
      final token = await NotificationService().getFCMToken();
      if (token != null) {
        await ApiService.post('/users/$userId/fcm-token', {'token': token});
      }
    }
  } catch (e) {
    debugPrint('Failed to sync FCM token on startup: $e');
  }

  runApp(const ProviderScope(child: WankanerGoApp()));
}

class WankanerGoApp extends ConsumerWidget {
  const WankanerGoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(orderNotificationProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'WankanerGo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
