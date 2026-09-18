import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../core/network/api_response.dart';
import '../models/payment_model.dart';

class PaymentService {
  PaymentService._();

  static final PaymentService instance = PaymentService._();

  final ApiClient _api = ApiClient.instance;

  // =========================
  // CREATE PAYMENT ORDER
  // =========================

  Future<ApiResponse<PaymentModel>> createOrder({
    required int bookingId,
    String method = 'mock',
  }) async {
    final apiMethod = switch (method) {
      'mock' => 'cash',
      'netbanking' => 'net_banking',
      _ => method,
    };

    final response = await _api.post(
      ApiConstants.createPaymentOrder,
      requiresAuth: true,
      body: {
        'booking_id': bookingId,
        'method': apiMethod,
        'transaction_id': 'APP-${DateTime.now().millisecondsSinceEpoch}',
      },
    );

    if (!response.success) {
      return ApiResponse.failure(
        message: response.message,
        statusCode: response.statusCode,
        error: response.error,
      );
    }

    try {
      final payment = PaymentModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );

      return ApiResponse.success(data: payment, message: response.message);
    } catch (error) {
      return ApiResponse.failure(
        message: 'Payment order parse nahi hua',
        error: error,
      );
    }
  }

  // =========================
  // VERIFY PAYMENT
  // =========================

  Future<ApiResponse<PaymentModel>> verifyPayment({
    required int paymentId,
    bool success = true,
  }) async {
    final response = await _api.post(
      ApiConstants.verifyPayment,
      requiresAuth: true,
      body: {'paymentId': paymentId, 'success': success},
    );

    if (!response.success) {
      return ApiResponse.failure(
        message: response.message,
        statusCode: response.statusCode,
        error: response.error,
      );
    }

    try {
      final payment = PaymentModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );

      return ApiResponse.success(data: payment, message: response.message);
    } catch (error) {
      return ApiResponse.failure(
        message: 'Payment verification response invalid hai',
        error: error,
      );
    }
  }

  // =========================
  // PAYMENT BY BOOKING
  // =========================

  Future<ApiResponse<PaymentModel>> getPaymentByBooking(int bookingId) async {
    final response = await _api.get(
      ApiConstants.paymentByBooking(bookingId),
      requiresAuth: true,
    );

    if (!response.success) {
      return ApiResponse.failure(
        message: response.message,
        statusCode: response.statusCode,
        error: response.error,
      );
    }

    try {
      final payment = PaymentModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );

      return ApiResponse.success(data: payment, message: response.message);
    } catch (error) {
      return ApiResponse.failure(
        message: 'Payment details parse nahi hui',
        error: error,
      );
    }
  }
}
