import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/vendor_provider.dart';

// Notice we changed StatelessWidget to ConsumerWidget so it can listen to Riverpod!
class CustomerDashboardScreen extends ConsumerWidget {
  const CustomerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This single line connects your UI to the live Firebase database
    final vendorsAsync = ref.watch(nearbyVendorsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wankaner Go'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Navigate to profile
            },
          ),
        ],
      ),
      body: vendorsAsync.when(
        // 1. WHAT TO SHOW WHEN DATA IS READY
        data: (vendors) {
          if (vendors.isEmpty) {
            return const Center(
              child: Text('No shops found nearby right now.'),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: vendors.length,
            itemBuilder: (context, index) {
              final vendor = vendors[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                child: Material(type: MaterialType.transparency, child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    vendor.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${vendor.category} • ${vendor.distance}'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.green, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          vendor.rating.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )),
              );
            },
          );
        },
        // 2. WHAT TO SHOW WHILE WAITING FOR INTERNET
        loading: () => const Center(child: CircularProgressIndicator()),
        
        // 3. WHAT TO SHOW IF THERE IS AN ERROR
        error: (error, stackTrace) => Center(
          child: Text('Something went wrong: $error'),
        ),
      ),
    );
  }
}