const db = require('./backend/db');

async function clearOrders() {
    try {
        console.log('Connecting to database and clearing orders...');
        // Delete all order items first to avoid foreign key constraints
        const [res1] = await db.query('DELETE FROM order_items');
        console.log(`Deleted ${res1.affectedRows} order items.`);
        
        // Delete all orders
        const [res2] = await db.query('DELETE FROM orders');
        console.log(`Deleted ${res2.affectedRows} orders.`);
        
        console.log('All fake orders cleared successfully!');
        process.exit(0);
    } catch (e) {
        console.error('Error clearing orders:', e);
        process.exit(1);
    }
}

clearOrders();
