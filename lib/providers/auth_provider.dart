import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  final AuthService _authService = AuthService();

  UserModel? _user;
  bool _isLoading = false;
  String _errorMessage = "";

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> tryAutoLogin() async {
    final token = await _storage.read(key: "accessToken");
    if (token != null) {
      try {
        final response = await _authService.getProfile();
        if (response['status'] == "success") {
          final payload = response['data'];
          _user = UserModel.fromJson(payload);
          notifyListeners();
        } else {
          await logout();
        }
      } catch (e) {
        log("Auto Login Error: $e");
        await logout();
      }
    }
  }

  Future<bool> register(RegisterRequest data) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final response = await _authService.register(data);
      _isLoading = false;

      if (response['status'] == "success") {
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? "Registrasi gagal";
        notifyListeners();
        return false;
      }
    } catch (e) {
      log("Register Error: $e");
      _isLoading = false;
      _errorMessage = "Terjadi kesalahan jaringan atau server";
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(LoginRequest data) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final response = await _authService.login(data);
      _isLoading = false;

      if (response['status'] == "success") {
        final payload = response['data'];

        await _storage.write(key: "accessToken", value: payload['accessToken']);
        await _storage.write(key: "refreshToken", value: payload['refreshToken']);

        _user = UserModel.fromJson(payload['user']);
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? "Login gagal";
        notifyListeners();
        return false;
      }
    } catch (e) {
      log("Login Error: $e");
      _isLoading = false;
      _errorMessage = "Terjadi kesalahan jaringan atau server";
      notifyListeners();
      return false;
    }
  }

  Future<bool> googleLogin(String idToken) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final response = await _authService.googleLogin(idToken);
      _isLoading = false;

      if (response['status'] == "success") {
        final payload = response['data'];

        await _storage.write(key: "accessToken", value: payload['accessToken']);
        await _storage.write(key: "refreshToken", value: payload['refreshToken']);

        _user = UserModel.fromJson(payload['user']);
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? "Login Google gagal";
        notifyListeners();
        return false;
      }
    } catch (e) {
      log("Google Login Error: $e");
      _isLoading = false;
      _errorMessage = "Terjadi kesalahan jaringan atau server";
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final response = await _authService.updatePassword(oldPassword, newPassword);
      _isLoading = false;
      if (response['status'] == "success") {
        notifyListeners();
        return true;
      }
      _errorMessage = response['message'] ?? "Gagal memperbarui password";
      notifyListeners();
      return false;
    } catch (e) {
      log("Update Password Error: $e");
      _isLoading = false;
      _errorMessage = "Gagal memperbarui password";
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile({
    required String nama,
    required String email,
    String? alamat,
    String? nomorTelepon,
    double? latitude,
    double? longitude,
  }) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final response = await _authService.updateProfile(
        nama: nama,
        email: email,
        alamat: alamat,
        nomorTelepon: nomorTelepon,
        latitude: latitude,
        longitude: longitude,
      );
      _isLoading = false;
      if (response['status'] == "success") {
        final responseProfile = await _authService.getProfile();
        if (responseProfile['status'] == "success") {
          _user = UserModel.fromJson(responseProfile['data']);
        }
        notifyListeners();
        return true;
      }
      _errorMessage = response['message'] ?? "Gagal memperbarui profil";
      notifyListeners();
      return false;
    } catch (e) {
      log("Update Profile Error: $e");
      _isLoading = false;
      _errorMessage = "Gagal memperbarui profil";
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfilePhoto(String imagePath) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final response = await _authService.updatePhoto(imagePath);
      _isLoading = false;
      if (response['status'] == "success") {
        final responseProfile = await _authService.getProfile();
        if (responseProfile['status'] == "success") {
          _user = UserModel.fromJson(responseProfile['data']);
        }
        notifyListeners();
        return true;
      }
      _errorMessage = response['message'] ?? "Gagal memperbarui foto profil";
      notifyListeners();
      return false;
    } catch (e) {
      log("Update Photo Error: $e");
      _isLoading = false;
      _errorMessage = "Gagal memperbarui foto profil";
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (e) {
      log("Logout API request error: $e");
    }
    await _storage.deleteAll();
    _user = null;
    notifyListeners();
  }
}
