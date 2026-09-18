const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../../.env') });
const required = ['DB_HOST', 'DB_USER', 'DB_NAME', 'JWT_SECRET'];
for (const key of required) if (!process.env[key]) throw new Error(`Missing environment variable: ${key}`);
module.exports = Object.freeze({
  nodeEnv: process.env.NODE_ENV || 'development', port: Number(process.env.PORT || 5000),
  apiPrefix: process.env.API_PREFIX || '/api/v1', corsOrigin: process.env.CORS_ORIGIN || '*',
  db: { host: process.env.DB_HOST, port: Number(process.env.DB_PORT || 3306), user: process.env.DB_USER,
    password: process.env.DB_PASSWORD || '', database: process.env.DB_NAME, connectionLimit: Number(process.env.DB_CONNECTION_LIMIT || 10) },
  jwtSecret: process.env.JWT_SECRET, jwtExpiresIn: process.env.JWT_EXPIRES_IN || '7d'
});
