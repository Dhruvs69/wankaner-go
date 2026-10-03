const fs = require('fs');

let text = fs.readFileSync('vendor_home_screen_restored.dart', 'utf-8');

text = text.replace('content = _buildEarnings(completedOrders);', 'content = _buildEarnings(completedOrders, selectedVendor);');

text = text.replace('Widget _buildEarnings(List orders) {', 'Widget _buildEarnings(List orders, Vendor vendor) {');

const recentOrdersStart = text.indexOf("Text('Recent Orders (");
const recentOrdersEnd = text.indexOf("Widget _buildTopSellingRow") - 4;

const newEnding = `const Text('Payout History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Consumer(builder: (context, ref, child) {
            final payoutsAsync = (vendor.ownerId != null && vendor.ownerId!.isNotEmpty)
                ? ref.watch(vendorPayoutsProvider(vendor.ownerId!))
                : const AsyncValue.data([]);
            return payoutsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error loading payouts: $err'),
              data: (payouts) {
                final list = payouts as List? ?? [];
                if (list.isEmpty) return const Text('No past payouts.');
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final p = list[index];
                    return Material(
                        type: MaterialType.transparency,
                        child: ListTile(
                          leading: const Icon(Icons.money, color: Colors.green),
                          title: Text('Payout #\${p['id']}'),
                          subtitle: Text('Status: \${p['status']} • Date: \${p['created_at']}'),
                          trailing: Text('₹\${p['amount']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ));
                  },
                );
              },
            );
          }),
          const SizedBox(height: 32),
          const Text('Completed Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          orders.isEmpty ? const Text('No completed orders yet.') :
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
                              Text("\${mapItem['quantity']}x \${mapItem['name']}"),
                              Text("₹\${mapItem['price'] * mapItem['quantity']}"),
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
          ),
        ],
      ),
    );
  }
`;

text = text.substring(0, recentOrdersStart) + newEnding + text.substring(recentOrdersEnd);

if (!text.includes('vendorPayoutsProvider')) {
    const providerCode = `
final vendorPayoutsProvider = FutureProvider.family<List<dynamic>, String>((ref, ownerId) async {
  final res = await ApiService.get('/payouts/user/$ownerId');
  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  }
  return [];
});
`;
    text = text.replace('class VendorHomeScreen', providerCode + '\nclass VendorHomeScreen');
}

if (!text.includes("import 'dart:convert';")) {
    text = "import 'dart:convert';\n" + text;
}

fs.writeFileSync('lib/features/auth/screens/vendor_home_screen.dart', text, 'utf-8');
console.log('Restored perfectly!');
