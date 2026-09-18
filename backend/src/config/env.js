const path = require('path');

// ========================================
// Load Environment Variables
// ========================================

const envPath = path.resolve(
  __dirname,
  '../../.env'
);

require('dotenv').config({
  path: envPath,
  override: true,
});

// ========================================
// Debug - Check Which Database Is Loading
// ========================================

console.log('ENV FILE:', envPath);
console.log('DB HOST:', process.env.DB_HOST);
console.log('DB PORT:', process.env.DB_PORT);
console.log('DB USER:', process.env.DB_USER);
console.log('DB NAME:', process.env.DB_NAME);

// Password ko console me print nahi karna.

// ========================================
// Required Environment Variables
// ========================================

const required = [
  'DB_HOST',
  'DB_USER',
  'DB_NAME',
  'JWT_SECRET',
];

for (const key of required) {
  if (!process.env[key]) {
    throw new Error(
      `Missing environment variable: ${key}`
    );
  }
}

// ========================================
// Application Configuration
// ========================================

const env = {
  nodeEnv:
    process.env.NODE_ENV ||
    'development',

  port: Number(
    process.env.PORT ||
    5000
  ),

  apiPrefix:
    process.env.API_PREFIX ||
    '/api/v1',

  corsOrigin:
    process.env.CORS_ORIGIN ||
    '*',

  // ======================================
  // MySQL / Aiven Database
  // ======================================

  db: {
    host:
      process.env.DB_HOST,

    port: Number(
      process.env.DB_PORT ||
      3306
    ),

    user:
      process.env.DB_USER,

    password:
      process.env.DB_PASSWORD ||
      '',

    database:
      process.env.DB_NAME,

    connectionLimit: Number(
      process.env.DB_CONNECTION_LIMIT ||
      10
    ),
  },

  // ======================================
  // JWT
  // ======================================

  jwtSecret:
    process.env.JWT_SECRET,

  jwtExpiresIn:
    process.env.JWT_EXPIRES_IN ||
    '7d',
};

// ========================================
// Export
// ========================================

module.exports = Object.freeze(env);