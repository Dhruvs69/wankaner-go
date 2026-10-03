const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/vendor_home_screen.dart', 'utf-8');

text = text.replace(
  '              Widget content;\n              switch (_currentIndex) {',
  '              final selectedVendor = shops.firstWhere((s) => s.id == _selectedShopId, orElse: () => shops.first);\n              Widget content;\n              switch (_currentIndex) {'
);

fs.writeFileSync('lib/features/auth/screens/vendor_home_screen.dart', text, 'utf-8');
console.log('Fixed selectedVendor!');
