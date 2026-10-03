const fs = require('fs');
let text = fs.readFileSync('lib/features/customer/repositories/vendor_repository.dart', 'utf-8');

// I will find the exact bounds of submitReview
const lines = text.split('\n');
let startIdx = -1;
let endIdx = -1;
for (let i = 0; i < lines.length; i++) {
    if (lines[i].includes('submitReview(String vendorId, double rating, String comment, String orderId)')) {
        startIdx = i;
    }
    if (startIdx !== -1 && lines[i].trim() === '}' && i > startIdx + 10) {
        // we are at the end of the submitReview block hopefully. Actually it's just the end of the class.
        // Let's just find the exact block since it's the last function.
    }
}

// Since submitReview is the last method in VendorRepository:
const newMethod = `  Future<void> submitReview(String vendorId, double rating, String comment, String orderId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customerId = prefs.getString('user_id') ?? 'unknown';
      
      final response = await ApiService.post('/vendors/$vendorId/reviews', {
        'rating': rating,
        'comment': comment,
        'order_id': orderId,
        'customer_id': customerId,
      });
      if (response.statusCode != 201) {
        throw Exception('Failed to submit review: \${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to submit review: $e');
    }
  }`;

// I'll just regex replace the whole function until the second to last closing brace
text = text.replace(/Future<void> submitReview\([\s\S]*?\}\s*\}\s*\n\}/, newMethod + '\n}');

fs.writeFileSync('lib/features/customer/repositories/vendor_repository.dart', text, 'utf-8');
console.log('Fixed submitReview');
