import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../core/api_service.dart';

class PromoBannerModel {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final Color color1;
  final Color color2;

  PromoBannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color1,
    required this.color2,
  });

  factory PromoBannerModel.fromJson(Map<String, dynamic> json) {
    Color parseColor(String hex) {
      hex = hex.replaceAll('#', '');
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return Color(int.parse(hex, radix: 16));
    }

    return PromoBannerModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      emoji: json['emoji'] ?? '',
      color1: parseColor(json['color1'] ?? 'FFFF9A9E'),
      color2: parseColor(json['color2'] ?? 'FFFECFEF'),
    );
  }

  Map<String, dynamic> toJson() {
    String toHex(Color c) => '#${c.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'emoji': emoji,
      'color1': toHex(color1),
      'color2': toHex(color2),
    };
  }
}

final bannersProvider = StreamProvider<List<PromoBannerModel>>((ref) async* {
  while (true) {
    try {
      final response = await ApiService.get('/banners');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        yield data.map((e) => PromoBannerModel.fromJson(e)).toList();
      }
    } catch (e) {
      // ignore
    }
    await Future.delayed(const Duration(seconds: 10));
  }
});
