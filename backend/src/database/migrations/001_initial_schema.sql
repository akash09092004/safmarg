CREATE TABLE IF NOT EXISTS users (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  phone VARCHAR(20) UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('user', 'admin') NOT NULL DEFAULT 'user',
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS flights (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  flight_number VARCHAR(20) NOT NULL,
  airline VARCHAR(100) NOT NULL,
  origin_code CHAR(3) NOT NULL,
  origin_city VARCHAR(100) NOT NULL,
  destination_code CHAR(3) NOT NULL,
  destination_city VARCHAR(100) NOT NULL,
  departure_time DATETIME NOT NULL,
  arrival_time DATETIME NOT NULL,
  base_price DECIMAL(10,2) NOT NULL,
  total_seats SMALLINT UNSIGNED NOT NULL,
  status ENUM('scheduled', 'delayed', 'cancelled', 'completed') DEFAULT 'scheduled',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_route_time (origin_code, destination_code, departure_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS seats (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  flight_id BIGINT UNSIGNED NOT NULL,
  seat_number VARCHAR(5) NOT NULL,
  seat_class ENUM('economy', 'premium_economy', 'business', 'first') DEFAULT 'economy',
  price_modifier DECIMAL(10,2) DEFAULT 0,
  is_available BOOLEAN DEFAULT TRUE,
  UNIQUE KEY uq_flight_seat (flight_id, seat_number),
  CONSTRAINT fk_seats_flight FOREIGN KEY (flight_id) REFERENCES flights(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bookings (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  pnr CHAR(6) NOT NULL UNIQUE,
  user_id BIGINT UNSIGNED NOT NULL,
  flight_id BIGINT UNSIGNED NOT NULL,
  contact_email VARCHAR(150) NOT NULL,
  contact_phone VARCHAR(20) NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL,
  status ENUM('pending', 'confirmed', 'cancelled', 'completed') DEFAULT 'pending',
  booked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_bookings_user FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_bookings_flight FOREIGN KEY (flight_id) REFERENCES flights(id),
  INDEX idx_user_bookings (user_id, booked_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS passengers (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  booking_id BIGINT UNSIGNED NOT NULL,
  seat_id BIGINT UNSIGNED NOT NULL,
  first_name VARCHAR(80) NOT NULL,
  last_name VARCHAR(80) NOT NULL,
  gender ENUM('male', 'female', 'other') NOT NULL,
  date_of_birth DATE NOT NULL,
  passport_number VARCHAR(30),
  nationality VARCHAR(60),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_passengers_booking FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE,
  CONSTRAINT fk_passengers_seat FOREIGN KEY (seat_id) REFERENCES seats(id),
  UNIQUE KEY uq_booking_seat (booking_id, seat_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS payments (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  booking_id BIGINT UNSIGNED NOT NULL,
  transaction_id VARCHAR(100) UNIQUE,
  amount DECIMAL(10,2) NOT NULL,
  method ENUM('card', 'upi', 'net_banking', 'wallet', 'cash') NOT NULL,
  status ENUM('pending', 'successful', 'failed', 'refunded') DEFAULT 'pending',
  paid_at DATETIME,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_payments_booking FOREIGN KEY (booking_id) REFERENCES bookings(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS refunds (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  booking_id BIGINT UNSIGNED NOT NULL,
  payment_id BIGINT UNSIGNED NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  reason VARCHAR(500) NOT NULL,
  status ENUM('requested', 'approved', 'rejected', 'processed') DEFAULT 'requested',
  requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  processed_at DATETIME,
  CONSTRAINT fk_refunds_booking FOREIGN KEY (booking_id) REFERENCES bookings(id),
  CONSTRAINT fk_refunds_payment FOREIGN KEY (payment_id) REFERENCES payments(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS offers (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(30) NOT NULL UNIQUE,
  title VARCHAR(150) NOT NULL,
  description TEXT,
  discount_type ENUM('percentage', 'fixed') NOT NULL,
  discount_value DECIMAL(10,2) NOT NULL,
  min_booking_amount DECIMAL(10,2) DEFAULT 0,
  max_discount DECIMAL(10,2),
  valid_from DATETIME NOT NULL,
  valid_until DATETIME NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS notifications (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  title VARCHAR(150) NOT NULL,
  message TEXT NOT NULL,
  type ENUM('booking', 'payment', 'refund', 'offer', 'system') DEFAULT 'system',
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_notifications (user_id, is_read, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
