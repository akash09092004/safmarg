import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService.instance;

  UserModel? _user;

  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  bool get isLoggedIn => _user != null;

  // =========================
  // REGISTER
  // =========================

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    final response = await _authService.register(
      name: name,
      email: email,
      phone: phone,
      password: password,
    );

    if (!response.success || response.data == null) {
      _setLoading(false);
      _setError(response.message);

      return false;
    }

    final currentUserResponse = await _authService.getCurrentUser();
    _user = currentUserResponse.success && currentUserResponse.data != null
        ? currentUserResponse.data
        : response.data;

    _setLoading(false);
    notifyListeners();

    return true;
  }

  // =========================
  // LOGIN
  // =========================

  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _clearError();

    final response = await _authService.login(email: email, password: password);

    if (!response.success || response.data == null) {
      _setLoading(false);
      _setError(response.message);

      return false;
    }

    final currentUserResponse = await _authService.getCurrentUser();
    _user = currentUserResponse.success && currentUserResponse.data != null
        ? currentUserResponse.data
        : response.data;

    _setLoading(false);
    notifyListeners();

    return true;
  }

  Future<bool> loadCurrentUser() async {
    _setLoading(true);
    _clearError();

    final response = await _authService.getCurrentUser();
    _setLoading(false);

    if (!response.success || response.data == null) {
      _setError(response.message);
      return false;
    }

    _user = response.data;
    notifyListeners();
    return true;
  }

  // =========================
  // LOGOUT
  // =========================

  Future<bool> logout() async {
    _setLoading(true);
    _clearError();

    final response = await _authService.logout();

    _setLoading(false);

    _user = null;

    notifyListeners();

    if (!response.success) {
      _setError(response.message);

      return false;
    }

    return true;
  }

  // =========================
  // SET USER
  // =========================

  void setUser(UserModel? user) {
    _user = user;

    notifyListeners();
  }

  // =========================
  // CLEAR SESSION
  // =========================

  void clearSession() {
    _authService.clearToken();

    _user = null;

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
