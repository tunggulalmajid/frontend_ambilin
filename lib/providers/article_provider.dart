import 'dart:developer';
import 'package:flutter/material.dart';
import '../models/artikel.dart';
import '../services/article_service.dart';

class ArticleProvider extends ChangeNotifier {
  final _articleService = ArticleService();

  List<Artikel> _allArticles = [];
  List<dynamic> _categories = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Artikel> get allArticles => _allArticles;
  List<dynamic> get categories => _categories;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  int _categoryIdFromName(String name) {
    final cat = _categories.firstWhere(
      (c) => c['nama']?.toString().trim().toLowerCase() == name.trim().toLowerCase(),
      orElse: () => null,
    );
    if (cat != null) {
      final id = cat['id_jenis_artikel'];
      if (id != null) {
        return int.tryParse(id.toString()) ?? 1;
      }
    }
    switch (name.trim()) {
      case 'Tips': return 1;
      case 'Edukasi': return 2;
      case 'Inspirasi': return 3;
      case 'Berita': return 4;
      default: return 1;
    }
  }

  List<Artikel> getFilteredArticles(String filter) {
    if (filter == 'Semua') return _allArticles;
    return _allArticles.where((a) => a.status == filter).toList();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await _articleService.getCategories();
      if (response['status'] == 'success') {
        _categories = response['data'] ?? [];
        notifyListeners();
      }
    } catch (e) {
      log("Fetch Categories Error: $e");
    }
  }

  Future<void> fetchArticles({int page = 1, int limit = 10, bool isLoadMore = false}) async {
    if (!isLoadMore) {
      _isLoading = true;
      _errorMessage = '';
      _allArticles = [];
      notifyListeners();
    }

    try {
      if (!isLoadMore && _categories.isEmpty) {
        final catRes = await _articleService.getCategories();
        if (catRes['status'] == 'success') {
          _categories = catRes['data'] ?? [];
        }
      }

      final artRes = await _articleService.getAllArticles(page: page, limit: limit);

      if (artRes['status'] == "success") {
        final List<dynamic> data = artRes['data'] ?? [];
        final List<Artikel> loaded = data.map((json) => Artikel.fromJson(json)).toList();
        if (isLoadMore) {
          _allArticles.addAll(loaded);
        } else {
          _allArticles = loaded;
        }
      } else {
        _errorMessage = artRes['message'] ?? "Gagal memuat artikel";
        if (!isLoadMore) _allArticles = [];
      }
    } catch (e) {
      log("Fetch Articles Error: $e");
      _errorMessage = 'Gagal memuat data artikel';
      if (!isLoadMore) _allArticles = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addArticle(Artikel article, {String? imagePath}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final categoryId = _categoryIdFromName(article.kategori);
      final path = imagePath ?? article.fotoThumbnail ?? '';
      
      final response = await _articleService.createArticle(
        judul: article.judul,
        idJenisArtikel: categoryId,
        isi: article.isi,
        thumbnailPath: path.isNotEmpty ? path : 'assets/sampah.jpg',
      );
      _isLoading = false;
      if (response['status'] == "success") {
        await fetchArticles();
        return true;
      }
      _errorMessage = response['message'] ?? "Gagal membuat artikel";
      notifyListeners();
      return false;
    } catch (e) {
      log("Add Article Error: $e");
      _isLoading = false;
      _errorMessage = "Terjadi kesalahan jaringan atau server";
      notifyListeners();
      return false;
    }
  }

  Future<bool> editArticle(int index, Artikel updatedArticle, {String? imagePath}) async {
    if (index < 0 || index >= _allArticles.length) return false;
    final id = _allArticles[index].idArtikel;

    _isLoading = true;
    notifyListeners();

    try {
      final categoryId = _categoryIdFromName(updatedArticle.kategori);
      final response = await _articleService.updateArticle(
        id: id,
        judul: updatedArticle.judul,
        idJenisArtikel: categoryId,
        isi: updatedArticle.isi,
        thumbnailPath: imagePath,
      );
      _isLoading = false;
      if (response['status'] == "success") {
        await fetchArticles();
        return true;
      }
      _errorMessage = response['message'] ?? "Gagal memperbarui artikel";
      notifyListeners();
      return false;
    } catch (e) {
      log("Edit Article Error: $e");
      _isLoading = false;
      _errorMessage = "Terjadi kesalahan jaringan atau server";
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteArticle(int index) async {
    if (index < 0 || index >= _allArticles.length) return false;
    final id = _allArticles[index].idArtikel;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _articleService.deleteArticle(id);
      _isLoading = false;
      if (response['status'] == "success") {
        await fetchArticles();
        return true;
      }
      _errorMessage = response['message'] ?? "Gagal menghapus artikel";
      notifyListeners();
      return false;
    } catch (e) {
      log("Delete Article Error: $e");
      _isLoading = false;
      _errorMessage = "Terjadi kesalahan jaringan atau server";
      notifyListeners();
      return false;
    }
  }

  Future<void> toggleArticleStatus(int index) async {
    if (index < 0 || index >= _allArticles.length) return;
    final article = _allArticles[index];

    _isLoading = true;
    notifyListeners();

    try {
      if (article.status == 'Aktif') {
        await _articleService.deleteArticle(article.idArtikel);
      } else {
        log("Activating articles not supported by current delete toggle.");
      }
      await fetchArticles();
    } catch (e) {
      log("Toggle Article Status Error: $e");
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Artikel?> fetchArticleById(int id) async {
    try {
      final response = await _articleService.getArticleById(id);
      if (response['status'] == 'success') {
        return Artikel.fromJson(response['data']);
      }
    } catch (e) {
      log("Fetch Article By Id Error: $e");
    }
    return null;
  }
}
