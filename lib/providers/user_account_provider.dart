import 'dart:developer';
import 'package:flutter/material.dart';
import '../models/akun_pengguna.dart';
import '../models/user_model.dart';
import '../services/user_management_service.dart';

class UserAccountProvider extends ChangeNotifier {
  final _userService = UserManagementService();

  List<AkunPengguna> _allUsers = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<AkunPengguna> get allUsers => _allUsers;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  List<AkunPengguna> getFilteredUsers(String filter) {
    if (filter == 'Semua') return _allUsers;
    return _allUsers.where((u) => u.peran == filter).toList();
  }

  Future<void> fetchUsers({int? role}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _userService.getAllUsers(role: role);
      _isLoading = false;

      if (response['status'] == "success") {
        final List<dynamic> data = response['data'] ?? [];
        final List<UserModel> userList = data.map((json) => UserModel.fromJson(json)).toList();
        _allUsers = [];
        for (int i = 0; i < userList.length; i++) {
          final userJson = data[i];
          final isActive = userJson['is_aktif'] != 0;
          _allUsers.add(AkunPengguna.fromUserModel(userList[i], active: isActive));
        }
        notifyListeners();
      } else {
        _errorMessage = response['message'] ?? 'Gagal memuat data pengguna';
        _allUsers = [];
        notifyListeners();
      }
    } catch (e) {
      log("Fetch Users Error: $e");
      _isLoading = false;
      _errorMessage = 'Gagal memuat data pengguna';
      _allUsers = [];
      notifyListeners();
    }
  }

  Future<bool> addUser({
    required String nama,
    required String email,
    required String password,
    required int idRole,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _userService.createUserAccount(
        nama: nama,
        email: email,
        password: password,
        idRole: idRole,
      );
      _isLoading = false;
      if (response['status'] == "success") {
        await fetchUsers();
        return true;
      }
      _errorMessage = response['message'] ?? "Gagal membuat user baru";
      notifyListeners();
      return false;
    } catch (e) {
      log("Add User Error: $e");
      _isLoading = false;
      _errorMessage = "Terjadi kesalahan jaringan atau server";
      notifyListeners();
      return false;
    }
  }

  Future<bool> editUser(
    int index, {
    required String nama,
    required String email,
    String? password,
    required int idRole,
  }) async {
    if (index < 0 || index >= _allUsers.length) return false;
    final idUser = _allUsers[index].idUser;
    if (idUser == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _userService.updateUser(
        idUser,
        nama: nama,
        email: email,
        password: password,
        idRole: idRole,
      );
      _isLoading = false;
      if (response['status'] == "success") {
        await fetchUsers();
        return true;
      }
      _errorMessage = response['message'] ?? "Gagal memperbarui user";
      notifyListeners();
      return false;
    } catch (e) {
      log("Edit User Error: $e");
      _isLoading = false;
      _errorMessage = "Terjadi kesalahan jaringan atau server";
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteUser(int index) async {
    if (index < 0 || index >= _allUsers.length) return false;
    final user = _allUsers[index];
    final idUser = user.idUser;
    if (idUser == null) return false;

    final idRole = user.peran == 'Petugas' ? 2 : 3;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _userService.deleteUser(idUser, idRole);
      _isLoading = false;
      if (response['status'] == "success") {
        await fetchUsers();
        return true;
      }
      _errorMessage = response['message'] ?? "Gagal menghapus user";
      notifyListeners();
      return false;
    } catch (e) {
      log("Delete User Error: $e");
      _isLoading = false;
      _errorMessage = "Terjadi kesalahan jaringan atau server";
      notifyListeners();
      return false;
    }
  }

  Future<void> toggleUserStatus(int index) async {
    if (index < 0 || index >= _allUsers.length) return;
    final user = _allUsers[index];
    final idUser = user.idUser;
    if (idUser == null) return;

    final idRole = user.peran == 'Petugas' ? 2 : 3;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _userService.deleteUser(idUser, idRole);
      _isLoading = false;
      if (response['status'] == "success") {
        await fetchUsers();
      } else {
        notifyListeners();
      }
    } catch (e) {
      log("Toggle User Status Error: $e");
      _isLoading = false;
      notifyListeners();
    }
  }
}
