const db = require('./db');

async function updateDB() {
  try {
    const connection = await db.getConnection();
    console.log("Connected to DB, running ALTER TABLE...");
    await connection.query("ALTER TABLE vendors ADD COLUMN lat DOUBLE DEFAULT 0.0");
    await connection.query("ALTER TABLE vendors ADD COLUMN lng DOUBLE DEFAULT 0.0");
    console.log("Added lat and lng to vendors successfully.");
    connection.release();
    process.exit(0);
  } catch (err) {
    if (err.code === 'ER_DUP_FIELDNAME') {
      console.log("Columns already exist.");
      process.exit(0);
    } else {
      console.error(err);
      process.exit(1);
    }
  }
}

updateDB();
