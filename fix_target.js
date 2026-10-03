const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/delivery_home_screen.dart', 'utf-8');

// First, revert the wrong replacement
const wrongSuccess = `                            
                            // Show success animation
                            if (mounted) {
                               showDialog(
                                 context: context, 
                                 barrierDismissible: false, 
                                 builder: (_) => const _SuccessAnimationDialog()
                               );
                            }`;
text = text.replace(wrongSuccess, '');


// Then explicitly target the "Mark Delivered" try/catch block
// We can use a regex that matches `updateOrderStatus(order.id, 'delivered'`
const deliveredBlockRegex = /updateOrderStatus\(order\.id,\s*'delivered'[\s\S]*?ref\.invalidate\([\s\S]*?deliveryOrdersProvider\([\s\S]*?\)\);\s*\} catch \(e\) \{/;

const newDeliveredBlock = `updateOrderStatus(order.id, 'delivered',
                                    proofImageUrl: capturedImageUrl,
                                    deliveryOtp: otpController.text.isNotEmpty ? otpController.text : null);
                            ref.invalidate(
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

if (deliveredBlockRegex.test(text)) {
   text = text.replace(deliveredBlockRegex, newDeliveredBlock);
   fs.writeFileSync('lib/features/auth/screens/delivery_home_screen.dart', text, 'utf-8');
   console.log('Fixed success animation target!');
} else {
   console.log('Target regex failed');
}
