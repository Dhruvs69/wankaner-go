const fs = require('fs');

let text = fs.readFileSync('lib/features/customer/screens/customer_orders_screen.dart', 'utf-8');

// 1. Add imports
const importsToAdd = `
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
`;
text = text.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';" + importsToAdd);

// 2. Replace UI
const oldUI = `    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.radar, size: 40, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              'Rider is at Lat: \${riderData!['current_lat']},\\nLng: \${riderData!['current_lng']}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ],
        ),
      ),
    );`;

const newUI = `    final double lat = (riderData!['current_lat'] is int) ? (riderData!['current_lat'] as int).toDouble() : riderData!['current_lat'];
    final double lng = (riderData!['current_lng'] is int) ? (riderData!['current_lng'] as int).toDouble() : riderData!['current_lng'];
    
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
    );`;

text = text.replace(oldUI, newUI);

fs.writeFileSync('lib/features/customer/screens/customer_orders_screen.dart', text, 'utf-8');
console.log('Fixed Live Tracking map!');
