const fs = require('fs');

let text = fs.readFileSync('lib/features/auth/screens/delivery_home_screen.dart', 'utf-8');
const lines = text.split('\n');

lines[533] = "                                    ref.read(authStateProvider).value ?? ''));";
lines[718] = "                                deliveryOrdersProvider(ref.read(authStateProvider).value ?? ''));";

fs.writeFileSync('lib/features/auth/screens/delivery_home_screen.dart', lines.join('\n'), 'utf-8');
console.log('Fixed undefined myPartnerId safely!');
