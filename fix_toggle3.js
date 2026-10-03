const fs = require('fs');

let text = fs.readFileSync('lib/features/auth/screens/delivery_home_screen.dart', 'utf-8');
const lines = text.split('\n');

for (let i = 0; i < lines.length; i++) {
  if (lines[i].includes("await ApiService.put('/users/delivery_partner_123/location', {")) {
    lines[i] = "                if (myPartnerId.isNotEmpty) { await ApiService.put('/users/$myPartnerId/location', {";
    lines[i+3] = "                  'is_online': val ? 1 : 0,";
    lines[i+4] = "                }); }";
    console.log('Fixed at line ' + i);
    break;
  }
}

fs.writeFileSync('lib/features/auth/screens/delivery_home_screen.dart', lines.join('\n'), 'utf-8');
