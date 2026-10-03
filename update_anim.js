const fs = require('fs');
let text = fs.readFileSync('lib/features/splash/screens/splash_screen.dart', 'utf-8');

text = text.replace(
  '_scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(',
  '_scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate('
);

text = text.replace(
  'CurvedAnimation(parent: _controller, curve: Curves.elasticOut),',
  'CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),'
);

fs.writeFileSync('lib/features/splash/screens/splash_screen.dart', text, 'utf-8');
console.log('Updated animation!');
