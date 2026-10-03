import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../repositories/auth_repository.dart';
import '../../customer/repositories/order_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/widgets/notification_bell.dart';
import '../../../core/widgets/settings_bottom_sheet.dart';
import '../../../core/api_service.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
class DeliveryHomeScreen extends ConsumerStatefulWidget {
  const DeliveryHomeScreen({super.key});

  @override
  ConsumerState<DeliveryHomeScreen> createState() => _DeliveryHomeScreenState();
}

class _DeliveryHomeScreenState extends ConsumerState<DeliveryHomeScreen> {
  int _currentIndex = 0;
  bool _isOnline = true;
  String? _updatingOrderId;
  final Set<String> _optimisticPickedUp = {};
  final Set<String> _optimisticDelivered = {};
  Timer? _locationTimer;

  @override
  void initState() {
    super.initState();
    _startLocationTimer();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  void _startLocationTimer() {
    _locationTimer?.cancel();
    _locationTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (!_isOnline) return;
      double lat = 22.6174;
      double lng = 70.9366;
      try {
        final permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
          final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          lat = pos.latitude;
          lng = pos.longitude;
        }
      } catch (_) {}
      
      try {
        final myPartnerId = ref.read(authStateProvider).value ?? '';
        if (myPartnerId.isEmpty) return;
        await ApiService.put('/users/$myPartnerId/location', {
          'lat': lat,
          'lng': lng,
          'is_online': _isOnline,
        });
      } catch (e) {
        debugPrint('Error updating location: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final myPartnerId = ref.watch(authStateProvider).value ?? '';
    final deliveryOrdersAsync = ref.watch(deliveryOrdersProvider(myPartnerId));
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.deepOrange,
              child: Icon(Icons.delivery_dining, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                currentUserAsync.when(
                  data: (user) => Text('Hi, ${user?.name ?? 'Partner'}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  loading: () => const Text('Hi, Partner',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  error: (_, __) => const Text('Hi, Partner',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
                Row(
                  children: [
                    Icon(Icons.circle,
                        size: 10,
                        color: _isOnline ? Colors.green : Colors.grey),
                    const SizedBox(width: 4),
                    Text(_isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                            color: _isOnline ? Colors.green : Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          const NotificationBell(),
          const SizedBox(width: 8),
          Switch(
            value: _isOnline,
            activeTrackColor: Colors.green.shade200,
            thumbColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) return Colors.green;
              return Colors.grey;
            }),
            onChanged: (val) async {
              setState(() => _isOnline = val);
              try {
                if (myPartnerId.isNotEmpty) { await ApiService.put('/users/$myPartnerId/location', {
                  'lat': 22.6174,
                  'lng': 70.9366,
                  'is_online': val ? 1 : 0,
                }); }
              } catch (_) {}
              
              if (!val) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Shift Ended. Active time: 4h 30m.')));
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Shift Started! Stay safe.')));
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black54),
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
      body: _isOnline
          ? deliveryOrdersAsync.when(
              data: (orders) {
                final activeOrders = orders
                    .where((o) =>
                        o.status != 'delivered' && o.status != 'cancelled')
                    .toList();
                final completedOrders =
                    orders.where((o) => o.status == 'delivered').toList();

                if (_currentIndex == 0) {
                  return RefreshIndicator(
                    color: Colors.deepOrange,
                    onRefresh: () async =>
                        ref.refresh(deliveryOrdersProvider(myPartnerId)),
                    child: _buildActiveDeliveries(activeOrders),
                  );
                } else {
                  return _buildEarningsAndHistory(completedOrders);
                }
              },
              loading: () => const Center(
                  child: CircularProgressIndicator(color: Colors.deepOrange)),
              error: (e, s) => Center(child: Text('Error: $e')),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bedtime, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text('You are currently offline.',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Go online to start receiving orders.',
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade500)),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 10,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.moped), label: 'Active'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet), label: 'Earnings'),
        ],
      ),
    );
  }

  Widget _buildActiveDeliveries(List orders) {
    if (orders.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          Center(
            child: Column(
              children: [
                Icon(Icons.check_circle_outline,
                    size: 80, color: Colors.green.shade300),
                const SizedBox(height: 16),
                const Text('No active deliveries right now.',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Waiting for new orders...',
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final isPickedUp = order.status == 'picked up' ||
            _optimisticPickedUp.contains(order.id);

        if (_optimisticDelivered.contains(order.id)) {
          return const SizedBox.shrink();
        }

        return Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                          '#${order.id.length > 8 ? order.id.substring(0, 8).toUpperCase() : order.id.toUpperCase()}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isPickedUp
                            ? Colors.orange.shade100
                            : Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        order.status.toUpperCase(),
                        style: TextStyle(
                            color: isPickedUp
                                ? Colors.orange.shade800
                                : Colors.blue.shade800,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Location Timeline
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.storefront,
                            color: Colors.blue, size: 24),
                        Container(
                            height: 30,
                            width: 2,
                            color: Colors.grey.shade300,
                            margin: const EdgeInsets.symmetric(vertical: 4)),
                        const Icon(Icons.location_on,
                            color: Colors.red, size: 24),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('PICKUP',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey)),
                          Text(
                              order.vendorName.isNotEmpty
                                  ? order.vendorName
                                  : 'Wankaner Supermart',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 18),
                          const Text('DROPOFF',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey)),
                          Text(
                              order.customerName.isNotEmpty
                                  ? '${order.customerName} (${order.customerId})'
                                  : 'Customer (${order.customerId})',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          if (order.deliveryAddress.isNotEmpty)
                            Text(order.deliveryAddress,
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 13),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
                const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider()),

                // Items
                const Text('ORDER ITEMS',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                const SizedBox(height: 4),
                ...order.items.map((item) {
                  final mapItem = item as dynamic;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(4)),
                          child: Text('${mapItem['quantity']}x',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Text('${mapItem['name']}',
                                style: const TextStyle(fontSize: 14))),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 12),

                // Cash Collect
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.payments, color: Colors.green, size: 20),
                          SizedBox(width: 8),
                          Text('Collect Cash (COD)',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)),
                        ],
                      ),
                      Text('₹${order.totalAmount}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.green)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        icon: const Icon(Icons.call, size: 18),
                        label: const Text('Call'),
                        onPressed: () async {
                          if (order.customerPhone.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('No phone number provided.')));
                            return;
                          }
                          final Uri phoneUri =
                              Uri(scheme: 'tel', path: order.customerPhone);
                          try {
                            final launched = await launchUrl(phoneUri);
                            if (!launched && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Could not open dialer.')));
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Could not open dialer.')));
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        icon: const Icon(Icons.directions, size: 18),
                        label: const Text('Navigate'),
                        onPressed: () async {
                          if (order.deliveryAddress.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('No address provided.')));
                            return;
                          }
                          final Uri mapUri = Uri.parse(
                              'https://www.google.com/maps/dir/?api=1&destination=${Uri.encodeComponent(order.deliveryAddress)}');
                          try {
                            final launched = await launchUrl(mapUri,
                                mode: LaunchMode.externalApplication);
                            if (!launched && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Could not open maps.')));
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Could not open maps.')));
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Main Status Button
                if (!isPickedUp)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      onPressed: _updatingOrderId != null
                          ? null
                          : () async {
                              setState(() {
                                _updatingOrderId = order.id;
                                _optimisticPickedUp.add(order.id);
                              });
                              try {
                                await ref
                                    .read(orderRepositoryProvider)
                                    .updateOrderStatus(order.id, 'picked up');
                                ref.invalidate(
                                deliveryOrdersProvider(ref.read(authStateProvider).value ?? ''));

                          } catch (e) {
                                setState(
                                    () => _optimisticPickedUp.remove(order.id));
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Failed to update: $e')));
                                }
                              } finally {
                                if (mounted) {
                                  setState(() => _updatingOrderId = null);
                                }
                              }
                            },
                      child: _updatingOrderId == order.id
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Text('CONFIRM PICKUP',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 1)),
                    ),
                  ),
                if (isPickedUp)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      onPressed: _updatingOrderId != null
                          ? null
                          : () {
                              _showProofOfDeliveryDialog(context, order);
                            },
                      child: _updatingOrderId == order.id
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Text('SWIPE TO DELIVER',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 1)),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showProofOfDeliveryDialog(BuildContext context, dynamic order) {
    final otpController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        bool isUploadingImage = false;
        String? capturedImageUrl;

        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: const Text('Proof of Delivery'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                      'Enter the 4-digit PIN provided by the customer to confirm delivery. This PIN is strictly required.'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    decoration: const InputDecoration(
                      labelText: 'Customer OTP',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.security),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('OR')),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: isUploadingImage || capturedImageUrl != null
                        ? null
                        : () async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.camera, imageQuality: 70);
                            if (pickedFile != null && ctx.mounted) {
                              setDialogState(() => isUploadingImage = true);
                              try {
                                final bytes = await pickedFile.readAsBytes();
                                final rawName = pickedFile.name.replaceAll(
                                    RegExp(r'[^a-zA-Z0-9._-]'), '_');
                                final url = await ApiService.uploadImage(
                                    bytes, 'proof_${order.id}_$rawName');
                                if (url != null) {
                                  setDialogState(() {
                                    capturedImageUrl = url;
                                    isUploadingImage = false;
                                  });
                                } else {
                                  throw Exception('Upload failed');
                                }
                              } catch (e) {
                                setDialogState(() => isUploadingImage = false);
                                if (ctx.mounted) {
                                  ScaffoldMessenger.of(ctx).showSnackBar(
                                      SnackBar(content: Text('Error: $e')));
                                }
                              }
                            }
                          },
                    icon: capturedImageUrl != null
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : (isUploadingImage
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.camera_alt)),
                    label: Text(capturedImageUrl != null
                        ? 'Photo Captured!'
                        : (isUploadingImage
                            ? 'Uploading...'
                            : 'Take Photo at Door')),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      side: BorderSide(
                          color: capturedImageUrl != null
                              ? Colors.green
                              : Colors.grey),
                      foregroundColor: capturedImageUrl != null
                          ? Colors.green
                          : Colors.deepOrange,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isUploadingImage
                      ? null
                      : () async {
                          Navigator.pop(ctx);
                          setState(() {
                            _updatingOrderId = order.id;
                            _optimisticDelivered.add(order.id);
                          });
                          final sm = ScaffoldMessenger.of(context);
                          try {
                            await ref
                                .read(orderRepositoryProvider)
                                .updateOrderStatus(order.id, 'delivered',
                                    proofImageUrl: capturedImageUrl,
                                    deliveryOtp: otpController.text.isNotEmpty ? otpController.text : null);
                            ref.invalidate(
                                deliveryOrdersProvider(ref.read(authStateProvider).value ?? ''));
                            
                            // Show success animation
                            if (context.mounted) {
                               showDialog(
                                 context: context, 
                                 barrierDismissible: false, 
                                 builder: (_) => const _SuccessAnimationDialog()
                               );
                            }
                          } catch (e) {
                            setState(
                                () => _optimisticDelivered.remove(order.id));
                            if (mounted) {
                              if (e.toString().contains('Invalid OTP')) {
                                sm.showSnackBar(const SnackBar(
                                    content: Text('Invalid PIN/OTP!'),
                                    backgroundColor: Colors.red));
                              } else {
                                sm.showSnackBar(SnackBar(
                                    content: Text('Failed to update: $e')));
                              }
                            }
                          } finally {
                            if (mounted) {
                              setState(() => _updatingOrderId = null);
                            }
                          }
                        },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Confirm Delivery',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildEarningsAndHistory(List orders) {
    double totalCashCollected = 0;
    double earnings = 0; // Rs. 30 per delivery flat rate

    for (var o in orders) {
      totalCashCollected += o.totalAmount;
      earnings += 30.0;
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Gradient Banner
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.deepOrange.shade400,
                Colors.deepOrange.shade800
              ]),
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Today\'s Earnings',
                    style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 8),
                Text('₹${earnings.toStringAsFixed(0)}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Deliveries',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text('${orders.length}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(height: 40, width: 1, color: Colors.white30),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Shift Hours',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                          SizedBox(height: 4),
                          Text('4.5h',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(height: 40, width: 1, color: Colors.white30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Cash in Hand',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text('₹${totalCashCollected.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text('Earnings Breakdown',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200)),
              child: Column(
                children: [
                  Material(type: MaterialType.transparency, child: ListTile(
                    leading:
                        const Icon(Icons.monetization_on, color: Colors.blue),
                    title: const Text('Base Pay'),
                    trailing: Text(
                        '₹${(orders.length * 20).toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  )),
                  const Divider(height: 1),
                  Material(type: MaterialType.transparency, child: ListTile(
                    leading: const Icon(Icons.map, color: Colors.purple),
                    title: const Text('Distance Bonuses'),
                    trailing: Text('₹${(orders.length * 5).toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  )),
                  const Divider(height: 1),
                  Material(type: MaterialType.transparency, child: ListTile(
                    leading: const Icon(Icons.favorite, color: Colors.red),
                    title: const Text('Customer Tips'),
                    trailing: Text('₹${(orders.length * 5).toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  )),
                  const Divider(height: 1),
                  const Material(type: MaterialType.transparency, child: ListTile(
                    leading: Icon(Icons.calendar_today, color: Colors.green),
                    title: Text('Next Payout'),
                    trailing: Text('Monday',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green)),
                  )),
                ],
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text('Delivery History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),

          if (orders.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Icon(Icons.history, size: 64, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text('No deliveries yet today',
                        style: TextStyle(color: Colors.grey.shade500)),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  elevation: 0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200)),
                  child: Material(type: MaterialType.transparency, child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade50,
                      child:
                          const Icon(Icons.check_circle, color: Colors.green),
                    ),
                    title: Text(
                        'Order ${order.id}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(order.createdAt.toString().split('.')[0],
                        style: const TextStyle(fontSize: 12)),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('₹${order.totalAmount}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const Text('Delivered',
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )),
                );
              },
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SuccessAnimationDialog extends StatefulWidget {
  const _SuccessAnimationDialog();
  @override
  State<_SuccessAnimationDialog> createState() => _SuccessAnimationDialogState();
}

class _SuccessAnimationDialogState extends State<_SuccessAnimationDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1.0, curve: Curves.easeIn)));
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) Navigator.pop(context);
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.green.withValues(alpha: 0.4), blurRadius: 40, spreadRadius: 10)
              ]
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 90),
                const SizedBox(height: 24),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    'Delivery Successful!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    'Great job! Earnings added.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
