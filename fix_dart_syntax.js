const fs = require('fs');
const file = 'lib/features/auth/screens/admin_home_screen.dart';
let text = fs.readFileSync(file, 'utf8');

text = text.replace('hex.upper()', 'hex.toUpperCase()');
text = text.replace('titleCtrl.text.replace(', 'titleCtrl.text.replaceAll(');
text = text.replace('/banners/${banner.id}', '/banners/\\${banner.id}');

fs.writeFileSync(file, text);
