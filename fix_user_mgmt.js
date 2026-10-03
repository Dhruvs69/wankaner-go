const fs = require('fs');

let text = fs.readFileSync('lib/features/auth/screens/admin_home_screen.dart', 'utf-8');

text = text.replace(
  'trailing: Row(\n                          mainAxisSize: MainAxisSize.min,',
  'trailing: FittedBox(\n                          fit: BoxFit.scaleDown,\n                          child: Row(\n                            mainAxisSize: MainAxisSize.min,'
);

// We need to add the closing parenthesis for FittedBox!
// Find the end of that trailing block.
const lines = text.split('\n');
let replaced = false;
for (let i = 0; i < lines.length; i++) {
  if (lines[i].includes('trailing: FittedBox(')) {
    // Search for the end of the Row
    let depth = 0;
    for (let j = i; j < lines.length; j++) {
      if (lines[j].includes('[')) depth++;
      if (lines[j].includes(']')) {
        depth--;
        if (depth === 0) {
          // Add the closing for FittedBox
          lines[j] = lines[j] + '),'; // children: [...]), 
          replaced = true;
          break;
        }
      }
    }
  }
}

if (replaced) {
  fs.writeFileSync('lib/features/auth/screens/admin_home_screen.dart', lines.join('\n'), 'utf-8');
  console.log('Fixed _buildUserManagement trailing overflow!');
} else {
  console.log('Failed to fix _buildUserManagement.');
}
