const fs = require('fs');
const file = 'lib/features/auth/screens/admin_home_screen.dart';
let text = fs.readFileSync(file, 'utf8');

text = text.replace(/backgroundColor: Colors\.blueGrey\.shade900,\s*foregroundColor: Colors\.white,\s*\),/, `backgroundColor: Colors.blueGrey.shade900,
                foregroundColor: Colors.white,
                actions: const [
                  NotificationBell(),
                  SizedBox(width: 8),
                ],
              ),`);

fs.writeFileSync(file, text);
