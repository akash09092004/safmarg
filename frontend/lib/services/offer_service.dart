import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../core/network/api_response.dart';
import '../models/offer_model.dart';

class OfferService {
  final ApiClient _api = ApiClient.instance;

  Future<List<OfferModel>> getOffers() async {
    final response = await _api.get(ApiConstants.offers);
    if (!response.success) {
      throw Exception(response.message);
    }

    final data = response.data;
    final list = data is List
        ? data
        : data is Map && data['offers'] is List
        ? data['offers'] as List
        : const <dynamic>[];

    return list
        .whereType<Map>()
        .map((item) => OfferModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<ApiResponse<Map<String, dynamic>>> validateOffer({
    required String code,
    required double amount,
  }) async {
    final response = await _api.post(
      ApiConstants.validateCoupon,
      body: {'code': code.trim().toUpperCase(), 'amount': amount},
    );

    if (!response.success || response.data is! Map) {
      return ApiResponse.failure(
        message: response.message,
        statusCode: response.statusCode,
        error: response.error,
      );
    }

    return ApiResponse.success(
      data: Map<String, dynamic>.from(response.data as Map),
      message: response.message,
      statusCode: response.statusCode,
    );
  }
}
