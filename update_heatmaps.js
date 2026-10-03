const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/admin_home_screen.dart', 'utf-8');

const regex = /Widget _buildHeatmaps\(\) \{[\s\S]*?120 orders\/hr'\),\s*\]\,\s*\)\,\s*\)\,\s*\)\,\s*\]\,\s*\)\,\s*\)\,\s*\)\,\s*\]\,\s*\)\,\s*\)\;/;

const newBlock = `Widget _buildHeatmaps() {
    final activeOrdersAsync = ref.watch(activeOrdersProvider);
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Demand Heatmaps & Analytics',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text(
              'Live view of active orders and demand zones.',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: activeOrdersAsync.when(
                data: (orders) {
                  // Filter out orders without lat/lng
                  final validOrders = orders.where((o) => o.deliveryLat != null && o.deliveryLng != null).toList();
                  
                  // Default to Wankaner center
                  LatLng center = const LatLng(22.6167, 70.9333);
                  if (validOrders.isNotEmpty) {
                    center = LatLng(validOrders.first.deliveryLat!, validOrders.first.deliveryLng!);
                  }

                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: center,
                            initialZoom: 14.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.speedtrack.wankanergo',
                            ),
                            CircleLayer(
                              circles: validOrders.map((order) {
                                // Dynamic color based on total amount
                                Color c = Colors.orange;
                                if (order.totalAmount > 500) c = Colors.red;
                                if (order.totalAmount < 200) c = Colors.blue;

                                return CircleMarker(
                                  point: LatLng(order.deliveryLat!, order.deliveryLng!),
                                  color: c.withValues(alpha: 0.5),
                                  borderStrokeWidth: 2,
                                  borderColor: c,
                                  useRadiusInMeter: true,
                                  radius: order.totalAmount > 500 ? 500 : 300, // larger radius for big orders
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 20,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 4)
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('🔥 Active Live Orders: \${validOrders.length}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)),
                              const SizedBox(height: 4),
                              Text('Total Orders in DB: \${orders.length}', style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              )
            ),
          ),
        ],
      ),
    );`;

if (regex.test(text)) {
    text = text.replace(regex, newBlock);
    fs.writeFileSync('lib/features/auth/screens/admin_home_screen.dart', text, 'utf-8');
    console.log('Fixed Heatmaps with Live Data!');
} else {
    console.log('Regex did not match!');
}
