exports.emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
exports.phoneRegex = /^\+?[1-9]\d{7,14}$/;
exports.isValidDate = (value) => !Number.isNaN(new Date(value).getTime());
