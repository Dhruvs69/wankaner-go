// lib/features/customer/models/cart_item_model.dart
import 'item_model.dart';

class CartItem {
  final Item item;
  final int quantity;
  final ItemVariant? selectedVariant;
  final List<ItemAddon> selectedAddons;

  CartItem({
    required this.item,
    this.quantity = 1,
    this.selectedVariant,
    this.selectedAddons = const [],
  });

  CartItem copyWith({
    Item? item, 
    int? quantity, 
    ItemVariant? selectedVariant, 
    List<ItemAddon>? selectedAddons
  }) {
    return CartItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      selectedVariant: selectedVariant ?? this.selectedVariant,
      selectedAddons: selectedAddons ?? this.selectedAddons,
    );
  }

  // Calculate total price for a single unit including variant and addons
  double get unitPrice {
    double base = selectedVariant != null ? selectedVariant!.price : item.price;
    double addonsTotal = selectedAddons.fold(0, (sum, addon) => sum + addon.price);
    return base + addonsTotal;
  }
}