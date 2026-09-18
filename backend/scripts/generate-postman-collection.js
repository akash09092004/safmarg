const fs = require('fs');
const path = require('path');

const json = (value) => ({ mode: 'raw', raw: JSON.stringify(value, null, 2), options: { raw: { language: 'json' } } });
const auth = (token) => ({ type: 'bearer', bearer: [{ key: 'token', value: `{{${token}}}`, type: 'string' }] });
const request = (name, method, url, body, token, tests) => ({
  name,
  event: tests ? [{ listen: 'test', script: { type: 'text/javascript', exec: tests } }] : undefined,
  request: {
    method,
    header: body ? [{ key: 'Content-Type', value: 'application/json' }] : [],
    auth: token ? auth(token) : undefined,
    body: body ? json(body) : undefined,
    url: `{{baseUrl}}${url}`,
  },
});

const saveUserToken = [
  'const r = pm.response.json();',
  "if (r.success && r.data?.token) pm.collectionVariables.set('userToken', r.data.token);",
];
const saveAdminToken = [
  'const r = pm.response.json();',
  "if (r.success && r.data?.token) pm.collectionVariables.set('adminToken', r.data.token);",
];
const saveBooking = [
  'const r = pm.response.json();',
  "if (r.success && r.data) {",
  "  pm.collectionVariables.set('bookingId', r.data.id);",
  "  pm.collectionVariables.set('pnr', r.data.pnr);",
  "  if (r.data.passengers?.length) pm.collectionVariables.set('passengerId', r.data.passengers[0].id);",
  '}',
];

const collection = {
  info: {
    name: 'SafMarg Backend - Complete API',
    description: 'Import and run requests folder-wise. Start the backend, register/login, fetch an available seat, then create a booking.',
    schema: 'https://schema.getpostman.com/json/collection/v2.1.0/collection.json',
  },
  variable: [
    { key: 'baseUrl', value: 'http://localhost:5000/api/v1' },
    { key: 'userToken', value: '' },
    { key: 'adminToken', value: '' },
    { key: 'flightId', value: '1' },
    { key: 'seatId', value: '1' },
    { key: 'bookingId', value: '1' },
    { key: 'pnr', value: 'ABC123' },
    { key: 'passengerId', value: '1' },
    { key: 'notificationId', value: '1' },
    { key: 'refundId', value: '1' },
    { key: 'userId', value: '1' },
    { key: 'offerId', value: '1' },
  ],
  item: [
    { name: '01 System', item: [
      { name: 'Health Check', request: { method: 'GET', header: [], url: 'http://localhost:5000/health' } },
    ] },
    { name: '02 Authentication', item: [
      request('Register User', 'POST', '/auth/register', { name: 'Aman Kumar', email: 'aman@example.com', password: 'Aman@12345', phone: '+919876543210' }, null, saveUserToken),
      request('Login User', 'POST', '/auth/login', { email: 'aman@example.com', password: 'Aman@12345' }, null, saveUserToken),
      request('Login Admin', 'POST', '/auth/login', { email: 'admin@safmarg.com', password: 'Admin@123' }, null, saveAdminToken),
      request('Current User', 'GET', '/auth/me', null, 'userToken'),
    ] },
    { name: '03 User Profile', item: [
      request('Get Profile', 'GET', '/users/profile', null, 'userToken'),
      request('Update Profile', 'PUT', '/users/profile', { name: 'Aman Sharma', phone: '+919876543211' }, 'userToken'),
    ] },
    { name: '04 Flights and Seats', item: [
      request('All Upcoming Flights', 'GET', '/flights'),
      request('Search DEL to BOM', 'GET', '/flights?origin=DEL&destination=BOM&date=2026-09-10&minPrice=2000&maxPrice=15000&airline=SafMarg'),
      request('Flight Details With Seats', 'GET', '/flights/{{flightId}}'),
      request('Flight Seat Map', 'GET', '/seats/flight/{{flightId}}'),
    ] },
    { name: '05 Offers', item: [
      request('Active Offers', 'GET', '/offers'),
      request('Validate Offer', 'POST', '/offers/validate', { code: 'WELCOME10', amount: 5000 }),
    ] },
    { name: '06 Bookings', item: [
      request('Create Booking', 'POST', '/bookings', {
        flight_id: '{{flightId}}', contact_email: 'aman@example.com', contact_phone: '+919876543210',
        passengers: [{ seat_id: '{{seatId}}', first_name: 'Aman', last_name: 'Kumar', gender: 'male', date_of_birth: '1998-05-10', passport_number: 'P1234567', nationality: 'Indian' }],
      }, 'userToken', saveBooking),
      request('My Bookings', 'GET', '/bookings', null, 'userToken'),
      request('Booking Details', 'GET', '/bookings/{{bookingId}}', null, 'userToken'),
      request('Booking By PNR', 'GET', '/bookings/pnr/{{pnr}}', null, 'userToken'),
      request('Cancel Booking', 'PATCH', '/bookings/{{bookingId}}/cancel', null, 'userToken'),
    ] },
    { name: '07 Passengers', item: [
      request('Passengers By Booking', 'GET', '/passengers/booking/{{bookingId}}', null, 'userToken'),
      request('Update Passenger', 'PUT', '/passengers/{{passengerId}}', { first_name: 'Aman', last_name: 'Sharma', gender: 'male', date_of_birth: '1998-05-10', passport_number: 'P7654321', nationality: 'Indian' }, 'userToken'),
    ] },
    { name: '08 Payments', item: [
      request('Pay For Booking', 'POST', '/payments', { booking_id: '{{bookingId}}', method: 'upi', transaction_id: 'TXN-SAFMARG-10001' }, 'userToken'),
      request('Payment By Booking', 'GET', '/payments/booking/{{bookingId}}', null, 'userToken'),
    ] },
    { name: '09 Refunds', item: [
      request('Request Refund', 'POST', '/refunds', { booking_id: '{{bookingId}}', reason: 'Travel plan has changed due to an emergency.' }, 'userToken'),
      request('My Refunds', 'GET', '/refunds', null, 'userToken'),
    ] },
    { name: '10 Notifications', item: [
      request('My Notifications', 'GET', '/notifications', null, 'userToken'),
      request('Mark Notification Read', 'PATCH', '/notifications/{{notificationId}}/read', null, 'userToken'),
      request('Mark All Read', 'PATCH', '/notifications/read-all', null, 'userToken'),
    ] },
    { name: '11 Admin', item: [
      request('Dashboard', 'GET', '/admin/dashboard', null, 'adminToken'),
      request('All Users', 'GET', '/admin/users', null, 'adminToken'),
      request('Deactivate User', 'PATCH', '/admin/users/{{userId}}/status', { is_active: false }, 'adminToken'),
      request('Activate User', 'PATCH', '/admin/users/{{userId}}/status', { is_active: true }, 'adminToken'),
      request('All Bookings', 'GET', '/admin/bookings', null, 'adminToken'),
      request('Create Flight', 'POST', '/admin/flights', { flight_number: 'SM202', airline: 'SafMarg Air', origin_code: 'DEL', origin_city: 'Delhi', destination_code: 'BOM', destination_city: 'Mumbai', departure_time: '2026-09-10 10:00:00', arrival_time: '2026-09-10 12:15:00', base_price: 5500, total_seats: 180, status: 'scheduled' }, 'adminToken'),
      request('Update Flight', 'PUT', '/admin/flights/{{flightId}}', { departure_time: '2026-09-10 11:00:00', arrival_time: '2026-09-10 13:15:00', base_price: 5999, status: 'delayed' }, 'adminToken'),
      request('Delete Flight', 'DELETE', '/admin/flights/{{flightId}}', null, 'adminToken'),
      request('All Refunds', 'GET', '/admin/refunds', null, 'adminToken'),
      request('Approve Refund', 'PATCH', '/admin/refunds/{{refundId}}', { status: 'approved' }, 'adminToken'),
      request('Process Refund', 'PATCH', '/admin/refunds/{{refundId}}', { status: 'processed' }, 'adminToken'),
      request('Create Percentage Offer', 'POST', '/admin/offers', { code: 'WELCOME10', title: 'Welcome discount', description: '10 percent off on first booking', discount_type: 'percentage', discount_value: 10, min_booking_amount: 2000, max_discount: 1000, valid_from: '2026-08-21 00:00:00', valid_until: '2026-12-31 23:59:59' }, 'adminToken'),
      request('Create Fixed Offer', 'POST', '/admin/offers', { code: 'FLAT500', title: 'Flat 500 off', description: 'Flat discount on eligible bookings', discount_type: 'fixed', discount_value: 500, min_booking_amount: 3000, max_discount: 500, valid_from: '2026-08-21 00:00:00', valid_until: '2026-12-31 23:59:59' }, 'adminToken'),
      request('Disable Offer', 'DELETE', '/admin/offers/{{offerId}}', null, 'adminToken'),
    ] },
  ],
};

const output = path.join(__dirname, '..', 'SafMarg.postman_collection.json');
fs.writeFileSync(output, `${JSON.stringify(collection, null, 2)}\n`);
console.log(`Generated ${output}`);
