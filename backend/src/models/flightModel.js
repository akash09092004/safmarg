const { pool, query } = require('../config/db');
const generateSeats = require('../utils/generateSeats');
exports.search = ({origin,destination,date,minPrice,maxPrice,airline}) => { let sql='SELECT *,TIMESTAMPDIFF(MINUTE,departure_time,arrival_time) duration_minutes FROM flights WHERE status IN (\'scheduled\',\'delayed\') AND departure_time>NOW()'; const p=[];
  if(origin){sql+=' AND origin_code=?';p.push(origin.toUpperCase())} if(destination){sql+=' AND destination_code=?';p.push(destination.toUpperCase())} if(date){sql+=' AND DATE(departure_time)=?';p.push(date)} if(minPrice){sql+=' AND base_price>=?';p.push(minPrice)} if(maxPrice){sql+=' AND base_price<=?';p.push(maxPrice)} if(airline){sql+=' AND airline LIKE ?';p.push(`%${airline}%`)} return query(sql+' ORDER BY departure_time',p); };
exports.findById = async id => (await query('SELECT *, TIMESTAMPDIFF(MINUTE,departure_time,arrival_time) AS duration_minutes FROM flights WHERE id=?',[id]))[0];
exports.create = async f => {
  const seats = generateSeats(f.total_seats);
  const connection = await pool.getConnection();
  try {
    await connection.beginTransaction();
    const [result] = await connection.execute(
      'INSERT INTO flights(flight_number,airline,origin_code,origin_city,destination_code,destination_city,departure_time,arrival_time,base_price,total_seats,status) VALUES(?,?,?,?,?,?,?,?,?,?,?)',
      [f.flight_number,f.airline,f.origin_code,f.origin_city,f.destination_code,f.destination_city,f.departure_time,f.arrival_time,f.base_price,f.total_seats,f.status||'scheduled']
    );
    const placeholders = seats.map(() => '(?,?,?,?,1)').join(',');
    const values = seats.flatMap(seat => [result.insertId, seat.seatNumber, seat.seatClass, seat.priceModifier]);
    await connection.execute(
      `INSERT INTO seats(flight_id,seat_number,seat_class,price_modifier,is_available) VALUES ${placeholders}`,
      values
    );
    await connection.commit();
    return exports.findById(result.insertId);
  } catch (error) {
    await connection.rollback();
    throw error;
  } finally {
    connection.release();
  }
};
exports.update = async (id,f) => { const allowed=['flight_number','airline','origin_code','origin_city','destination_code','destination_city','departure_time','arrival_time','base_price','total_seats','status']; const keys=allowed.filter(k=>f[k]!==undefined); if(keys.length) await query(`UPDATE flights SET ${keys.map(k=>`${k}=?`).join(',')} WHERE id=?`,[...keys.map(k=>f[k]),id]); return exports.findById(id); };
exports.remove = id => query('DELETE FROM flights WHERE id=?',[id]);
