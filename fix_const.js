const fs = require('fs');
const file = 'lib/features/auth/screens/admin_home_screen.dart';
let text = fs.readFileSync(file, 'utf8');

text = text.replace(/Expanded\(\s*child:\s*Card\(\s*shape:\s*RoundedRectangleBorder\(\s*borderRadius:\s*BorderRadius\.circular\(16\)\),\s*child:\s*Padding\(\s*padding:\s*const\s*EdgeInsets\.all\(24\.0\),\s*child:\s*Column\(/g, "Expanded( child: const Card( shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))), child: Padding( padding: EdgeInsets.all(24.0), child: Column(");

fs.writeFileSync(file, text);
