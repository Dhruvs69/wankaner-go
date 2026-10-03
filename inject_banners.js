const fs = require('fs');
const file = 'lib/features/auth/screens/admin_home_screen.dart';
let text = fs.readFileSync(file, 'utf8');

const injectCode = `
  Widget _buildBannersManagement() {
    final bannersAsync = ref.watch(bannersProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Promotional Banners',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Banner'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white),
                onPressed: () => _showAddBannerDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: bannersAsync.when(
              data: (banners) {
                if (banners.isEmpty) {
                  return const Center(child: Text('No banners found.'));
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 800 ? 3 : 1,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: banners.length,
                  itemBuilder: (context, index) {
                    final banner = banners[index];
                    return Card(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [banner.color1, banner.color2],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(banner.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                                    const SizedBox(height: 8),
                                    Text(banner.subtitle, style: const TextStyle(fontSize: 16, color: Colors.black54)),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(banner.emoji, style: const TextStyle(fontSize: 40)),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      await ApiService.delete('/banners/\${banner.id}');
                                      ref.invalidate(bannersProvider);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddBannerDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final subtitleCtrl = TextEditingController();
    final emojiCtrl = TextEditingController();
    Color c1 = const Color(0xFFFF9A9E);
    Color c2 = const Color(0xFFFECFEF);

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Promotional Banner'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title (use \\n for newline)')),
                    TextField(controller: subtitleCtrl, decoration: const InputDecoration(labelText: 'Subtitle')),
                    TextField(controller: emojiCtrl, decoration: const InputDecoration(labelText: 'Emoji (e.g. 🍔)')),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Color 1: '),
                        GestureDetector(
                          onTap: () {
                            showDialog(context: context, builder: (_) => AlertDialog(
                              content: SingleChildScrollView(child: ColorPicker(pickerColor: c1, onColorChanged: (c) => setState(() => c1 = c))),
                              actions: [TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('Done'))],
                            ));
                          },
                          child: Container(width: 40, height: 40, color: c1),
                        ),
                        const SizedBox(width: 16),
                        const Text('Color 2: '),
                        GestureDetector(
                          onTap: () {
                            showDialog(context: context, builder: (_) => AlertDialog(
                              content: SingleChildScrollView(child: ColorPicker(pickerColor: c2, onColorChanged: (c) => setState(() => c2 = c))),
                              actions: [TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('Done'))],
                            ));
                          },
                          child: Container(width: 40, height: 40, color: c2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () async {
                    String toHex(Color c) {
                      final hex = c.toString().split('(0x')[1].split(')')[0];
                      return '#\${hex.toUpperCase()}';
                    }
                    await ApiService.post('/banners', {
                      'title': titleCtrl.text.replaceAll('\\\\n', '\\n'),
                      'subtitle': subtitleCtrl.text,
                      'emoji': emojiCtrl.text,
                      'color1': toHex(c1),
                      'color2': toHex(c2),
                    });
                    ref.invalidate(bannersProvider);
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  child: const Text('Save Banner'),
                ),
              ],
            );
          },
        );
      },
    );
  }

`;

const target = 'class _AddShopDialog extends ConsumerStatefulWidget {';
if (text.includes(target)) {
    text = text.replace(target, injectCode + target);
    fs.writeFileSync(file, text);
    console.log('Injected successfully');
} else {
    console.log('Target not found');
}
