const crypto = require('crypto');
module.exports = () => crypto.randomBytes(4).toString('hex').slice(0, 6).toUpperCase();
