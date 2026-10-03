const fs = require('fs');
const file = 'lib/features/customer/screens/vendor_details_screen.dart';
let text = fs.readFileSync(file, 'utf8');

text = text.replace(/item.categoryId == 'non-veg'/g, "item.name.toLowerCase().contains('chicken') || item.name.toLowerCase().contains('mutton') || item.name.toLowerCase().contains('egg') || item.name.toLowerCase().contains('fish')");
text = text.replace(/withOpacity\(/g, "withValues(alpha: ");

fs.writeFileSync(file, text);
