import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:3000/api';
    // Use the machine's local network IP so physical Android devices on Wi-Fi can connect.
    // If you are using an Android Emulator, 10.0.2.2 works, but the local IP covers both.
    return 'http://10.205.76.116:3000/api';
  }

  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return {
      'Content-Type': 'application/json',
      'Cache-Control': 'no-cache, no-store, must-revalidate',
      'Pragma': 'no-cache',
      'Expires': '0',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();
    return http.get(Uri.parse('$baseUrl$endpoint'), headers: headers).timeout(const Duration(seconds: 5));
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    return http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 5));
  }

  static Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    return http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 5));
  }

  static Future<http.Response> delete(String endpoint) async {
    final headers = await _getHeaders();
    return http.delete(Uri.parse('$baseUrl$endpoint'), headers: headers).timeout(const Duration(seconds: 5));
  }

  static Future<String?> uploadImage(List<int> bytes, String filename) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload'));
      final headers = await _getHeaders();
      request.headers.addAll(headers);
      
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        bytes,
        filename: filename,
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['imageUrl'];
      }
      return null;
    } catch (e) {
      debugPrint('Upload error: $e');
      return null;
    }
  }
}
