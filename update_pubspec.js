const fs = require('fs');

let text = fs.readFileSync('pubspec.yaml', 'utf-8');

text = text.replace(/assets\/images\/app_icon\.png/g, 'assets/images/app_icon.jpg');

if (!text.includes('flutter_native_splash:')) {
  text += '\nflutter_native_splash:\n  color: "#FF5722"\n  image: assets/images/app_icon.jpg\n  android: true\n  ios: true\n  web: false\n';
}

fs.writeFileSync('pubspec.yaml', text, 'utf-8');
console.log('Updated pubspec.yaml');
