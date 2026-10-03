const fs = require('fs');

let text = fs.readFileSync('lib/features/auth/screens/delivery_home_screen.dart', 'utf-8');

text = text.replace(
  'final deliveryOrdersAsync = ref.watch(deliveryOrdersProvider(myPartnerId));',
  'final deliveryOrdersAsync = ref.watch(deliveryOrdersProvider(myPartnerId));\n    final currentUserAsync = ref.watch(currentUserProvider);'
);

const oldText = `const Text('Hi, Partner',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16))`;

const newText = `currentUserAsync.when(
                  data: (user) => Text('Hi, \${user?.name ?? 'Partner'}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  loading: () => const Text('Hi, Partner',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  error: (_, __) => const Text('Hi, Partner',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                )`;

text = text.replace(oldText, newText);

fs.writeFileSync('lib/features/auth/screens/delivery_home_screen.dart', text, 'utf-8');
console.log('Fixed delivery greeting!');
