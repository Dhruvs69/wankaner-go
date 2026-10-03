const fs = require('fs');

let text = fs.readFileSync('lib/features/auth/screens/delivery_home_screen.dart', 'utf-8');

text = text.replace(/'delivery_partner_123'/g, 'myPartnerId');

fs.writeFileSync('lib/features/auth/screens/delivery_home_screen.dart', text, 'utf-8');
console.log('Fixed all remaining hardcoded IDs!');
