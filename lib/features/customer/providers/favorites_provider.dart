// lib/features/customer/providers/favorites_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({}) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favList = prefs.getStringList('favorite_vendors') ?? [];
    state = favList.toSet();
  }

  Future<void> toggleFavorite(String vendorId) async {
    final prefs = await SharedPreferences.getInstance();
    if (state.contains(vendorId)) {
      state = {...state}..remove(vendorId);
    } else {
      state = {...state}..add(vendorId);
    }
    await prefs.setStringList('favorite_vendors', state.toList());
  }
}
