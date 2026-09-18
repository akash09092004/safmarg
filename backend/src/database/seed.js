const bcrypt = require('bcryptjs');
const { pool } = require('../config/db');
const generateSeats = require('../utils/generateSeats');

// Development inventory. Replace with an airline schedule source for production.
const airports = [
  ['DEL', 'New Delhi'], ['BOM', 'Mumbai'], ['BLR', 'Bengaluru'],
  ['MAA', 'Chennai'], ['CCU', 'Kolkata'], ['HYD', 'Hyderabad'],
  ['GOI', 'Goa'], ['AMD', 'Ahmedabad'],
];

async function seed() {
  const connection = await pool.getConnection();
  let created = 0;
  try {
    await connection.beginTransaction();
    const hash = await bcrypt.hash('Admin@123', 12);
    await connection.execute(
      "INSERT INTO users(name,email,phone,password_hash,role) VALUES('SafMarg Admin','admin@safmarg.com','+919999999999',?,'admin') ON DUPLICATE KEY UPDATE role='admin'",
      [hash]
    );
    // Update previously seeded demo rows without changing manually added flights.
    const [renamed] = await connection.execute(
      `UPDATE flights SET airline = CASE RIGHT(flight_number, 1)
        WHEN 'M' THEN 'IndiGo'
        WHEN 'A' THEN 'Air India'
        WHEN 'E' THEN 'SpiceJet'
        ELSE 'Akasa Air'
      END WHERE airline = 'SafMarg Demo' AND flight_number LIKE 'SM%'`
    );
    const [[{ today }]] = await connection.query('SELECT DATE_FORMAT(CURDATE(), "%Y-%m-%d") AS today');
    const firstDay = new Date(`${today}T00:00:00Z`);
    const seats = generateSeats(36);
    for (let day = 1; day <= 30; day++) {
      const date = new Date(firstDay.getTime() + day * 86400000).toISOString().slice(0, 10);
      for (let origin = 0; origin < airports.length; origin++) {
        for (let destination = 0; destination < airports.length; destination++) {
          if (origin === destination) continue;
          const [originCode, originCity] = airports[origin];
          const [destinationCode, destinationCity] = airports[destination];
          for (const [slot, hour] of [['M', 6], ['A', 14], ['E', 19]]) {
          const airline = slot === 'M' ? 'IndiGo' : slot === 'A' ? 'Air India' : 'SpiceJet';
          const flightNumber = `SM${origin + 1}${destination + 1}${slot}`;
          const departure = `${date} ${String(hour).padStart(2, '0')}:00:00`;
          const arrival = `${date} ${String(hour + 2).padStart(2, '0')}:00:00`;
          const [existing] = await connection.execute(
            'SELECT id FROM flights WHERE flight_number=? AND departure_time=? LIMIT 1',
            [flightNumber, departure]
          );
          if (existing.length) continue;
          const [result] = await connection.execute(
            'INSERT INTO flights(flight_number,airline,origin_code,origin_city,destination_code,destination_city,departure_time,arrival_time,base_price,total_seats,status) VALUES(?,?,?,?,?,?,?,?,?,?,?)',
            [flightNumber, airline, originCode, originCity, destinationCode, destinationCity,
              departure, arrival, 3000 + Math.abs(origin - destination) * 450 + (hour - 6) * 35, seats.length, 'scheduled']
          );
          const placeholders = seats.map(() => '(?,?,?,?,1)').join(',');
          const values = seats.flatMap(seat => [result.insertId, seat.seatNumber, seat.seatClass, seat.priceModifier]);
          await connection.execute(
            `INSERT INTO seats(flight_id,seat_number,seat_class,price_modifier,is_available) VALUES ${placeholders}`,
            values
          );
          created++;
          }
          const flightNumber = `SM${origin + 1}${destination + 1}`;
          const hour = 8 + (origin % 4) * 2;
          const departure = `${date} ${String(hour).padStart(2, '0')}:00:00`;
          const arrival = `${date} ${String(hour + 2).padStart(2, '0')}:00:00`;
          const [existing] = await connection.execute(
            'SELECT id FROM flights WHERE flight_number=? AND departure_time=? LIMIT 1',
            [flightNumber, departure]
          );
          if (existing.length) continue;
          const [result] = await connection.execute(
            'INSERT INTO flights(flight_number,airline,origin_code,origin_city,destination_code,destination_city,departure_time,arrival_time,base_price,total_seats,status) VALUES(?,?,?,?,?,?,?,?,?,?,?)',
            [flightNumber, 'Akasa Air', originCode, originCity, destinationCode, destinationCity,
              departure, arrival, 3000 + Math.abs(origin - destination) * 450, seats.length, 'scheduled']
          );
          const placeholders = seats.map(() => '(?,?,?,?,1)').join(',');
          const values = seats.flatMap(seat => [result.insertId, seat.seatNumber, seat.seatClass, seat.priceModifier]);
          await connection.execute(
            `INSERT INTO seats(flight_id,seat_number,seat_class,price_modifier,is_available) VALUES ${placeholders}`,
            values
          );
          created++;
        }
      }
    }
    await connection.commit();
    console.log(`Seed complete: ${created} demo flights added, ${renamed.affectedRows} existing flights renamed.`);
  } catch (error) {
    await connection.rollback();
    throw error;
  } finally {
    connection.release();
    await pool.end();
  }
}

seed().catch(error => { console.error(error); process.exitCode = 1; });
