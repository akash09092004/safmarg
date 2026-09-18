import 'package:flutter/material.dart';

import '../models/flight_model.dart';
import '../models/seat_model.dart';
import '../services/flight_service.dart';

class FlightProvider extends ChangeNotifier {
  final FlightService _flightService =
      FlightService.instance;

  List<FlightModel> _flights = [];

  FlightModel? _selectedFlight;

  List<SeatModel> _seats = [];

  bool _isLoading = false;
  bool _isSeatLoading = false;

  String? _errorMessage;

  List<FlightModel> get flights =>
      _flights;

  FlightModel? get selectedFlight =>
      _selectedFlight;

  List<SeatModel> get seats =>
      _seats;

  bool get isLoading =>
      _isLoading;

  bool get isSeatLoading =>
      _isSeatLoading;

  String? get errorMessage =>
      _errorMessage;

  bool get hasFlights =>
      _flights.isNotEmpty;

  // =========================
  // ALL FLIGHTS
  // =========================

  Future<bool> loadFlights() async {
    _setLoading(true);
    _clearError();

    final response =
        await _flightService.getFlights();

    _setLoading(false);

    if (!response.success) {
      _flights = [];

      _setError(
        response.message,
      );

      return false;
    }

    _flights =
        response.data ?? [];

    notifyListeners();

    return true;
  }

  // =========================
  // SEARCH FLIGHTS
  // =========================

  Future<bool> searchFlights({
    required String origin,
    required String destination,
    required String date,
  }) async {
    _setLoading(true);
    _clearError();

    final response =
        await _flightService
            .searchFlights(
      origin: origin,
      destination: destination,
      date: date,
    );

    _setLoading(false);

    if (!response.success) {
      _flights = [];

      _setError(
        response.message,
      );

      return false;
    }

    _flights =
        response.data ?? [];

    notifyListeners();

    return true;
  }

  // =========================
  // FLIGHT DETAILS
  // =========================

  Future<bool> loadFlightDetails(
    int flightId,
  ) async {
    _setLoading(true);
    _clearError();

    final response =
        await _flightService
            .getFlightDetails(
      flightId,
    );

    _setLoading(false);

    if (!response.success ||
        response.data == null) {
      _selectedFlight = null;

      _setError(
        response.message,
      );

      return false;
    }

    _selectedFlight =
        response.data;

    notifyListeners();

    return true;
  }

  // =========================
  // SEATS
  // =========================

  Future<bool> loadSeats(
    int flightId,
  ) async {
    _isSeatLoading = true;
    _clearError();

    notifyListeners();

    final response =
        await _flightService
            .getFlightSeats(
      flightId,
    );

    _isSeatLoading = false;

    if (!response.success) {
      _seats = [];

      _setError(
        response.message,
      );

      return false;
    }

    _seats =
        response.data ?? [];

    notifyListeners();

    return true;
  }

  // =========================
  // SELECT SEAT
  // =========================

  void toggleSeatSelection(
    int seatId,
  ) {
    final index = _seats.indexWhere(
      (seat) => seat.id == seatId,
    );

    if (index == -1) {
      return;
    }

    final seat = _seats[index];

    if (!seat.isAvailable) {
      return;
    }

    seat.isSelected =
        !seat.isSelected;

    notifyListeners();
  }

  List<SeatModel>
      get selectedSeats {
    return _seats
        .where(
          (seat) =>
              seat.isSelected,
        )
        .toList();
  }

  void clearSeatSelection() {
    for (final seat in _seats) {
      seat.isSelected = false;
    }

    notifyListeners();
  }

  // =========================
  // RESET
  // =========================

  void reset() {
    _flights = [];
    _selectedFlight = null;
    _seats = [];
    _errorMessage = null;

    notifyListeners();
  }

  // =========================
  // HELPERS
  // =========================

  void _setLoading(
    bool value,
  ) {
    _isLoading = value;

    notifyListeners();
  }

  void _setError(
    String message,
  ) {
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

