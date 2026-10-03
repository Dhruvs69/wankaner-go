const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/vendor_home_screen.dart', 'utf-8');

// The corrupted lines look like:
// Text('x '),
// Text('₹'),

text = text.replace("Text('x '),", "Text('\\${mapItem[\\'quantity\\']}x \\${mapItem[\\'name\\']}'),");
text = text.replace("Text('₹'),", "Text('₹\\${mapItem[\\'price\\'] * mapItem[\\'quantity\\']}'),");

fs.writeFileSync('lib/features/auth/screens/vendor_home_screen.dart', text, 'utf-8');
console.log('Fixed powershell interpolation corruption!');
