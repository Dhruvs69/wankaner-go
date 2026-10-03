const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/delivery_home_screen.dart', 'utf-8');
text = text.replace(
  "await ApiService.put('/users/delivery_partner_123/location'", 
  "final myPartnerId = ref.read(authStateProvider).value ?? '';\n        if (myPartnerId.isEmpty) return;\n        await ApiService.put('/users/$myPartnerId/location'"
);
fs.writeFileSync('lib/features/auth/screens/delivery_home_screen.dart', text, 'utf-8');
console.log('Fixed hardcoded delivery partner ID!');
