import 'package:flutter/material.dart';
import 'package:wankaner_go/features/auth/providers/settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';
import '../../../core/api_service.dart';
import '../../customer/providers/banner_provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../customer/repositories/order_repository.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/widgets/notification_bell.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../customer/providers/vendor_provider.dart';
import '../../customer/models/vendor_model.dart';
import 'dart:convert';

final deliveryPartnersProvider = FutureProvider<List<dynamic>>((ref) async {
  final response = await ApiService.get('/users?role=delivery');
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }
  return [];
});

final payoutsProvider = FutureProvider<List<dynamic>>((ref) async {
  final response = await ApiService.get('/payouts');
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }
  return [];
});

class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  ConsumerState<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _notifTitleController = TextEditingController();
  final TextEditingController _notifMessageController = TextEditingController();

  @override
  void dispose() {
    _notifTitleController.dispose();
    _notifMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              title: const Text('WankanerGo Admin',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              actions: const [
                NotificationBell(),
                SizedBox(width: 8),
              ],
            ),
      drawer: isDesktop
          ? null
          : Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(color: Colors.deepOrange),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.admin_panel_settings,
                            size: 48, color: Colors.white),
                        SizedBox(height: 8),
                        Text('Admin Control Panel',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ],
                    ),
                  ),
                  _buildDrawerItem(0, Icons.dashboard, 'Dashboard'),
                  _buildDrawerItem(1, Icons.shopping_bag, 'Orders'),
                  _buildDrawerItem(2, Icons.store, 'Vendors'),
                  _buildDrawerItem(3, Icons.storefront, 'Shops'),
                  _buildDrawerItem(4, Icons.people, 'Customers'),
                  _buildDrawerItem(
                      5, Icons.delivery_dining, 'Delivery Partners'),
                  _buildDrawerItem(6, Icons.map, 'Heatmaps'),
                  _buildDrawerItem(
                      7, Icons.notifications_active, 'Push Notifications'),
                  _buildDrawerItem(8, Icons.gavel, 'Disputes & Refunds'),
                  _buildDrawerItem(9, Icons.account_balance_wallet, 'Payouts'),
                  _buildDrawerItem(10, Icons.image, 'Banners'),
                  _buildDrawerItem(11, Icons.settings, 'Settings'),
                  const Divider(),
                  Material(type: MaterialType.transparency, child: ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold)),
                    onTap: () async {
                      await ref.read(authRepositoryProvider).signOut();
                    },
                  )),
                ],
              ),
            ),
      body: Row(
        children: [
          // Sidebar Navigation for Desktop
          if (isDesktop)
            NavigationRail(
              extended: MediaQuery.of(context).size.width >= 1000,
              backgroundColor: Colors.deepOrange,
              unselectedIconTheme:
                  const IconThemeData(color: Colors.white70, opacity: 1),
              unselectedLabelTextStyle: const TextStyle(color: Colors.white70),
              selectedIconTheme: const IconThemeData(color: Colors.deepOrange),
              selectedLabelTextStyle: const TextStyle(
                  color: Colors.deepOrange, fontWeight: FontWeight.bold),
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Column(
                  children: [
                    const Icon(Icons.admin_panel_settings,
                        size: 48, color: Colors.white),
                    if (MediaQuery.of(context).size.width >= 1000)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text('WankanerGo Admin',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      )
                  ],
                ),
              ),
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white70),
                      tooltip: 'Logout',
                      onPressed: () async {
                        await ref.read(authRepositoryProvider).signOut();
                      },
                    ),
                  ),
                ),
              ),
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.dashboard), label: Text('Dashboard')),
                NavigationRailDestination(
                    icon: Icon(Icons.shopping_bag), label: Text('Orders')),
                NavigationRailDestination(
                    icon: Icon(Icons.store), label: Text('Vendors')),
                NavigationRailDestination(
                    icon: Icon(Icons.storefront), label: Text('Shops')),
                NavigationRailDestination(
                    icon: Icon(Icons.people), label: Text('Customers')),
                NavigationRailDestination(
                    icon: Icon(Icons.delivery_dining),
                    label: Text('Delivery Partners')),
                NavigationRailDestination(
                    icon: Icon(Icons.map), label: Text('Heatmaps')),
                NavigationRailDestination(
                    icon: Icon(Icons.notifications_active),
                    label: Text('Push Notifications')),
                NavigationRailDestination(
                    icon: Icon(Icons.gavel), label: Text('Disputes & Refunds')),
                NavigationRailDestination(
                    icon: Icon(Icons.account_balance_wallet),
                    label: Text('Payouts')),
                NavigationRailDestination(
                    icon: Icon(Icons.settings), label: Text('Settings')),
              ],
            ),

          // Main Content Area
          Expanded(
            child: Container(
              color: Colors.grey.shade50,
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(int index, IconData icon, String title) {
    return Material(type: MaterialType.transparency, child: ListTile(
      leading: Icon(icon,
          color: _selectedIndex == index
              ? Colors.deepOrange
              : Colors.grey.shade700),
      title: Text(title,
          style: TextStyle(
              color:
                  _selectedIndex == index ? Colors.deepOrange : Colors.black87,
              fontWeight: _selectedIndex == index
                  ? FontWeight.bold
                  : FontWeight.normal)),
      selected: _selectedIndex == index,
      selectedTileColor: Colors.deepOrange.shade50,
      onTap: () {
        setState(() => _selectedIndex = index);
        Navigator.pop(context); // Close drawer
      },
    ));
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardOverview();
      case 1:
        return _buildOrdersManagement();
      case 2:
        return _buildUserManagement('vendor', 'Vendors');
      case 3:
        return _buildShopsManagement();
      case 4:
        return _buildUserManagement('customer', 'Customers');
      case 5:
        return _buildUserManagement('delivery', 'Delivery Partners');
      case 6:
        return _buildHeatmaps();
      case 7:
        return _buildPushNotifications();
      case 8:
        return _buildDisputes();
      case 9:
        return _buildPayouts();
      case 10:
        return _buildBannersManagement();
      case 11:
        return _buildSettings();
      default:
        return const Center(child: Text('Page not found'));
    }
  }

  // Generic User Management Screen
  Widget _buildUserManagement(String role, String title) {
    final usersAsync = ref.watch(usersByRoleProvider(role));

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Expanded(
            child: usersAsync.when(
              data: (users) {
                if (users.isEmpty) {
                  return Center(child: Text('No $role found.'));
                }
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Material(type: MaterialType.transparency, child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepOrange.shade100,
                          child: Icon(Icons.person,
                              color: Colors.deepOrange.shade800),
                        ),
                        title: Text(user.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${user.email} • ${user.phone}'),
                            if (role == 'delivery')
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  user.isOnline == 1 ? '🟢 Online' : '⚪ Offline',
                                  style: TextStyle(
                                    color: user.isOnline == 1 ? Colors.green.shade700 : Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (role == 'vendor' || role == 'delivery')
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Status updated')));
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white),
                                child: const Text('Approve'),
                              ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    String selectedRole = user.role;
                                    return AlertDialog(
                                      title: Text('Edit Role for ${user.name}'),
                                      content: StatefulBuilder(
                                        builder: (context, setDialogState) {
                                          return DropdownButton<String>(
                                            value: selectedRole,
                                            isExpanded: true,
                                            items: const [
                                              DropdownMenuItem(
                                                  value: 'customer',
                                                  child: Text('Customer')),
                                              DropdownMenuItem(
                                                  value: 'vendor',
                                                  child: Text('Vendor')),
                                              DropdownMenuItem(
                                                  value: 'delivery',
                                                  child:
                                                      Text('Delivery Partner')),
                                              DropdownMenuItem(
                                                  value: 'admin',
                                                  child: Text('Admin')),
                                            ],
                                            onChanged: (val) {
                                              if (val != null) {
                                                setDialogState(
                                                    () => selectedRole = val);
                                              }
                                            },
                                          );
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Cancel')),
                                        ElevatedButton(
                                          onPressed: () async {
                                            try {
                                              final response =
                                                  await ApiService.put(
                                                      '/users/${user.id}',
                                                      {'role': selectedRole});
                                              if (response.statusCode != 200) {
                                                throw Exception(
                                                    'Failed to update role');
                                              }
                                              if (context.mounted) {
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            'Role updated successfully!')));
                                              }
                                            } catch (e) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content:
                                                            Text('Error: $e')));
                                              }
                                            }
                                          },
                                          child: const Text('Save'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.block, color: Colors.red),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Suspend ${user.name}')));
                              },
                            ),
                          ],
                        ),
                      )),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error loading $role: $e')),
            ),
          ),
        ],
      ),
    );
  }

  // Shops Management Screen
  Widget _buildShopsManagement() {
    final vendorsAsync = ref.watch(nearbyVendorsProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Shops',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Shop Profile'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white),
                onPressed: () {
                  _showAddShopDialog(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: vendorsAsync.when(
              data: (vendors) {
                if (vendors.isEmpty) {
                  return const Center(child: Text('No shops found.'));
                }
                return ListView.builder(
                  itemCount: vendors.length,
                  itemBuilder: (context, index) {
                    final vendor = vendors[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Material(type: MaterialType.transparency, child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey.shade200,
                          child: vendor.imageUrl.isNotEmpty
                              ? Image.network(vendor.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) =>
                                      const Icon(Icons.store))
                              : const Icon(Icons.store),
                        ),
                        title: Text(vendor.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            '${vendor.category} • ${vendor.isOpen ? 'Currently Open' : 'Currently Closed'} • ${vendor.isActive ? 'Visible' : 'Hidden'}'),
                        trailing: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Open',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey)),
                                      Switch(
                                        value: vendor.isOpen,
                                        activeTrackColor: Colors.green.shade200,
                                        activeThumbColor: Colors.green,
                                        onChanged: (val) async {
                                          try {
                                            final response =
                                                await ApiService.put(
                                                    '/vendors/${vendor.id}', {
                                              'name': vendor.name,
                                              'category': vendor.category,
                                              'is_open': val,
                                              'is_active': vendor.isActive,
                                              'image_url': vendor.imageUrl,
                                              'lat': vendor.lat,
                                              'lng': vendor.lng,
                                            });
                                            if (response.statusCode != 200) {
                                              throw Exception(
                                                  'Failed to update status');
                                            }
                                            ref.invalidate(
                                                nearbyVendorsProvider);
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          '${vendor.name} is now ${val ? "Open" : "Closed"}')));
                                            }
                                          } catch (e) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content:
                                                          Text('Error: $e')));
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Visible',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey)),
                                      Switch(
                                        value: vendor.isActive,
                                        activeTrackColor: Colors.blue.shade200,
                                        activeThumbColor: Colors.blue,
                                        onChanged: (val) async {
                                          try {
                                            final response =
                                                await ApiService.put(
                                                    '/vendors/${vendor.id}', {
                                              'name': vendor.name,
                                              'category': vendor.category,
                                              'is_open': vendor.isOpen,
                                              'is_active': val,
                                              'image_url': vendor.imageUrl,
                                              'lat': vendor.lat,
                                              'lng': vendor.lng,
                                            });
                                            if (response.statusCode != 200) {
                                              throw Exception(
                                                  'Failed to update visibility');
                                            }
                                            ref.invalidate(
                                                nearbyVendorsProvider);
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          '${vendor.name} is now ${val ? "Visible" : "Hidden"}')));
                                            }
                                          } catch (e) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content:
                                                          Text('Error: $e')));
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Promoted',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey)),
                                      Switch(
                                        value: vendor.isPromoted,
                                        activeTrackColor: Colors.purple.shade200,
                                        activeThumbColor: Colors.purple,
                                        onChanged: (val) async {
                                          try {
                                            final response =
                                                await ApiService.put(
                                                    '/vendors/${vendor.id}/promote', {
                                              'is_promoted': val,
                                            });
                                            if (response.statusCode != 200) {
                                              throw Exception(
                                                  'Failed to update promotion');
                                            }
                                            ref.invalidate(
                                                nearbyVendorsProvider);
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          '${vendor.name} is now ${val ? "Promoted" : "Not Promoted"}')));
                                            }
                                          } catch (e) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content:
                                                          Text('Error: $e')));
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert),
                                onSelected: (val) async {
                                  if (val == 'edit') {
                                    _showEditShopDialog(context, vendor);
                                  } else if (val == 'delete') {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Delete Shop?'),
                                        content: Text(
                                            'Are you sure you want to delete ${vendor.name}? This action cannot be undone.'),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(ctx, false),
                                              child: const Text('Cancel')),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white),
                                            onPressed: () =>
                                                Navigator.pop(ctx, true),
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      try {
                                        final response =
                                            await ApiService.delete(
                                                '/vendors/${vendor.id}');
                                        if (response.statusCode != 200 &&
                                            response.statusCode != 204) {
                                          throw Exception(
                                              'Failed to delete shop');
                                        }
                                        ref.invalidate(nearbyVendorsProvider);
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      '${vendor.name} deleted successfully')));
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Error deleting shop: $e')));
                                        }
                                      }
                                    }
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                      value: 'edit',
                                      child: Row(children: [
                                        Icon(Icons.edit,
                                            color: Colors.blue, size: 18),
                                        SizedBox(width: 8),
                                        Text('Edit Profile')
                                      ])),
                                  const PopupMenuItem(
                                      value: 'delete',
                                      child: Row(children: [
                                        Icon(Icons.delete,
                                            color: Colors.red, size: 18),
                                        SizedBox(width: 8),
                                        Text('Delete Shop')
                                      ])),
                                ],
                              ),
                             ],
                          ),
                        ),
                      )),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error loading shops: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() => const _SettingsView();

  Widget _buildDashboardOverview() {
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
                          value: '₹${totalRevenue.toStringAsFixed(2)}',
                          icon: Icons.currency_rupee,
                          color: Colors.green),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Active Orders List', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Card(
                        child: Material(type: MaterialType.transparency, child: ListTile(
                          leading: CircleAvatar(child: Text(order.status.isNotEmpty ? order.status[0].toUpperCase() : '-')),
                          title: Text('Order #${order.id}'),
                          subtitle: Text('Status: ${order.status.toUpperCase()} | Amount: ₹${order.totalAmount}'),
                        )),
                      );
                    },
                  ),
                ],
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (e, s) => Text('Error loading stats: $e'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersManagement() {
    final activeOrdersAsync = ref.watch(activeOrdersProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Active Orders',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Expanded(
            child: activeOrdersAsync.when(
              data: (orders) {
                if (orders.isEmpty) {
                  return const Center(
                      child: Text('No active orders right now.'));
                }
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Wrap( spacing: 16, runSpacing: 12, crossAxisAlignment: WrapCrossAlignment.center, 
                          
                          children: [
                            SizedBox(width: 200, child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Order #${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  Text(
                                      'Date: ${order.createdAt.toLocal().toString().split('.')[0]}',
                                      style: TextStyle(
                                          color: Colors.grey.shade600)),
                                ],
                              ),
                            ),
                            SizedBox(width: 100, child: Text('₹${order.totalAmount}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.green)),
                            ),
                            SizedBox(width: 150, child: Chip(
                                label: Text(order.status.toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                                backgroundColor: _getStatusColor(order.status),
                              ),
                            ),
                            SizedBox(width: 300, child: Wrap(
                                alignment: WrapAlignment.end,
                                spacing: 8.0,
                                runSpacing: 4.0,
                                children: [
                                  if (order.status == 'ready' ||
                                      order.status == 'processing')
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.delivery_dining,
                                          size: 18),
                                      onPressed: () {
                                        _showAssignPartnerDialog(
                                            context, ref, order.id);
                                      },
                                      label: const Text('Assign Partner',
                                          style: TextStyle(fontSize: 12)),
                                    ),
                                  const SizedBox(width: 8),
                                  if (order.status != 'delivered' &&
                                      order.status != 'cancelled')
                                    PopupMenuButton<String>(
                                      icon: const Icon(Icons.more_vert),
                                      onSelected: (val) async {
                                        if (val == 'cancel') {
                                          final confirm =
                                              await showDialog<bool>(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title:
                                                  const Text('Cancel Order?'),
                                              content: Text(
                                                  'Are you sure you want to forcibly cancel Order #${order.id.length > 8 ? order.id.substring(0, 8) : order.id}?'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            ctx, false),
                                                    child: const Text(
                                                        'No, Go Back')),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.red,
                                                          foregroundColor:
                                                              Colors.white),
                                                  onPressed: () =>
                                                      Navigator.pop(ctx, true),
                                                  child: const Text(
                                                      'Yes, Cancel Order'),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirm == true) {
                                            try {
                                              await ref
                                                  .read(orderRepositoryProvider)
                                                  .updateOrderStatus(
                                                      order.id, 'cancelled');
                                              ref.invalidate(
                                                  activeOrdersProvider);
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            'Order Cancelled by Admin')));
                                              }
                                            } catch (e) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content:
                                                            Text('Error: $e')));
                                              }
                                            }
                                          }
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                            value: 'cancel',
                                            child: Row(children: [
                                              Icon(Icons.cancel,
                                                  color: Colors.red, size: 18),
                                              SizedBox(width: 8),
                                              Text('Force Cancel',
                                                  style: TextStyle(
                                                      color: Colors.red))
                                            ])),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => const Center(child: Text('Error')),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddShopDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _AddShopDialog(),
    );
  }

  void _showEditShopDialog(BuildContext context, Vendor vendor) {
    showDialog(
      context: context,
      builder: (context) => _EditShopDialog(vendor: vendor),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.red;
      case 'processing':
        return Colors.orange;
      case 'ready':
        return Colors.amber;
      case 'out for delivery':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildHeatmaps() {
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
                              Text('🔥 Active Live Orders: ${validOrders.length}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)),
                              const SizedBox(height: 4),
                              Text('Total Orders in DB: ${orders.length}', style: const TextStyle(fontSize: 12)),
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
    );
  }

  Widget _buildPushNotifications() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Global Push Notifications',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text(
              'Blast a message to all customers via Firebase Cloud Messaging.',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 32),
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _notifTitleController,
                  decoration: const InputDecoration(
                      labelText: 'Notification Title',
                      border: OutlineInputBorder(),
                      hintText: 'e.g., Flash Sale!'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _notifMessageController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                      labelText: 'Notification Message',
                      border: OutlineInputBorder(),
                      hintText:
                          'e.g., It\'s raining! Order hot pakodas now 🌧️'),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white),
                    icon: const Icon(Icons.send),
                    label: const Text('Blast to All Customers'),
                    onPressed: () async {
                      try {
                        if (_notifTitleController.text.isEmpty ||
                            _notifMessageController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Please enter title and message')));
                          return;
                        }

                        await ApiService.post('/notifications', {
                          'title': _notifTitleController.text,
                          'message': _notifMessageController.text,
                        });
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'Global Notification Queued Successfully!')));
                        _notifTitleController.clear();
                        _notifMessageController.clear();
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to send: $e')));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisputes() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dispute & Refund Engine',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text(
              'Manage customer complaints, process partial/full refunds, or penalize vendors for missing items.',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Order #${10045 + index}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    color: Colors.red.shade100,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text('Missing Item',
                                    style: TextStyle(
                                        color: Colors.red.shade800,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                              'Customer Complaint: "I ordered 2 pizzas but only received 1. Please refund."'),
                          const SizedBox(height: 8),
                          const Text(
                              'Vendor: Honest Restaurant | Driver: Rajesh Kumar',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                          const Divider(height: 24),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Refund processed to Customer Wallet.')));
                                },
                                child: const Text('Issue Full Refund'),
                              ),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Vendor Penalized successfully.')));
                                },
                                child: const Text('Penalize Vendor'),
                              ),
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Dispute Rejected.')));
                                },
                                child: const Text('Reject Claim',
                                    style: TextStyle(color: Colors.grey)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildPayouts() {
    final payoutsAsync = ref.watch(payoutsProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Automated Payouts', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Create Payout'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
                onPressed: () => _showCreatePayoutDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Manage manual and automated payouts to vendors and riders.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          Expanded(
            child: payoutsAsync.when(
              data: (payouts) {
                if (payouts.isEmpty) return const Center(child: Text('No payouts found.'));
                return ListView.builder(
                  itemCount: payouts.length,
                  itemBuilder: (context, index) {
                    final payout = payouts[index];
                    return _buildPayoutCard(
                      payout['user_id']?.toString() ?? 'Unknown User',
                      '₹${payout['amount'] ?? 0}',
                      payout['type']?.toString().toUpperCase() ?? 'UNKNOWN',
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error loading payouts: $e')),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreatePayoutDialog(BuildContext context) {
    final userIdCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    String selectedType = 'vendor';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create Payout'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: userIdCtrl,
                      decoration: const InputDecoration(labelText: 'User ID'),
                    ),
                    TextField(
                      controller: amountCtrl,
                      decoration: const InputDecoration(labelText: 'Amount'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: selectedType,
                      items: const [
                        DropdownMenuItem(value: 'vendor', child: Text('Vendor')),
                        DropdownMenuItem(value: 'delivery', child: Text('Delivery')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => selectedType = val);
                      },
                      decoration: const InputDecoration(labelText: 'Type'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final amount = double.tryParse(amountCtrl.text) ?? 0;
                      await ApiService.post('/payouts', {
                        'id': DateTime.now().millisecondsSinceEpoch.toString(),
                        'user_id': userIdCtrl.text,
                        'amount': amount,
                        'type': selectedType,
                      });
                      if (context.mounted) {
                        Navigator.pop(ctx);
                        ref.invalidate(payoutsProvider);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payout created successfully')));
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPayoutCard(String userId, String amount, String type) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Material(type: MaterialType.transparency, child: ListTile(
        leading: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: const Icon(Icons.account_balance, color: Colors.blue)),
        title: Text('User ID: $userId', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Type: $type'),
        trailing: Text(amount,
                style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
      )),
    );
  }

  void _showAssignPartnerDialog(
      BuildContext context, WidgetRef ref, String orderId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Assign Delivery Partner'),
          content: SizedBox(
            width: double.maxFinite,
            child: Consumer(
              builder: (context, ref, child) {
                final partnersAsync = ref.watch(deliveryPartnersProvider);
                return partnersAsync.when(
                  data: (partners) {
                    if (partners.isEmpty) {
                      return const Text('No delivery partners available.');
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: partners.length,
                      itemBuilder: (context, index) {
                        final partner = partners[index];
                        return Material(type: MaterialType.transparency, child: ListTile(
                          leading:
                              const CircleAvatar(child: Icon(Icons.person)),
                          title: Text(partner['name'] ?? 'Unknown'),
                          subtitle: Text(partner['phone'] ?? ''),
                          onTap: () {
                            ref
                                .read(orderRepositoryProvider)
                                .assignDeliveryPartner(
                                    orderId, partner['id'].toString());
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Assigned to ${partner['name']}')),
                            );
                            Navigator.pop(context);
                          },
                        ));
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Text('Error loading partners: $e'),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBannersManagement() {
    final bannersAsync = ref.watch(bannersProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(child: Text('Promotional Banners', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Banner'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white),
                onPressed: () => _showAddBannerDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: bannersAsync.when(
              data: (banners) {
                if (banners.isEmpty) {
                  return const Center(child: Text('No banners found.'));
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 800 ? 3 : 1,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: banners.length,
                  itemBuilder: (context, index) {
                    final banner = banners[index];
                    return Card(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [banner.color1, banner.color2],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(banner.title,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87)),
                                    const SizedBox(height: 8),
                                    Text(banner.subtitle,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54)),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(banner.emoji, style: const TextStyle(fontSize: 40)),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () async {
                                      await ApiService.delete('/banners/${banner.id}');
                                      ref.invalidate(bannersProvider);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => const Center(child: Text('Error')),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddBannerDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final subtitleCtrl = TextEditingController();
    final emojiCtrl = TextEditingController();
    Color c1 = const Color(0xFFFF9A9E);
    Color c2 = const Color(0xFFFECFEF);

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Promotional Banner'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                        controller: titleCtrl,
                        decoration: const InputDecoration(
                            labelText: 'Title (use \n for newline)')),
                    TextField(
                        controller: subtitleCtrl,
                        decoration:
                            const InputDecoration(labelText: 'Subtitle')),
                    TextField(
                        controller: emojiCtrl,
                        decoration: const InputDecoration(
                            labelText: 'Emoji (e.g. 🍔)')),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Color 1: '),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      content: SingleChildScrollView(
                                          child: ColorPicker(
                                              pickerColor: c1,
                                              onColorChanged: (c) =>
                                                  setState(() => c1 = c))),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Done'))
                                      ],
                                    ));
                          },
                          child: Container(width: 40, height: 40, color: c1),
                        ),
                        const SizedBox(width: 16),
                        const Text('Color 2: '),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      content: SingleChildScrollView(
                                          child: ColorPicker(
                                              pickerColor: c2,
                                              onColorChanged: (c) =>
                                                  setState(() => c2 = c))),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Done'))
                                      ],
                                    ));
                          },
                          child: Container(width: 40, height: 40, color: c2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () async {
                    String toHex(Color c) {
                      return '#${c.toARGB32().toRadixString(16).padLeft(8, "0").toUpperCase()}';
                    }

                    await ApiService.post('/banners', {
                      'title': titleCtrl.text.replaceAll('\\n', '\n'),
                      'subtitle': subtitleCtrl.text,
                      'emoji': emojiCtrl.text,
                      'color1': toHex(c1),
                      'color2': toHex(c2),
                    });
                    ref.invalidate(bannersProvider);
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  child: const Text('Save Banner'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _AddShopDialog extends ConsumerStatefulWidget {
  const _AddShopDialog();

  @override
  ConsumerState<_AddShopDialog> createState() => _AddShopDialogState();
}

class _AddShopDialogState extends ConsumerState<_AddShopDialog> {
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final vendorIdController = TextEditingController();
  final imageUrlController = TextEditingController();
  final latController = TextEditingController();
  final lngController = TextEditingController();

  bool _isUploading = false;
  String? _uploadedImageUrl;

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    vendorIdController.dispose();
    imageUrlController.dispose();
    latController.dispose();
    lngController.dispose();
    super.dispose();
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
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Shop image uploaded successfully!')));
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

  @override
  Widget build(BuildContext context) {
    final previewUrl = imageUrlController.text.trim().isNotEmpty
        ? imageUrlController.text.trim()
        : _uploadedImageUrl;

    return AlertDialog(
      title: const Text('Register New Shop'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Consumer(builder: (context, ref, child) {
                final vendorsAsync = ref.watch(usersByRoleProvider('vendor'));
                return vendorsAsync.when(
                  data: (vendors) {
                    if (vendors.isEmpty) {
                      return const Text(
                          'No users with Vendor role found. Change a user\'s role to Vendor first.',
                          style: TextStyle(color: Colors.red));
                    }
                    return DropdownButtonFormField<String>(
                      initialValue: vendorIdController.text.isNotEmpty
                          ? vendorIdController.text
                          : null,
                      decoration: const InputDecoration(
                          labelText: 'Select Vendor Owner'),
                      items: vendors
                          .map((v) => DropdownMenuItem(
                              value: v.id, child: Text(v.name)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            vendorIdController.text = val;
                          });
                        }
                      },
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (e, s) => Text('Error loading vendors: $e'),
                );
              }),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    labelText: 'Shop Name', hintText: 'e.g. Pizza House'),
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                    labelText: 'Category', hintText: 'e.g. Food'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: latController,
                      decoration: const InputDecoration(
                          labelText: 'Latitude', hintText: '22.61'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: lngController,
                      decoration: const InputDecoration(
                          labelText: 'Longitude', hintText: '70.93'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Shop Image URL',
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
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
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
                          icon: const Icon(Icons.close,
                              color: Colors.white, size: 16),
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
                  if (vendorIdController.text.isNotEmpty &&
                      nameController.text.isNotEmpty) {
                    try {
                      final finalImageUrl =
                          imageUrlController.text.trim().isNotEmpty
                              ? imageUrlController.text.trim()
                              : (_uploadedImageUrl ?? '');

                      final response = await ApiService.post('/vendors', {
                        'owner_id': vendorIdController.text.trim(),
                        'name': nameController.text.trim(),
                        'category': categoryController.text.trim(),
                        'rating': 5.0,
                        'is_open': true,
                        'is_active': true,
                        'distance': '1.0 km',
                        'image_url': finalImageUrl,
                        'lat': double.tryParse(latController.text) ?? 0.0,
                        'lng': double.tryParse(lngController.text) ?? 0.0,
                      });
                      if (response.statusCode != 201) {
                        throw Exception('Failed to add shop');
                      }

                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Shop Profile Created Successfully!')));
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    }
                  }
                },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white),
          child: const Text('Create Shop'),
        ),
      ],
    );
  }
}

class _EditShopDialog extends ConsumerStatefulWidget {
  final Vendor vendor;
  const _EditShopDialog({required this.vendor});

  @override
  ConsumerState<_EditShopDialog> createState() => _EditShopDialogState();
}

class _EditShopDialogState extends ConsumerState<_EditShopDialog> {
  late final TextEditingController nameController;
  late final TextEditingController categoryController;
  late final TextEditingController imageUrlController;
  late final TextEditingController latController;
  late final TextEditingController lngController;

  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.vendor.name);
    categoryController = TextEditingController(text: widget.vendor.category);
    imageUrlController = TextEditingController(text: widget.vendor.imageUrl);
    latController = TextEditingController(text: widget.vendor.lat.toString());
    lngController = TextEditingController(text: widget.vendor.lng.toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    imageUrlController.dispose();
    latController.dispose();
    lngController.dispose();
    super.dispose();
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
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Shop image uploaded successfully!')));
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

  @override
  Widget build(BuildContext context) {
    final previewUrl = imageUrlController.text.trim();

    return AlertDialog(
      title: Text('Edit ${widget.vendor.name}'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Shop Name'),
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: latController,
                      decoration: const InputDecoration(labelText: 'Latitude'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: lngController,
                      decoration: const InputDecoration(labelText: 'Longitude'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Shop Image URL',
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
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
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
                          icon: const Icon(Icons.close,
                              color: Colors.white, size: 16),
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
                  if (nameController.text.isNotEmpty) {
                    try {
                      final response =
                          await ApiService.put('/vendors/${widget.vendor.id}', {
                        'name': nameController.text.trim(),
                        'category': categoryController.text.trim(),
                        'image_url': imageUrlController.text.trim(),
                        'is_open': widget.vendor.isOpen,
                        'is_active': widget.vendor.isActive,
                        'lat': double.tryParse(latController.text) ?? 0.0,
                        'lng': double.tryParse(lngController.text) ?? 0.0,
                      });
                      if (response.statusCode != 200) {
                        throw Exception('Failed to update shop');
                      }

                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Shop Updated Successfully!')));
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    }
                  }
                },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white),
          child: const Text('Save Changes'),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard(
      {required this.title,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(value,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsView extends ConsumerStatefulWidget {
  const _SettingsView();

  @override
  ConsumerState<_SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<_SettingsView> {
  final baseFeeCtrl = TextEditingController();
  final platformCommCtrl = TextEditingController();
  final minOrderCtrl = TextEditingController();

  bool maintenanceMode = false;
  bool autoAssignPartners = true;
  bool surgePricing = false;
  bool _isInitialized = false;

  @override
  void dispose() {
    baseFeeCtrl.dispose();
    platformCommCtrl.dispose();
    minOrderCtrl.dispose();
    super.dispose();
  }

  void _saveSettings() async {
    try {
      await ApiService.post('/settings', {
        'baseDeliveryFee': baseFeeCtrl.text,
        'platformCommission': platformCommCtrl.text,
        'minimumOrderValue': minOrderCtrl.text,
        'maintenanceMode': maintenanceMode,
        'autoAssignPartners': autoAssignPartners,
        'surgePricing': surgePricing,
      });
      ref.invalidate(settingsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Settings Saved Successfully!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Failed to save settings: ')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);

    return settingsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => const Center(child: Text('Error: ')),
      data: (settings) {
        if (!_isInitialized) {
          baseFeeCtrl.text = settings.baseDeliveryFee;
          platformCommCtrl.text = settings.platformCommission;
          minOrderCtrl.text = settings.minimumOrderValue;
          maintenanceMode = settings.maintenanceMode;
          autoAssignPartners = settings.autoAssignPartners;
          surgePricing = settings.surgePricing;
          _isInitialized = true;
        }

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('App Settings',
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Card(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.local_shipping,
                                      color: Colors.deepOrange),
                                  SizedBox(width: 8),
                                  Text('Delivery & Commissions',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 24),
                              TextField(
                                controller: baseFeeCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Base Delivery Fee (₹)',
                                  prefixIcon: Icon(Icons.currency_rupee),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: platformCommCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Platform Commission (%)',
                                  prefixIcon: Icon(Icons.percent),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: minOrderCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Minimum Order Value (₹)',
                                  prefixIcon:
                                      Icon(Icons.shopping_cart_checkout),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Card(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.admin_panel_settings,
                                      color: Colors.deepPurple),
                                  SizedBox(width: 8),
                                  Text('System Controls',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Material(type: MaterialType.transparency, child: SwitchListTile(
                                title: const Text('App Maintenance Mode',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: const Text(
                                    'Temporarily disable ordering for all customers.'),
                                value: maintenanceMode,
                                activeThumbColor: Colors.red,
                                onChanged: (val) =>
                                    setState(() => maintenanceMode = val),
                              )),
                              const Divider(),
                              Material(type: MaterialType.transparency, child: SwitchListTile(
                                title: const Text(
                                    'Auto-Assign Delivery Partners',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: const Text(
                                    'Automatically ping nearby riders when order is ready.'),
                                value: autoAssignPartners,
                                activeThumbColor: Colors.green,
                                onChanged: (val) =>
                                    setState(() => autoAssignPartners = val),
                              )),
                              const Divider(),
                              Material(type: MaterialType.transparency, child: SwitchListTile(
                                title: const Text('Surge Pricing (Peak Hours)',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: const Text(
                                    'Apply 1.5x delivery fee automatically during high demand.'),
                                value: surgePricing,
                                activeThumbColor: Colors.deepOrange,
                                onChanged: (val) =>
                                    setState(() => surgePricing = val),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48, vertical: 18),
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.save),
                    label: const Text('Save All Settings',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    onPressed: _saveSettings,
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}
