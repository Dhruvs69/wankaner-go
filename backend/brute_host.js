const mysql = require('mysql2/promise');

async function test() {
    const chars = 'abcdefghijklmnopqrstuvwxyz'.split('');
    for (const c of chars) {
        const host = `wankaner-mysql-wankaner-go.${c}.aivencloud.com`;
        try {
            console.log('Trying', host);
            const connection = await mysql.createConnection({
                host: host,
                port: 22766,
                user: 'avnadmin',
                password: 'AVNS_oij8oBfUhJ7l_2Lk09L',
                database: 'defaultdb',
                connectTimeout: 2000
            });
            console.log('SUCCESS with', host);
            await connection.end();
            return;
        } catch (e) {
            if (e.code !== 'ENOTFOUND') {
                console.log('Error with', host, e.message);
            }
        }
    }
}
test();
