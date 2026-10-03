const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/vendor_home_screen.dart', 'utf-8');

text = text.replace("import 'package:url_launcher/url_launcher.dart';\n", "");
text = text.replace("import 'package:wankaner_go/features/customer/models/order_model.dart';\n", "");

fs.writeFileSync('lib/features/auth/screens/vendor_home_screen.dart', text, 'utf-8');
console.log('Removed unused imports!');
