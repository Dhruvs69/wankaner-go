const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/vendor_home_screen.dart', 'utf-8');
const providerCode = `
final vendorPayoutsProvider = FutureProvider.family<List<dynamic>, String>((ref, ownerId) async {
  final res = await ApiService.get('/payouts/user/\${ownerId}');
  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  }
  return [];
});
`;
text = text.replace('class VendorHomeScreen', providerCode + '\nclass VendorHomeScreen');
fs.writeFileSync('lib/features/auth/screens/vendor_home_screen.dart', text, 'utf-8');
console.log('Added provider!');
