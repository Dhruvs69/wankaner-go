const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/customer_home_screen.dart', 'utf-8');

const regex = /Expanded\(\s*child:\s*Column\(\s*crossAxisAlignment:\s*CrossAxisAlignment\.start,[\s\S]*?Icon\(Icons\.keyboard_arrow_down,[\s\S]*?ref\.watch\(customerAddressesProvider\);[\s\S]*?\}\),\s*\]\,\s*\)\,\s*\)/;

const newBlock = `Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final userStream = ref.watch(currentUserStreamProvider);
                    
                    return userStream.when(
                      data: (user) {
                        if (user == null || user.savedAddresses == null || user.savedAddresses!.isEmpty) {
                          return const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('Select Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                                  Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.deepOrange),
                                ],
                              ),
                              Text('Add an address to deliver', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                            ],
                          );
                        }

                        final address = user.savedAddresses!.firstWhere(
                          (a) => a.isDefault, 
                          orElse: () => user.savedAddresses!.first
                        );

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(address.label.isNotEmpty ? address.label : 'Current Location', 
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                                const Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.deepOrange),
                              ],
                            ),
                            Text('\${address.fullAddress}, \${address.city}', 
                              style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        );
                      },
                      loading: () => const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text('Locating...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                           Text('Fetching your location...', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      error: (err, stack) => const Text('Location Error'),
                    );
                  },
                ),
              )`;

if (regex.test(text)) {
    text = text.replace(regex, newBlock);
    fs.writeFileSync('lib/features/auth/screens/customer_home_screen.dart', text, 'utf-8');
    console.log('Fixed location blinking successfully via regex!');
} else {
    console.log('Regex did not match!');
}
