// lib/features/customer/repositories/vendor_repository.dart
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vendor_model.dart';
import '../../../core/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final vendorRepositoryProvider = Provider((ref) {
  return VendorRepository();
});

class VendorRepository {
  VendorRepository();

  Stream<List<Vendor>> getNearbyVendors() async* {
    while (true) {
      try {
        final response = await ApiService.get('/vendors');
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          yield data.map((doc) => Vendor.fromMap(doc, doc['id'])).toList();
        } else {
          yield [];
        }
      } catch (e) {
        yield [];
      }
      await Future.delayed(const Duration(seconds: 10));
    }
  }

  Stream<List<Vendor>> getVendorsByOwner(String ownerId) async* {
    while (true) {
      try {
        final response = await ApiService.get('/vendors?owner_id=$ownerId');
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          yield data.map((doc) => Vendor.fromMap(doc, doc['id'])).toList();
        } else {
          yield [];
        }
      } catch (e) {
        yield [];
      }
      await Future.delayed(const Duration(seconds: 10));
    }
  }

    Future<void> submitReview(String vendorId, double rating, String comment, String orderId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customerId = prefs.getString('user_id') ?? 'unknown';
      
      final response = await ApiService.post('/vendors/$vendorId/reviews', {
        'rating': rating,
        'comment': comment,
        'order_id': orderId,
        'customer_id': customerId,
      });
      if (response.statusCode != 201) {
        throw Exception('Failed to submit review: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to submit review: $e');
    }
  }
}