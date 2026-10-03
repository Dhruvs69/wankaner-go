const fs = require('fs');
const file = 'lib/features/auth/screens/admin_home_screen.dart';
let text = fs.readFileSync(file, 'utf8');

const bad = `String toHex(Color c) { return '#\${c.toARGB32().toRadixString(16).padLeft(8, "0").toUpperCase()}'; }';
                      }`;
const good = `String toHex(Color c) { return '#\${c.toARGB32().toRadixString(16).padLeft(8, "0").toUpperCase()}'; }`;

text = text.replace(bad, good);

fs.writeFileSync(file, text);
