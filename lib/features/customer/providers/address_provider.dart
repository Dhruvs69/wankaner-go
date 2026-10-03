// lib/features/customer/providers/address_provider.dart
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api_service.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/address_model.dart';

final customerAddressesProvider = FutureProvider<List<Address>>((ref) async {
  final userAsync = ref.watch(currentUserStreamProvider);
  
  return userAsync.when(
    data: (user) async {
      if (user == null) return [];
      try {
        final response = await ApiService.get('/addresses/user/${user.id}');
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          return data.map((map) => Address.fromMap(map, map['id'].toString())).toList();
        } else {
          throw Exception('Failed to load addresses');
        }
      } catch (e) {
        throw Exception('Error fetching addresses: $e');
      }
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

final currentDeliveryAddressProvider = StateProvider<Address?>((ref) => null);
