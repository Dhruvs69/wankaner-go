import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../../models/address_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/repositories/auth_repository.dart';

class AddAddressDialog extends ConsumerStatefulWidget {
  const AddAddressDialog({super.key});

  @override
  ConsumerState<AddAddressDialog> createState() => _AddAddressDialogState();
}

class _AddAddressDialogState extends ConsumerState<AddAddressDialog> {
  final labelController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final pincodeController = TextEditingController();
  
  LatLng _selectedLocation = const LatLng(22.6167, 70.9333); // Default to Wankaner
  final MapController _mapController = MapController();
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Location services are disabled.');
      
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) throw Exception('Location permissions are denied');
      }
      if (permission == LocationPermission.deniedForever) throw Exception('Location permissions are permanently denied');

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
        _mapController.move(_selectedLocation, 15.0);
      });
    } catch (e) {
      // Ignore or show snackbar
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add New Address', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SizedBox(
                height: 250,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _selectedLocation,
                          initialZoom: 15.0,
                          onPositionChanged: (pos, hasGesture) {
                            if (hasGesture) {
                              setState(() => _selectedLocation = pos.center);
                            }
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.speedtrack.wankanergo',
                          ),
                        ],
                      ),
                    ),
                    const Center(
                      child: Icon(Icons.location_on, size: 40, color: Colors.red),
                    ),
                    if (_isLoadingLocation)
                      const Center(child: CircularProgressIndicator()),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: FloatingActionButton.small(
                        onPressed: _getCurrentLocation,
                        child: const Icon(Icons.my_location),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('Drag the map to pinpoint your exact location', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 16),
              TextField(controller: labelController, decoration: const InputDecoration(labelText: 'Label (e.g. Home, Work)')),
              TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Full Address', hintText: 'Flat, House no., Building, Company, Apartment'), maxLines: 2),
              Row(
                children: [
                  Expanded(child: TextField(controller: cityController, decoration: const InputDecoration(labelText: 'City'))),
                  const SizedBox(width: 16),
                  Expanded(child: TextField(controller: pincodeController, decoration: const InputDecoration(labelText: 'Pincode'), keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (labelController.text.isEmpty || addressController.text.isEmpty) return;
                      final newAddress = AddressModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        label: labelController.text,
                        fullAddress: addressController.text,
                        city: cityController.text,
                        pincode: pincodeController.text,
                        isDefault: true,
                        lat: _selectedLocation.latitude,
                        lng: _selectedLocation.longitude,
                      );
                      final userId = ref.read(authStateProvider).value;
                      if (userId != null && userId.isNotEmpty) {
                        await ref.read(authRepositoryProvider).addAddress(userId, newAddress);
                        if (context.mounted) Navigator.pop(context, newAddress);
                      }
                    },
                    child: const Text('Save Address'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}