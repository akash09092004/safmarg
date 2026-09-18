import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../core/network/api_response.dart';
import '../models/passenger_model.dart';
import '../models/user_model.dart';

class ProfileService {
  ProfileService._();

  static final ProfileService instance =
      ProfileService._();

  final ApiClient _api =
      ApiClient.instance;

  // =========================
  // GET PROFILE
  // =========================

  Future<ApiResponse<UserModel>>
      getProfile() async {
    final response = await _api.get(
      ApiConstants.profile,
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
      final user =
          UserModel.fromJson(
        Map<String, dynamic>.from(
          response.data,
        ),
      );

      return ApiResponse.success(
        data: user,
        message: response.message,
      );
    } catch (error) {
      return ApiResponse.failure(
        message:
            'Profile data parse nahi hua',
        error: error,
      );
    }
  }

  // =========================
  // UPDATE PROFILE
  // =========================

  Future<ApiResponse<UserModel>>
      updateProfile({
    String? name,
    String? phone,
    String? profileImage,
  }) async {
    final body =
        <String, dynamic>{};

    if (name != null &&
        name.trim().isNotEmpty) {
      body['name'] = name.trim();
    }

    if (phone != null &&
        phone.trim().isNotEmpty) {
      body['phone'] = phone.trim();
    }

    if (profileImage != null) {
      body['profileImage'] =
          profileImage;
    }

    final response = await _api.put(
      ApiConstants.updateProfile,
      requiresAuth: true,
      body: body,
    );

    if (!response.success) {
      return ApiResponse.failure(
        message: response.message,
        statusCode: response.statusCode,
        error: response.error,
      );
    }

    try {
      final user =
          UserModel.fromJson(
        Map<String, dynamic>.from(
          response.data,
        ),
      );

      return ApiResponse.success(
        data: user,
        message: response.message,
      );
    } catch (error) {
      return ApiResponse.failure(
        message:
            'Updated profile parse nahi hua',
        error: error,
      );
    }
  }

  // =========================
  // CHANGE PASSWORD
  // =========================

  Future<ApiResponse<bool>>
      changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await _api.put(
      ApiConstants.changePassword,
      requiresAuth: true,
      body: {
        'currentPassword':
            currentPassword,
        'newPassword':
            newPassword,
      },
    );

    if (!response.success) {
      return ApiResponse.failure(
        message: response.message,
        statusCode: response.statusCode,
        error: response.error,
      );
    }

    return ApiResponse.success(
      data: true,
      message: response.message,
    );
  }

  // =========================
  // SAVED TRAVELLERS
  // =========================

  Future<ApiResponse<List<PassengerModel>>>
      getTravellers() async {
    final response = await _api.get(
      ApiConstants.travellers,
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
      final data = response.data;

      final List<dynamic> list =
          data is List ? data : [];

      final travellers = list
          .whereType<Map>()
          .map(
            (item) =>
                PassengerModel.fromJson(
              Map<String, dynamic>.from(
                item,
              ),
            ),
          )
          .toList();

      return ApiResponse.success(
        data: travellers,
        message: response.message,
      );
    } catch (error) {
      return ApiResponse.failure(
        message:
            'Traveller list parse nahi hui',
        error: error,
      );
    }
  }

  // =========================
  // ADD TRAVELLER
  // =========================

  Future<ApiResponse<PassengerModel>>
      addTraveller({
    required PassengerModel traveller,
  }) async {
    final response = await _api.post(
      ApiConstants.travellers,
      requiresAuth: true,
      body: traveller.toJson(),
    );

    if (!response.success) {
      return ApiResponse.failure(
        message: response.message,
        statusCode: response.statusCode,
        error: response.error,
      );
    }

    try {
      final result =
          PassengerModel.fromJson(
        Map<String, dynamic>.from(
          response.data,
        ),
      );

      return ApiResponse.success(
        data: result,
        message: response.message,
      );
    } catch (error) {
      return ApiResponse.failure(
        message:
            'Traveller parse nahi hua',
        error: error,
      );
    }
  }

  // =========================
  // UPDATE TRAVELLER
  // =========================

  Future<ApiResponse<PassengerModel>>
      updateTraveller({
    required int travellerId,
    required PassengerModel traveller,
  }) async {
    final response = await _api.put(
      '${ApiConstants.travellers}/$travellerId',
      requiresAuth: true,
      body: traveller.toJson(),
    );

    if (!response.success) {
      return ApiResponse.failure(
        message: response.message,
        statusCode: response.statusCode,
        error: response.error,
      );
    }

    try {
      final result =
          PassengerModel.fromJson(
        Map<String, dynamic>.from(
          response.data,
        ),
      );

      return ApiResponse.success(
        data: result,
        message: response.message,
      );
    } catch (error) {
      return ApiResponse.failure(
        message:
            'Traveller update parse nahi hua',
        error: error,
      );
    }
  }

  // =========================
  // DELETE TRAVELLER
  // =========================

  Future<ApiResponse<bool>>
      deleteTraveller(
    int travellerId,
  ) async {
    final response =
        await _api.delete(
      '${ApiConstants.travellers}/$travellerId',
      requiresAuth: true,
    );

    if (!response.success) {
      return ApiResponse.failure(
        message: response.message,
        statusCode: response.statusCode,
        error: response.error,
      );
    }

    return ApiResponse.success(
      data: true,
      message: response.message,
    );
  }
}

