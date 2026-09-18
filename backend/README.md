# SafMarg Backend

SafMarg flight-booking app ke liye Node.js, Express aur MySQL REST API. Isme JWT authentication, flight search, atomic seat booking, passenger, payment, cancellation/refund, offer, notification aur admin APIs shamil hain.

## 1. Requirements

- Node.js 18+
- MySQL 8+
- npm

## 2. Installation

```bash
cd backend
npm install
```

`.env` me apne MySQL credentials set karein. Production me `JWT_SECRET` ko strong random value se replace karein. Safe template `.env.example` me diya gaya hai.

```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=safmarg
JWT_SECRET=your_long_random_secret
```

## 3. Database setup

Migration database aur tables khud create karti hai:

```bash
npm run migrate
npm run seed
```

`npm run seed` development ke liye agle 30 din tak listed 8 airports ke har
origin/destination pair par morning, afternoon aur evening demo flights aur seats
banata hai. Script ko dobara
chalane par existing demo flights duplicate nahi hoti. Ye real airline inventory
nahi hai; 30 din se aage ki dates ke liye naya seed ya actual schedule import chahiye.
Demo entries par IndiGo, Air India, SpiceJet aur Akasa Air ke naam sample display
ke liye use hote hain; ye un airlines ki real bookable flights nahi hain.

Seed ke baad development admin login:

```text
Email: admin@safmarg.com
Password: Admin@123
```

Is password ko real deployment me turant badlein.

## 4. Run

```bash
npm run dev
```

API base URL: `http://localhost:5000/api/v1`  
Health check: `GET http://localhost:5000/health`

USB debugging wale Android phone par `adb reverse tcp:5000 tcp:5000` chalayein;
Flutter ka default Android URL `http://127.0.0.1:5000/api/v1` isi port mapping
ko use karta hai. USB ke bina phone aur computer same network par hon to app
`--dart-define=API_BASE_URL=http://COMPUTER_LAN_IP:5000/api/v1` ke saath run karein.
Android emulator ke liye `--dart-define=API_BASE_URL=http://10.0.2.2:5000/api/v1` use karein.

## 5. Response format

```json
{
  "success": true,
  "message": "Success",
  "data": {}
}
```

Protected endpoints par header bhejein:

```http
Authorization: Bearer YOUR_JWT_TOKEN
```

## 6. Main endpoints

| Method | Endpoint | Purpose |
|---|---|---|
| POST | `/auth/register` | Account create |
| POST | `/auth/login` | Login/token |
| GET | `/auth/me` | Current user |
| GET, PUT | `/users/profile` | Profile |
| GET | `/flights?origin=DEL&destination=BOM&date=2026-08-23` | Search |
| GET | `/flights/:id` | Details + seats |
| GET | `/seats/flight/:flightId` | Seat map |
| POST | `/bookings` | Seat booking |
| GET | `/bookings` | My bookings |
| GET | `/bookings/:id` | Booking details |
| PATCH | `/bookings/:id/cancel` | Cancel |
| POST | `/payments` | Payment confirm |
| POST | `/refunds` | Refund request |
| GET | `/offers` | Active offers |
| POST | `/offers/validate` | Discount calculate |
| GET | `/notifications` | User notifications |
| GET | `/admin/dashboard` | Admin statistics |

### Booking request example

```json
{
  "flight_id": 1,
  "contact_email": "traveller@example.com",
  "contact_phone": "+919876543210",
  "passengers": [
    {
      "seat_id": 5,
      "first_name": "Aman",
      "last_name": "Kumar",
      "gender": "male",
      "date_of_birth": "1998-05-10",
      "nationality": "Indian"
    }
  ]
}
```

### Payment request example

```json
{
  "booking_id": 1,
  "method": "upi",
  "transaction_id": "PAYMENT_PROVIDER_REFERENCE"
}
```

Payment endpoint abhi provider reference ko record karke demo payment successful karta hai. Production me Razorpay/Stripe webhook verification lagana zaroori hai; client se aayi success value par bharosa na karein.

## 7. Folder flow

```text
Route -> validation/auth middleware -> controller -> service -> model -> MySQL
```

- `config`: environment aur MySQL pool
- `routes`: URL definitions aur validation
- `controllers`: HTTP request/response handling
- `services`: business logic aur transactions
- `models`: parameterized SQL queries
- `middleware`: JWT, admin, validation, errors
- `database`: schema migrations aur seed data
- `utils`: token, PNR, dates aur responses

## 8. Verification

```bash
npm run check
```

Ye project ki sabhi JavaScript files ka syntax check karta hai.
