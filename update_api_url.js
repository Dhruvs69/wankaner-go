const fs = require('fs');
let text = fs.readFileSync('lib/core/api_service.dart', 'utf-8');

text = text.replace(
    /static String get baseUrl \{[\s\S]*?\}/,
    `static String get baseUrl {
    return 'https://wankaner-go.onrender.com/api';
  }`
);

fs.writeFileSync('lib/core/api_service.dart', text, 'utf-8');
console.log('Updated api_service.dart to point to Render!');
