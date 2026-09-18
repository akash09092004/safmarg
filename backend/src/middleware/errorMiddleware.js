const { failure } = require('../utils/response');
exports.asyncHandler = (fn) => (req, res, next) => Promise.resolve(fn(req, res, next)).catch(next);
exports.notFound = (req, res) => failure(res, `Route not found: ${req.method} ${req.originalUrl}`, 404);
exports.errorHandler = (err, _req, res, _next) => {
  if (process.env.NODE_ENV !== 'production') console.error(err);
  if (err.code === 'ER_DUP_ENTRY') return failure(res, 'A record with this value already exists', 409);
  if (err.code === 'ER_NO_REFERENCED_ROW_2') return failure(res, 'Related record not found', 400);
  return failure(res, err.message || 'Internal server error', err.statusCode || 500);
};
