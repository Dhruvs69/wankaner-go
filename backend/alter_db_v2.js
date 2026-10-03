const pool = require('./db.js');

async function runAlter() {
  try {
    console.log('Adding delivery_otp, commission, delivery_fee to orders...');
    await pool.query("ALTER TABLE orders ADD COLUMN IF NOT EXISTS delivery_otp VARCHAR(10) DEFAULT NULL;");
    await pool.query("ALTER TABLE orders ADD COLUMN IF NOT EXISTS vendor_commission DOUBLE DEFAULT 0.0;");
    await pool.query("ALTER TABLE orders ADD COLUMN IF NOT EXISTS delivery_fee DOUBLE DEFAULT 0.0;");
    await pool.query("ALTER TABLE orders ADD COLUMN IF NOT EXISTS is_paid_to_vendor BOOLEAN DEFAULT false;");
    await pool.query("ALTER TABLE orders ADD COLUMN IF NOT EXISTS is_paid_to_delivery BOOLEAN DEFAULT false;");

    console.log('Adding opening_time, closing_time, wallet_balance to vendors...');
    await pool.query("ALTER TABLE vendors ADD COLUMN IF NOT EXISTS opening_time TIME DEFAULT '09:00:00';");
    await pool.query("ALTER TABLE vendors ADD COLUMN IF NOT EXISTS closing_time TIME DEFAULT '22:00:00';");
    await pool.query("ALTER TABLE vendors ADD COLUMN IF NOT EXISTS wallet_balance DOUBLE DEFAULT 0.0;");

    console.log('Adding current_lat, current_lng, wallet_balance to users...');
    await pool.query("ALTER TABLE users ADD COLUMN IF NOT EXISTS current_lat DOUBLE DEFAULT NULL;");
    await pool.query("ALTER TABLE users ADD COLUMN IF NOT EXISTS current_lng DOUBLE DEFAULT NULL;");
    await pool.query("ALTER TABLE users ADD COLUMN IF NOT EXISTS wallet_balance DOUBLE DEFAULT 0.0;");
    await pool.query("ALTER TABLE users ADD COLUMN IF NOT EXISTS is_online BOOLEAN DEFAULT false;");

    console.log('Creating payouts table...');
    await pool.query(`
      CREATE TABLE IF NOT EXISTS payouts (
        id VARCHAR(100) PRIMARY KEY,
        user_id VARCHAR(100) NOT NULL,
        amount DOUBLE NOT NULL,
        type ENUM('vendor', 'delivery') NOT NULL,
        status ENUM('pending', 'completed') DEFAULT 'pending',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      );
    `);

    console.log('Database schema successfully updated for new features.');
  } catch (err) {
    console.error('Error altering table:', err);
  } finally {
    process.exit();
  }
}

runAlter();
