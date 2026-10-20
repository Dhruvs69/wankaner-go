const mysql = require('mysql2/promise');
require('dotenv').config();

const isRemote = process.env.DB_HOST && 
    process.env.DB_HOST !== 'localhost' && 
    process.env.DB_HOST !== '127.0.0.1';

const pool = mysql.createPool({
    host: process.env.DB_HOST || 'localhost',
    port: Number(process.env.DB_PORT) || 3306,
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'wankaner_go',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0,
    ssl: (isRemote || process.env.DB_SSL === 'true') ? {
        minVersion: 'TLSv1.2',
        rejectUnauthorized: true
    } : undefined
});

module.exports = pool;
