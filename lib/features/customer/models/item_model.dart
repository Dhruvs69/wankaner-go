// lib/features/customer/models/item_model.dart

class ItemVariant {
  final String name;
  final double price; // The base price for this variant

  ItemVariant({required this.name, required this.price});

  factory ItemVariant.fromMap(Map<String, dynamic> map) {
    return ItemVariant(
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
    );
  }
}

class ItemAddon {
  final String name;
  final double price; // Additional cost for this addon

  ItemAddon({required this.name, required this.price});

  factory ItemAddon.fromMap(Map<String, dynamic> map) {
    return ItemAddon(
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
    );
  }
}

class Item {
  final String id;
  final String name;
  final double price; // Base price if no variants
  final String imageUrl;
  final bool isAvailable;
  final List<ItemVariant> variants;
  final List<ItemAddon> addons;

  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.isAvailable,
    this.variants = const [],
    this.addons = const [],
  });

  factory Item.fromMap(Map<String, dynamic> map, String documentId) {
    return Item(
      id: map['id'] ?? documentId,
      name: map['name'] ?? 'Product',
      price: (map['price'] ?? 0.0).toDouble(),
      imageUrl: map['image_url'] ?? map['imageUrl'] ?? '',
      isAvailable: map['is_available'] == 1 || map['is_available'] == true || map['isAvailable'] == true,
      variants: map['variants'] != null
          ? (map['variants'] as List).map((v) => ItemVariant.fromMap(v)).toList()
          : [],
      addons: map['addons'] != null
          ? (map['addons'] as List).map((a) => ItemAddon.fromMap(a)).toList()
          : [],
    );
  }
}