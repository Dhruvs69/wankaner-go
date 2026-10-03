const fs = require('fs');
let text = fs.readFileSync('lib/features/customer/screens/checkout_screen.dart', 'utf-8');

text = text.replace(
    'border: BorderSide(color: Colors.grey.shade200)',
    'border: Border.all(color: Colors.grey.shade200)'
);

fs.writeFileSync('lib/features/customer/screens/checkout_screen.dart', text, 'utf-8');
console.log('Fixed BorderSide error');
