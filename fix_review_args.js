const fs = require('fs');

// 1. Update ReviewScreen to take orderId
let reviewScreen = fs.readFileSync('lib/features/customer/screens/review_screen.dart', 'utf-8');
reviewScreen = reviewScreen.replace(
  'final String vendorName;',
  'final String vendorName;\n  final String orderId;'
);
reviewScreen = reviewScreen.replace(
  'const ReviewScreen({super.key, required this.vendorId, required this.vendorName});',
  'const ReviewScreen({super.key, required this.vendorId, required this.vendorName, required this.orderId});'
);
reviewScreen = reviewScreen.replace(
  '_commentController.text.trim(),',
  '_commentController.text.trim(),\n        widget.orderId,'
);
fs.writeFileSync('lib/features/customer/screens/review_screen.dart', reviewScreen, 'utf-8');

// 2. Update customer_orders_screen.dart to pass orderId
let ordersScreen = fs.readFileSync('lib/features/customer/screens/customer_orders_screen.dart', 'utf-8');
ordersScreen = ordersScreen.replace(
  'vendorName: order.vendorName.isNotEmpty',
  'orderId: order.id,\n                                    vendorName: order.vendorName.isNotEmpty'
);
fs.writeFileSync('lib/features/customer/screens/customer_orders_screen.dart', ordersScreen, 'utf-8');

// 3. Update vendor_repository.dart
let vendorRepo = fs.readFileSync('lib/features/customer/repositories/vendor_repository.dart', 'utf-8');
vendorRepo = vendorRepo.replace(
  'Future<void> submitReview(String vendorId, double rating, String comment) async {',
  'Future<void> submitReview(String vendorId, double rating, String comment, String orderId) async {'
);
vendorRepo = vendorRepo.replace(
  "'rating': rating,",
  "'rating': rating,\n          'order_id': orderId,"
);
// We also need customer_id! I'll just let the backend handle it or pass it.
// Oh wait, ApiService already sends Authorization headers? No, it's just basic API.
// Let's get customer_id from SharedPreferences in submitReview.
const repoFix = `Future<void> submitReview(String vendorId, double rating, String comment, String orderId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customerId = prefs.getString('user_id') ?? 'unknown_customer';
      final response = await ApiService.post('/vendors/$vendorId/reviews', {
        'rating': rating,
        'comment': comment,
        'order_id': orderId,
        'customer_id': customerId,
      });`;
vendorRepo = vendorRepo.replace(/Future<void> submitReview[\s\S]*?'comment': comment,\n\s*\}\);/g, repoFix + '\n        });');

fs.writeFileSync('lib/features/customer/repositories/vendor_repository.dart', vendorRepo, 'utf-8');
console.log('Fixed review screens and repository');
