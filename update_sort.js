const fs = require('fs');
const file = 'lib/features/auth/screens/customer_home_screen.dart';
let content = fs.readFileSync(file, 'utf8');

const target = `                } else if (_selectedSort == 'Fastest Delivery') {
                  // Since real ETA depends on GPS we don't have here perfectly, we can just sort by distance as proxy or a random mock.
                  // Assuming vendor.distance is a string like "2.5 km", we can extract the number.
                  filteredVendors.sort((a, b) {
                    final aDist =
                        double.tryParse(a.distance.split(' ').first) ?? 0.0;
                    final bDist =
                        double.tryParse(b.distance.split(' ').first) ?? 0.0;
                    return aDist.compareTo(bDist);
                  });
                }`;

const replacement = `                } else if (_selectedSort == 'Fastest Delivery') {
                  filteredVendors.sort((a, b) {
                    if (_userPosition != null) {
                      final aDist = Geolocator.distanceBetween(_userPosition!.latitude, _userPosition!.longitude, a.lat, a.lng);
                      final bDist = Geolocator.distanceBetween(_userPosition!.latitude, _userPosition!.longitude, b.lat, b.lng);
                      return aDist.compareTo(bDist);
                    }
                    final aDist = double.tryParse(a.distance.split(' ').first) ?? 0.0;
                    final bDist = double.tryParse(b.distance.split(' ').first) ?? 0.0;
                    return aDist.compareTo(bDist);
                  });
                }`;

if (!content.includes('if (_userPosition != null) {')) {
    content = content.replace(target, replacement);
    fs.writeFileSync(file, content);
}
