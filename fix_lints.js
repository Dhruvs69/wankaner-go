const fs = require('fs');

let file1 = 'lib/features/auth/screens/admin_home_screen.dart';
let text1 = fs.readFileSync(file1, 'utf8');

text1 = text1.replace("error: (e, s) => Center(child: Text('Error: ')),", "error: (e, s) => const Center(child: Text('Error')),");
text1 = text1.replace("error: (e, s) => Center(child: Text('Error: $e')),", "error: (e, s) => const Center(child: Text('Error')),");
text1 = text1.replace("return '#' + hex.toUpperCase();", "return '#${hex.toUpperCase()}';");

fs.writeFileSync(file1, text1);

let file2 = 'lib/features/customer/providers/banner_provider.dart';
let text2 = fs.readFileSync(file2, 'utf8');

text2 = text2.replace("c.value", "c.toARGB32()");

fs.writeFileSync(file2, text2);
