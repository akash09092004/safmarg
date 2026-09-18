const jwt = require('jsonwebtoken');
const env = require('../config/env');
const User = require('../models/userModel');
const { failure } = require('../utils/response');
const { asyncHandler } = require('./errorMiddleware');
exports.protect = asyncHandler(async (req, res, next) => {
  const token = req.headers.authorization?.startsWith('Bearer ') && req.headers.authorization.slice(7);
  if (!token) return failure(res, 'Authentication required', 401);
  try {
    const payload = jwt.verify(token, env.jwtSecret);
    const user = await User.findById(payload.id);
    if (!user || !user.is_active) return failure(res, 'User is inactive or does not exist', 401);
    req.user = user; next();
  } catch (_) { return failure(res, 'Invalid or expired token', 401); }
});
