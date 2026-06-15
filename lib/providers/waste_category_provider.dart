import 'dart:developer';
import 'package:flutter/material.dart';
import '../models/jenis_sampah.dart';
import '../services/waste_category_service.dart';

class WasteCategoryProvider extends ChangeNotifier {
  final _categoryService = WasteCategoryService();

  List<JenisSampah> _categories = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<JenisSampah> get categories => _categories;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchCategories({int page = 1, int limit = 10, bool isLoadMore = false}) async {
    if (!isLoadMore) {
      _isLoading = true;
      _categories = [];
    }
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _categoryService.getAllJenisSampah(page: page, limit: limit);
      _isLoading = false;

      if (response['status'] == "success") {
        final List<dynamic> data = response['data'] ?? [];
        final List<JenisSampah> loaded = data.map((json) => JenisSampah.fromJson(json)).toList();
        if (isLoadMore) {
          _categories.addAll(loaded);
        } else {
          _categories = loaded;
        }
        notifyListeners();
      } else {
        _errorMessage = response['message'] ?? 'Gagal memuat data kategori';
        if (!isLoadMore) _categories = [];
        notifyListeners();
      }
    } catch (e) {
      log("Fetch Categories Error: $e");
      _isLoading = false;
      _errorMessage = 'Gagal memuat data kategori';
      if (!isLoadMore) _categories = [];
      notifyListeners();
    }
  }

  Future<bool> addCategory(JenisSampah category) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _categoryService.create(
        nama: category.nama,
        poinPerKg: category.poinPerKg,
      );
      _isLoading = false;
      if (response['status'] == "success") {
        await fetchCategories();
        return true;
      }
      _errorMessage = response['message'] ?? "Gagal membuat kategori baru";
      notifyListeners();
      return false;
    } catch (e) {
      log("Add Category Error: $e");
      _isLoading = false;
      _errorMessage = "Terjadi kesalahan jaringan atau server";
      notifyListeners();
      return false;
    }
  }

  Future<bool> editCategory(int index, JenisSampah updatedCategory) async {
    if (index < 0 || index >= _categories.length) return false;
    final id = _categories[index].idJenisSampah;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _categoryService.update(
        id,
        nama: updatedCategory.nama,
        poinPerKg: updatedCategory.poinPerKg,
      );
      _isLoading = false;
      if (response['status'] == "success") {
        await fetchCategories();
        return true;
      }
      _errorMessage = response['message'] ?? "Gagal memperbarui kategori";
      notifyListeners();
      return false;
    } catch (e) {
      log("Edit Category Error: $e");
      _isLoading = false;
      _errorMessage = "Terjadi kesalahan jaringan atau server";
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCategory(int index) async {
    if (index < 0 || index >= _categories.length) return false;
    final id = _categories[index].idJenisSampah;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _categoryService.delete(id);
      _isLoading = false;
      if (response['status'] == "success") {
        await fetchCategories();
        return true;
      }
      _errorMessage = response['message'] ?? "Gagal menghapus kategori";
      notifyListeners();
      return false;
    } catch (e) {
      log("Delete Category Error: $e");
      _isLoading = false;
      _errorMessage = "Terjadi kesalahan jaringan atau server";
      notifyListeners();
      return false;
    }
  }
}
