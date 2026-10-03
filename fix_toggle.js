const fs = require('fs');

let text = fs.readFileSync('lib/features/auth/screens/delivery_home_screen.dart', 'utf-8');

const oldCode = `await ApiService.put('/users/delivery_partner_123/location', {
                  'lat': 22.6174,
                  'lng': 70.9366,
                  'is_online': val,
                });`;

const newCode = `if (myPartnerId.isNotEmpty) {
                  await ApiService.put('/users/$myPartnerId/location', {
                    'lat': 22.6174,
                    'lng': 70.9366,
                    'is_online': val ? 1 : 0,
                  });
                }`;

text = text.replace(oldCode, newCode);

fs.writeFileSync('lib/features/auth/screens/delivery_home_screen.dart', text, 'utf-8');
console.log('Fixed hardcoded ID in switch toggle!');
