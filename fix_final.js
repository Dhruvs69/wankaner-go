const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/vendor_home_screen.dart', 'utf-8');

// Use regex to remove backslash before dollar signs ONLY inside the mapped widgets
text = text.replace(/Text\("\\\$\{mapItem\['quantity']/g, "Text(\"\\${mapItem['quantity']}");
text = text.replace(/\}x \\\$\{mapItem\['name']/g, "}x \\${mapItem['name']}");
text = text.replace(/Text\("₹\\\$\{mapItem\['price']/g, "Text(\"₹\\${mapItem['price']}");

fs.writeFileSync('lib/features/auth/screens/vendor_home_screen.dart', text, 'utf-8');
console.log('Fixed for real');
