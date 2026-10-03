const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/customer_home_screen.dart', 'utf-8');

// Add import
const importToAdd = "import '../../../core/widgets/settings_bottom_sheet.dart';";
if (!text.includes(importToAdd)) {
   text = text.replace("import '../../../core/widgets/notification_bell.dart';", "import '../../../core/widgets/notification_bell.dart';\n" + importToAdd);
}

// Replace person with logout and add settings
const originalIcons = `CircleAvatar(
            backgroundColor: Colors.grey.shade100,
            child: IconButton(
              icon: const Icon(Icons.person, color: Colors.black87),
              onPressed: () async {
                await ref.read(authRepositoryProvider).signOut();
              },
            ),
          ),`;

const newIcons = `CircleAvatar(
            backgroundColor: Colors.grey.shade100,
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.black87),
              onPressed: () => showSettings(context),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.grey.shade100,
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.red),
              onPressed: () async {
                await ref.read(authRepositoryProvider).signOut();
              },
            ),
          ),`;

if (text.includes('Icons.person')) {
    text = text.replace(originalIcons, newIcons);
    fs.writeFileSync('lib/features/auth/screens/customer_home_screen.dart', text, 'utf-8');
    console.log('Customer home updated');
} else {
    console.log('Customer home regex failed');
}
