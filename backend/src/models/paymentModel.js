const { query } = require('../config/db');
exports.findByBooking = async id => (await query('SELECT * FROM payments WHERE booking_id=? ORDER BY created_at DESC LIMIT 1',[id]))[0];
exports.findById = async id => (await query('SELECT * FROM payments WHERE id=?',[id]))[0];
exports.create = async ({bookingId,transactionId,amount,method,status='successful'}) => { const r=await query('INSERT INTO payments(booking_id,transaction_id,amount,method,status,paid_at) VALUES(?,?,?,?,?,IF(?=\'successful\',NOW(),NULL))',[bookingId,transactionId,amount,method,status,status]); return exports.findById(r.insertId); };
