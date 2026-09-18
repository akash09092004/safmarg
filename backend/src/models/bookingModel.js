const { query } = require('../config/db');
const select=`SELECT b.*,f.flight_number,f.airline,f.origin_code,f.origin_city,f.destination_code,f.destination_city,f.departure_time,f.arrival_time,f.status AS flight_status FROM bookings b JOIN flights f ON f.id=b.flight_id`;
exports.findById = async id => (await query(`${select} WHERE b.id=?`,[id]))[0];
exports.findByPnr = async pnr => (await query(`${select} WHERE b.pnr=?`,[pnr]))[0];
exports.findByUser = userId => query(`${select} WHERE b.user_id=? ORDER BY b.booked_at DESC`,[userId]);
exports.cancel = id => query("UPDATE bookings SET status='cancelled' WHERE id=?",[id]);
exports.list = () => query(`${select} ORDER BY b.booked_at DESC`);
