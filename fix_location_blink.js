const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/customer_home_screen.dart', 'utf-8');

const originalLocationBlock = `              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text('Home',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                        Icon(Icons.keyboard_arrow_down,
                            size: 20, color: Colors.deepOrange),
                      ],
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final addressesAsync =
                            ref.watch(customerAddressesProvider);
                        return addressesAsync.when(
                          data: (addresses) {
                            if (addresses.isEmpty) {
                              return const Text('Add an address',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500));
                            }
                            final address =
                                addresses.first; // Just show first for now
                            return Text(address.address,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis);
                          },
                          loading: () => const Text('Loading...',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500)),
                          error: (_, __) => const Text('Error loading address',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500)),
                        );
                      },
                    ),
                  ],
                ),
              ),`;

const newLocationBlock = `              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final userStream = ref.watch(currentUserStreamProvider);
                    
                    return userStream.when(
                      data: (user) {
                        if (user == null || user.savedAddresses == null || user.savedAddresses!.isEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Text('Select Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                                  Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.deepOrange),
                                ],
                              ),
                              const Text('Add an address to deliver', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                            ],
                          );
                        }

                        // Try to find the default address, otherwise use the first one
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
              ),`;

if (text.includes(originalLocationBlock)) {
    text = text.replace(originalLocationBlock, newLocationBlock);
    fs.writeFileSync('lib/features/auth/screens/customer_home_screen.dart', text, 'utf-8');
    console.log('Fixed location display with StreamProvider');
} else {
    console.log('Original block not found. Could not replace.');
}
