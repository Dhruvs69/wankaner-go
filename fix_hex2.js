const fs = require('fs');
const file = 'lib/features/auth/screens/admin_home_screen.dart';
let text = fs.readFileSync(file, 'utf8');

const oldStr = `                      String toHex(Color c) {
                        final hex = c.toString().split('(0x')[1].split(')')[0];
                        return '#\${hex.toUpperCase()}';
                      }`;
const newStr = `                      String toHex(Color c) {
                        return '#\${c.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
                      }`;

text = text.replace(oldStr, newStr);

// Let's also wrap the API call in a try/catch so if anything fails, we can show a SnackBar!
const oldApi = `await ApiService.post('/banners', {
                        'title': titleCtrl.text.replaceAll('\\\\n', '\\n'),
                        'subtitle': subtitleCtrl.text,
                        'emoji': emojiCtrl.text,
                        'color1': toHex(c1),
                        'color2': toHex(c2),
                      });
                      ref.invalidate(bannersProvider);
                      if (ctx.mounted) Navigator.pop(ctx);`;

const newApi = `try {
                        await ApiService.post('/banners', {
                          'title': titleCtrl.text.replaceAll('\\\\n', '\\n'),
                          'subtitle': subtitleCtrl.text,
                          'emoji': emojiCtrl.text,
                          'color1': toHex(c1),
                          'color2': toHex(c2),
                        });
                        ref.invalidate(bannersProvider);
                        if (ctx.mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Banner saved successfully')));
                        }
                      } catch (e) {
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save banner: $e')));
                        }
                      }`;

text = text.replace(oldApi, newApi);

fs.writeFileSync(file, text);
