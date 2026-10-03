const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/customer_home_screen.dart', 'utf-8');
const lines = text.split('\n');

const newTitleBlock = `        title: GestureDetector(
          onTap: () {
            _showAddressSelector(ref);
          },
          child: Row(
            children: [
              const Icon(Icons.location_on, color: Colors.deepOrange, size: 28),
              const SizedBox(width: 8),
              Expanded(
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
                                Expanded(
                                  child: Text(address.label.isNotEmpty ? address.label : 'Current Location', 
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                  ),
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
              ),
            ],
          ),
        ),`;

// Replace lines 262 to 326
lines.splice(262, 65, newTitleBlock);

fs.writeFileSync('lib/features/auth/screens/customer_home_screen.dart', lines.join('\n'), 'utf-8');
console.log('Fixed AppBar successfully!');
