exports.toMysqlDateTime = (value) => new Date(value).toISOString().slice(0, 19).replace('T', ' ');
exports.isFuture = (value) => new Date(value).getTime() > Date.now();
