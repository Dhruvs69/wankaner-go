const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/delivery_home_screen.dart', 'utf-8');

const importToAdd = "import '../../../core/widgets/settings_bottom_sheet.dart';";
if (!text.includes(importToAdd)) {
   text = text.replace("import '../../../core/widgets/notification_bell.dart';", "import '../../../core/widgets/notification_bell.dart';\n" + importToAdd);
}

const originalIcons = `IconButton(
            icon: const Icon(Icons.logout, color: Colors.black54),`;

const newIcons = `IconButton(
            icon: const Icon(Icons.settings, color: Colors.black54),
            onPressed: () => showSettings(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),`;

text = text.replace(originalIcons, newIcons);
fs.writeFileSync('lib/features/auth/screens/delivery_home_screen.dart', text, 'utf-8');
console.log('Delivery home updated');
