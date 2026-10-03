// lib/features/auth/screens/customer_home_screen.dart
import '../../customer/screens/customer_orders_screen.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../customer/screens/checkout_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../customer/screens/vendor_details_screen.dart';

import '../../customer/providers/vendor_provider.dart';
import '../../customer/providers/cart_provider.dart';
import '../../customer/providers/favorites_provider.dart';
import '../../customer/providers/address_provider.dart';
import '../../customer/repositories/order_repository.dart';
import '../providers/auth_provider.dart';
import '../repositories/auth_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/widgets/notification_bell.dart';
import '../../../core/widgets/settings_bottom_sheet.dart';
import '../../customer/providers/banner_provider.dart';

class CustomerHomeScreen extends ConsumerStatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  ConsumerState<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;
  String _selectedSort = 'Rating: High to Low';
  bool _isPureVeg = false;
  bool _isNonVeg = false;
  Position? _userPosition;
  Timer? _bannerTimer;
  final PageController _bannerController =
      PageController(viewportFraction: 0.9);

  @override
  void initState() {
    super.initState();
    _startBannerTimer();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      final position = await Geolocator.getCurrentPosition();
      if (mounted) setState(() => _userPosition = position);
    }
  }

  
  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_bannerController.hasClients) {
        int nextPage = _bannerController.page!.round() + 1;
        final length = ref.read(bannersProvider).value?.length ?? 2;
        if (nextPage >= length) {
          nextPage = 0;
        }
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bannerController.dispose();
    _bannerTimer?.cancel();
    super.dispose();
  }

  void _setSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _searchController.text = query;
    });
  }

  void _showFilterSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) {
          return StatefulBuilder(builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sort & Filter',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  const Text('Sort By',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 8),
                  RadioGroup<String>(
                    groupValue: _selectedSort,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedSort = val);
                        setSheetState(() => _selectedSort = val);
                        Navigator.pop(context);
                      }
                    },
                    child: const Column(
                      children: [
                        Material(type: MaterialType.transparency, child: RadioListTile<String>(
                          title: Text('Rating: High to Low'),
                          value: 'Rating: High to Low',
                        )),
                        Material(type: MaterialType.transparency, child: RadioListTile<String>(
                          title: Text('Fastest Delivery'),
                          value: 'Fastest Delivery',
                        )),
                      ],
                    ),
                  ),
                  const Text('Food Preference',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Material(type: MaterialType.transparency, child: SwitchListTile(
                    title: const Row(children: [
                      Icon(Icons.eco, color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Text('Pure Veg')
                    ]),
                    value: _isPureVeg,
                    activeThumbColor: Colors.green,
                    onChanged: (val) {
                      setState(() => _isPureVeg = val);
                      if (val) setState(() => _isNonVeg = false);
                      setSheetState(() {});
                    },
                  )),
                  Material(type: MaterialType.transparency, child: SwitchListTile(
                    title: const Row(children: [
                      Icon(Icons.kebab_dining, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text('Non-Veg Available')
                    ]),
                    value: _isNonVeg,
                    activeThumbColor: Colors.red,
                    onChanged: (val) {
                      setState(() => _isNonVeg = val);
                      if (val) setState(() => _isPureVeg = false);
                      setSheetState(() {});
                    },
                  )),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  void _showAddressSelector(WidgetRef ref) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select an Address',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Material(type: MaterialType.transparency, child: ListTile(
                  leading:
                      const Icon(Icons.my_location, color: Colors.deepOrange),
                  title: const Text('Use current location',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange)),
                  onTap: () {
                    // Setup GPS logic
                    Navigator.pop(context);
                  },
                )),
                const Divider(),
                Consumer(
                  builder: (context, ref, child) {
                    final addressesAsync = ref.watch(customerAddressesProvider);
                    return addressesAsync.when(
                      data: (addresses) {
                        return Column(
                          children: addresses
                              .map((addr) => Material(type: MaterialType.transparency, child: ListTile(
                                    leading:
                                        const Icon(Icons.location_on_outlined),
                                    title: Text(addr.title),
                                    subtitle: Text(addr.address),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  )))
                              .toList(),
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (_, __) => const Text('Error loading addresses'),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final vendorsAsync = ref.watch(activeNearbyVendorsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: GestureDetector(
          onTap: () {
            _showAddressSelector(ref);
          },
          child: Row(
            children: [
              const Icon(Icons.location_on, color: Colors.deepOrange, size: 28),
              const SizedBox(width: 8),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final userStream = ref.watch(currentUserStreamProvider);
                    
                    return userStream.when(
                      data: (user) {
                        if (user == null || user.savedAddresses == null || user.savedAddresses!.isEmpty) {
                          return const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('Select Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                                  Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.deepOrange),
                                ],
                              ),
                              Text('Add an address to deliver', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                            ],
                          );
                        }

                        final address = user.savedAddresses!.firstWhere(
                          (a) => a.isDefault, 
                          orElse: () => user.savedAddresses!.first
                        );

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(address.label.isNotEmpty ? address.label : 'Current Location', 
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.deepOrange),
                              ],
                            ),
                            Text('${address.fullAddress}, ${address.city}', 
                              style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        );
                      },
                      loading: () => const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text('Locating...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                           Text('Fetching your location...', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      error: (err, stack) => const Text('Location Error'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          const NotificationBell(),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.grey.shade100,
            child: IconButton(
              icon: const Icon(Icons.receipt_long, color: Colors.black87),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CustomerOrdersScreen()),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          Consumer(
            builder: (context, ref, child) {
              final cart = ref.watch(cartProvider);
              final itemCount =
                  cart.fold<int>(0, (sum, item) => sum + item.quantity);
              return CircleAvatar(
                backgroundColor: Colors.grey.shade100,
                child: IconButton(
                  icon: Badge(
                    isLabelVisible: itemCount > 0,
                    label: Text(itemCount.toString()),
                    child:
                        const Icon(Icons.shopping_cart, color: Colors.black87),
                  ),
                  onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CheckoutScreen(totalAmount: cart.fold<double>(0, (sum, i) => sum + (i.unitPrice * i.quantity)))),
                      );
                    },
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.grey.shade100,
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.black87),
              onPressed: () => showSettings(context),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.grey.shade100,
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.red),
              onPressed: () async {
                await ref.read(authRepositoryProvider).signOut();
              },
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGreeting(ref),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 10,
                            offset: const Offset(0, 4)),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) =>
                          setState(() => _searchQuery = value.toLowerCase()),
                      decoration: InputDecoration(
                        hintText: 'Search for restaurants, groceries...',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.deepOrange),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon:
                                    const Icon(Icons.clear, color: Colors.grey),
                                onPressed: () => _setSearchQuery(''))
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                      height: 24,
                                      child:
                                          VerticalDivider(color: Colors.grey)),
                                  IconButton(
                                    icon: const Icon(Icons.tune,
                                        color: Colors.deepOrange),
                                    onPressed: () {
                                      _showFilterSheet();
                                    },
                                  ),
                                  const SizedBox(width: 4),
                                ],
                              ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ),

                if (_searchQuery.isEmpty) ...[
                  // Promos
                  SizedBox(
                      height: 160,
                      child: ref.watch(bannersProvider).when(
                        data: (banners) {
                          if (banners.isEmpty) return const SizedBox.shrink();
                          return PageView(
                            controller: _bannerController,
                            children: banners.map((b) => _PromoBanner(
                                  title: b.title,
                                  subtitle: b.subtitle,
                                  colors: [b.color1, b.color2],
                                  emoji: b.emoji,
                                )).toList(),
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ),
                  const SizedBox(height: 24),
                  _buildQuickReorder(ref),
                  const SizedBox(height: 24),

                  // Explore Categories
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'What\'s on your mind?',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        _EmojiCategory(
                          emoji: '🍕',
                          label: 'Pizza',
                          isSelected: _selectedCategory == 'Pizza',
                          onTap: () => setState(() => _selectedCategory =
                              _selectedCategory == 'Pizza' ? null : 'Pizza'),
                        ),
                        _EmojiCategory(
                          emoji: '🍔',
                          label: 'Burger',
                          isSelected: _selectedCategory == 'Burger',
                          onTap: () => setState(() => _selectedCategory =
                              _selectedCategory == 'Burger' ? null : 'Burger'),
                        ),
                        _EmojiCategory(
                          emoji: '🍚',
                          label: 'Biryani',
                          isSelected: _selectedCategory == 'Biryani',
                          onTap: () => setState(() => _selectedCategory =
                              _selectedCategory == 'Biryani'
                                  ? null
                                  : 'Biryani'),
                        ),
                        _EmojiCategory(
                          emoji: '🍰',
                          label: 'Cake',
                          isSelected: _selectedCategory == 'Cake',
                          onTap: () => setState(() => _selectedCategory =
                              _selectedCategory == 'Cake' ? null : 'Cake'),
                        ),
                        _EmojiCategory(
                          emoji: '🥦',
                          label: 'Healthy',
                          isSelected: _selectedCategory == 'Healthy',
                          onTap: () => setState(() => _selectedCategory =
                              _selectedCategory == 'Healthy'
                                  ? null
                                  : 'Healthy'),
                        ),
                        _EmojiCategory(
                          emoji: '☕',
                          label: 'Coffee',
                          isSelected: _selectedCategory == 'Coffee',
                          onTap: () => setState(() => _selectedCategory =
                              _selectedCategory == 'Coffee' ? null : 'Coffee'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Divider(thickness: 8, color: Colors.grey.shade50),
                  const SizedBox(height: 16),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Restaurants to explore',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // If searching, just show a title
                if (_searchQuery.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Search Results for "$_searchQuery"',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),

          // Vendors List
          vendorsAsync.when(
            data: (vendors) {
              final filteredVendors = vendors.where((v) {
                final matchedItems = v.items
                    .where((i) => (i['name'] ?? '')
                        .toString()
                        .toLowerCase()
                        .contains(_searchQuery))
                    .toList();
                final matchesSearch = _searchQuery.isEmpty ||
                    v.name.toLowerCase().contains(_searchQuery) ||
                    v.category.toLowerCase().contains(_searchQuery) ||
                    matchedItems.isNotEmpty;

                                final matchesCategory = _selectedCategory == null ||
                    v.category
                        .toLowerCase()
                        .contains(_selectedCategory!.toLowerCase()) ||
                    v.items.any((item) => 
                        (item['name'] ?? '').toString().toLowerCase().contains(_selectedCategory!.toLowerCase()) ||
                        (item['category'] ?? '').toString().toLowerCase().contains(_selectedCategory!.toLowerCase()));

                // Demo logic: Since we don't have isPureVeg on Vendor model, we mock it based on category string
                bool matchesVeg = true;
                if (_isPureVeg) {
                  matchesVeg = v.category.toLowerCase().contains('veg') &&
                      !v.category.toLowerCase().contains('non-veg');
                } else if (_isNonVeg) {
                  matchesVeg = v.category.toLowerCase().contains('non-veg') ||
                      v.category.toLowerCase().contains('chicken') ||
                      v.category.toLowerCase().contains('meat');
                }

                return matchesSearch && matchesCategory && matchesVeg;
              }).toList();

              if (_selectedSort == 'Rating: High to Low') {
                filteredVendors.sort((a, b) => b.rating.compareTo(a.rating));
              } else if (_selectedSort == 'Fastest Delivery') {
                // Since real ETA depends on GPS we don't have here perfectly, we can just sort by distance as proxy or a random mock.
                // Assuming vendor.distance is a string like "2.5 km", we can extract the number.
                filteredVendors.sort((a, b) {
                  final aDist =
                      double.tryParse(a.distance.split(' ').first) ?? 0.0;
                  final bDist =
                      double.tryParse(b.distance.split(' ').first) ?? 0.0;
                  return aDist.compareTo(bDist);
                });
              }

              if (filteredVendors.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(48.0),
                      child: Column(
                        children: [
                          Icon(Icons.search_off,
                              size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text('No restaurants found.',
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final vendor = filteredVendors[index];
                      return _FadeInSlide(
                        duration:
                            Duration(milliseconds: 300 + (index % 5) * 100),
                        child: _BouncyCard(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      VendorDetailsScreen(vendor: vendor)),
                            );
                          },
                          child: _ModernShopCard(
                              vendor: vendor,
                              userPosition: _userPosition,
                              searchQuery: _searchQuery),
                        ),
                      );
                    },
                    childCount: filteredVendors.length,
                  ),
                ),
              );
            },
            loading: () => SliverToBoxAdapter(child: _buildShimmerLoading()),
            error: (error, stack) =>
                SliverToBoxAdapter(child: Center(child: Text('Error: $error'))),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  
  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Widget _buildGreeting(WidgetRef ref) {
    final userAsync = ref.watch(currentUserStreamProvider);
    return userAsync.when(
      data: (user) {
        if (user == null) return const SizedBox.shrink();
        final firstName = user.name.split(' ').first;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${_getGreeting()}, $firstName!', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: Colors.black87)),
              const SizedBox(height: 4),
              const Text('Feeling hungry? We got you.', style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(16.0),
        child: SizedBox(height: 40, width: 200, child: Placeholder(color: Colors.transparent)),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildQuickReorder(WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    if (user == null) return const SizedBox.shrink();

    final ordersAsync = ref.watch(customerOrdersProvider(user));

    return ordersAsync.when(
      data: (orders) {
        final deliveredOrders =
            orders.where((o) => o.status == 'delivered').take(3).toList();
        if (deliveredOrders.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Order it again',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5)),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: deliveredOrders.length,
                itemBuilder: (context, index) {
                  final order = deliveredOrders[index];
                  // Display the first item's name as summary
                  final itemName = order.items.isNotEmpty
                      ? order.items.first['name']
                      : 'Items';
                  return Container(
                    width: 220,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.history,
                                color: Colors.deepOrange, size: 16),
                            const SizedBox(width: 4),
                            Text('₹${order.totalAmount.toStringAsFixed(0)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                            child: Text(
                                '$itemName ${order.items.length > 1 ? '+ ${order.items.length - 1} more' : ''}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis)),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 0)),
                            onPressed: () {
                              // Clear cart and add these items
                              final cart = ref.read(cartProvider.notifier);
                              cart.clearCart();
                              // or re-construct the cart. Since we don't have the full item model, we will just navigate to VendorDetails Screen
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Quick Reorder: Please visit the shop to re-add items.')));
                            },
                            child: const Text('Reorder'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: List.generate(
            3,
            (index) => Shimmer.fromColors(
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.white,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    height: 220,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)),
                  ),
                )),
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Color> colors;
  final String emoji;

  const _PromoBanner(
      {required this.title,
      required this.subtitle,
      required this.colors,
      required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        height: 1.1)),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(subtitle,
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Text(emoji, style: const TextStyle(fontSize: 70)),
        ],
      ),
    );
  }
}

class _EmojiCategory extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const _EmojiCategory(
      {required this.emoji,
      required this.label,
      this.isSelected = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.deepOrange.shade100
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: Colors.deepOrange, width: 2)
                    : null,
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 32)),
              ),
            ),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.deepOrange : Colors.black87,
                    fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _FadeInSlide extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const _FadeInSlide({required this.child, required this.duration});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: child,
    );
  }
}

class _BouncyCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _BouncyCard({required this.child, required this.onTap});

  @override
  State<_BouncyCard> createState() => _BouncyCardState();
}

class _BouncyCardState extends State<_BouncyCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTap: () {
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

class _ModernShopCard extends ConsumerWidget {
  final dynamic vendor;
  final Position? userPosition;
  final String searchQuery;

  const _ModernShopCard(
      {required this.vendor, this.userPosition, this.searchQuery = ''});


  String _calculateDistanceString() {
    if (userPosition == null || vendor.lat == 0 || vendor.lng == 0) {
      return vendor.distance; // Fallback to database string if GPS missing
    }
    final distanceInMeters = Geolocator.distanceBetween(
      userPosition!.latitude,
      userPosition!.longitude,
      vendor.lat,
      vendor.lng,
    );
    final distanceInKm = distanceInMeters / 1000;
    return '${distanceInKm.toStringAsFixed(1)} km';
  }

  int _calculateEta() {
    if (userPosition == null || vendor.lat == 0 || vendor.lng == 0) {
      return 30; // fallback default
    }
    final distanceInMeters = Geolocator.distanceBetween(
      userPosition!.latitude,
      userPosition!.longitude,
      vendor.lat,
      vendor.lng,
    );
    // Assume 20km/h speed for delivery + 15 mins prep time
    final travelTimeMins = (distanceInMeters / 1000) / 20 * 60;
    return (15 + travelTimeMins).round();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eta = _calculateEta();
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.contains(vendor.id);

    int matchingProductsCount = 0;
    if (searchQuery.isNotEmpty) {
      matchingProductsCount = vendor.items
          .where((i) =>
              (i['name'] ?? '').toString().toLowerCase().contains(searchQuery))
          .length;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: vendor.imageUrl.isNotEmpty
                    ? Image.network(
                        vendor.imageUrl,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
              if (!vendor.isOpen)
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: const Center(
                    child: Text('CLOSED',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2)),
                  ),
                ),
              // Promo Badge overlay
              if (vendor.isPromoted)
                Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4)
                    ],
                  ),
                  child: const Text('PROMOTED',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5)),
                ),
              ),
              // Discount Tag overlay
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8)
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer,
                          size: 16, color: Colors.deepOrange),
                      const SizedBox(width: 4),
                      Text('$eta mins',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              // Favorite Button
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    ref
                        .read(favoritesProvider.notifier)
                        .toggleFavorite(vendor.id);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 18,
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey.shade400,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        vendor.name,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Text(vendor.reviewCount == 0 ? 'New' : vendor.rating.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(width: 4),
                          const Icon(Icons.star, color: Colors.white, size: 12),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.restaurant_menu,
                        size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(vendor.category,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 14)),
                    const SizedBox(width: 12),
                    const Text('•', style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 12),
                    Icon(Icons.location_on,
                        size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(_calculateDistanceString(),
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.local_offer,
                        size: 16, color: Colors.purple.shade300),
                    const SizedBox(width: 8),
                    Text('50% off up to ₹100',
                        style: TextStyle(
                            color: Colors.purple.shade300,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                  ],
                ),
                if (matchingProductsCount > 0) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        color: Colors.deepOrange.shade50,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search,
                            size: 14, color: Colors.deepOrange),
                        const SizedBox(width: 6),
                        Text('$matchingProductsCount products available inside',
                            style: const TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade200, Colors.grey.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storefront, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text('No Image Available',
                style: TextStyle(
                    color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
