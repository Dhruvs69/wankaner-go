const fs = require('fs');

let text = fs.readFileSync('pubspec.yaml', 'utf-8');

if (!text.includes('color: "#ffffff"')) {
  text += '\nflutter_native_splash:\n  color: "#ffffff"\n  image: assets/images/app_icon.jpg\n  android: true\n  ios: true\n  web: false\n';
}

fs.writeFileSync('pubspec.yaml', text, 'utf-8');
console.log('Appended flutter_native_splash block');
