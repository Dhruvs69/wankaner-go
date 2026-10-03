const fs = require('fs');
let text = fs.readFileSync('backend/routes/users.js', 'utf-8');
const lines = text.split('\n');
const filtered = [];
let found = false;
for (let line of lines) {
    if (line.includes("const { v4: uuidv4 } = require('uuid');")) {
        if (!found) {
            found = true; // Keep the first one
            filtered.push(line);
        } else {
            // Drop the second one
        }
    } else {
        filtered.push(line);
    }
}
fs.writeFileSync('backend/routes/users.js', filtered.join('\n'), 'utf-8');
