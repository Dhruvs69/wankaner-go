const fs = require('fs');
let text = fs.readFileSync('backend/server.js', 'utf-8');

text = text.replace(
    "const settingsRoutes = require('./routes/settings');",
    "const settingsRoutes = require('./routes/settings');\nconst payoutsRoutes = require('./routes/payouts');"
);

text = text.replace(
    "app.use('/api/settings', settingsRoutes);",
    "app.use('/api/settings', settingsRoutes);\napp.use('/api/payouts', payoutsRoutes);"
);

fs.writeFileSync('backend/server.js', text, 'utf-8');
