// lib/features/customer/providers/cart_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item_model.dart';
import '../models/item_model.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier(ref);
});

final currentCartVendorIdProvider = StateProvider<String?>((ref) => null);
final currentCartVendorNameProvider = StateProvider<String?>((ref) => null);

// A provider to instantly calculate the total price of the cart
final cartTotalProvider = Provider<double>((ref) {
  final cartItems = ref.watch(cartProvider);
  return cartItems.fold(0, (total, current) => total + (current.unitPrice * current.quantity));
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  final Ref ref;
  CartNotifier(this.ref) : super([]);

  void addItem(Item item, {ItemVariant? variant, List<ItemAddon> addons = const []}) {
    // Check if item is already in the cart with the exact same options
    final existingIndex = state.indexWhere((c) {
      if (c.item.id != item.id) return false;
      if (c.selectedVariant?.name != variant?.name) return false;
      
      // Compare addons (simplified comparison by length and names)
      if (c.selectedAddons.length != addons.length) return false;
      final cAddonNames = c.selectedAddons.map((a) => a.name).toSet();
      final newAddonNames = addons.map((a) => a.name).toSet();
      if (!cAddonNames.containsAll(newAddonNames)) return false;

      return true;
    });
    
    if (existingIndex >= 0) {
      final updatedCart = [...state];
      updatedCart[existingIndex] = updatedCart[existingIndex].copyWith(
        quantity: updatedCart[existingIndex].quantity + 1,
      );
      state = updatedCart;
    } else {
      state = [...state, CartItem(item: item, selectedVariant: variant, selectedAddons: addons)];
    }
  }

  void removeItem(String itemId) {
    final newState = state.where((c) => c.item.id != itemId).toList();
    if (newState.isEmpty) {
      ref.read(currentCartVendorIdProvider.notifier).state = null;
      ref.read(currentCartVendorNameProvider.notifier).state = null;
    }
    state = newState;
  }

  void clearCart() {
    ref.read(currentCartVendorIdProvider.notifier).state = null;
    ref.read(currentCartVendorNameProvider.notifier).state = null;
    state = [];
  }
}