const jwt = require('jsonwebtoken');
const env = require('../config/env');
module.exports = (user) => jwt.sign({ id: user.id, role: user.role, email: user.email }, env.jwtSecret, { expiresIn: env.jwtExpiresIn });
