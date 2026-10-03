const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/customer_home_screen.dart', 'utf-8');

const regex = /CircleAvatar\(\s*backgroundColor: Colors\.grey\.shade100,\s*child: IconButton\(\s*icon: const Icon\(Icons\.person, color: Colors\.black87\),\s*onPressed: \(\) async \{\s*await ref\.read\(authRepositoryProvider\)\.signOut\(\);\s*\},\s*\),\s*\),/;

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

if (regex.test(text)) {
  text = text.replace(regex, newIcons);
  fs.writeFileSync('lib/features/auth/screens/customer_home_screen.dart', text, 'utf-8');
  console.log('Customer fixed');
} else {
  console.log('Customer regex failed');
}
