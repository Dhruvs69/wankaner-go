const fs = require('fs');
const file = 'lib/features/auth/screens/admin_home_screen.dart';
let text = fs.readFileSync(file, 'utf8');

text = text.replace("_buildDrawerItem(6, Icons.notifications_active, 'Global Push'),", "_buildDrawerItem(6, Icons.notifications_active, 'Global Push'),\n                    _buildDrawerItem(7, Icons.image, 'Banners'),");

text = text.replace("NavigationRailDestination(\n                    icon: Icon(Icons.notifications_active),\n                    label: Text('Global Push')),", "NavigationRailDestination(\n                    icon: Icon(Icons.notifications_active),\n                    label: Text('Global Push')),\n                NavigationRailDestination(\n                    icon: Icon(Icons.image), label: Text('Banners')),");

text = text.replace("return _buildGlobalPush();", "return _buildGlobalPush();\n      case 7:\n        return _buildBannersManagement();");

fs.writeFileSync(file, text);
