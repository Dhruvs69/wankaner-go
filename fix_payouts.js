const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/vendor_home_screen.dart', 'utf-8');

if (!text.includes("dart:convert")) {
    text = text.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'dart:convert';");
}

text = text.replace("ApiService.get(`/payouts/user/${vendor.ownerId}`)", "ApiService.get(`/payouts/user/${vendor.ownerId}`).then((res) => jsonDecode(res.body))");
// Note: Dart interpolation uses ${vendor.ownerId}. Let's just do a string replacement exactly.
text = text.replace("ApiService.get('/payouts/user/${vendor.ownerId}')", "ApiService.get('/payouts/user/${vendor.ownerId}').then((res) => jsonDecode(res.body))");

fs.writeFileSync('lib/features/auth/screens/vendor_home_screen.dart', text, 'utf-8');
