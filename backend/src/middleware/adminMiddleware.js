const { failure } = require('../utils/response');
exports.adminOnly = (req, res, next) => req.user?.role === 'admin' ? next() : failure(res, 'Admin access required', 403);
