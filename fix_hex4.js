const fs = require('fs');
const file = 'lib/features/auth/screens/admin_home_screen.dart';
let text = fs.readFileSync(file, 'utf8');

text = text.replace(/String toHex[\s\S]*?await ApiService\.post/g, `String toHex(Color c) { return '#\${c.toARGB32().toRadixString(16).padLeft(8, "0").toUpperCase()}'; }
                      try {
                        await ApiService.post`);

// And replace the rest of the block...
text = text.replace(/ref\.invalidate\(bannersProvider\);\n\s*if \(ctx\.mounted\) Navigator\.pop\(ctx\);/, `ref.invalidate(bannersProvider);
                        if (ctx.mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Banner saved successfully')));
                        }
                      } catch (e) {
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save banner: $e')));
                        }
                      }`);

fs.writeFileSync(file, text);
