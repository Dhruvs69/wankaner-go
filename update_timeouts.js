const fs = require('fs');
let text = fs.readFileSync('lib/core/api_service.dart', 'utf-8');
text = text.replaceAll('Duration(seconds: 5)', 'Duration(seconds: 60)');
fs.writeFileSync('lib/core/api_service.dart', text, 'utf-8');
console.log('Timeouts updated to 60 seconds!');
