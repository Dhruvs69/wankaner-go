import 'dart:convert';
// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../customer/repositories/order_repository.dart';
import '../../customer/repositories/item_repository.dart';
import '../repositories/auth_repository.dart';
import '../providers/auth_provider.dart';
import '../../../core/api_service.dart';
import '../../customer/providers/vendor_provider.dart';
import '../../customer/models/vendor_model.dart';
import '../../customer/models/item_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/widgets/notification_bell.dart';
import '../../../core/widgets/settings_bottom_sheet.dart';

final vendorPrepTimeProvider =
    StateProvider.family<int, String>((ref, vendorId) => 15);
final vendorBusinessHoursProvider = StateProvider.family<String, String>(
    (ref, vendorId) => 'Auto-Offline at 11:00 PM');


final vendorPayoutsProvider = FutureProvider.family<List<dynamic>, String>((ref, ownerId) async {
  final res = await ApiService.get('/payouts/user/$ownerId');
  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  }
  return [];
});

class VendorHomeScreen extends ConsumerStatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  ConsumerState<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends ConsumerState<VendorHomeScreen> {
  int _currentIndex = 0;
  String? _cachedVendorId;
  String? _selectedShopId;

  String get myUserId {
    if (_cachedVendorId != null) return _cachedVendorId!;
    return ref.watch(authStateProvider).value ?? '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cachedVendorId = ref.watch(authStateProvider).value;
  }

  final Map<String, String> _optimisticStatus = {};

  @override
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
          orElse: () => const Text('Vendor Dashboard',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          const NotificationBell(),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => showSettings(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
              await ref.read(authRepositoryProvider).signOut();
            },
          ),
        ],
      ),
      body: shopsAsync.when(
        data: (shops) {
          if (shops.isEmpty) {
            return _buildEmptyState(Icons.storefront, 'No Shops Assigned',
                'You have no shops assigned to you yet.\nPlease contact the Admin.');
          }
          if (_selectedShopId == null) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.deepOrange));
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

              final selectedVendor = shops.firstWhere((s) => s.id == _selectedShopId, orElse: () => shops.first);
              Widget content;
              switch (_currentIndex) {
                case 0:
                  content = _buildLiveOrders(activeOrders);
                  break;
                case 1:
                  content = _buildMenuManagement();
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
      return _buildEmptyState(Icons.receipt_long, 'No Active Orders',
          'Wait for new orders to come in.');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final currentStatus = _optimisticStatus[order.id] ?? order.status;

        // Calculate time elapsed
        final diff = DateTime.now().difference(order.createdAt);
        String timeStr = '${diff.inMinutes}m ago';
        if (diff.inMinutes > 60) timeStr = '${diff.inHours}h ago';

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 4,
          shadowColor: Colors.deepOrange.withValues(alpha: 0.1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                        Text(
                            order.customerName.isNotEmpty ? order.customerName : 'Guest Customer',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 4),
                        Text(
                            'Order ID: ${order.id}',
                            style: const TextStyle(
                                color: Colors.deepOrange, fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(timeStr,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    _StatusBadge(status: currentStatus),
                  ],
                ),
                const Divider(height: 24),

                // Customer Info
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
                                  ? order.customerName
                                  : 'Guest Customer',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    if (order.customerPhone.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.phone, color: Colors.green),
                        onPressed: () async {
                          final Uri phoneUri =
                              Uri(scheme: 'tel', path: order.customerPhone);
                          if (await canLaunchUrl(phoneUri)) {
                            await launchUrl(phoneUri);
                          }
                        },
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                  color: Colors.deepOrange.shade50,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Text('${mapItem['quantity']}x',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrange)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Text('${mapItem['name']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500))),
                            Text('₹${mapItem['price'] * mapItem['quantity']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 16)),
                    Text('₹${order.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.green)),
                  ],
                ),
                const SizedBox(height: 16),

                // Action Buttons
                if (currentStatus == 'pending' || currentStatus == '')
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          onPressed: () async {
                            setState(() =>
                                _optimisticStatus[order.id] = 'cancelled');
                            try {
                              await ref
                                  .read(orderRepositoryProvider)
                                  .updateOrderStatus(order.id, 'cancelled');
                              ref.invalidate(
                                  vendorOrdersProvider(_selectedShopId!));
                            } catch (e) {
                              setState(
                                  () => _optimisticStatus.remove(order.id));
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Failed: $e')));
                              }
                            }
                          },
                          child: const Text('Reject',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          onPressed: () async {
                            setState(() =>
                                _optimisticStatus[order.id] = 'processing');
                            try {
                              await ref
                                  .read(orderRepositoryProvider)
                                  .updateOrderStatus(order.id, 'processing');
                              ref.invalidate(
                                  vendorOrdersProvider(_selectedShopId!));
                            } catch (e) {
                              setState(
                                  () => _optimisticStatus.remove(order.id));
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Failed: $e')));
                              }
                            }
                          },
                          child: const Text('Accept',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                if (currentStatus == 'processing')
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.orange,
                              side: BorderSide(color: Colors.orange.shade300),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        '+15 mins added to Prep Time. Customer notified.')));
                          },
                          child: const Text('Delay +15m',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          onPressed: () async {
                            setState(
                                () => _optimisticStatus[order.id] = 'ready');
                            try {
                              await ref
                                  .read(orderRepositoryProvider)
                                  .updateOrderStatus(order.id, 'ready');
                              ref.invalidate(
                                  vendorOrdersProvider(_selectedShopId!));
                            } catch (e) {
                              setState(
                                  () => _optimisticStatus.remove(order.id));
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Failed: $e')));
                              }
                            }
                          },
                          child: const Text('FOOD READY',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 1)),
                        ),
                      ),
                    ],
                  ),
                if (currentStatus == 'ready' ||
                    currentStatus == 'out for delivery' ||
                    currentStatus == 'out for delivery')
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200)),
                    child: Center(
                      child: Text(
                          currentStatus == 'out for delivery'
                              ? 'Order Picked Up by Driver'
                              : 'Waiting for Delivery Partner...',
                          style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuManagement() {
    final itemsAsync = ref.watch(vendorItemsProvider(_selectedShopId!));
    final prepTime = ref.watch(vendorPrepTimeProvider(_selectedShopId!));
    final businessHours =
        ref.watch(vendorBusinessHoursProvider(_selectedShopId!));

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepOrange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Item',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () {
          _showAddItemDialog(context);
        },
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Store Settings',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200)),
                    child: Column(
                      children: [
                        ListTile(
                          leading:
                              const Icon(Icons.access_time, color: Colors.blue),
                          title: const Text('Business Hours',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(businessHours),
                          trailing: ElevatedButton(
                            onPressed: () {
                              _showBusinessHoursDialog(context, businessHours);
                            },
                            child: const Text('Edit'),
                          ),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading:
                              const Icon(Icons.timer, color: Colors.orange),
                          title: const Text('Preparation Time',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Currently: $prepTime mins'),
                          trailing: DropdownButton<int>(
                            value: prepTime,
                            items: [15, 30, 45, 60, 90, 120]
                                .map((e) => DropdownMenuItem(
                                    value: e, child: Text('$e mins')))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                ref
                                    .read(
                                        vendorPrepTimeProvider(_selectedShopId!)
                                            .notifier)
                                    .state = val;
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Prep time set to $val mins')));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Menu Items',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          itemsAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return SliverToBoxAdapter(
                    child: _buildEmptyState(
                        Icons.restaurant_menu,
                        'No Products Yet',
                        'Add your first product to start selling!'));
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = items[index];
                      return Card(
                        elevation: 2,
                        shadowColor: Colors.black.withValues(alpha: 0.05),
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: item.imageUrl.isNotEmpty
                                  ? Image.network(
                                      item.imageUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                  width: 60,
                                                  height: 60,
                                                  color: Colors.red.shade50,
                                                  child: const Icon(
                                                      Icons.broken_image,
                                                      color: Colors.red)),
                                    )
                                  : Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey.shade100,
                                      child: const Icon(Icons.fastfood,
                                          color: Colors.grey)),
                            ),
                            title: Text(item.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text('₹${item.price}',
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Switch(
                                  value: item.isAvailable,
                                  activeTrackColor: Colors.green.shade200,
                                  activeThumbColor: Colors.green,
                                  inactiveThumbColor: Colors.red.shade400,
                                  inactiveTrackColor: Colors.red.shade100,
                                  onChanged: (val) {
                                    ref
                                        .read(itemRepositoryProvider)
                                        .updateItemStock(
                                            _selectedShopId!, item.id, val);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                '${item.name} is now ${val ? "In Stock" : "Out of Stock"}')));
                                  },
                                ),
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert,
                                      color: Colors.grey),
                                  onSelected: (value) async {
                                    if (value == 'edit') {
                                      _showEditItemDialog(context, item);
                                    } else if (value == 'schedule') {
                                      _showOutOfStockScheduleDialog(
                                          context, item);
                                    } else if (value == 'delete') {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Delete Product?'),
                                          content: Text(
                                              'Are you sure you want to delete "${item.name}"?'),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(ctx, false),
                                                child: const Text('Cancel')),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  foregroundColor:
                                                      Colors.white),
                                              onPressed: () =>
                                                  Navigator.pop(ctx, true),
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirm == true) {
                                        await ref
                                            .read(itemRepositoryProvider)
                                            .deleteItem(
                                                _selectedShopId!, item.id);
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      '${item.name} deleted')));
                                        }
                                      }
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                        value: 'edit',
                                        child: Row(children: [
                                          Icon(Icons.edit,
                                              size: 18, color: Colors.blue),
                                          SizedBox(width: 8),
                                          Text('Edit')
                                        ])),
                                    const PopupMenuItem(
                                        value: 'schedule',
                                        child: Row(children: [
                                          Icon(Icons.access_time,
                                              size: 18, color: Colors.orange),
                                          SizedBox(width: 8),
                                          Text('Auto-Offline')
                                        ])),
                                    const PopupMenuItem(
                                        value: 'delete',
                                        child: Row(children: [
                                          Icon(Icons.delete,
                                              size: 18, color: Colors.red),
                                          SizedBox(width: 8),
                                          Text('Delete')
                                        ])),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: items.length,
                  ),
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator())),
            error: (e, s) => SliverToBoxAdapter(
                child: Center(child: Text('Error loading menu: $e'))),
          ),
        ],
      ),
    );
  }

  void _showBusinessHoursDialog(BuildContext context, String currentHours) {
    showDialog(
      context: context,
      builder: (ctx) {
        String selected = currentHours;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Business Hours'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: const Text('Auto-Offline at 11:00 PM'),
                    value: 'Auto-Offline at 11:00 PM',
                    groupValue: selected,
                    onChanged: (val) => setState(() => selected = val!),
                  ),
                  RadioListTile<String>(
                    title: const Text('Auto-Offline at 10:00 PM'),
                    value: 'Auto-Offline at 10:00 PM',
                    groupValue: selected,
                    onChanged: (val) => setState(() => selected = val!),
                  ),
                  RadioListTile<String>(
                    title: const Text('Always Online (24/7)'),
                    value: 'Always Online (24/7)',
                    groupValue: selected,
                    onChanged: (val) => setState(() => selected = val!),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(vendorBusinessHoursProvider(_selectedShopId!)
                            .notifier)
                        .state = selected;
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Business hours updated successfully.')));
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _AddItemDialog(vendorId: _selectedShopId!),
    );
  }

  void _showEditItemDialog(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (context) =>
          _EditItemDialog(vendorId: _selectedShopId!, item: item),
    );
  }

  void _showOutOfStockScheduleDialog(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Auto-Offline Schedule'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Turn off "${item.name}" temporarily.',
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.timer, color: Colors.blue),
              title: const Text('For 3 Hours'),
              onTap: () {
                Navigator.pop(context);
                ref
                    .read(itemRepositoryProvider)
                    .updateItemStock(_selectedShopId!, item.id, false);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('${item.name} is offline for 3 hours')));
              },
            ),
            ListTile(
              leading: const Icon(Icons.nightlight_round, color: Colors.indigo),
              title: const Text('Until Tomorrow'),
              onTap: () {
                Navigator.pop(context);
                ref
                    .read(itemRepositoryProvider)
                    .updateItemStock(_selectedShopId!, item.id, false);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('${item.name} is offline until tomorrow')));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarnings(List orders, Vendor vendor) {
    if (orders.isEmpty) {
      return _buildEmptyState(Icons.account_balance_wallet, 'No Earnings Yet',
          'Completed orders will show up here.');
    }

    double totalRevenue = 0;
    for (var o in orders) {
      totalRevenue += o.totalAmount;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Financial & Analytics',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.green.shade400, Colors.green.shade700]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.green.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Revenue (Today)',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 16)),
                      SizedBox(height: 4),
                      Text('+12% vs Yesterday',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('₹${totalRevenue.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200)),
                  child: Column(
                    children: [
                      const Icon(Icons.trending_up,
                          color: Colors.blue, size: 32),
                      const SizedBox(height: 8),
                      const Text('Orders',
                          style: TextStyle(color: Colors.grey)),
                      Text('${orders.length}',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200)),
                  child: const Column(
                    children: [
                      Icon(Icons.favorite, color: Colors.red, size: 32),
                      SizedBox(height: 8),
                      Text('Retention', style: TextStyle(color: Colors.grey)),
                      Text('85%',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text('Top Selling Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          // Mock top selling items based on orders
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200)),
            child: Column(
              children: [
                _buildTopSellingRow('1. Margerita Pizza', '12 Orders'),
                const Divider(),
                _buildTopSellingRow('2. Garlic Bread', '8 Orders'),
                const Divider(),
                _buildTopSellingRow('3. Coca Cola (500ml)', '5 Orders'),
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
                          title: Text('Payout #${p['id']}'),
                          subtitle: Text('Status: ${p['status']} • Date: ${p['created_at']}'),
                          trailing: Text('₹${p['amount']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                          Text('Order: ${order.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const Chip(label: Text('Delivered', style: TextStyle(color: Colors.green)), backgroundColor: Colors.white, side: BorderSide(color: Colors.green)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('${order.customerName} (${order.customerPhone})'),
                      const Divider(),
                      ...order.items.map<Widget>((item) {
                        final mapItem = item as dynamic;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${mapItem['quantity']}x ${mapItem['name']}"),
                              Text("₹${mapItem['price'] * mapItem['quantity']}"),
                            ],
                          ),
                        );
                      }).toList(),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('₹${order.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
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

  Widget _buildTopSellingRow(String name, String orders) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(orders,
              style: const TextStyle(
                  color: Colors.deepOrange, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _AddItemDialog extends ConsumerStatefulWidget {
  final String vendorId;
  const _AddItemDialog({required this.vendorId});

  @override
  ConsumerState<_AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends ConsumerState<_AddItemDialog> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final imageUrlController = TextEditingController();

  final List<Map<String, TextEditingController>> _variants = [];
  final List<Map<String, TextEditingController>> _addons = [];

  bool _isUploading = false;
  String? _uploadedImageUrl;

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    imageUrlController.dispose();
    for (var v in _variants) {
      v['name']!.dispose();
      v['price']!.dispose();
    }
    for (var a in _addons) {
      a['name']!.dispose();
      a['price']!.dispose();
    }
    super.dispose();
  }

  void _addVariant() {
    setState(() {
      _variants.add({
        'name': TextEditingController(),
        'price': TextEditingController(),
      });
    });
  }

  void _addAddon() {
    setState(() {
      _addons.add({
        'name': TextEditingController(),
        'price': TextEditingController(),
      });
    });
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        setState(() {
          _isUploading = true;
        });

        final bytes = await pickedFile.readAsBytes();
        final rawName =
            pickedFile.name.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');

        final downloadUrl = await ApiService.uploadImage(bytes, rawName);

        if (downloadUrl != null) {
          setState(() {
            _uploadedImageUrl = downloadUrl;
            imageUrlController.text = downloadUrl;
            _isUploading = false;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Image uploaded successfully!')));
          }
        } else {
          throw Exception('Failed to upload image');
        }
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Upload notice: $e. You can also paste an Image URL directly.'),
          duration: const Duration(seconds: 4),
        ));
      }
    }
  }

  Widget _buildListSection(
      String title, List<Map<String, TextEditingController>> list, VoidCallback onAdd) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
            TextButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
              onPressed: onAdd,
            )
          ],
        ),
        for (int i = 0; i < list.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: list[i]['name'],
                    decoration: const InputDecoration(
                        labelText: 'Name', isDense: true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: list[i]['price'],
                    decoration: const InputDecoration(
                        labelText: 'Price', isDense: true),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () {
                    setState(() {
                      list[i]['name']!.dispose();
                      list[i]['price']!.dispose();
                      list.removeAt(i);
                    });
                  },
                )
              ],
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final previewUrl = imageUrlController.text.trim().isNotEmpty
        ? imageUrlController.text.trim()
        : _uploadedImageUrl;

    return AlertDialog(
      title: const Text('Add New Product'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    labelText: 'Product Name (e.g. Paneer Tikka)'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Base Price (₹)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Product Image URL',
                  hintText: 'Upload image or paste direct image URL',
                  prefixIcon: Icon(Icons.link),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: _isUploading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.upload_file),
                label: Text(_isUploading
                    ? 'Uploading Image...'
                    : 'Pick & Upload Image From Device'),
                onPressed: _isUploading ? null : _pickAndUploadImage,
              ),
              if (previewUrl != null && previewUrl.isNotEmpty) ...[
                const SizedBox(height: 12),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        previewUrl,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 80,
                          color: Colors.grey.shade200,
                          alignment: Alignment.center,
                          child: const Text(
                              'Invalid image URL or preview unavailable',
                              style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.6),
                        radius: 14,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.close, color: Colors.white, size: 16),
                          onPressed: () {
                            setState(() {
                              imageUrlController.clear();
                              _uploadedImageUrl = null;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              const Divider(),
              _buildListSection('Variants (e.g. Small / Large)', _variants, _addVariant),
              const Divider(),
              _buildListSection('Add-ons (e.g. Extra Cheese)', _addons, _addAddon),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isUploading
              ? null
              : () async {
                  if (nameController.text.isNotEmpty &&
                      priceController.text.isNotEmpty) {
                    final finalImageUrl =
                        imageUrlController.text.trim().isNotEmpty
                            ? imageUrlController.text.trim()
                            : (_uploadedImageUrl ?? '');

                    List<ItemVariant> variantsList = _variants.map((v) => ItemVariant(
                          name: v['name']!.text.trim(),
                          price: double.tryParse(v['price']!.text) ?? 0.0,
                        )).where((v) => v.name.isNotEmpty).toList();

                    List<ItemAddon> addonsList = _addons.map((a) => ItemAddon(
                          name: a['name']!.text.trim(),
                          price: double.tryParse(a['price']!.text) ?? 0.0,
                        )).where((a) => a.name.isNotEmpty).toList();

                    final newItem = Item(
                      id: '', // Generated by Firestore/Backend
                      name: nameController.text.trim(),
                      price: double.tryParse(priceController.text) ?? 0.0,
                      imageUrl: finalImageUrl,
                      isAvailable: true,
                      variants: variantsList,
                      addons: addonsList,
                    );

                    await ref
                        .read(itemRepositoryProvider)
                        .addItem(widget.vendorId, newItem);

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Product Added Successfully!')));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please fill all required fields')));
                  }
                },
          child: const Text('Save Product'),
        ),
      ],
    );
  }
}

class _EditItemDialog extends ConsumerStatefulWidget {
  final String vendorId;
  final Item item;
  const _EditItemDialog({required this.vendorId, required this.item});

  @override
  ConsumerState<_EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends ConsumerState<_EditItemDialog> {
  late final TextEditingController nameController;
  late final TextEditingController priceController;
  late final TextEditingController imageUrlController;
  
  final List<Map<String, TextEditingController>> _variants = [];
  final List<Map<String, TextEditingController>> _addons = [];

  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item.name);
    priceController = TextEditingController(text: widget.item.price.toString());
    imageUrlController = TextEditingController(text: widget.item.imageUrl);
    
    for (var v in widget.item.variants) {
      _variants.add({
        'name': TextEditingController(text: v.name),
        'price': TextEditingController(text: v.price.toString()),
      });
    }
    for (var a in widget.item.addons) {
      _addons.add({
        'name': TextEditingController(text: a.name),
        'price': TextEditingController(text: a.price.toString()),
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    imageUrlController.dispose();
    for (var v in _variants) {
      v['name']!.dispose();
      v['price']!.dispose();
    }
    for (var a in _addons) {
      a['name']!.dispose();
      a['price']!.dispose();
    }
    super.dispose();
  }

  void _addVariant() {
    setState(() {
      _variants.add({
        'name': TextEditingController(),
        'price': TextEditingController(),
      });
    });
  }

  void _addAddon() {
    setState(() {
      _addons.add({
        'name': TextEditingController(),
        'price': TextEditingController(),
      });
    });
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        setState(() {
          _isUploading = true;
        });

        final bytes = await pickedFile.readAsBytes();
        final rawName =
            pickedFile.name.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');

        final downloadUrl = await ApiService.uploadImage(bytes, rawName);

        if (downloadUrl != null) {
          setState(() {
            imageUrlController.text = downloadUrl;
            _isUploading = false;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Image uploaded successfully!')));
          }
        } else {
          throw Exception('Failed to upload image');
        }
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Upload notice: $e. You can also paste an Image URL directly.'),
          duration: const Duration(seconds: 4),
        ));
      }
    }
  }

  Widget _buildListSection(
      String title, List<Map<String, TextEditingController>> list, VoidCallback onAdd) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
            TextButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
              onPressed: onAdd,
            )
          ],
        ),
        for (int i = 0; i < list.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: list[i]['name'],
                    decoration: const InputDecoration(
                        labelText: 'Name', isDense: true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: list[i]['price'],
                    decoration: const InputDecoration(
                        labelText: 'Price', isDense: true),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () {
                    setState(() {
                      list[i]['name']!.dispose();
                      list[i]['price']!.dispose();
                      list.removeAt(i);
                    });
                  },
                )
              ],
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final previewUrl = imageUrlController.text.trim();

    return AlertDialog(
      title: Text('Edit ${widget.item.name}'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Base Price (₹)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Product Image URL',
                  hintText: 'Upload or paste image URL',
                  prefixIcon: Icon(Icons.link),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: _isUploading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.upload_file),
                label: Text(
                    _isUploading ? 'Uploading Image...' : 'Upload New Image'),
                onPressed: _isUploading ? null : _pickAndUploadImage,
              ),
              if (previewUrl.isNotEmpty) ...[
                const SizedBox(height: 12),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        previewUrl,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 80,
                          color: Colors.grey.shade200,
                          alignment: Alignment.center,
                          child: const Text(
                              'Invalid image URL or preview unavailable',
                              style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.6),
                        radius: 14,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.close, color: Colors.white, size: 16),
                          onPressed: () {
                            setState(() {
                              imageUrlController.clear();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              const Divider(),
              _buildListSection('Variants (e.g. Small / Large)', _variants, _addVariant),
              const Divider(),
              _buildListSection('Add-ons (e.g. Extra Cheese)', _addons, _addAddon),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isUploading
              ? null
              : () async {
                  if (nameController.text.isNotEmpty &&
                      priceController.text.isNotEmpty) {
                      
                    List<Map<String, dynamic>> variantsList = _variants.map((v) => {
                          'name': v['name']!.text.trim(),
                          'price': double.tryParse(v['price']!.text) ?? 0.0,
                        }).where((v) => v['name'] != '').toList();

                    List<Map<String, dynamic>> addonsList = _addons.map((a) => {
                          'name': a['name']!.text.trim(),
                          'price': double.tryParse(a['price']!.text) ?? 0.0,
                        }).where((a) => a['name'] != '').toList();

                    await ref
                        .read(itemRepositoryProvider)
                        .updateItem(widget.vendorId, widget.item.id, {
                      'name': nameController.text.trim(),
                      'price': double.tryParse(priceController.text) ??
                          widget.item.price,
                      'imageUrl': imageUrlController.text.trim(),
                      'variants': variantsList,
                      'addons': addonsList,
                    });
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Product Updated Successfully!')));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please fill all required fields')));
                  }
                },
          child: const Text('Save Changes'),
        ),
      ],
    );
  }
}


class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.grey.shade200;
    Color textColor = Colors.grey.shade800;

    if (status.toLowerCase() == 'pending') {
      bgColor = Colors.orange.shade100;
      textColor = Colors.orange.shade900;
    } else if (status.toLowerCase() == 'accepted' || status.toLowerCase() == 'preparing') {
      bgColor = Colors.blue.shade100;
      textColor = Colors.blue.shade900;
    } else if (status.toLowerCase() == 'ready' || status.toLowerCase() == 'out_for_delivery') {
      bgColor = Colors.purple.shade100;
      textColor = Colors.purple.shade900;
    } else if (status.toLowerCase() == 'delivered') {
      bgColor = Colors.green.shade100;
      textColor = Colors.green.shade900;
    } else if (status.toLowerCase() == 'cancelled') {
      bgColor = Colors.red.shade100;
      textColor = Colors.red.shade900;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}

class ComingSoonScreen extends StatelessWidget {
  final String title;
  const ComingSoonScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction,
                size: 80, color: Colors.deepOrange.shade300),
            const SizedBox(height: 16),
            const Text('Coming Soon!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('We are working hard to bring you\n$title.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, height: 1.5)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

