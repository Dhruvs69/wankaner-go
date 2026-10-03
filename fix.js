const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/customer_home_screen.dart', 'utf8');
text = text.replace(/\\'New\\'/g, "'New'");
fs.writeFileSync('lib/features/auth/screens/customer_home_screen.dart', text);
