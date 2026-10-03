// lib/features/customer/screens/vendor_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vendor_model.dart';
import '../repositories/item_repository.dart';
import '../models/item_model.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';
import 'item_options_bottom_sheet.dart';

class VendorDetailsScreen extends ConsumerWidget {
  final Vendor vendor;

  const VendorDetailsScreen({super.key, required this.vendor});

  void _handleAdd(BuildContext context, WidgetRef ref, Item item, ItemVariant? variant, List<ItemAddon> addons) {
    final currentVendorId = ref.read(currentCartVendorIdProvider);
    if (currentVendorId != null && currentVendorId != vendor.id) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Clear cart?'),
          content: const Text('Your cart contains items from another shop. Do you want to clear the cart and add this item?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                ref.read(cartProvider.notifier).clearCart();
                ref.read(currentCartVendorIdProvider.notifier).state = vendor.id;
                ref.read(currentCartVendorNameProvider.notifier).state = vendor.name;
                ref.read(cartProvider.notifier).addItem(item, variant: variant, addons: addons);
                Navigator.pop(context);
              },
              child: const Text('Clear & Add'),
            ),
          ],
        )
      );
      return;
    }

    ref.read(currentCartVendorIdProvider.notifier).state = vendor.id;
    ref.read(currentCartVendorNameProvider.notifier).state = vendor.name;
    ref.read(cartProvider.notifier).addItem(item, variant: variant, addons: addons);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} added to cart!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showProductDetails(BuildContext context, WidgetRef ref, Item item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'item_img_${item.id}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    child: item.imageUrl.isNotEmpty
                        ? Image.network(item.imageUrl, height: 350, width: double.infinity, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(height: 350, color: Colors.grey.shade200, child: const Icon(Icons.fastfood, size: 80)))
                        : Container(height: 350, color: Colors.grey.shade200, child: const Icon(Icons.fastfood, size: 80, color: Colors.grey)),
                  ),
                ),
                Positioned(
                  top: 0, left: 0, right: 0,
                  height: 120,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
                      ),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                  ),
                ),
                Positioned(
                  top: 24,
                  right: 24,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 24),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.stop_circle_outlined, color: item.name.toLowerCase().contains('chicken') || item.name.toLowerCase().contains('mutton') || item.name.toLowerCase().contains('egg') || item.name.toLowerCase().contains('fish') ? Colors.red : Colors.green, size: 24),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade50,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text('BESTSELLER', style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(item.name, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1, height: 1.1)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text('Rs. ${item.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.deepOrange)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          _buildDetailChip(Icons.local_fire_department, '450 kcal', Colors.orange),
                          const SizedBox(width: 12),
                          _buildDetailChip(Icons.timer, '15-20 min', Colors.blue),
                          const SizedBox(width: 12),
                          _buildDetailChip(Icons.star, '4.8 rating', Colors.amber),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(height: 1, color: Color(0xFFEEEEEE)),
                      const SizedBox(height: 24),
                      const Text('About this item', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Text(
                        'Delicious ${item.name} freshly prepared with premium ingredients. A perfect choice to satisfy your cravings! Our chefs take special care to ensure the authentic taste and quality you expect.',
                        style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.6),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, -10), blurRadius: 20)],
              ),
              child: ElevatedButton(
                onPressed: item.isAvailable ? () {
                  Navigator.pop(context); // Close details sheet
                  if (item.variants.isNotEmpty || item.addons.isNotEmpty) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => ItemOptionsBottomSheet(item: item, onAdd: (v, a) => _handleAdd(context, ref, item, v, a)),
                    );
                  } else {
                    _handleAdd(context, ref, item, null, []);
                  }
                } : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.isAvailable ? Icons.shopping_bag_outlined : Icons.block, size: 24),
                    const SizedBox(width: 12),
                    Text(item.isAvailable ? 'ADD TO CART' : 'OUT OF STOCK', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(vendorItemsProvider(vendor.id));
    final cartItems = ref.watch(cartProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(vendor.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black54, blurRadius: 4)])),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  vendor.imageUrl.isNotEmpty
                      ? Image.network(vendor.imageUrl, fit: BoxFit.cover)
                      : Container(color: Colors.deepOrange.shade300, child: const Icon(Icons.store, size: 80, color: Colors.white)),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 20),
                  const SizedBox(width: 4),
                  Text('${vendor.rating} Rating', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(width: 16),
                  const Icon(Icons.timer, color: Colors.grey, size: 20),
                  const SizedBox(width: 4),
                  const Text('30-40 mins', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey)),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: Divider(thickness: 8, color: Color(0xFFF5F5F5))),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text('Recommended', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
          ),
          itemsAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(32.0), child: Center(child: Text('No items available in this shop yet.', style: TextStyle(fontSize: 16)))));
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = items[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 15,
                            spreadRadius: 0,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () => _showProductDetails(context, ref, item),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.stop_circle_outlined, color: item.name.toLowerCase().contains('chicken') || item.name.toLowerCase().contains('mutton') || item.name.toLowerCase().contains('egg') || item.name.toLowerCase().contains('fish') ? Colors.red : Colors.green, size: 20),
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.orange.shade50,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text('BESTSELLER', style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(item.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                                      const SizedBox(height: 6),
                                      Text('Rs. ${item.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.deepOrange)),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Freshly prepared ${item.name} with premium ingredients. Tap to view product details.',
                                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Hero(
                                      tag: 'item_img_${item.id}',
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: item.imageUrl.isNotEmpty
                                            ? Image.network(item.imageUrl, width: 140, height: 140, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: 140, height: 140, color: Colors.grey.shade100, child: const Icon(Icons.fastfood, color: Colors.grey)))
                                            : Container(width: 140, height: 140, color: Colors.grey.shade100, child: const Icon(Icons.fastfood, color: Colors.grey)),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: -15,
                                      child: GestureDetector(
                                        onTap: item.isAvailable ? () {
                                          if (item.variants.isNotEmpty || item.addons.isNotEmpty) {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor: Colors.transparent,
                                              builder: (context) => ItemOptionsBottomSheet(item: item, onAdd: (v, a) => _handleAdd(context, ref, item, v, a)),
                                            );
                                          } else {
                                            _handleAdd(context, ref, item, null, []);
                                          }
                                        } : null,
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          width: 110,
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          decoration: BoxDecoration(
                                            color: item.isAvailable ? Colors.white : Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: [
                                              if (item.isAvailable)
                                                BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              item.isAvailable ? 'ADD' : 'OUT',
                                              style: TextStyle(color: item.isAvailable ? Colors.green.shade700 : Colors.red, fontWeight: FontWeight.w900, fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: items.length,
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator()))),
            error: (e, s) => SliverToBoxAdapter(child: Center(child: Text('Error loading items: $e'))),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)), // Space for floating cart
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: cartItems.isNotEmpty
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
                },
                backgroundColor: Colors.deepOrange,
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                label: Row(
                  children: [
                    Text(
                      '${cartItems.length} items',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    const Text('|', style: TextStyle(color: Colors.white54)),
                    const SizedBox(width: 8),
                    const Text('View Cart', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
