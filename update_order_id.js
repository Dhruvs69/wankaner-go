const fs = require('fs');
let text = fs.readFileSync('backend/routes/orders.js', 'utf-8');

// Replace uuid require with crypto (optional, we can just require crypto inside)
const original = 'const id = uuidv4();';
const newCode = `const crypto = require('crypto');
    const id = 'WK-' + crypto.randomBytes(3).toString('hex').toUpperCase();`;

if (text.includes(original)) {
   text = text.replace(original, newCode);
   fs.writeFileSync('backend/routes/orders.js', text, 'utf-8');
   console.log('Backend Order ID updated!');
} else {
   console.log('original text not found');
}
