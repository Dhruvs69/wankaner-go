const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/vendor_home_screen.dart', 'utf-8');
const lines = text.split('\n');

// Find the FutureBuilder index
let startIndex = -1;
let endIndex = -1;
for (let i = 0; i < lines.length; i++) {
    if (lines[i].includes('FutureBuilder<dynamic>(')) {
        startIndex = i;
    }
    if (startIndex !== -1 && i > startIndex && lines[i].includes('          ),') && lines[i+1].includes('        ],')) {
        endIndex = i;
        break;
    }
}

if (startIndex !== -1 && endIndex !== -1) {
    const providerStr = `final vendorPayoutsProvider = FutureProvider.family<List<dynamic>, String>((ref, ownerId) async {
  final res = await ApiService.get('/payouts/user/$ownerId');
  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  }
  return [];
});\n\n`;

    // Only add if not exists
    if (!text.includes('vendorPayoutsProvider')) {
        text = text.replace("class VendorHomeScreen extends ConsumerStatefulWidget", providerStr + "class VendorHomeScreen extends ConsumerStatefulWidget");
    }
    
    // Now replace the lines again
    const newLines = text.split('\n');
    let s = -1;
    let e = -1;
    for (let i = 0; i < newLines.length; i++) {
        if (newLines[i].includes('FutureBuilder<dynamic>(')) s = i;
        if (s !== -1 && i > s && newLines[i].includes('          ),') && newLines[i+1].includes('        ],')) {
            e = i;
            break;
        }
    }

    const replacement = `          Consumer(builder: (context, ref, child) {
            final payoutsAsync = vendor.ownerId.isNotEmpty
                ? ref.watch(vendorPayoutsProvider(vendor.ownerId))
                : const AsyncValue.data([]);
            return payoutsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error loading payouts: $err'),
              data: (payouts) {
                final list = payouts as List? ?? [];
                if (list.isEmpty) {
                  return const Text('No past payouts.');
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final p = list[index];
                    return Material(type: MaterialType.transparency, child: ListTile(
                      leading: const Icon(Icons.money, color: Colors.green),
                      title: Text('Payout #\${p['id']}'),
                      subtitle: Text('Status: \${p['status']} • Date: \${p['created_at']}'),
                      trailing: Text('₹\${p['amount']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ));
                  },
                );
              },
            );
          }),`;
          
    newLines.splice(s, e - s + 1, replacement);
    fs.writeFileSync('lib/features/auth/screens/vendor_home_screen.dart', newLines.join('\n'), 'utf-8');
}
