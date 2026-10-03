const fs = require('fs');
let text = fs.readFileSync('backend/server.js', 'utf8');
text = text.replace("const settingsRouter = require('./routes/settings');", "const settingsRouter = require('./routes/settings');\nconst payoutsRouter = require('./routes/payouts');");
text = text.replace("app.use('/settings', settingsRouter);", "app.use('/settings', settingsRouter);\napp.use('/payouts', payoutsRouter);");
fs.writeFileSync('backend/server.js', text);
