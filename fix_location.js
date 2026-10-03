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
                    final addressesAsync = ref.watch(customerAddressesProvider);
                    
                    String title = 'Live Location';
                    String subtitle = 'Detecting location...';
                    
                    addressesAsync.whenData((addresses) {
                       if (addresses.isEmpty) {
                          title = 'Select Location';
                          subtitle = 'Add an address';
                       } else {
                          title = addresses.first.title.isNotEmpty ? addresses.first.title : 'Current Location';
                          subtitle = addresses.first.address;
                       }
                    });

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(title,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                            const Icon(Icons.keyboard_arrow_down,
                                size: 20, color: Colors.deepOrange),
                          ],
                        ),
                        Text(subtitle,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    );
                  },
                ),
              ),`;

text = text.replace(originalLocationBlock, newLocationBlock);
fs.writeFileSync('lib/features/auth/screens/customer_home_screen.dart', text, 'utf-8');
console.log('Fixed location display');
