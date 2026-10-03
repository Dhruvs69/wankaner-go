const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/vendor_home_screen.dart', 'utf-8');

const regex = /order\.customerName\.isNotEmpty\s*\?\s*'\$\{order\.customerName\} \(\$\{order\.customerId\}\)'\s*:\s*'Customer \(\$\{order\.customerId\}\)',/;
const newText = `order.customerName.isNotEmpty
                                  ? order.customerName
                                  : 'Guest Customer',`;

text = text.replace(regex, newText);
fs.writeFileSync('lib/features/auth/screens/vendor_home_screen.dart', text, 'utf-8');
console.log('Fixed customer name display');
