import 'package:flutter/material.dart';

import '../models/payment_model.dart';
import '../services/payment_service.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentService _paymentService =
      PaymentService.instance;

  PaymentModel? _payment;

  bool _isLoading = false;

  String? _errorMessage;

  PaymentModel? get payment =>
      _payment;

  bool get isLoading =>
      _isLoading;

  String? get errorMessage =>
      _errorMessage;

  bool get isPaid =>
      _payment?.isSuccessful ??
      false;

  // =========================
  // CREATE ORDER
  // =========================

  Future<PaymentModel?> createOrder({
    required int bookingId,
    String method = 'mock',
  }) async {
    _setLoading(true);
    _clearError();

    final response =
        await _paymentService
            .createOrder(
      bookingId: bookingId,
      method: method,
    );

    _setLoading(false);

    if (!response.success ||
        response.data == null) {
      _setError(
        response.message,
      );

      return null;
    }

    _payment =
        response.data;

    notifyListeners();

    return response.data;
  }

  // =========================
  // VERIFY
  // =========================

  Future<bool> verifyPayment({
    required int paymentId,
    bool success = true,
  }) async {
    _setLoading(true);
    _clearError();

    final response =
        await _paymentService
            .verifyPayment(
      paymentId: paymentId,
      success: success,
    );

    _setLoading(false);

    if (!response.success ||
        response.data == null) {
      _setError(
        response.message,
      );

      return false;
    }

    _payment =
        response.data;

    notifyListeners();

    return _payment!.isSuccessful;
  }

  // =========================
  // PAYMENT DETAILS
  // =========================

  Future<bool> loadPayment(
    int bookingId,
  ) async {
    _setLoading(true);
    _clearError();

    final response =
        await _paymentService
            .getPaymentByBooking(
      bookingId,
    );

    _setLoading(false);

    if (!response.success ||
        response.data == null) {
      _payment = null;

      _setError(
        response.message,
      );

      return false;
    }

    _payment =
        response.data;

    notifyListeners();

    return true;
  }

  // =========================
  // RESET
  // =========================

  void reset() {
    _payment = null;
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

