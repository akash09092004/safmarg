const { query } = require('../config/db');
exports.findByBooking = id => query('SELECT p.*,s.seat_number,s.seat_class FROM passengers p JOIN seats s ON s.id=p.seat_id WHERE p.booking_id=?',[id]);
exports.findById = async id => (await query('SELECT * FROM passengers WHERE id=?',[id]))[0];
exports.update = async (id,p) => { await query('UPDATE passengers SET first_name=COALESCE(?,first_name),last_name=COALESCE(?,last_name),gender=COALESCE(?,gender),date_of_birth=COALESCE(?,date_of_birth),passport_number=COALESCE(?,passport_number),nationality=COALESCE(?,nationality) WHERE id=?',[p.first_name||null,p.last_name||null,p.gender||null,p.date_of_birth||null,p.passport_number||null,p.nationality||null,id]); return exports.findById(id); };
