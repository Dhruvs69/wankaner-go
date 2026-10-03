const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/vendor_home_screen.dart', 'utf-8');
text = text.replace("'/payouts/user/\${ownerId}'", "'/payouts/user/$ownerId'");
fs.writeFileSync('lib/features/auth/screens/vendor_home_screen.dart', text, 'utf-8');
console.log('Fixed braces!');
