const { query } = require('../config/db');
exports.findById = async id => (await query('SELECT * FROM refunds WHERE id=?',[id]))[0];
exports.findByBooking = async bookingId => (await query('SELECT * FROM refunds WHERE booking_id=? ORDER BY requested_at DESC LIMIT 1',[bookingId]))[0];
exports.findByUser = userId => query('SELECT r.*,b.pnr FROM refunds r JOIN bookings b ON b.id=r.booking_id WHERE b.user_id=? ORDER BY requested_at DESC',[userId]);
exports.create = async x => { const r=await query('INSERT INTO refunds(booking_id,payment_id,amount,reason) VALUES(?,?,?,?)',[x.bookingId,x.paymentId,x.amount,x.reason]); return exports.findById(r.insertId); };
exports.list = () => query('SELECT r.*,b.pnr,u.email FROM refunds r JOIN bookings b ON b.id=r.booking_id JOIN users u ON u.id=b.user_id ORDER BY r.requested_at DESC');
exports.setStatus = async (id,status) => { await query('UPDATE refunds SET status=?,processed_at=IF(?=\'processed\',NOW(),processed_at) WHERE id=?',[status,status,id]); return exports.findById(id); };
