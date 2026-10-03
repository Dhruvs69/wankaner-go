const pool = require('./backend/db.js');
async function run() {
  try {
    const tables = ['items', 'vendors'];
    for (let table of tables) {
      if (table === 'vendors') {
          await pool.query("UPDATE vendors SET image_url = REPLACE(image_url, '10.180.131.116', '10.205.76.116')");
      } else if (table === 'items') {
          await pool.query("UPDATE items SET image_url = REPLACE(image_url, '10.180.131.116', '10.205.76.116')");
      }
    }
    console.log('Done');
    process.exit(0);
  } catch(e) {
    console.error(e);
    process.exit(1);
  }
}
run();
