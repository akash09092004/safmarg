const fs = require("fs");
const path = require("path");
const mysql = require("mysql2/promise");
const generateSeats = require("../utils/generateSeats");
require("dotenv").config();

async function runMigration() {
  let connection;

  try {
    connection = await mysql.createConnection({
      host: process.env.DB_HOST || "localhost",
      port: Number(process.env.DB_PORT || 3306),
      user: process.env.DB_USER || "root",
      password: process.env.DB_PASSWORD || "",
      multipleStatements: true,
    });

    console.log("MySQL connected");

    const databaseName = process.env.DB_NAME || "safmarg";
    if (!/^[a-zA-Z0-9_]+$/.test(databaseName)) {
      throw new Error("DB_NAME may contain only letters, numbers, and underscores");
    }

    await connection.query(
      `CREATE DATABASE IF NOT EXISTS \`${databaseName}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci`
    );
    await connection.changeUser({ database: databaseName });

    const sqlFilePath = path.join(
      __dirname,
      "migrations",
      "001_initial_schema.sql"
    );

    const sql = fs.readFileSync(sqlFilePath, "utf8");

    if (!sql.trim()) {
      throw new Error("001_initial_schema.sql file is empty");
    }

    await connection.query(sql);

    const [flightsWithoutSeats] = await connection.query(
      `SELECT f.id, f.total_seats
       FROM flights f
       LEFT JOIN seats s ON s.flight_id = f.id
       GROUP BY f.id, f.total_seats
       HAVING COUNT(s.id) = 0`
    );

    for (const flight of flightsWithoutSeats) {
      const seats = generateSeats(flight.total_seats);
      const placeholders = seats.map(() => "(?,?,?,?,1)").join(",");
      const values = seats.flatMap((seat) => [
        flight.id,
        seat.seatNumber,
        seat.seatClass,
        seat.priceModifier,
      ]);
      await connection.execute(
        `INSERT INTO seats(flight_id,seat_number,seat_class,price_modifier,is_available) VALUES ${placeholders}`,
        values
      );
      console.log(`Created ${seats.length} missing seats for flight ${flight.id}`);
    }

    console.log(`Safemarg database '${databaseName}' and tables created successfully`);
  } catch (error) {
    console.error("Migration failed:", error.message);
    process.exitCode = 1;
  } finally {
    if (connection) {
      await connection.end();
    }
  }
}

runMigration();
