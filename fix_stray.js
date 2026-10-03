const fs = require('fs');
let text = fs.readFileSync('backend/routes/vendors.js', 'utf-8');

const regex = /\s*\}\s*catch\s*\(err\)\s*\{\s*res\.status\(500\)\.json\(\{\s*error:\s*err\.message\s*\}\);\s*\}\s*\}\);/g;

text = text.replace(regex, (match, offset) => {
   // Only replace if it's the stray one (we can check if the previous lines don't have a matching try block).
   // Let's just remove the first one that matches the specific stray format right after another router block.
   return '';
});

// Actually, I'll just use my trusty node loop to find the exact line numbers and splice them out.
const lines = text.split('\n');
let newLines = [];
let i = 0;
while (i < lines.length) {
    if (lines[i].includes('} catch (err) {') && 
        lines[i+1] && lines[i+1].includes('res.status(500).json({ error: err.message });') &&
        lines[i+2] && lines[i+2].includes('}') &&
        lines[i+3] && lines[i+3].includes('});') &&
        lines[i-1] === '' && lines[i-2] === '') {
        // Skip these 4 lines
        i += 4;
    } else {
        newLines.push(lines[i]);
        i++;
    }
}

fs.writeFileSync('backend/routes/vendors.js', newLines.join('\n'), 'utf-8');
console.log('Fixed stray block');
