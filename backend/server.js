const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');
const env = require('./src/config/env');
const { testConnection, closePool } = require('./src/config/db');
const { notFound, errorHandler } = require('./src/middleware/errorMiddleware');

const app = express();
app.disable('x-powered-by');
app.use(helmet());
app.use(cors({ origin: env.corsOrigin === '*' ? true : env.corsOrigin.split(',') }));
app.use(express.json({ limit: '1mb' }));
app.use(express.urlencoded({ extended: true }));
app.use(morgan(env.nodeEnv === 'production' ? 'combined' : 'dev'));
app.use(`${env.apiPrefix}/auth`, rateLimit({ windowMs: 15 * 60 * 1000, limit: 100 }), require('./src/routes/authRoutes'));
app.use(`${env.apiPrefix}/users`, require('./src/routes/userRoutes'));
app.use(`${env.apiPrefix}/flights`, require('./src/routes/flightRoutes'));
app.use(`${env.apiPrefix}/bookings`, require('./src/routes/bookingRoutes'));
app.use(`${env.apiPrefix}/passengers`, require('./src/routes/passengerRoutes'));
app.use(`${env.apiPrefix}/seats`, require('./src/routes/seatRoutes'));
app.use(`${env.apiPrefix}/payments`, require('./src/routes/paymentRoutes'));
app.use(`${env.apiPrefix}/refunds`, require('./src/routes/refundRoutes'));
app.use(`${env.apiPrefix}/offers`, require('./src/routes/offerRoutes'));
app.use(`${env.apiPrefix}/notifications`, require('./src/routes/notificationRoutes'));
app.use(`${env.apiPrefix}/admin`, require('./src/routes/adminRoutes'));
app.get('/health', (_req, res) => res.json({ success: true, message: 'SafMarg API is running' }));
app.use(notFound);
app.use(errorHandler);

let server;
async function start() {
  await testConnection();
  server = app.listen(env.port, () => console.log(`SafMarg API: http://localhost:${env.port}${env.apiPrefix}`));
}
if (require.main === module) start().catch((error) => { console.error('Startup failed:', error.message); process.exit(1); });
async function shutdown() { if (server) server.close(); await closePool(); }
process.on('SIGINT', shutdown);
process.on('SIGTERM', shutdown);
module.exports = app;
