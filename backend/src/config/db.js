const mysql = require('mysql2/promise');
const env = require('./env');
const pool = mysql.createPool({ ...env.db, waitForConnections: true, queueLimit: 0, decimalNumbers: true, dateStrings: true });
async function query(sql, params = []) { const [rows] = await pool.execute(sql, params); return rows; }
async function testConnection() { const connection = await pool.getConnection(); connection.release(); console.log('MySQL connected'); }
async function closePool() { await pool.end(); }
module.exports = { pool, query, testConnection, closePool };
