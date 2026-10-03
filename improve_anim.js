const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/delivery_home_screen.dart', 'utf-8');

const regex = /class _SuccessAnimationDialog extends StatefulWidget \{[\s\S]*?\}(?=\s*$)/;

const newDialog = `class _SuccessAnimationDialog extends StatefulWidget {
  const _SuccessAnimationDialog();
  @override
  State<_SuccessAnimationDialog> createState() => _SuccessAnimationDialogState();
}

class _SuccessAnimationDialogState extends State<_SuccessAnimationDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1.0, curve: Curves.easeIn)));
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 2500), () {
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
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.green.withValues(alpha: 0.4), blurRadius: 40, spreadRadius: 10)
              ]
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 90),
                const SizedBox(height: 24),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    'Delivery Successful!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    'Great job! Earnings added.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}`;

if (regex.test(text)) {
  text = text.replace(regex, newDialog);
  fs.writeFileSync('lib/features/auth/screens/delivery_home_screen.dart', text, 'utf-8');
  console.log('Success animation improved!');
} else {
  console.log('Regex did not match!');
}
