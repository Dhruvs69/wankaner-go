const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/vendor_home_screen.dart', 'utf-8');

// Replace the Order Header text
const headerRegex = /Text\(\s*'Order #\$\{order\.id\.length > 8 \? order\.id\.substring\(0, 8\) : order\.id\}',\s*style: const TextStyle\(\s*fontWeight: FontWeight\.bold,\s*fontSize: 16\)\),/;

const newHeader = `Text(
                            order.customerName.isNotEmpty ? order.customerName : 'Guest Customer',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 4),
                        Text(
                            'Order ID: \${order.id}',
                            style: const TextStyle(
                                color: Colors.deepOrange, fontWeight: FontWeight.w600, fontSize: 14)),`;

text = text.replace(headerRegex, newHeader);

// Replace any remaining truncated order ids (like bottom sheets)
const truncatedOrderRegex = /'Order #\$\{order\.id\.length > 8 \? order\.id\.substring\(0, 8\) : order\.id\}'/g;
text = text.replace(truncatedOrderRegex, "'Order: \${order.id}'");

fs.writeFileSync('lib/features/auth/screens/vendor_home_screen.dart', text, 'utf-8');
console.log('Fixed Order IDs in Vendor UI');
