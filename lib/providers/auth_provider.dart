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
  bool _isProfileLoading = false;
  bool _isTransactionsLoading = false;
  String _errorMessage = "";
  bool _isLoggedIn = false;
  List<dynamic> _pendingTransactions = [];
  List<dynamic> _allTransactions = [];

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isProfileLoading => _isProfileLoading;
  bool get isTransactionsLoading => _isTransactionsLoading;
  String get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;
  List<dynamic> get pendingTransactions => _pendingTransactions;
  List<dynamic> get allTransactions => _allTransactions;

  Future<String?> getSavedRole() async {
    return await _storage.read(key: "role");
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: "accessToken");
  }

  Future<void> checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _storage.read(key: "accessToken");

      if (token != null && token.isNotEmpty) {
        final response = await _authService.getProfile(token);

        if (response['status'] == "success") {
          final payload = response['data'];
          _user = UserModel.fromJson(payload);

          final String role = _mapIdRoleToString(_user!.idRole);
          await _storage.write(key: "role", value: role);

          _isLoggedIn = true;
        } else {
          await _clearLocalSession();
        }
      } else {
        _isLoggedIn = false;
      }
    } catch (e) {
      log("checkLoginStatus Error: $e");
      await _clearLocalSession();
    }

    _isLoading = false;
    notifyListeners();
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

        await _storage.write(
            key: "accessToken", value: payload['accessToken']);
        await _storage.write(
            key: "refreshToken", value: payload['refreshToken']);

        _user = UserModel.fromJson(payload['user']);

        final String namaRole =
            (payload['user']['nama_role'] ?? '').toString().toLowerCase();
        final String role =
            namaRole.isNotEmpty ? namaRole : _mapIdRoleToString(_user!.idRole);
        await _storage.write(key: "role", value: role);

        _isLoggedIn = true;
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
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginWithGoogle(String idToken) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final response = await _authService.loginWithGoogle(idToken);
      _isLoading = false;

      if (response['status'] == "success") {
        final payload = response['data'];

        // Simpan token ke secure storage
        await _storage.write(
            key: "accessToken", value: payload['accessToken']);
        await _storage.write(
            key: "refreshToken", value: payload['refreshToken']);

        // Parse user data dari response
        _user = UserModel.fromJson(payload['user']);

        // Simpan role ke secure storage
        final String namaRole =
            (payload['user']['nama_role'] ?? '').toString().toLowerCase();
        final String role =
            namaRole.isNotEmpty ? namaRole : _mapIdRoleToString(_user!.idRole);
        await _storage.write(key: "role", value: role);

        _isLoggedIn = true;
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
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      notifyListeners();
      return false;
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
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePassword({
    required String passwordLama,
    required String passwordBaru,
    required String konfirmasiPassword,
  }) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final response = await _authService.updatePassword(
        passwordLama: passwordLama,
        passwordBaru: passwordBaru,
        konfirmasiPassword: konfirmasiPassword,
      );
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
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
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
        // Refresh data user dari server setelah update sukses
        final token = await _storage.read(key: "accessToken");
        if (token != null) {
          final responseProfile = await _authService.getProfile(token);
          if (responseProfile['status'] == "success") {
            _user = UserModel.fromJson(responseProfile['data']);
          }
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
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
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
        // Refresh data user dari server setelah upload foto sukses
        final token = await _storage.read(key: "accessToken");
        if (token != null) {
          final responseProfile = await _authService.getProfile(token);
          if (responseProfile['status'] == "success") {
            _user = UserModel.fromJson(responseProfile['data']);
          }
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
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
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
    await _clearLocalSession();
  }

  Future<void> tryAutoLogin() async {
    final token = await _storage.read(key: "accessToken");
    if (token != null) {
      try {
        final response = await _authService.getProfile(token);
        if (response['status'] == "success") {
          final payload = response['data'];
          _user = UserModel.fromJson(payload);

          // Perbarui role di storage
          final String role = _mapIdRoleToString(_user!.idRole);
          await _storage.write(key: "role", value: role);

          _isLoggedIn = true;
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

  Future<void> fetchProfile() async {
    _isProfileLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final token = await _storage.read(key: "accessToken");
      if (token != null) {
        final response = await _authService.getProfile(token);
        if (response['status'] == "success") {
          final payload = response['data'];
          _user = UserModel.fromJson(payload);

          final String role = _mapIdRoleToString(_user!.idRole);
          await _storage.write(key: "role", value: role);
        } else {
          _errorMessage = response['message'] ?? "Gagal memuat profil";
        }
      } else {
        _errorMessage = "Token tidak ditemukan";
      }
    } catch (e) {
      log("fetchProfile Error: $e");
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
    } finally {
      _isProfileLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPendingTransactions({int page = 1, int limit = 10}) async {
    _isTransactionsLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final response = await _authService.getPendingTransactions(page: page, limit: limit);
      if (response['status'] == "success") {
        _pendingTransactions = response['data'] ?? [];
      } else {
        _errorMessage = response['message'] ?? "Gagal mengambil antrean verifikasi";
      }
    } catch (e) {
      log("fetchPendingTransactions Error: $e");
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
    } finally {
      _isTransactionsLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTransactions({String? status, int page = 1, int limit = 10}) async {
    _isTransactionsLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final response = await _authService.getTransactions(status: status, page: page, limit: limit);
      if (response['status'] == "success") {
        _allTransactions = response['data'] ?? [];
      } else {
        _errorMessage = response['message'] ?? "Gagal mengambil daftar transaksi";
      }
    } catch (e) {
      log("fetchTransactions Error: $e");
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
    } finally {
      _isTransactionsLoading = false;
      notifyListeners();
    }
  }

  Future<bool> confirmTransaction(int id, String status) async {
    _isTransactionsLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final response = await _authService.confirmTransaction(id, status);
      if (response['status'] == "success") {
        await fetchPendingTransactions();
        return true;
      } else {
        _errorMessage = response['message'] ?? "Gagal memproses verifikasi";
        return false;
      }
    } catch (e) {
      log("confirmTransaction Error: $e");
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      return false;
    } finally {
      _isTransactionsLoading = false;
      notifyListeners();
    }
  }

  String _mapIdRoleToString(int idRole) {
    switch (idRole) {
      case 1:
        return 'admin';
      case 2:
        return 'petugas';
      case 3:
        return 'customer';
      default:
        return 'customer';
    }
  }

  Future<void> _clearLocalSession() async {
    await _storage.deleteAll();
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
