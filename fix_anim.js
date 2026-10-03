const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/delivery_home_screen.dart', 'utf-8');

const regex = /ref\.invalidate\([\s\S]*?deliveryOrdersProvider\([\s\S]*?\)\);\s*\} catch \(e\) \{/;
const newSuccess = `ref.invalidate(
                                deliveryOrdersProvider(ref.read(authStateProvider).value ?? ''));
                            
                            // Show success animation
                            if (mounted) {
                               showDialog(
                                 context: context, 
                                 barrierDismissible: false, 
                                 builder: (_) => const _SuccessAnimationDialog()
                               );
                            }
                          } catch (e) {`;

if (regex.test(text)) {
  text = text.replace(regex, newSuccess);
  fs.writeFileSync('lib/features/auth/screens/delivery_home_screen.dart', text, 'utf-8');
  console.log('Success animation added!');
} else {
  console.log('Regex did not match!');
}
