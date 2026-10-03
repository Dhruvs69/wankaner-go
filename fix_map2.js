const fs = require('fs');
let text = fs.readFileSync('lib/features/customer/screens/customer_orders_screen.dart', 'utf-8');

const regex = /return Container\([\s\S]*?child: Center\([\s\S]*?Column\([\s\S]*?Icon\(Icons\.radar[\s\S]*?\]\,[\s\S]*?\)[\s\S]*?\)[\s\S]*?\)\;/;

const newUI = `final double lat = (riderData!['current_lat'] is int) ? (riderData!['current_lat'] as int).toDouble() : riderData!['current_lat'];
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

if(regex.test(text)) {
  text = text.replace(regex, newUI);
  fs.writeFileSync('lib/features/customer/screens/customer_orders_screen.dart', text, 'utf-8');
  console.log('Replaced successfully!');
} else {
  console.log('Regex did not match!');
}
