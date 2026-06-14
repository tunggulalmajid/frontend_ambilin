import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  final AuthService _authService =
      AuthService(); // Menggunakan service yang sudah kita buat

  UserModel? _user;
  bool _isLoading = false;
  String _errorMessage = "";

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // --- FUNGSI REGISTER ---
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
        // Tangkap pesan error dari backend
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

  // --- FUNGSI LOGIN ---
  Future<bool> login(LoginRequest data) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final response = await _authService.login(data);
      _isLoading = false;

      if (response['status'] == "success") {
        // Ambil data dari key 'data'
        final payload = response['data'];

        // Simpan token ke storage
        await _storage.write(key: "accessToken", value: payload['accessToken']);
        await _storage.write(
          key: "refreshToken",
          value: payload['refreshToken'],
        );

        // Simpan user ke memory provider
        _user = UserModel.fromJson(payload['user']);

        notifyListeners();
        return true;
      } else {
        // Tangkap pesan error dari backend (misal: "Password salah")
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

  // --- FUNGSI LOGIN DENGAN GOOGLE ---
  Future<bool> loginWithGoogle(String idToken) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final response = await _authService.loginWithGoogle(idToken);
      _isLoading = false;

      if (response['status'] == "success") {
        // Ambil data dari key 'data'
        final payload = response['data'];

        // Simpan token ke storage
        await _storage.write(key: "accessToken", value: payload['accessToken']);
        await _storage.write(
          key: "refreshToken",
          value: payload['refreshToken'],
        );

        // Simpan user ke memory provider (mendukung response reguler maupun google auth nested structure)
        final userPayload = payload['user'] ?? (payload['data'] != null ? payload['data']['user'] : null);
        if (userPayload != null) {
          _user = UserModel.fromJson(userPayload);
        }

        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? "Login Google gagal";
        notifyListeners();
        return false;
      }
    } catch (e) {
      log("Login Google Error: $e");
      _isLoading = false;
      _errorMessage = "Terjadi kesalahan jaringan atau server";
      notifyListeners();
      return false;
    }
  }

  // --- FUNGSI LOGOUT ---
  void logout() async {
    await _storage.deleteAll();
    _user = null;
    notifyListeners();
  }
}
