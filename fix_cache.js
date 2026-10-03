const fs = require('fs');

let text = fs.readFileSync('lib/core/api_service.dart', 'utf-8');

text = text.replace(
  "'Content-Type': 'application/json',",
  "'Content-Type': 'application/json',\n      'Cache-Control': 'no-cache, no-store, must-revalidate',\n      'Pragma': 'no-cache',\n      'Expires': '0',"
);

fs.writeFileSync('lib/core/api_service.dart', text, 'utf-8');
console.log('Added anti-caching headers to ApiService!');
