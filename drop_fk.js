const db = require('./backend/db');

async function dropConstraint() {
    try {
        const [rows] = await db.query('SHOW CREATE TABLE reviews');
        const createTableSql = rows[0]['Create Table'];
        console.log(createTableSql);
        
        // Find the constraint name for order_id
        // CONSTRAINT `reviews_ibfk_3` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
        const match = createTableSql.match(/CONSTRAINT `([^`]+)` FOREIGN KEY \(`order_id`\)/);
        if (match) {
            const constraintName = match[1];
            await db.query(`ALTER TABLE reviews DROP FOREIGN KEY \`${constraintName}\``);
            console.log(`Dropped constraint ${constraintName}`);
        } else {
            console.log('Could not find foreign key constraint for order_id');
        }
        process.exit(0);
    } catch (e) {
        console.error(e);
        process.exit(1);
    }
}
dropConstraint();
