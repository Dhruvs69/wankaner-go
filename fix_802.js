const fs = require('fs');
let text = fs.readFileSync('lib/features/auth/screens/vendor_home_screen.dart', 'utf-8');
const lines = text.split('\n');

const newLines = [];
for (let i=0; i<lines.length; i++) {
  if (lines[i].includes('The above content does NOT show')) {
    continue;
  }
  if (i === 802 && lines[i].trim() === '),') {
    continue;
  }
  newLines.push(lines[i]);
}

fs.writeFileSync('lib/features/auth/screens/vendor_home_screen.dart', newLines.join('\n'), 'utf-8');
console.log('Fixed line 802!');
