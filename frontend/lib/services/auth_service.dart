import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../core/network/api_response.dart';
import '../models/user_model.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final ApiClient _api = ApiClient.instance;

  // =========================
  // REGISTER
  // =========================

  Future<ApiResponse<UserModel>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final response = await _api.post(
      ApiConstants.register,
      body: {
        'name': name.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'password': password,
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
      final data = response.data;

      if (data is! Map) {
        return ApiResponse.failure(message: 'Invalid register response');
      }

      final map = Map<String, dynamic>.from(data);

      final dynamic userData = map['user'] ?? map;

      final user = UserModel.fromJson(Map<String, dynamic>.from(userData));

      final token = map['token']?.toString();

      if (token != null && token.isNotEmpty) {
        _api.setToken(token);
      }

      return ApiResponse.success(
        data: user,
        message: response.message,
        statusCode: response.statusCode,
      );
    } catch (error) {
      return ApiResponse.failure(
        message: 'Register response parse nahi hua',
        error: error,
      );
    }
  }

  // =========================
  // LOGIN
  // =========================

  Future<ApiResponse<UserModel>> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.post(
      ApiConstants.login,
      body: {'email': email.trim(), 'password': password},
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
        return ApiResponse.failure(message: 'Invalid login response');
      }

      final map = Map<String, dynamic>.from(data);

      final token = map['token']?.toString();

      final dynamic userData = map['user'] ?? map;

      final user = UserModel.fromJson(Map<String, dynamic>.from(userData));

      if (token != null && token.isNotEmpty) {
        _api.setToken(token);
      }

      return ApiResponse.success(
        data: user,
        message: response.message,
        statusCode: response.statusCode,
      );
    } catch (error) {
      return ApiResponse.failure(
        message: 'Login response parse nahi hua',
        error: error,
      );
    }
  }

  // =========================
  // CURRENT USER
  // =========================

  Future<ApiResponse<UserModel>> getCurrentUser() async {
    final response = await _api.get(ApiConstants.me, requiresAuth: true);

    if (!response.success || response.data is! Map) {
      return ApiResponse.failure(
        message: response.message,
        statusCode: response.statusCode,
        error: response.error,
      );
    }

    try {
      return ApiResponse.success(
        data: UserModel.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        ),
        message: response.message,
        statusCode: response.statusCode,
      );
    } catch (error) {
      return ApiResponse.failure(
        message: 'User data parse nahi hua',
        error: error,
      );
    }
  }

  // =========================
  // LOGOUT
  // =========================

  Future<ApiResponse<bool>> logout() async {
    // Backend stateless JWT use karta hai; logout client-side token clear karta hai.
    _api.clearToken();

    return ApiResponse.success(data: true, message: 'Logout successful');
  }

  // =========================
  // TOKEN
  // =========================

  void setToken(String token) {
    _api.setToken(token);
  }

  void clearToken() {
    _api.clearToken();
  }

  String? get token => _api.token;
}
