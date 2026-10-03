const mysql = require('mysql2/promise');

async function migrate() {
    console.log('Connecting to local DB...');
    const local = await mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: '',
        database: 'wankaner_go'
    });

    console.log('Connecting to remote DB...');
    const remote = await mysql.createConnection({
        host: 'wankaner-mysql-wankaner-go.b.aivencloud.com',
        port: 22766,
        user: 'avnadmin',
        password: 'AVNS_oij8oBfUhJ71_2Lk09L',
        database: 'defaultdb'
    });

    const [tables] = await local.query("SHOW TABLES");
    const tableNames = tables.map(t => Object.values(t)[0]);
    console.log('Tables found:', tableNames);

    await remote.query('SET FOREIGN_KEY_CHECKS = 0');

    for (const tableName of tableNames) {
        console.log(`Migrating table ${tableName}...`);
        
        // Create table
        const [createTableResult] = await local.query(`SHOW CREATE TABLE \`${tableName}\``);
        const createSql = createTableResult[0]['Create Table'];
        
        await remote.query(`DROP TABLE IF EXISTS \`${tableName}\``);
        await remote.query(createSql);
        console.log(`- Created table ${tableName}`);

        // Insert data
        const [rows] = await local.query(`SELECT * FROM \`${tableName}\``);
        if (rows.length > 0) {
            const columns = Object.keys(rows[0]).map(c => `\`${c}\``).join(', ');
            
            // Chunk inserts
            const chunkSize = 100;
            for (let i = 0; i < rows.length; i += chunkSize) {
                const chunk = rows.slice(i, i + chunkSize);
                const values = [];
                const placeholders = [];
                for (const row of chunk) {
                    const rowValues = Object.values(row);
                    values.push(...rowValues);
                    placeholders.push(`(${new Array(rowValues.length).fill('?').join(',')})`);
                }
                
                await remote.query(`INSERT INTO \`${tableName}\` (${columns}) VALUES ${placeholders.join(',')}`, values);
            }
            console.log(`- Inserted ${rows.length} rows into ${tableName}`);
        } else {
            console.log(`- No data for ${tableName}`);
        }
    }

    await remote.query('SET FOREIGN_KEY_CHECKS = 1');
    
    console.log('Migration Complete!');
    await local.end();
    await remote.end();
}

migrate().catch(console.error);
