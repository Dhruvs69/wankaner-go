const fs = require('fs');
let text = fs.readFileSync('backend/routes/vendors.js', 'utf-8');

const strayBlock = `    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});`;

text = text.replace(strayBlock, '');
fs.writeFileSync('backend/routes/vendors.js', text, 'utf-8');
console.log('Fixed stray block');
