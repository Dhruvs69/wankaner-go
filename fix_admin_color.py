import sys
file_path = 'lib/features/auth/screens/admin_home_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

# Fix AppBar
text = text.replace(
    'title: const Text(\'WankanerGo Admin\',\n                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),\n              backgroundColor: Colors.blueGrey.shade900,',
    'title: const Text(\'WankanerGo Admin\',\n                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),\n              backgroundColor: Colors.deepOrange,'
)
text = text.replace(
    'title: const Text(\'WankanerGo Admin\',\n                  style: TextStyle(fontWeight: FontWeight.bold)),\n              backgroundColor: Colors.blueGrey.shade900,',
    'title: const Text(\'WankanerGo Admin\',\n                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),\n              backgroundColor: Colors.deepOrange,'
)

# Fix DrawerHeader
text = text.replace(
    'DrawerHeader(\n                    decoration: BoxDecoration(color: Colors.blueGrey.shade900),',
    'DrawerHeader(\n                    decoration: BoxDecoration(color: Colors.deepOrange),'
)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(text)
print('Fixed precise admin colors')
