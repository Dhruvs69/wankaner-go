const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/delivery_home_screen.dart', 'utf-8');

const regex = /'Order #\$\{order\.id\.length > 8 \? order\.id\.substring\(0, 8\)\.toUpperCase\(\) : order\.id\.toUpperCase\(\)\}'/g;
text = text.replace(regex, "'Order \${order.id}'");

fs.writeFileSync('lib/features/auth/screens/delivery_home_screen.dart', text, 'utf-8');
console.log('Fixed delivery UI');
