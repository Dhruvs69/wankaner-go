const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/delivery_home_screen.dart', 'utf-8');

const classCode = `
class _SuccessAnimationDialog extends StatefulWidget {
  const _SuccessAnimationDialog();
  @override
  State<_SuccessAnimationDialog> createState() => _SuccessAnimationDialogState();
}

class _SuccessAnimationDialogState extends State<_SuccessAnimationDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) Navigator.pop(context);
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.green.withOpacity(0.5), blurRadius: 40, spreadRadius: 15)
              ]
            ),
            child: const Icon(Icons.check_circle, color: Colors.green, size: 100),
          ),
        ),
      ),
    );
  }
}
`;

if (!text.includes('_SuccessAnimationDialog')) {
  text += classCode;
}

const originalSuccess = `                            ref.invalidate(
                                deliveryOrdersProvider(ref.read(authStateProvider).value ?? ''));
                          } catch (e) {`;

const newSuccess = `                            ref.invalidate(
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

text = text.replace(originalSuccess, newSuccess);
fs.writeFileSync('lib/features/auth/screens/delivery_home_screen.dart', text, 'utf-8');
console.log('Added success animation');
