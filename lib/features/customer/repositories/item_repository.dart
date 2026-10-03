// lib/features/customer/repositories/item_repository.dart
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/item_model.dart';
import '../../../core/api_service.dart';

final itemRepositoryProvider = Provider((ref) {
  return ItemRepository();
});

// A family provider takes the vendorId as an argument to fetch items specific to that shop
final vendorItemsProvider = StreamProvider.family<List<Item>, String>((ref, vendorId) {
  final repository = ref.watch(itemRepositoryProvider);
  return repository.getItemsForVendor(vendorId);
});

class ItemRepository {
  ItemRepository();

  Stream<List<Item>> getItemsForVendor(String vendorId) async* {
    while (true) {
      try {
        final response = await ApiService.get('/items/vendor/$vendorId');
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          yield data.map((doc) => Item.fromMap(doc, doc['id'])).toList();
        } else {
          yield [];
        }
      } catch (e) {
        yield [];
      }
      await Future.delayed(const Duration(seconds: 10));
    }
  }

  Future<void> addItem(String vendorId, Item item) async {
    try {
      final response = await ApiService.post('/items', {
        'vendor_id': vendorId,
        'name': item.name,
        'price': item.price,
        'category': '',
        'image_url': item.imageUrl,
        'is_vegetarian': true,
        'description': '',
        'variants': item.variants.map((v) => {'name': v.name, 'price': v.price}).toList(),
        'addons': item.addons.map((a) => {'name': a.name, 'price': a.price}).toList(),
      });
      if (response.statusCode != 201) {
        throw Exception('Failed to add item');
      }
    } catch (e) {
      throw Exception('Failed to add item: $e');
    }
  }

  Future<void> updateItemStock(String vendorId, String itemId, bool isAvailable) async {
    try {
      final response = await ApiService.put('/items/$itemId', {'isAvailable': isAvailable});
      if (response.statusCode != 200) {
        throw Exception('Failed to update stock');
      }
    } catch (e) {
      throw Exception('Failed to update stock: $e');
    }
  }

  Future<void> updateItem(String vendorId, String itemId, Map<String, dynamic> data) async {
    try {
      final response = await ApiService.put('/items/$itemId', data);
      if (response.statusCode != 200) {
        throw Exception('Failed to update item');
      }
    } catch (e) {
      throw Exception('Failed to update item: $e');
    }
  }

  Future<void> deleteItem(String vendorId, String itemId) async {
    try {
      final response = await ApiService.delete('/items/$itemId');
      if (response.statusCode != 200) {
        throw Exception('Failed to delete item');
      }
    } catch (e) {
      throw Exception('Failed to delete item: $e');
    }
  }
}