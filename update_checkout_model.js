const fs = require('fs');
let text = fs.readFileSync('lib/features/customer/screens/checkout_screen.dart', 'utf-8');

text = text.replace(
  "customerPhone: _phoneController.text.trim(),\n        deliveryAddress: '\\\${_selectedAddress!.fullAddress}, \\\${_selectedAddress!.city} - \\\${_selectedAddress!.pincode}',",
  "customerPhone: _phoneController.text.trim(),\n        deliveryAddress: '\\\${_selectedAddress!.fullAddress}, \\\${_selectedAddress!.city} - \\\${_selectedAddress!.pincode}',\n        deliveryLat: _selectedAddress!.lat,\n        deliveryLng: _selectedAddress!.lng,"
);

fs.writeFileSync('lib/features/customer/screens/checkout_screen.dart', text, 'utf-8');
console.log('CheckoutScreen updated');
