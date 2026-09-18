import 'package:flutter/material.dart';

import '../models/refund_model.dart';
import '../services/refund_service.dart';

class RefundProvider extends ChangeNotifier {
  final RefundService _refundService =
      RefundService.instance;

  List<RefundModel> _refunds = [];

  RefundModel? _selectedRefund;

  bool _isLoading = false;

  String? _errorMessage;

  List<RefundModel> get refunds =>
      _refunds;

  RefundModel? get selectedRefund =>
      _selectedRefund;

  bool get isLoading =>
      _isLoading;

  String? get errorMessage =>
      _errorMessage;

  bool get hasRefunds =>
      _refunds.isNotEmpty;

  // =========================
  // REQUEST REFUND
  // =========================

  Future<RefundModel?> requestRefund({
    required int bookingId,
    required String reason,
  }) async {
    _setLoading(true);
    _clearError();

    final response =
        await _refundService
            .requestRefund(
      bookingId: bookingId,
      reason: reason,
    );

    _setLoading(false);

    if (!response.success ||
        response.data == null) {
      _setError(
        response.message,
      );

      return null;
    }

    _selectedRefund =
        response.data;

    _refunds.insert(
      0,
      response.data!,
    );

    notifyListeners();

    return response.data;
  }

  // =========================
  // MY REFUNDS
  // =========================

  Future<bool> loadMyRefunds() async {
    _setLoading(true);
    _clearError();

    final response =
        await _refundService
            .getMyRefunds();

    _setLoading(false);

    if (!response.success) {
      _refunds = [];

      _setError(
        response.message,
      );

      return false;
    }

    _refunds =
        response.data ?? [];

    notifyListeners();

    return true;
  }

  // =========================
  // DETAILS
  // =========================

  Future<bool> loadRefundDetails(
    int refundId,
  ) async {
    _setLoading(true);
    _clearError();

    final response =
        await _refundService
            .getRefundDetails(
      refundId,
    );

    _setLoading(false);

    if (!response.success ||
        response.data == null) {
      _selectedRefund = null;

      _setError(
        response.message,
      );

      return false;
    }

    _selectedRefund =
        response.data;

    notifyListeners();

    return true;
  }

  // =========================
  // SELECT REFUND
  // =========================

  void selectRefund(
    RefundModel refund,
  ) {
    _selectedRefund = refund;

    notifyListeners();
  }

  // =========================
  // RESET
  // =========================

  void reset() {
    _refunds = [];
    _selectedRefund = null;
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

