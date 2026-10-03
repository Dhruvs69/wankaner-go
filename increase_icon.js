const fs = require('fs');
let text = fs.readFileSync('lib/features/splash/screens/splash_screen.dart', 'utf-8');

text = text.replace(/BorderRadius\.circular\(50\)/g, 'BorderRadius.circular(75)');
text = text.replace(/width:\s*150,/g, 'width: 220,');
text = text.replace(/height:\s*150,/g, 'height: 220,');

fs.writeFileSync('lib/features/splash/screens/splash_screen.dart', text, 'utf-8');
console.log('Increased icon size to 220x220!');
