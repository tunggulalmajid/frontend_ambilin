import 'package:flutter/material.dart';
import '../models/akun_pengguna.dart';

class UserAccountProvider extends ChangeNotifier {
  List<AkunPengguna> _allUsers = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<AkunPengguna> get allUsers => _allUsers;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  /// Filter users by role
  List<AkunPengguna> getFilteredUsers(String filter) {
    if (filter == 'Semua') return _allUsers;
    return _allUsers.where((u) => u.peran == filter).toList();
  }

  /// Fetch data (simulasi delay jaringan 2 detik)
  Future<void> fetchUsers() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Simulasi proses loading jaringan
      await Future.delayed(const Duration(seconds: 2));

      _allUsers = AkunPengguna.getDummyData();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Gagal memuat data pengguna';
      notifyListeners();
    }
  }

  /// Tambah user baru
  Future<void> addUser(AkunPengguna user) async {
    _isLoading = true;
    notifyListeners();

    // Simulasi proses loading jaringan
    await Future.delayed(const Duration(seconds: 2));

    _allUsers.add(user);
    _isLoading = false;
    notifyListeners();
  }

  /// Edit user
  Future<void> editUser(int index, AkunPengguna updatedUser) async {
    _isLoading = true;
    notifyListeners();

    // Simulasi proses loading jaringan
    await Future.delayed(const Duration(seconds: 2));

    if (index >= 0 && index < _allUsers.length) {
      _allUsers[index] = updatedUser;
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Hapus user
  Future<void> deleteUser(int index) async {
    _isLoading = true;
    notifyListeners();

    // Simulasi proses loading jaringan
    await Future.delayed(const Duration(seconds: 2));

    if (index >= 0 && index < _allUsers.length) {
      _allUsers.removeAt(index);
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Toggle status aktif/nonaktif
  Future<void> toggleUserStatus(int index) async {
    _isLoading = true;
    notifyListeners();

    // Simulasi proses loading jaringan
    await Future.delayed(const Duration(seconds: 2));

    if (index >= 0 && index < _allUsers.length) {
      final user = _allUsers[index];
      _allUsers[index] = AkunPengguna(
        nama: user.nama,
        email: user.email,
        peran: user.peran,
        status: user.status == 'Aktif' ? 'Nonaktif' : 'Aktif',
        warnaAvatar: user.warnaAvatar,
      );
    }
    _isLoading = false;
    notifyListeners();
  }
}
