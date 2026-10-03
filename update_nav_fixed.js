const fs = require('fs');
const file = 'lib/features/auth/screens/admin_home_screen.dart';
let text = fs.readFileSync(file, 'utf8');

text = text.replace("_buildDrawerItem(10, Icons.settings, 'Settings')", "_buildDrawerItem(10, Icons.image, 'Banners'),\n                  _buildDrawerItem(11, Icons.settings, 'Settings')");

text = text.replace("NavigationRailDestination(\n                      icon: Icon(Icons.settings), label: Text('Settings')),", "NavigationRailDestination(\n                      icon: Icon(Icons.image), label: Text('Banners')),\n                  NavigationRailDestination(\n                      icon: Icon(Icons.settings), label: Text('Settings')),");

text = text.replace("        case 10:\n          return const Center(child: Text('Settings View'));", "        case 10:\n          return _buildBannersManagement();\n        case 11:\n          return const Center(child: Text('Settings View'));");

fs.writeFileSync(file, text);
