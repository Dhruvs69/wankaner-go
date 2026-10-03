const fs = require('fs');

try { fs.unlinkSync('lib/features/auth/screens/top.dart'); } catch(e) {}

let text = fs.readFileSync('lib/features/auth/screens/vendor_home_screen.dart', 'utf-8');

const imports = `import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wankaner_go/core/api_service.dart';
import 'package:wankaner_go/features/auth/providers/auth_provider.dart';
import 'package:wankaner_go/features/customer/models/order_model.dart';
import 'package:wankaner_go/features/customer/models/vendor_model.dart';
import 'package:wankaner_go/features/customer/models/item_model.dart';
import 'package:wankaner_go/features/customer/providers/vendor_provider.dart';
import 'package:wankaner_go/features/customer/repositories/order_repository.dart';
import 'package:wankaner_go/features/customer/repositories/item_repository.dart';

final vendorPayoutsProvider = FutureProvider.family<List<dynamic>, String>((ref, ownerId) async {
  final res = await ApiService.get('/payouts/user/$ownerId');
  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  }
  return [];
});
`;

text = text.replace(/import.*?;\n/gs, ''); // clear old imports
text = text.replace(/final vendorPayoutsProvider.*?\n\}\);\n/gs, '');

text = imports + "\n" + text;
fs.writeFileSync('lib/features/auth/screens/vendor_home_screen.dart', text, 'utf-8');
console.log('Fixed imports and providers!');
