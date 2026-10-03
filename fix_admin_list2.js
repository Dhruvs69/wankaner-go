const fs = require('fs');

let text = fs.readFileSync('lib/features/auth/screens/admin_home_screen.dart', 'utf-8');

const oldSubtitle = "subtitle: Text('\\${user.email} • \\${user.phone}'),";

const newSubtitle = `subtitle: Column(
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

text = text.replace(oldSubtitle, newSubtitle);

fs.writeFileSync('lib/features/auth/screens/admin_home_screen.dart', text, 'utf-8');
console.log('Fixed delivery partner status in list, FOR REAL!');
