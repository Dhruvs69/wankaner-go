const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/customer_home_screen.dart', 'utf-8');

const originalMatch = `                final matchesCategory = _selectedCategory == null ||
                    v.category
                        .toLowerCase()
                        .contains(_selectedCategory!.toLowerCase());`;

const newMatch = `                final matchesCategory = _selectedCategory == null ||
                    v.category
                        .toLowerCase()
                        .contains(_selectedCategory!.toLowerCase()) ||
                    v.items.any((item) => 
                        (item['name'] ?? '').toString().toLowerCase().contains(_selectedCategory!.toLowerCase()) ||
                        (item['category'] ?? '').toString().toLowerCase().contains(_selectedCategory!.toLowerCase()));`;

if (text.includes(originalMatch)) {
  fs.writeFileSync('lib/features/auth/screens/customer_home_screen.dart', text.replace(originalMatch, newMatch), 'utf-8');
  console.log('Fixed matchesCategory!');
} else {
  console.log('originalMatch not found!');
  // Try fallback replacement if whitespace is off
  const regex = /final matchesCategory = _selectedCategory == null \|\|[\s\S]*?contains\(_selectedCategory!\.toLowerCase\(\)\);/;
  if (regex.test(text)) {
    text = text.replace(regex, newMatch);
    fs.writeFileSync('lib/features/auth/screens/customer_home_screen.dart', text, 'utf-8');
    console.log('Fixed matchesCategory using Regex!');
  } else {
     console.log('Regex also failed.');
  }
}
