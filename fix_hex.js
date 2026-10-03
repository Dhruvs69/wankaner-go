const fs = require('fs');
const file = 'lib/features/auth/screens/admin_home_screen.dart';
let text = fs.readFileSync(file, 'utf8');

text = text.replace(/String toHex\(Color c\) \{[\s\S]*?return '#\$\{hex\.toUpperCase\(\)\}';\n\s*\}/g, "String toHex(Color c) { return '#${c.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}'; }");

fs.writeFileSync(file, text);
