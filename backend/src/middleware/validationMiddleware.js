const { validationResult } = require('express-validator');
const { failure } = require('../utils/response');
exports.validate = (req, res, next) => { const result = validationResult(req); return result.isEmpty() ? next() : failure(res, 'Validation failed', 422, result.array()); };
