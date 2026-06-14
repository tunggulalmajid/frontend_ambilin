import 'package:flutter/material.dart';
import '../models/jenis_sampah.dart';

class WasteCategoryProvider extends ChangeNotifier {
  List<JenisSampah> _categories = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<JenisSampah> get categories => _categories;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  /// Fetch data (simulasi delay jaringan 2 detik)
  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Simulasi proses loading jaringan
      await Future.delayed(const Duration(seconds: 2));

      _categories = JenisSampah.getMockList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Gagal memuat data kategori';
      notifyListeners();
    }
  }

  /// Tambah kategori baru
  Future<void> addCategory(JenisSampah category) async {
    _isLoading = true;
    notifyListeners();

    // Simulasi proses loading jaringan
    await Future.delayed(const Duration(seconds: 2));

    _categories.add(category);
    _isLoading = false;
    notifyListeners();
  }

  /// Edit kategori
  Future<void> editCategory(int index, JenisSampah updatedCategory) async {
    _isLoading = true;
    notifyListeners();

    // Simulasi proses loading jaringan
    await Future.delayed(const Duration(seconds: 2));

    if (index >= 0 && index < _categories.length) {
      _categories[index] = updatedCategory;
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Hapus kategori
  Future<void> deleteCategory(int index) async {
    _isLoading = true;
    notifyListeners();

    // Simulasi proses loading jaringan
    await Future.delayed(const Duration(seconds: 2));

    if (index >= 0 && index < _categories.length) {
      _categories.removeAt(index);
    }
    _isLoading = false;
    notifyListeners();
  }
}
