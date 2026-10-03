const fs = require('fs');

let text = fs.readFileSync('lib/features/auth/screens/delivery_home_screen.dart', 'utf-8');

text = text.replace(
  'ref.invalidate(deliveryOrdersProvider(\n                                    myPartnerId));',
  "ref.invalidate(deliveryOrdersProvider(ref.read(authStateProvider).value ?? ''));"
);

text = text.replace(
  'ref.invalidate(\n                                deliveryOrdersProvider(myPartnerId));',
  "ref.invalidate(deliveryOrdersProvider(ref.read(authStateProvider).value ?? ''));"
);

fs.writeFileSync('lib/features/auth/screens/delivery_home_screen.dart', text, 'utf-8');
console.log('Fixed undefined myPartnerId!');
