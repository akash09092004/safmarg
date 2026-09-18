const { query } = require('../config/db');
exports.listActive = () => query('SELECT * FROM offers WHERE is_active=1 AND NOW() BETWEEN valid_from AND valid_until ORDER BY valid_until');
exports.findByCode = async code => (await query('SELECT * FROM offers WHERE code=? AND is_active=1 AND NOW() BETWEEN valid_from AND valid_until',[code]))[0];
exports.create = async o => { const r=await query('INSERT INTO offers(code,title,description,discount_type,discount_value,min_booking_amount,max_discount,valid_from,valid_until) VALUES(?,?,?,?,?,?,?,?,?)',[o.code,o.title,o.description||null,o.discount_type,o.discount_value,o.min_booking_amount||0,o.max_discount||null,o.valid_from,o.valid_until]); return (await query('SELECT * FROM offers WHERE id=?',[r.insertId]))[0]; };
exports.remove = id => query('UPDATE offers SET is_active=0 WHERE id=?',[id]);
