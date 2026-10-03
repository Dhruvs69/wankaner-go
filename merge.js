const fs = require('fs');
let original = fs.readFileSync('vendor_home_screen_original.dart', 'utf-8');
// Remove the 'The above content does NOT show...' line
original = original.replace('The above content does NOT show the entire file contents. If you need to view any lines of the file which were not shown to complete your task, call this tool again to view those lines.', '');

let current = fs.readFileSync('lib/features/auth/screens/vendor_home_screen.dart', 'utf-8');
const searchStr = "                  labelText: 'Product Image URL',\n                  hintText: 'Upload or paste image URL',\n                  prefixIcon: Icon(Icons.link),\n                ),";

const idx = current.indexOf(searchStr);
if (idx === -1) { console.log('ERROR matching string!'); process.exit(1); }

const restOfFile = current.substring(idx + searchStr.length);

const fullFile = original.trimEnd() + '\n' + restOfFile;
fs.writeFileSync('vendor_home_screen_restored.dart', fullFile, 'utf-8');
console.log('Successfully merged! Length: ' + fullFile.length);
