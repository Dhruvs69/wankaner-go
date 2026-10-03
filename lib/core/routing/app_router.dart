import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/providers/auth_provider.dart';

// Updated imports matching your current VS Code folder structure
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/customer_home_screen.dart';
import '../../features/auth/screens/vendor_home_screen.dart';
import '../../features/auth/screens/delivery_home_screen.dart';
import '../../features/auth/screens/admin_home_screen.dart';
import '../../features/splash/screens/splash_screen.dart';

import 'package:flutter/foundation.dart';

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

// Create a notifier to trigger redirects without rebuilding GoRouter
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  bool _splashFinished = false;

  RouterNotifier(this._ref) {
    _ref.listen(authStateProvider, (_, __) => notifyListeners());
    _ref.listen(currentUserProvider, (_, __) => notifyListeners());
  }

  bool get splashFinished => _splashFinished;

  void finishSplash() {
    _splashFinished = true;
    notifyListeners();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: (context, state) {
      if (!notifier.splashFinished) {
        return state.matchedLocation == '/splash' ? null : '/splash';
      }

      final authState = ref.read(authStateProvider);
      final currentUser = ref.read(currentUserProvider);

      final isLoading = authState.isLoading || currentUser.isLoading;
      if (isLoading) return null;

      final isAuthenticated = authState.value != null;
      final user = currentUser.value;
      final isGoingToLogin = state.matchedLocation == '/login';
      final isSplash = state.matchedLocation == '/splash';

      if (!isAuthenticated || currentUser.hasError || user == null) {
        return isGoingToLogin ? null : '/login';
      }

      if (isAuthenticated && (isGoingToLogin || isSplash)) {
        // Redirect based on role
        switch (user.role) {
          case 'admin':
            return '/admin';
          case 'vendor':
            return '/vendor';
          case 'delivery':
            return '/delivery';
          case 'customer':
          default:
            return '/customer';
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/customer',
        builder: (context, state) => const CustomerHomeScreen(),
      ),
      GoRoute(
        path: '/vendor',
        builder: (context, state) => const VendorHomeScreen(),
      ),
      GoRoute(
        path: '/delivery',
        builder: (context, state) => const DeliveryHomeScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminHomeScreen(),
      ),
    ],
  );
});
