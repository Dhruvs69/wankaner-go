const fs = require('fs');
let text = fs.readFileSync('lib/features/customer/repositories/vendor_repository.dart', 'utf-8');

if (!text.includes('shared_preferences')) {
    text = text.replace("import '../../../core/api_service.dart';", "import '../../../core/api_service.dart';\nimport 'package:shared_preferences/shared_preferences.dart';");
    fs.writeFileSync('lib/features/customer/repositories/vendor_repository.dart', text, 'utf-8');
    console.log('Imported SharedPreferences');
}
