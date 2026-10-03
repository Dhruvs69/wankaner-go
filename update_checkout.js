const fs = require('fs');

const code = `// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../repositories/order_repository.dart';
import '../models/order_model.dart';
import 'order_success_screen.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../models/address_model.dart';
import 'add_address_dialog.dart';
import '../../auth/repositories/auth_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../providers/vendor_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final double totalAmount;
  
  const CheckoutScreen({super.key, required this.totalAmount});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _promoController = TextEditingController();
  
  AddressModel? _selectedAddress;
  int _selectedTip = 0;
  double _discount = 0.0;
  bool _isInit = false;
  bool _isPlacingOrder = false;
  String _paymentMethod = 'COD';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  void _showAddAddressDialog() async {
    final newAddress = await showDialog<AddressModel>(
      context: context,
      builder: (context) => const AddAddressDialog(),
    );
    if (newAddress != null) {
      ref.invalidate(currentUserStreamProvider);
      setState(() {
        _selectedAddress = newAddress;
      });
    }
  }

  void _deleteAddress(String addressId) async {
    try {
      await ref.read(authRepositoryProvider).deleteAddress(addressId);
      if (_selectedAddress?.id == addressId) {
        setState(() {
          _selectedAddress = null;
        });
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Address deleted')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void _placeOrder(double deliveryFee) async {
    if (!_formKey.currentState!.validate() || _selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete delivery information and select an address', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red));
      return;
    }
    
    setState(() => _isPlacingOrder = true);
    
    try {
      final userId = ref.read(authStateProvider).value;
      if (userId == null || userId.isEmpty) throw Exception('Please log in to place an order');

      final cartItems = ref.read(cartProvider);
      if (cartItems.isEmpty) throw Exception('Your cart is empty');

      final vendorId = ref.read(currentCartVendorIdProvider);
      final vendorName = ref.read(currentCartVendorNameProvider);

      if (vendorId == null || vendorName == null) {
        throw Exception('Cannot determine shop for order. Please clear cart and try again.');
      }

      final orderItems = cartItems.map((c) => {
        'item_id': c.item.id,
        'name': c.item.name,
        'price': c.item.price,
        'quantity': c.quantity,
      }).toList();

      final order = OrderModel(
        id: '', 
        customerId: userId,
        vendorId: vendorId,
        vendorName: vendorName,
        items: orderItems,
        totalAmount: (widget.totalAmount + deliveryFee + _selectedTip - _discount > 0 ? widget.totalAmount + deliveryFee + _selectedTip - _discount : 0),
        createdAt: DateTime.now(),
        customerName: _nameController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        deliveryAddress: '\${_selectedAddress!.fullAddress}, \${_selectedAddress!.city} - \${_selectedAddress!.pincode}',
      );

      await ref.read(orderRepositoryProvider).placeOrder(order);
      ref.read(cartProvider.notifier).clearCart();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OrderSuccessScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isPlacingOrder = false);
    }
  }
  
  Future<void> _launchUPI(double amount) async {
    const String upiId = '7383855568@ptyes';
    const String name = 'Wankaner Go';
    final String upiUrl = 'upi://pay?pa=$upiId&pn=$name&am=\${amount.toStringAsFixed(2)}&cu=INR';
    
    final Uri uri = Uri.parse(upiUrl);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No UPI app found on your device.')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error launching UPI: $e')));
    }
  }

  Widget _buildSectionTitle(String title, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.deepOrange, size: 24),
            const SizedBox(width: 8),
          ],
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 0.3)),
        ],
      ),
    );
  }

  Widget _buildTipChip(int amount) {
    final isSelected = _selectedTip == amount;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ChoiceChip(
          label: Text('₹$amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isSelected ? Colors.white : Colors.black87)),
          selected: isSelected,
          selectedColor: Colors.deepOrange,
          backgroundColor: Colors.white,
          side: BorderSide(color: isSelected ? Colors.deepOrange : Colors.grey.shade300, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onSelected: (val) {
            setState(() {
              _selectedTip = val ? amount : 0;
            });
          },
        ),
      ),
    );
  }

  Widget _buildPaymentSection(double finalAmount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('Payment Method', icon: Icons.account_balance_wallet_rounded),
        Card(
          elevation: 2,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              InkWell(
                onTap: () => setState(() => _paymentMethod = 'COD'),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.money, color: Colors.green),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(child: Text('Cash on Delivery (COD)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                      Radio<String>(
                        value: 'COD',
                        groupValue: _paymentMethod,
                        onChanged: (val) => setState(() => _paymentMethod = val!),
                        activeColor: Colors.deepOrange,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(height: 1, color: Colors.grey.shade200, indent: 64),
              InkWell(
                onTap: () => setState(() => _paymentMethod = 'UPI'),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.qr_code_scanner, color: Colors.blue),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(child: Text('Pay via UPI (GPay, PhonePe, Paytm)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                      Radio<String>(
                        value: 'UPI',
                        groupValue: _paymentMethod,
                        onChanged: (val) => setState(() => _paymentMethod = val!),
                        activeColor: Colors.deepOrange,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_paymentMethod == 'UPI') ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Column(
              children: [
                const Text('Scan QR to Pay', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))]),
                  child: QrImageView(
                    data: 'upi://pay?pa=7383855568@ptyes&pn=Wankaner Go&am=\${finalAmount.toStringAsFixed(2)}&cu=INR',
                    version: QrVersions.auto,
                    size: 140.0,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('— OR —', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 2)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _launchUPI(finalAmount),
                  icon: const Icon(Icons.touch_app),
                  label: Text('Open UPI App & Pay ₹\${finalAmount.toStringAsFixed(2)}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size(double.infinity, 54),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('After completing payment, click "Place Order" below.', style: TextStyle(fontSize: 12, color: Colors.deepOrange, fontWeight: FontWeight.w600)),
              ],
            ),
          )
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userStream = ref.watch(currentUserStreamProvider);
    final cartItems = ref.watch(cartProvider);

    final vendorId = ref.read(currentCartVendorIdProvider);
    final vendorsAsync = ref.watch(nearbyVendorsProvider);
    final vendorList = vendorsAsync.value ?? [];
    final vendor = vendorList.where((v) => v.id == vendorId).firstOrNull;

    double calculatedDeliveryFee = 25.0; 
    if (vendor != null && _selectedAddress != null && _selectedAddress!.lat != 0.0 && vendor.lat != 0.0) {
      final distanceInMeters = const Distance().as(
        LengthUnit.Meter, 
        LatLng(vendor.lat, vendor.lng), 
        LatLng(_selectedAddress!.lat, _selectedAddress!.lng)
      );
      double km = distanceInMeters / 1000.0;
      if (km < 1) km = 1.0; 
      calculatedDeliveryFee = km * 10.0; 
    }

    final double finalTotal = (widget.totalAmount + calculatedDeliveryFee + _selectedTip - _discount > 0 ? widget.totalAmount + calculatedDeliveryFee + _selectedTip - _discount : 0);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      bottomNavigationBar: userStream.hasValue && userStream.value != null ? Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -5))],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total to Pay', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text('₹\${finalTotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black87)),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isPlacingOrder ? null : () => _placeOrder(calculatedDeliveryFee),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isPlacingOrder
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                      : const Text('Place Order', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ),
              ),
            ],
          ),
        ),
      ) : null,
      body: userStream.when(
        data: (user) {
          if (user == null) return const Center(child: Text('Please log in'));
          
          if (!_isInit) {
            _nameController.text = user.name;
            _phoneController.text = user.phone;
            if (user.savedAddresses != null && user.savedAddresses!.isNotEmpty) {
              _selectedAddress = user.savedAddresses!.firstWhere((a) => a.isDefault, orElse: () => user.savedAddresses!.first);
            }
            _isInit = true;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSectionTitle('Delivery Information', icon: Icons.location_on_rounded),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              prefixIcon: const Icon(Icons.person_outline),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              prefixIcon: const Icon(Icons.phone_outlined),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Saved Addresses', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                      TextButton.icon(
                        onPressed: _showAddAddressDialog,
                        icon: const Icon(Icons.add, size: 20),
                        label: const Text('Add New', style: TextStyle(fontWeight: FontWeight.bold)),
                        style: TextButton.styleFrom(foregroundColor: Colors.deepOrange),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (user.savedAddresses == null || user.savedAddresses!.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: BorderSide(color: Colors.grey.shade200)),
                      child: const Center(child: Text('No saved addresses yet. Please add one to deliver.', style: TextStyle(color: Colors.grey))),
                    )
                  else
                    ...user.savedAddresses!.map((address) {
                      final isSelected = _selectedAddress?.id == address.id;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () => setState(() => _selectedAddress = address),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.orange.shade50 : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: isSelected ? Colors.deepOrange.shade200 : Colors.grey.shade200, width: isSelected ? 2 : 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.location_on, color: isSelected ? Colors.deepOrange : Colors.grey.shade400),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(address.label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isSelected ? Colors.deepOrange.shade700 : Colors.black87)),
                                        const SizedBox(height: 4),
                                        Text('\${address.fullAddress}\\n\${address.city} - \${address.pincode}', style: TextStyle(color: Colors.grey.shade700, height: 1.4)),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                                    onPressed: () => _deleteAddress(address.id),
                                    constraints: const BoxConstraints(),
                                    padding: EdgeInsets.zero,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Order Summary', icon: Icons.receipt_long_rounded),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
                    color: Colors.white,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cartItems.length,
                      separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade200),
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: item.item.imageUrl.isNotEmpty
                                    ? Image.network(item.item.imageUrl, width: 60, height: 60, fit: BoxFit.cover)
                                    : Container(width: 60, height: 60, color: Colors.grey.shade100, child: const Icon(Icons.fastfood, color: Colors.grey)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 4),
                                    if (item.selectedVariant != null) Text('Variant: \${item.selectedVariant!.name}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                    if (item.selectedAddons.isNotEmpty) Text('Addons: \${item.selectedAddons.map((a) => a.name).join(', ')}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                    const SizedBox(height: 8),
                                    Text('\${item.quantity} × ₹\${item.unitPrice}', style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.deepOrange)),
                                  ],
                                ),
                              ),
                              Text('₹\${(item.quantity * item.unitPrice).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Tip your Rider', icon: Icons.motorcycle_rounded),
                  Row(
                    children: [
                      _buildTipChip(20),
                      _buildTipChip(50),
                      _buildTipChip(100),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.deepOrange.shade200),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.orange.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_offer, color: Colors.deepOrange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _promoController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Apply Promo Code',
                              hintStyle: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            final code = _promoController.text.trim().toUpperCase();
                            if (code == 'WELCOME50') {
                              setState(() {
                                _discount = 50.0;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Promo Code WELCOME50 Applied! ₹50 Off'), backgroundColor: Colors.green));
                            } else {
                              setState(() {
                                _discount = 0.0;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid Promo Code'), backgroundColor: Colors.red));
                            }
                          },
                          style: TextButton.styleFrom(foregroundColor: Colors.deepOrange),
                          child: const Text('APPLY', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  if (_discount > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, left: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 20),
                          const SizedBox(width: 8),
                          Text('Discount Applied: -₹\${_discount.toStringAsFixed(0)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Bill Summary', icon: Icons.receipt),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Item Total', style: TextStyle(fontSize: 15, color: Colors.black87)),
                              Text('₹\${widget.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Delivery Fee', style: TextStyle(fontSize: 15, color: Colors.black87)),
                              Text('₹\${calculatedDeliveryFee.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          if (_selectedTip > 0) ...[
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Rider Tip', style: TextStyle(fontSize: 15, color: Colors.black87)),
                                Text('₹\${_selectedTip.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                          if (_discount > 0) ...[
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Discount', style: TextStyle(fontSize: 15, color: Colors.green, fontWeight: FontWeight.w600)),
                                Text('-₹\${_discount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, color: Colors.green, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Divider(height: 1),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Grand Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                              Text('₹\${finalTotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.deepOrange)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildPaymentSection(finalTotal),
                  const SizedBox(height: 48), // Bottom padding
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
`;

fs.writeFileSync('lib/features/customer/screens/checkout_screen.dart', code, 'utf-8');
console.log('Checkout screen updated!');
