exports.success = (res, data = null, message = 'Success', status = 200) => res.status(status).json({ success: true, message, data });
exports.failure = (res, message = 'Request failed', status = 400, errors = undefined) => res.status(status).json({ success: false, message, ...(errors && { errors }) });
