const fs = require('fs');
let text = fs.readFileSync('lib/features/customer/repositories/vendor_repository.dart', 'utf-8');

text = text.replace(
  "throw Exception('Failed to submit review');",
  "throw Exception('Failed to submit review: ${response.body}');"
);

fs.writeFileSync('lib/features/customer/repositories/vendor_repository.dart', text, 'utf-8');
console.log('Fixed error reporting in vendor repository');
