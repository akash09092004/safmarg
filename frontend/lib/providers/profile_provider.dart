import 'package:flutter/material.dart';

import '../models/passenger_model.dart';
import '../models/user_model.dart';
import '../services/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _profileService =
      ProfileService.instance;

  UserModel? _profile;

  List<PassengerModel>
      _travellers = [];

  bool _isLoading = false;
  bool _isTravellerLoading = false;

  String? _errorMessage;

  UserModel? get profile =>
      _profile;

  UserModel? get user => _profile;

  List<PassengerModel>
      get travellers =>
          _travellers;

  bool get isLoading =>
      _isLoading;

  bool get isTravellerLoading =>
      _isTravellerLoading;

  String? get errorMessage =>
      _errorMessage;

  // =========================
  // PROFILE
  // =========================

  Future<bool> loadProfile() async {
    _setLoading(true);
    _clearError();

    final response =
        await _profileService
            .getProfile();

    _setLoading(false);

    if (!response.success ||
        response.data == null) {
      _profile = null;

      _setError(
        response.message,
      );

      return false;
    }

    _profile =
        response.data;

    notifyListeners();

    return true;
  }

  // =========================
  // UPDATE PROFILE
  // =========================

  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? profileImage,
  }) async {
    _setLoading(true);
    _clearError();

    final response =
        await _profileService
            .updateProfile(
      name: name,
      phone: phone,
      profileImage: profileImage,
    );

    _setLoading(false);

    if (!response.success ||
        response.data == null) {
      _setError(
        response.message,
      );

      return false;
    }

    _profile =
        response.data;

    notifyListeners();

    return true;
  }

  // =========================
  // CHANGE PASSWORD
  // =========================

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _setLoading(true);
    _clearError();

    final response =
        await _profileService
            .changePassword(
      currentPassword:
          currentPassword,
      newPassword:
          newPassword,
    );

    _setLoading(false);

    if (!response.success) {
      _setError(
        response.message,
      );

      return false;
    }

    return true;
  }

  // =========================
  // LOAD TRAVELLERS
  // =========================

  Future<bool> loadTravellers() async {
    _isTravellerLoading = true;
    _clearError();

    notifyListeners();

    final response =
        await _profileService
            .getTravellers();

    _isTravellerLoading = false;

    if (!response.success) {
      _travellers = [];

      _setError(
        response.message,
      );

      return false;
    }

    _travellers =
        response.data ?? [];

    notifyListeners();

    return true;
  }

  // =========================
  // ADD TRAVELLER
  // =========================

  Future<bool> addTraveller(
    PassengerModel traveller,
  ) async {
    _isTravellerLoading = true;
    _clearError();

    notifyListeners();

    final response =
        await _profileService
            .addTraveller(
      traveller: traveller,
    );

    _isTravellerLoading = false;

    if (!response.success ||
        response.data == null) {
      _setError(
        response.message,
      );

      return false;
    }

    _travellers.add(
      response.data!,
    );

    notifyListeners();

    return true;
  }

  // =========================
  // UPDATE TRAVELLER
  // =========================

  Future<bool> updateTraveller({
    required int travellerId,
    required PassengerModel traveller,
  }) async {
    _isTravellerLoading = true;
    _clearError();

    notifyListeners();

    final response =
        await _profileService
            .updateTraveller(
      travellerId: travellerId,
      traveller: traveller,
    );

    _isTravellerLoading = false;

    if (!response.success ||
        response.data == null) {
      _setError(
        response.message,
      );

      return false;
    }

    final index =
        _travellers.indexWhere(
      (item) =>
          item.id ==
          travellerId,
    );

    if (index != -1) {
      _travellers[index] =
          response.data!;
    }

    notifyListeners();

    return true;
  }

  // =========================
  // DELETE TRAVELLER
  // =========================

  Future<bool> deleteTraveller(
    int travellerId,
  ) async {
    _isTravellerLoading = true;
    _clearError();

    notifyListeners();

    final response =
        await _profileService
            .deleteTraveller(
      travellerId,
    );

    _isTravellerLoading = false;

    if (!response.success) {
      _setError(
        response.message,
      );

      return false;
    }

    _travellers.removeWhere(
      (traveller) =>
          traveller.id ==
          travellerId,
    );

    notifyListeners();

    return true;
  }

  // =========================
  // SET PROFILE
  // =========================

  void setProfile(
    UserModel? user,
  ) {
    _profile = user;

    notifyListeners();
  }

  // =========================
  // RESET
  // =========================

  void reset() {
    _profile = null;
    _travellers = [];
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
