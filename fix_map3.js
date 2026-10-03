const fs = require('fs');

let text = fs.readFileSync('lib/features/customer/screens/customer_orders_screen.dart', 'utf-8');

const startIdx = text.indexOf('class _LiveTrackingWidgetState extends State<LiveTrackingWidget> {');

const replacement = `class _LiveTrackingWidgetState extends State<LiveTrackingWidget> {
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
`;

text = text.substring(0, startIdx) + replacement;

fs.writeFileSync('lib/features/customer/screens/customer_orders_screen.dart', text, 'utf-8');
console.log('Fixed LiveTrackingWidgetState perfectly!');
