const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/delivery_home_screen.dart', 'utf-8');
text = text.replace("import 'package:flutter_riverpod/flutter_riverpod.dart';", "import 'package:flutter_riverpod/flutter_riverpod.dart';\nimport '../providers/auth_provider.dart';");
fs.writeFileSync('lib/features/auth/screens/delivery_home_screen.dart', text, 'utf-8');
