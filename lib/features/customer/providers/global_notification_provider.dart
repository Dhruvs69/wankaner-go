import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:convert';
import '../../../core/api_service.dart';

final globalNotificationsProvider = StreamProvider<List<dynamic>>((ref) {
  return Stream.periodic(const Duration(seconds: 15)).asyncMap((_) async {
    try {
      final response = await ApiService.get('/notifications');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      // ignore
    }
    return [];
  });
});