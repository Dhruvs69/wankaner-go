const fs = require('fs');

let text = fs.readFileSync('lib/features/auth/screens/vendor_home_screen.dart', 'utf-8');

// First, inject the Completed Orders UI below Payout History
const insertLocation = `          }),
        ],
      ),
    );
  }}`;

const completedOrdersUI = `          }),
          const SizedBox(height: 32),
          const Text('Completed Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          if (orders.isEmpty)
            const Text('No completed orders yet.')
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Order #\${order.id.length > 8 ? order.id.substring(0, 8) : order.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const Chip(label: Text('Delivered', style: TextStyle(color: Colors.green)), backgroundColor: Colors.white, side: BorderSide(color: Colors.green)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('\${order.customerName} (\${order.customerPhone})'),
                        const Divider(),
                        ...order.items.map<Widget>((item) {
                          final mapItem = item as dynamic;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('\${mapItem['quantity']}x \${mapItem['name']}'),
                                Text('₹\${mapItem['price'] * mapItem['quantity']}'),
                              ],
                            ),
                          );
                        }).toList(),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('₹\${order.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                          ],
                        )
                      ],
                    ),
                  )
                );
              }
            )
        ],
      ),
    );
  }}`;

text = text.replace(insertLocation, completedOrdersUI);

fs.writeFileSync('lib/features/auth/screens/vendor_home_screen.dart', text, 'utf-8');
