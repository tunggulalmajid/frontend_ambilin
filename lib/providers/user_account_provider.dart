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

  Future<int> fetchUsers({
    int? role,
    int page = 1,
    int limit = 10,
    bool isLoadMore = false,
  }) async {
    if (!isLoadMore) {
      _isLoading = true;
      _allUsers = [];
    }
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _userService.getAllUsers(
        role: role,
        page: page,
        limit: limit,
      );
      _isLoading = false;

      if (response['status'] == "success") {
        final List<dynamic> data = response['data'] ?? [];
        final List<UserModel> userList = data
            .map((json) => UserModel.fromJson(json))
            .toList();

        List<AkunPengguna> loadedUsers = [];
        for (int i = 0; i < userList.length; i++) {
          final userJson = data[i];
          bool isActive = true;
          if (userList[i].idRole == 3) {
            final profile = userJson['customer_profile'];
            if (profile != null) {
              isActive =
                  (profile['is_aktif'] == 1 ||
                  profile['is_aktif'] == true ||
                  profile['is_aktif'] == '1');
            }
          } else if (userList[i].idRole == 2) {
            final profile = userJson['petugas_profile'];
            if (profile != null) {
              isActive =
                  (profile['is_aktif'] == 1 ||
                  profile['is_aktif'] == true ||
                  profile['is_aktif'] == '1');
            }
          }
          if (isActive) {
            loadedUsers.add(
              AkunPengguna.fromUserModel(userList[i], active: true),
            );
          }
        }

        if (isLoadMore) {
          _allUsers.addAll(loadedUsers);
        } else {
          _allUsers = loadedUsers;
        }
        notifyListeners();
        return data.length;
      } else {
        _errorMessage = response['message'] ?? 'Gagal memuat data pengguna';
        if (!isLoadMore) _allUsers = [];
        notifyListeners();
        return 0;
      }
    } catch (e) {
      log("Fetch Users Error: $e");
      _isLoading = false;
      _errorMessage = 'Gagal memuat data pengguna';
      if (!isLoadMore) _allUsers = [];
      notifyListeners();
      return 0;
    }
  }

  Future<bool> addUser({
    required String nama,
    required String email,
    required String password,
    required int idRole,
    String? nomorTelepon,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _userService.createUserAccount(
        nama: nama,
        email: email,
        password: password,
        idRole: idRole,
        nomorTelepon: nomorTelepon,
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
    String? nomorTelepon,
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
        nomorTelepon: nomorTelepon,
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

  Future<bool> deleteUserById(int idUser, int idRole) async {
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
      log("Delete User By ID Error: $e");
      _isLoading = false;
      _errorMessage = "Terjadi kesalahan jaringan atau server";
      notifyListeners();
      return false;
    }
  }
}
