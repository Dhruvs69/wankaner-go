// lib/features/customer/screens/customer_orders_screen.dart
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api_service.dart';
import '../repositories/order_repository.dart';
import '../../auth/providers/auth_provider.dart';
import 'review_screen.dart';

class CustomerOrdersScreen extends ConsumerWidget {
  const CustomerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authStateProvider).value;

    if (userId == null || userId.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Orders')),
        body: const Center(child: Text('Please log in to view orders')),
      );
    }

    final ordersAsync = ref.watch(customerOrdersProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('You have no past orders.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Order #${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: order.status == 'pending'
                                  ? Colors.orange.withValues(alpha: 0.2)
                                  : Colors.green.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              order.status.toUpperCase(),
                              style: TextStyle(
                                color: order.status == 'pending'
                                    ? Colors.orange
                                    : Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      ...order.items.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${item['quantity']}x ${item['name']}'),
                                Text('₹${item['price'] * item['quantity']}'),
                              ],
                            ),
                          )),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('₹${order.totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      if (order.status == 'delivered') ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReviewScreen(
                                    vendorId: order.vendorId,
                                    orderId: order.id,
                                    vendorName: order.vendorName.isNotEmpty
                                        ? order.vendorName
                                        : 'Shop',
                                  ),
                                ),
                              );
                            },
                            child: const Text('Leave a Review'),
                          ),
                        ),
                      ] else if (order.status != 'cancelled') ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.blue, size: 20),
                                  const SizedBox(width: 8),
                                  const Text('Live Tracking',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue)),
                                  const Spacer(),
                                  Text(
                                    order.status == 'delivered' ? 'Delivered' : 'ETA: ${ (30 - DateTime.now().difference(order.createdAt).inMinutes).clamp(1, 45) } mins',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Delivery PIN and Tracking
                              if (order.deliveryOtp != null && order.status != 'delivered') ...[
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.amber.shade400),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.lock_outline, color: Colors.orange),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Give this PIN to the delivery rider: ${order.deliveryOtp}',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],
                              if (order.deliveryPartnerId != null)
                                LiveTrackingWidget(deliveryPartnerId: order.deliveryPartnerId!)
                              else
                                Container(
                                  height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Text('Waiting for a rider to be assigned...'),
                                  ),
                                ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () async {
                                        final uri = Uri.parse('whatsapp://send?phone=+917383855568&text=Hi, I need help with Order #${order.id}');
                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(uri);
                                        } else {
                                          // Fallback to regular url if whatsapp isn't installed
                                          await launchUrl(Uri.parse('https://wa.me/917383855568?text=Hi, I need help with Order #${order.id}'));
                                        }
                                      },
                                      icon: const Icon(Icons.chat, size: 16),
                                      label: const Text('Chat'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white),
                                      onPressed: () async {
                                        final uri = Uri.parse('tel:+917383855568');
                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(uri);
                                        }
                                      },
                                      icon: const Icon(Icons.call, size: 16),
                                      label: const Text('Call'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error loading orders: $e')),
      ),
    );
  }
}

class LiveTrackingWidget extends StatefulWidget {
  final String deliveryPartnerId;
  const LiveTrackingWidget({super.key, required this.deliveryPartnerId});

  @override
  State<LiveTrackingWidget> createState() => _LiveTrackingWidgetState();
}

class _LiveTrackingWidgetState extends State<LiveTrackingWidget> {
  Map<String, dynamic>? riderData;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchRider();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => _fetchRider());
  }

  Future<void> _fetchRider() async {
    try {
      final response = await ApiService.get('/users?role=delivery');
      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);
        final rider = users.firstWhere((u) => u['id'] == widget.deliveryPartnerId, orElse: () => null);
        if (mounted && rider != null) {
          setState(() {
            riderData = rider;
          });
        }
      }
    } catch (e) {
      // Ignore
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (riderData == null || riderData!['current_lat'] == null || riderData!['current_lng'] == null) {
      return Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text('Finding rider location...'),
        ),
      );
    }

    final double lat = (riderData!['current_lat'] is int) ? (riderData!['current_lat'] as int).toDouble() : riderData!['current_lat'] as double;
    final double lng = (riderData!['current_lng'] is int) ? (riderData!['current_lng'] as int).toDouble() : riderData!['current_lng'] as double;
    
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(lat, lng),
            initialZoom: 15.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.wankaner.go',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(lat, lng),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.delivery_dining, color: Colors.blue, size: 40),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
