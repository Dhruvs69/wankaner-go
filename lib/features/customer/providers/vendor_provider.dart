// lib/features/customer/providers/vendor_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vendor_model.dart';
import '../repositories/vendor_repository.dart';

final nearbyVendorsProvider = StreamProvider<List<Vendor>>((ref) {
  final repository = ref.watch(vendorRepositoryProvider);
  return repository.getNearbyVendors();
});

final activeNearbyVendorsProvider = Provider<AsyncValue<List<Vendor>>>((ref) {
  final vendorsAsync = ref.watch(nearbyVendorsProvider);
  return vendorsAsync.whenData((vendors) => vendors.where((v) => v.isActive).toList());
});

final myOwnedShopsProvider = StreamProvider.family<List<Vendor>, String>((ref, ownerId) {
  final repository = ref.watch(vendorRepositoryProvider);
  return repository.getVendorsByOwner(ownerId);
});