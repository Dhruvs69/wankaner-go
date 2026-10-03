const fs = require('fs');

let text = fs.readFileSync('lib/features/auth/screens/admin_home_screen.dart', 'utf-8');

const oldDashboard = `  Widget _buildDashboardOverview() {
    final activeOrdersAsync = ref.watch(activeOrdersProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dashboard Overview',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          activeOrdersAsync.when(
            data: (orders) {
              double totalRevenue = 0;
              for (var order in orders) {
                totalRevenue += order.totalAmount;
              }

              int crossAxisCount = 1;
              if (MediaQuery.of(context).size.width > 1200) {
                crossAxisCount = 4;
              } else if (MediaQuery.of(context).size.width > 800) {
                crossAxisCount = 2;
              } else if (MediaQuery.of(context).size.width > 600) {
                crossAxisCount = 2;
              }

              int pendingCount = orders.where((o) => o.status == 'pending').length;
              int outForDeliveryCount = orders.where((o) => o.status == 'out for delivery').length;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio:
                        MediaQuery.of(context).size.width < 600 ? 3 : 2.5,
                    children: [
                      _StatCard(
                          title: 'Active Orders',
                          value: orders.length.toString(),
                          icon: Icons.shopping_bag,
                          color: Colors.blue),
                      _StatCard(
                          title: 'Pending Orders',
                          value: pendingCount.toString(),
                          icon: Icons.pending_actions,
                          color: Colors.orange),
                      _StatCard(
                          title: 'Out for Delivery',
                          value: outForDeliveryCount.toString(),
                          icon: Icons.delivery_dining,
                          color: Colors.purple),
                      _StatCard(
                          title: 'Live Revenue',
                          value: '₹\${totalRevenue.toStringAsFixed(2)}',
                          icon: Icons.currency_rupee,
                          color: Colors.green),
                    ],
                  ),`;

const newDashboard = `  Widget _buildDashboardOverview() {
    final activeOrdersAsync = ref.watch(activeOrdersProvider);
    final deliveryPartnersAsync = ref.watch(usersByRoleProvider('delivery'));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dashboard Overview',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          activeOrdersAsync.when(
            data: (orders) {
              return deliveryPartnersAsync.when(
                data: (partners) {
                  double totalRevenue = 0;
                  for (var order in orders) {
                    totalRevenue += order.totalAmount;
                  }

                  int crossAxisCount = 1;
                  if (MediaQuery.of(context).size.width > 1200) {
                    crossAxisCount = 4;
                  } else if (MediaQuery.of(context).size.width > 800) {
                    crossAxisCount = 3;
                  } else if (MediaQuery.of(context).size.width > 600) {
                    crossAxisCount = 2;
                  }

                  int pendingCount = orders.where((o) => o.status == 'pending').length;
                  int outForDeliveryCount = orders.where((o) => o.status == 'out for delivery').length;
                  int onlinePartnersCount = partners.where((p) => p.isOnline == 1).length;
                  int offlinePartnersCount = partners.where((p) => p.isOnline == 0).length;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio:
                            MediaQuery.of(context).size.width < 600 ? 3 : 2.5,
                        children: [
                          _StatCard(
                              title: 'Active Orders',
                              value: orders.length.toString(),
                              icon: Icons.shopping_bag,
                              color: Colors.blue),
                          _StatCard(
                              title: 'Out for Delivery',
                              value: outForDeliveryCount.toString(),
                              icon: Icons.delivery_dining,
                              color: Colors.purple),
                          _StatCard(
                              title: 'Online Partners',
                              value: onlinePartnersCount.toString(),
                              icon: Icons.motorcycle,
                              color: Colors.teal),
                          _StatCard(
                              title: 'Offline Partners',
                              value: offlinePartnersCount.toString(),
                              icon: Icons.motorcycle_outlined,
                              color: Colors.grey),
                          _StatCard(
                              title: 'Pending Orders',
                              value: pendingCount.toString(),
                              icon: Icons.pending_actions,
                              color: Colors.orange),
                          _StatCard(
                              title: 'Live Revenue',
                              value: '₹\${totalRevenue.toStringAsFixed(2)}',
                              icon: Icons.currency_rupee,
                              color: Colors.green),
                        ],
                      ),`;

if (text.includes('Widget _buildDashboardOverview() {')) {
  text = text.replace(oldDashboard, newDashboard);
  text = text.replace(
      '          activeOrdersAsync.when(\n            data: (orders) {\n              double totalRevenue = 0;',
      '// NOTE: replacement failed, this is fallback log' // wait, I already replaced the top part.
  );
  // Need to close the new 'when' block!
  const oldClosing = `            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e')),
          ),
        ],
      ),
    );
  }`;
  
  const newClosing = `                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text('Error: $e')),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e')),
          ),
        ],
      ),
    );
  }`;
  text = text.replace(oldClosing, newClosing);
  
  fs.writeFileSync('lib/features/auth/screens/admin_home_screen.dart', text, 'utf-8');
  console.log('Fixed admin panel!');
} else {
  console.log('Not found!');
}
