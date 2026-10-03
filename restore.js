const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/vendor_home_screen.dart', 'utf-8');

const startIndex = text.indexOf('@override\n  Widget build(BuildContext context) {');
const endIndex = text.indexOf('class _AddItemDialog extends ConsumerStatefulWidget');

const replacement = `@override
  Widget build(BuildContext context) {
    final shopsAsync = ref.watch(myOwnedShopsProvider(myUserId));

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: shopsAsync.maybeWhen(
          data: (shops) {
            if (shops.isEmpty) {
              return const Text('Vendor Dashboard',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
            }

            if (_selectedShopId == null ||
                !shops.any((s) => s.id == _selectedShopId)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() => _selectedShopId = shops.first.id);
              });
              return const Text('Vendor Dashboard');
            }

            return DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedShopId,
                dropdownColor: Colors.deepOrange,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => _selectedShopId = newValue);
                  }
                },
                items: shops.map<DropdownMenuItem<String>>((Vendor shop) {
                  return DropdownMenuItem<String>(
                    value: shop.id,
                    child: Text(shop.name),
                  );
                }).toList(),
              ),
            );
          },
          orElse: () => const Text('Vendor Dashboard'),
        ),
      ),
      body: shopsAsync.when(
        data: (shops) {
          if (shops.isEmpty) {
            return _buildEmptyState(
                Icons.store, 'No Shops Found', 'You do not own any shops yet.');
          }

          if (_selectedShopId == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final ordersAsync = ref.watch(vendorOrdersProvider(_selectedShopId!));
          return ordersAsync.when(
            data: (orders) {
              final activeOrders = orders.where((o) {
                final status = _optimisticStatus[o.id] ?? o.status;
                return status != 'delivered' && status != 'cancelled';
              }).toList();
              final completedOrders = orders.where((o) {
                final status = _optimisticStatus[o.id] ?? o.status;
                return status == 'delivered';
              }).toList();

              final selectedVendor = shops.firstWhere((s) => s.id == _selectedShopId!);

              Widget content;
              switch (_currentIndex) {
                case 0:
                  content = _buildLiveOrders(activeOrders);
                  break;
                case 1:
                  content = _buildMenuManagement(selectedVendor);
                  break;
                case 2:
                  content = _buildEarnings(completedOrders, selectedVendor);
                  break;
                default:
                  content = const Center(child: Text('Page not found'));
              }

              return RefreshIndicator(
                color: Colors.deepOrange,
                onRefresh: () async {
                  ref.invalidate(vendorOrdersProvider(_selectedShopId!));
                  ref.invalidate(vendorItemsProvider(_selectedShopId!));
                },
                child: content,
              );
            },
            loading: () => const Center(
                child: CircularProgressIndicator(color: Colors.deepOrange)),
            error: (e, s) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.deepOrange)),
        error: (e, s) => Center(child: Text('Error loading shops: $e')),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -5))
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.deepOrange,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          elevation: 0,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long), label: 'Live Orders'),
            BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_menu), label: 'Menu'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet), label: 'Earnings'),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800)),
          const SizedBox(height: 8),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildLiveOrders(List orders) {
    if (orders.isEmpty) {
      return _buildEmptyState(Icons.receipt_long, 'No Active Orders', 'Wait for new orders to come in.');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final currentStatus = _optimisticStatus[order.id] ?? order.status;

        final diff = DateTime.now().difference(order.createdAt);
        String timeStr = '\${diff.inMinutes}m ago';
        if (diff.inMinutes > 60) timeStr = '\${diff.inHours}h ago';

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 4,
          shadowColor: Colors.deepOrange.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order #\${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(timeStr, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    _StatusBadge(status: currentStatus),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.deepOrange.shade100,
                      foregroundColor: Colors.deepOrange,
                      radius: 16,
                      child: const Icon(Icons.person, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              order.customerName.isNotEmpty
                                  ? '\${order.customerName} (\${order.customerPhone})'
                                  : 'Customer (\${order.customerPhone})',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: order.items.map<Widget>((item) {
                      final mapItem = item as dynamic;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                  color: Colors.deepOrange.shade50,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Text('\${mapItem['quantity']}x',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrange)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Text('\${mapItem['name']}',
                                    style: const TextStyle(fontWeight: FontWeight.w500))),
                            Text('₹\${mapItem['price'] * mapItem['quantity']}',
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Bill:',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 16)),
                    Text('₹\${order.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green)),
                  ],
                ),
                const SizedBox(height: 16),
                if (currentStatus == 'pending' || currentStatus == '')
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _updateOrderStatus(order.id, 'cancelled'),
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                          child: const Text('Reject'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _updateOrderStatus(order.id, 'processing'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                          child: const Text('Accept'),
                        ),
                      ),
                    ],
                  )
                else if (currentStatus == 'processing')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _updateOrderStatus(order.id, 'ready'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                      child: const Text('Mark as Ready'),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateOrderStatus(String orderId, String newStatus) async {
    setState(() {
      _optimisticStatus[orderId] = newStatus;
    });
    try {
      final res = await ApiService.put('/orders/$orderId', {'status': newStatus});
      if (res.statusCode != 200) {
        throw Exception('Failed to update');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _optimisticStatus.remove(orderId);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  Widget _buildMenuManagement(Vendor vendor) {
    return Consumer(builder: (context, ref, child) {
      final itemsAsync = ref.watch(vendorItemsProvider(vendor.id));
      return itemsAsync.when(
        data: (items) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => showDialog(context: context, builder: (_) => _AddItemDialog(vendorId: vendor.id)),
              backgroundColor: Colors.deepOrange,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Add Item", style: TextStyle(color: Colors.white)),
            ),
            body: items.isEmpty
                ? _buildEmptyState(Icons.restaurant_menu, 'Menu is Empty', 'Add items to your menu to start selling.')
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80, top: 16, left: 16, right: 16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: item.imageUrl.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(item.imageUrl, width: 50, height: 50, fit: BoxFit.cover))
                              : Container(
                                  width: 50, height: 50, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
                                  child: const Icon(Icons.fastfood, color: Colors.grey)),
                          title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('₹\${item.price.toStringAsFixed(2)}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => showDialog(context: context, builder: (_) => _EditItemDialog(vendorId: vendor.id, item: item)),
                          ),
                        ),
                      );
                    },
                  ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      );
    });
  }

  Widget _buildEarnings(List orders, Vendor vendor) {
    double totalRevenue = 0;
    for (var o in orders) {
      totalRevenue += o.totalAmount;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Earnings & Payouts', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.blue.shade400, Colors.blue.shade700]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.blue.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Wallet Balance', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text('₹\${vendor.walletBalance.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.green.shade400, Colors.green.shade700]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.green.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text('Total Revenue', style: TextStyle(color: Colors.white70, fontSize: 16))],
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('₹\${totalRevenue.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text('Payout History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

text = text.substring(0, startIndex) + replacement + "\n\n" + text.substring(endIndex);
fs.writeFileSync('lib/features/auth/screens/vendor_home_screen.dart', text, 'utf-8');
console.log('Restored all deleted methods safely!');
