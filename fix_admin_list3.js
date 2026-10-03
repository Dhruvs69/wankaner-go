const fs = require('fs');

let text = fs.readFileSync('lib/features/auth/screens/admin_home_screen.dart', 'utf-8');
const lines = text.split('\n');

for (let i = 0; i < lines.length; i++) {
  if (lines[i].includes("subtitle: Text('\${user.email} • \${user.phone}'),")) {
    lines[i] = `                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('\${user.email} • \${user.phone}'),
                            if (role == 'delivery')
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  user.isOnline == 1 ? '🟢 Online' : '⚪ Offline',
                                  style: TextStyle(
                                    color: user.isOnline == 1 ? Colors.green.shade700 : Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),`;
    console.log('Found and replaced at line ' + i);
    break;
  }
}

fs.writeFileSync('lib/features/auth/screens/admin_home_screen.dart', lines.join('\n'), 'utf-8');
