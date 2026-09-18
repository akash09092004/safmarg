import 'package:flutter/material.dart';

import '../models/booking_model.dart';
import '../models/passenger_model.dart';
import '../models/seat_model.dart';
import '../services/booking_service.dart';

class BookingProvider extends ChangeNotifier {
  final BookingService _bookingService = BookingService.instance;

  List<BookingModel> _bookings = [];

  BookingModel? _selectedBooking;

  bool _isLoading = false;

  String? _errorMessage;

  List<BookingModel> get bookings => _bookings;

  BookingModel? get selectedBooking => _selectedBooking;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  bool get hasBookings => _bookings.isNotEmpty;

  // =========================
  // CREATE BOOKING
  // =========================

  Future<BookingModel?> createBooking({
    required int flightId,
    required String contactEmail,
    required String contactPhone,
    required List<PassengerModel> passengers,
    required List<SeatModel> seats,
  }) async {
    _setLoading(true);
    _clearError();

    final response = await _bookingService.createBooking(
      flightId: flightId,
      contactEmail: contactEmail,
      contactPhone: contactPhone,
      passengers: passengers,
      seats: seats,
    );

    _setLoading(false);

    if (!response.success || response.data == null) {
      _setError(response.message);

      return null;
    }

    _selectedBooking = response.data;

    _bookings.insert(0, response.data!);

    notifyListeners();

    return response.data;
  }

  // =========================
  // MY BOOKINGS
  // =========================

  Future<bool> loadMyBookings() async {
    _setLoading(true);
    _clearError();

    final response = await _bookingService.getMyBookings();

    _setLoading(false);

    if (!response.success) {
      _bookings = [];

      _setError(response.message);

      return false;
    }

    _bookings = response.data ?? [];

    notifyListeners();

    return true;
  }

  // =========================
  // DETAILS
  // =========================

  Future<bool> loadBookingDetails(int bookingId) async {
    _setLoading(true);
    _clearError();

    final response = await _bookingService.getBookingDetails(bookingId);

    _setLoading(false);

    if (!response.success || response.data == null) {
      _selectedBooking = null;

      _setError(response.message);

      return false;
    }

    final passengerResponse = await _bookingService.getBookingPassengers(
      bookingId,
    );
    _selectedBooking = response.data!.copyWith(
      passengers: passengerResponse.success ? passengerResponse.data : null,
    );

    notifyListeners();

    return true;
  }

  // =========================
  // PNR SEARCH
  // =========================

  Future<BookingModel?> searchByPnr(String pnr) async {
    _setLoading(true);
    _clearError();

    final response = await _bookingService.getBookingByPnr(pnr);

    _setLoading(false);

    if (!response.success || response.data == null) {
      _setError(response.message);

      return null;
    }

    _selectedBooking = response.data;

    notifyListeners();

    return response.data;
  }

  Future<bool> updatePassenger(PassengerModel passenger) async {
    _setLoading(true);
    _clearError();
    final response = await _bookingService.updatePassenger(passenger);
    _setLoading(false);

    if (!response.success) {
      _setError(response.message);
      return false;
    }

    if (_selectedBooking != null) {
      await loadBookingDetails(_selectedBooking!.id);
    }
    return true;
  }

  // =========================
  // CANCEL
  // =========================

  Future<bool> cancelBooking(int bookingId) async {
    _setLoading(true);
    _clearError();

    final response = await _bookingService.cancelBooking(bookingId);

    _setLoading(false);

    if (!response.success || response.data == null) {
      _setError(response.message);

      return false;
    }

    _selectedBooking = response.data;

    final index = _bookings.indexWhere((booking) => booking.id == bookingId);

    if (index != -1) {
      _bookings[index] = response.data!;
    }

    notifyListeners();

    return true;
  }

  // =========================
  // SELECT BOOKING
  // =========================

  void selectBooking(BookingModel booking) {
    _selectedBooking = booking;

    notifyListeners();
  }

  // =========================
  // RESET
  // =========================

  void reset() {
    _bookings = [];
    _selectedBooking = null;
    _errorMessage = null;

    notifyListeners();
  }

  // =========================
  // HELPERS
  // =========================

  void _setLoading(bool value) {
    _isLoading = value;

    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;

    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void clearError() {
    _errorMessage = null;

    notifyListeners();
  }
}
