const fs = require('fs');
const file = 'lib/features/auth/screens/customer_home_screen.dart';
let content = fs.readFileSync(file, 'utf8');

const distTarget = `  int _calculateEta() {`;
const distReplacement = `  String _calculateDistanceString() {
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
    return '\${distanceInKm.toStringAsFixed(1)} km';
  }

  int _calculateEta() {`;

if (!content.includes('_calculateDistanceString()')) {
    content = content.replace(distTarget, distReplacement);
}

content = content.replace('Text(vendor.distance,', 'Text(_calculateDistanceString(),');

fs.writeFileSync(file, content);
