const fs = require('fs');

let text = fs.readFileSync('lib/features/auth/repositories/auth_repository.dart', 'utf-8');

text = text.replace(
  "await ApiService.get('/users?role=$role');",
  "await ApiService.get('/users?role=$role&_t=\\${DateTime.now().millisecondsSinceEpoch}');"
);

fs.writeFileSync('lib/features/auth/repositories/auth_repository.dart', text, 'utf-8');
console.log('Added timestamp cache buster to users loop!');
