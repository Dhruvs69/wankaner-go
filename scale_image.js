const fs = require('fs');
let text = fs.readFileSync('lib/features/splash/screens/splash_screen.dart', 'utf-8');

const originalImage = `child: Image.asset(
                          'assets/images/app_icon.jpg',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),`;

const newImage = `child: Transform.scale(
                          scale: 1.15,
                          child: Image.asset(
                            'assets/images/app_icon.jpg',
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),`;

if (text.includes(originalImage)) {
  fs.writeFileSync('lib/features/splash/screens/splash_screen.dart', text.replace(originalImage, newImage), 'utf-8');
  console.log('Scaled the image!');
} else {
  console.log('originalImage not found! Retrying with regex.');
  
  // Regex approach
  text = text.replace(/child:\s*Image\.asset\(\s*'assets\/images\/app_icon\.jpg',\s*width:\s*150,\s*height:\s*150,\s*fit:\s*BoxFit\.cover,\s*\),/g, newImage);
  fs.writeFileSync('lib/features/splash/screens/splash_screen.dart', text, 'utf-8');
  console.log('Regex replace attempted!');
}
