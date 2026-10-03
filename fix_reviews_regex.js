const fs = require('fs');
let text = fs.readFileSync('backend/routes/vendors.js', 'utf-8');

const regex = /\/\/\s*Promote vendor \(Admin\)[\s\S]*?router\.put\('\/:id\/promote', async \(req, res\) => \{[\s\S]*?\}\);/;

const match = text.match(regex);
if (match) {
   const promoteText = match[0];
   text = text.replace(promoteText, '');
   text += '\n\n' + promoteText;
   fs.writeFileSync('backend/routes/vendors.js', text, 'utf-8');
   console.log('Moved promote route out of reviews route successfully!');
} else {
   console.log('Regex failed');
}
