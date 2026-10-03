import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:wankaner_go/core/api_service.dart';

class AppSettings {
  final String baseDeliveryFee;
  final String platformCommission;
  final String minimumOrderValue;
  final bool maintenanceMode;
  final bool autoAssignPartners;
  final bool surgePricing;

  AppSettings({
    required this.baseDeliveryFee,
    required this.platformCommission,
    required this.minimumOrderValue,
    required this.maintenanceMode,
    required this.autoAssignPartners,
    required this.surgePricing,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      baseDeliveryFee: json['baseDeliveryFee']?.toString() ?? '20',
      platformCommission: json['platformCommission']?.toString() ?? '10',
      minimumOrderValue: json['minimumOrderValue']?.toString() ?? '99',
      maintenanceMode: json['maintenanceMode'] ?? false,
      autoAssignPartners: json['autoAssignPartners'] ?? true,
      surgePricing: json['surgePricing'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'baseDeliveryFee': baseDeliveryFee,
      'platformCommission': platformCommission,
      'minimumOrderValue': minimumOrderValue,
      'maintenanceMode': maintenanceMode,
      'autoAssignPartners': autoAssignPartners,
      'surgePricing': surgePricing,
    };
  }
}

final settingsProvider = FutureProvider<AppSettings>((ref) async {
  final response = await ApiService.get('/settings');
  if (response.statusCode == 200) {
    return AppSettings.fromJson(jsonDecode(response.body));
  }
  throw Exception('Failed to load settings');
});
