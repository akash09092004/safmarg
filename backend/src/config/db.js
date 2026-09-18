const mysql = require('mysql2/promise');

const env = require('./env');

// =========================
// MySQL Connection Pool
// =========================

const pool = mysql.createPool({
  ...env.db,

  ssl: {
    rejectUnauthorized: false,
  },

  waitForConnections: true,
  queueLimit: 0,
  decimalNumbers: true,
  dateStrings: true,
});

// =========================
// Run SQL Query
// =========================

async function query(sql, params = []) {
  const [rows] = await pool.execute(
    sql,
    params
  );

  return rows;
}

// =========================
// Test Database Connection
// =========================

async function testConnection() {
  const connection =
    await pool.getConnection();

  try {
    console.log('MySQL connected');
    console.log(
      'Database:',
      env.db.database
    );
    console.log(
      'Host:',
      env.db.host
    );
  } finally {
    connection.release();
  }
}

// =========================
// Close Connection Pool
// =========================

async function closePool() {
  await pool.end();
}

module.exports = {
  pool,
  query,
  testConnection,
  closePool,
};