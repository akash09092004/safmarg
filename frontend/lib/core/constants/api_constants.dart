import 'package:flutter/foundation.dart';

class ApiConstants {
  ApiConstants._();

  // ==========================================
  // BASE URL
  // ==========================================

  static final String baseUrl = kIsWeb
      ? 'http://localhost:5000/api/v1'
      : const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: '',
        ).isNotEmpty
      ? const String.fromEnvironment('API_BASE_URL')
      : defaultTargetPlatform == TargetPlatform.android
      ? 'http://127.0.0.1:5000/api/v1'
      : 'http://localhost:5000/api/v1';

  // ==========================================
  // AUTH
  // ==========================================

  static final String register = '$baseUrl/auth/register';

  static final String login = '$baseUrl/auth/login';

  static final String me = '$baseUrl/auth/me';

  static final String logout = '$baseUrl/auth/logout';

  // ==========================================
  // USER
  // ==========================================

  static final String profile = '$baseUrl/users/profile';

  static final String updateProfile = '$baseUrl/users/profile';

  static final String changePassword = '$baseUrl/users/change-password';

  static final String travellers = '$baseUrl/users/travellers';

  // ==========================================
  // FLIGHTS
  // ==========================================

  static final String flights = '$baseUrl/flights';

  static String flightDetails(int flightId) {
    return '$baseUrl/flights/$flightId';
  }

  static String searchFlights({
    required String origin,
    required String destination,
    required String date,
  }) {
    return '$baseUrl/flights'
        '?origin=$origin'
        '&destination=$destination'
        '&date=$date';
  }

  // ==========================================
  // SEATS
  // ==========================================

  static String flightSeats(int flightId) {
    return '$baseUrl/seats/flight/$flightId';
  }

  static String bookingSeats(int bookingId) {
    return '$baseUrl/seats/booking/$bookingId';
  }

  // ==========================================
  // BOOKINGS
  // ==========================================

  static final String bookings = '$baseUrl/bookings';

  static final String myBookings = '$baseUrl/bookings';

  static String bookingDetails(int bookingId) {
    return '$baseUrl/bookings/$bookingId';
  }

  static String bookingByPnr(String pnr) {
    return '$baseUrl/bookings/pnr/$pnr';
  }

  static String cancelBooking(int bookingId) {
    return '$baseUrl/bookings/$bookingId/cancel';
  }

  // ==========================================
  // PASSENGERS
  // ==========================================

  static String bookingPassengers(int bookingId) {
    return '$baseUrl/passengers/booking/$bookingId';
  }

  // ==========================================
  // PAYMENT
  // ==========================================

  static final String createPaymentOrder = '$baseUrl/payments';

  static final String verifyPayment = '$baseUrl/payments/verify';

  static String paymentByBooking(int bookingId) {
    return '$baseUrl/payments/booking/$bookingId';
  }

  // ==========================================
  // REFUND
  // ==========================================

  static final String refunds = '$baseUrl/refunds';

  static final String myRefunds = '$baseUrl/refunds';

  static String refundDetails(int refundId) {
    return '$baseUrl/refunds/$refundId';
  }

  // ==========================================
  // OFFERS
  // ==========================================

  static final String offers = '$baseUrl/offers';

  static String offerDetails(int offerId) {
    return '$baseUrl/offers/$offerId';
  }

  static final String validateCoupon = '$baseUrl/offers/validate';

  // ==========================================
  // NOTIFICATIONS
  // ==========================================

  static final String notifications = '$baseUrl/notifications';

  static final String markAllNotificationsRead =
      '$baseUrl/notifications/read-all';

  static String markNotificationRead(int notificationId) {
    return '$baseUrl/notifications/$notificationId/read';
  }

  // ==========================================
  // ADMIN
  // ==========================================

  static final String adminDashboard = '$baseUrl/admin/dashboard';

  static final String adminUsers = '$baseUrl/admin/users';

  static final String adminFlights = '$baseUrl/admin/flights';

  static final String adminBookings = '$baseUrl/admin/bookings';

  static final String adminPayments = '$baseUrl/admin/payments';

  static final String adminRefunds = '$baseUrl/admin/refunds';

  static final String adminOffers = '$baseUrl/admin/offers';

  // ==========================================
  // TIMEOUT
  // ==========================================

  static const Duration connectionTimeout = Duration(seconds: 20);

  static const Duration receiveTimeout = Duration(seconds: 20);
}
