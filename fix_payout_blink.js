const fs = require('fs');

let text = fs.readFileSync('lib/features/auth/screens/vendor_home_screen.dart', 'utf-8');

// Add the provider at the top level
const providerCode = `
final vendorPayoutsProvider = FutureProvider.family<List<dynamic>, String>((ref, ownerId) async {
  final res = await ApiService.get('/payouts/user/$ownerId');
  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  }
  return [];
});
`;

if (!text.includes('vendorPayoutsProvider')) {
  text = text.replace(
    "class VendorHomeScreen extends ConsumerStatefulWidget", 
    providerCode + "\nclass VendorHomeScreen extends ConsumerStatefulWidget"
  );
}

const oldFutureBuilder = `            FutureBuilder<dynamic>(
              future: vendor.ownerId != null ? ApiService.get('/payouts/user/\${vendor.ownerId}').then((res) => jsonDecode(res.body)) : Future.value([]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error loading payouts: \${snapshot.error}');
                }
                final payouts = snapshot.data as List? ?? [];
                if (payouts.isEmpty) {
                  return const Text('No past payouts.');
                }
                return ListView.separated(`;

const newFutureBuilder = `            Consumer(builder: (context, ref, child) {
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
                  return ListView.separated(`;

text = text.replace(oldFutureBuilder, newFutureBuilder);
// Also need to close the Consumer properly
const oldEnd = `                    );
                  },
                );
              },
            ),`;
const newEnd = `                    );
                  },
                );
                },
              );
            }),`;
text = text.replace(oldEnd, newEnd);

fs.writeFileSync('lib/features/auth/screens/vendor_home_screen.dart', text, 'utf-8');
