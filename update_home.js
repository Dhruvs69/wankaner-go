const fs = require('fs');
const filePath = 'lib/features/auth/screens/customer_home_screen.dart';
let content = fs.readFileSync(filePath, 'utf8');

if (!content.includes("import 'dart:async';")) {
    content = content.replace("import 'package:flutter/material.dart';", "import 'dart:async';\nimport 'package:flutter/material.dart';");
}

if (!content.includes('Timer? _bannerTimer;')) {
    content = content.replace("final PageController _bannerController =", "Timer? _bannerTimer;\n  final PageController _bannerController =");
}

if (!content.includes('_startBannerTimer();')) {
    content = content.replace('super.initState();', "super.initState();\n    _startBannerTimer();");
}

if (!content.includes('void _startBannerTimer()')) {
    const timerCode = `
  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_bannerController.hasClients) {
        int nextPage = _bannerController.page!.round() + 1;
        if (nextPage > 1) {
          nextPage = 0; // We have 2 banners right now
        }
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }
`;
    content = content.replace('void dispose() {', timerCode + '\n  @override\n  void dispose() {');
}

if (!content.includes('_bannerTimer?.cancel();')) {
    content = content.replace('_bannerController.dispose();', '_bannerController.dispose();\n    _bannerTimer?.cancel();');
}

if (!content.includes('Widget _buildGreeting')) {
    const greetingCode = `
  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Widget _buildGreeting(WidgetRef ref) {
    final userAsync = ref.watch(currentUserStreamProvider);
    return userAsync.when(
      data: (user) {
        if (user == null) return const SizedBox.shrink();
        final firstName = user.name.split(' ').first;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('\${_getGreeting()}, \$firstName!', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: Colors.black87)),
              const SizedBox(height: 4),
              const Text('Feeling hungry? We got you.', style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(16.0),
        child: SizedBox(height: 40, width: 200, child: Placeholder(color: Colors.transparent)),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
`;
    content = content.replace('Widget _buildQuickReorder(WidgetRef ref)', greetingCode + '\n  Widget _buildQuickReorder(WidgetRef ref)');
}

if (!content.includes('_buildGreeting(ref)')) {
    content = content.replace('children: [\n                Padding(', 'children: [\n                _buildGreeting(ref),\n                Padding(');
}

fs.writeFileSync(filePath, content);
