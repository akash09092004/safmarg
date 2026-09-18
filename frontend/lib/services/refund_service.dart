import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../core/network/api_response.dart';
import '../models/refund_model.dart';

class RefundService {
  RefundService._();

  static final RefundService instance = RefundService._();

  final ApiClient _api = ApiClient.instance;

  // =========================
  // REQUEST REFUND
  // =========================

  Future<ApiResponse<RefundModel>> requestRefund({
    required int bookingId,
    required String reason,
  }) async {
    final response = await _api.post(
      ApiConstants.refunds,
      requiresAuth: true,
      body: {'booking_id': bookingId, 'reason': reason.trim()},
    );

    if (!response.success) {
      return ApiResponse.failure(
        message: response.message,
        statusCode: response.statusCode,
        error: response.error,
      );
    }

    try {
      final data = response.data;

      if (data is! Map) {
        return ApiResponse.failure(message: 'Refund response invalid hai');
      }

      final refund = RefundModel.fromJson(Map<String, dynamic>.from(data));

      return ApiResponse.success(data: refund, message: response.message);
    } catch (error) {
      return ApiResponse.failure(
        message: 'Refund response parse nahi hua',
        error: error,
      );
    }
  }

  // =========================
  // MY REFUNDS
  // =========================

  Future<ApiResponse<List<RefundModel>>> getMyRefunds() async {
    final response = await _api.get(ApiConstants.myRefunds, requiresAuth: true);

    if (!response.success) {
      return ApiResponse.failure(
        message: response.message,
        statusCode: response.statusCode,
        error: response.error,
      );
    }

    try {
      final data = response.data;

      final List<dynamic> list = data is List ? data : [];

      final refunds = list
          .whereType<Map>()
          .map((item) => RefundModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      return ApiResponse.success(data: refunds, message: response.message);
    } catch (error) {
      return ApiResponse.failure(
        message: 'Refund list parse nahi hui',
        error: error,
      );
    }
  }

  // =========================
  // REFUND DETAILS
  // =========================

  Future<ApiResponse<RefundModel>> getRefundDetails(int refundId) async {
    final response = await _api.get(ApiConstants.refunds, requiresAuth: true);

    if (!response.success) {
      return ApiResponse.failure(
        message: response.message,
        statusCode: response.statusCode,
        error: response.error,
      );
    }

    try {
      final list = response.data is List ? response.data as List : const [];
      final item = list.whereType<Map>().cast<Map>().where(
        (item) => int.tryParse(item['id']?.toString() ?? '') == refundId,
      );
      if (item.isEmpty) {
        return ApiResponse.failure(
          message: 'Refund not found',
          statusCode: 404,
        );
      }
      final refund = RefundModel.fromJson(
        Map<String, dynamic>.from(item.first),
      );

      return ApiResponse.success(data: refund, message: response.message);
    } catch (error) {
      return ApiResponse.failure(
        message: 'Refund details parse nahi hui',
        error: error,
      );
    }
  }
}
