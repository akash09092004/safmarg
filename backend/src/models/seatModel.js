const { query } = require('../config/db');
exports.findByFlight = flightId => query('SELECT * FROM seats WHERE flight_id=? ORDER BY seat_number',[flightId]);
exports.findById = async id => (await query('SELECT * FROM seats WHERE id=?',[id]))[0];
