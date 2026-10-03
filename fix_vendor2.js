const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/vendor_home_screen.dart', 'utf-8');

const regex = /IconButton\(\s*icon: const Icon\(Icons\.logout\),\s*onPressed: \(\) async \{\s*await ref\.read\(authRepositoryProvider\)\.signOut\(\);\s*\},\s*\),/;

const newIcons = `IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => showSettings(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
              await ref.read(authRepositoryProvider).signOut();
            },
          ),`;

if (regex.test(text)) {
  text = text.replace(regex, newIcons);
  fs.writeFileSync('lib/features/auth/screens/vendor_home_screen.dart', text, 'utf-8');
  console.log('Vendor fixed');
} else {
  console.log('Vendor regex failed');
}
