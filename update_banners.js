const fs = require('fs');
const file = 'lib/features/auth/screens/customer_home_screen.dart';
let text = fs.readFileSync(file, 'utf8');

if (!text.includes('banner_provider.dart')) {
  text = text.replace("import '../../../core/widgets/notification_bell.dart';", "import '../../../core/widgets/notification_bell.dart';\nimport '../../customer/providers/banner_provider.dart';");
}

text = text.replace(/SizedBox\(\s*height: 160,\s*child: PageView\([\s\S]*?\]\,\s*\)\,\s*\)\,/, `SizedBox(
                      height: 160,
                      child: ref.watch(bannersProvider).when(
                        data: (banners) {
                          if (banners.isEmpty) return const SizedBox.shrink();
                          return PageView(
                            controller: _bannerController,
                            children: banners.map((b) => _PromoBanner(
                                  title: b.title,
                                  subtitle: b.subtitle,
                                  colors: [b.color1, b.color2],
                                  emoji: b.emoji,
                                )).toList(),
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ),`);

fs.writeFileSync(file, text);
