import sys
import re
file_path = 'lib/features/auth/screens/admin_home_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

# Fix Row with 'Promotional Banners'
text = text.replace(
    "const Text('Promotional Banners',\n                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),",
    "Expanded(child: const Text('Promotional Banners', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),"
)

# Fix Column overflowing at the bottom
text = text.replace(
    '''                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(banner.emoji,
                                      style: const TextStyle(fontSize: 40)),
                                  IconButton(
                                    icon: const Icon(Icons.delete,''',
    '''                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(banner.emoji, style: const TextStyle(fontSize: 40)),
                                  IconButton(
                                    icon: const Icon(Icons.delete,'''
)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(text)
print('Fixed admin overflows')
