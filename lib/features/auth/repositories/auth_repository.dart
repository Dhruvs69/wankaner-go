import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/user_model.dart';
import '../../../models/address_model.dart';
import '../../../core/api_service.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());

class AuthRepository {
  AuthRepository();

  Future<UserModel?> getUserData(String uid) async {
    try {
      final response = await ApiService.get('/users/$uid');
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch user data: $e');
    }
  }

  Stream<UserModel?> getUserDataStream(String uid) async* {
    // Basic polling mechanism since we lost Firestore streams
    while (true) {
      yield await getUserData(uid);
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  Future<void> registerWithEmail(String name, String phone, String email, String password) async {
    try {
      final response = await ApiService.post('/auth/register', {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      });

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', data['token']);
        await prefs.setString('user_id', data['userId']);
      } else {
        throw Exception('Registration failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    try {
      final response = await ApiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', data['token']);
        await prefs.setString('user_id', data['userId']);
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('user_id');
  }

  Future<void> updateFcmToken(String uid, String token) async {
    try {
      await ApiService.post('/users/$uid/fcm-token', {'token': token});
    } catch (e) {
      debugPrint('Failed to update FCM token: $e');
    }
  }

  Future<void> addAddress(String uid, AddressModel address) async {
    try {
      final response = await ApiService.post('/users/$uid/addresses', address.toJson());
      if (response.statusCode != 201) {
        throw Exception('Failed to save address');
      }
    } catch (e) {
      throw Exception('Failed to save address: $e');
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      final response = await ApiService.delete('/addresses/$addressId');
      if (response.statusCode != 200) {
        throw Exception('Failed to delete address');
      }
    } catch (e) {
      throw Exception('Failed to delete address: $e');
    }
  }

  Stream<List<UserModel>> getUsersByRole(String role) async* {
    while (true) {
      try {
        final response = await ApiService.get('/users?role=$role&_t=\${DateTime.now().millisecondsSinceEpoch}');
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          yield data.map((e) => UserModel.fromJson(e)).toList();
        } else {
          yield [];
        }
      } catch (e) {
        yield [];
      }
      await Future.delayed(const Duration(seconds: 10));
    }
  }
}

final usersByRoleProvider = StreamProvider.family<List<UserModel>, String>((ref, role) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.getUsersByRole(role);
});