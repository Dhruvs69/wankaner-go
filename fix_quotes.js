const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/vendor_home_screen.dart', 'utf-8');

text = text.replace(
  "Text('${mapItem[\\'quantity\\']}x ${mapItem[\\'name\\']}'),",
  'Text("\\${mapItem[\'quantity\']}x \\${mapItem[\'name\']}"),'
);
text = text.replace(
  "Text('₹${mapItem[\\'price\\'] * mapItem[\\'quantity\\']}'),",
  'Text("₹\\${mapItem[\'price\'] * mapItem[\'quantity\']}"),'
);

fs.writeFileSync('lib/features/auth/screens/vendor_home_screen.dart', text, 'utf-8');
console.log('Fixed quotes!');
