import 'package:flutter/material.dart';
import '../models/artikel.dart';

class ArticleProvider extends ChangeNotifier {
  List<Artikel> _allArticles = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Artikel> get allArticles => _allArticles;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  /// Filter articles by status
  List<Artikel> getFilteredArticles(String filter) {
    if (filter == 'Semua') return _allArticles;
    return _allArticles.where((a) => a.status == filter).toList();
  }

  /// Fetch data (simulasi delay jaringan 2 detik)
  Future<void> fetchArticles() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Simulasi proses loading jaringan
      await Future.delayed(const Duration(seconds: 2));

      _allArticles = Artikel.getMockList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Gagal memuat data artikel';
      notifyListeners();
    }
  }

  /// Tambah artikel baru
  Future<void> addArticle(Artikel article) async {
    _isLoading = true;
    notifyListeners();

    // Simulasi proses loading jaringan
    await Future.delayed(const Duration(seconds: 2));

    _allArticles.add(article);
    _isLoading = false;
    notifyListeners();
  }

  /// Edit artikel
  Future<void> editArticle(int index, Artikel updatedArticle) async {
    _isLoading = true;
    notifyListeners();

    // Simulasi proses loading jaringan
    await Future.delayed(const Duration(seconds: 2));

    if (index >= 0 && index < _allArticles.length) {
      _allArticles[index] = updatedArticle;
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Hapus artikel
  Future<void> deleteArticle(int index) async {
    _isLoading = true;
    notifyListeners();

    // Simulasi proses loading jaringan
    await Future.delayed(const Duration(seconds: 2));

    if (index >= 0 && index < _allArticles.length) {
      _allArticles.removeAt(index);
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Toggle status aktif/nonaktif
  Future<void> toggleArticleStatus(int index) async {
    _isLoading = true;
    notifyListeners();

    // Simulasi proses loading jaringan
    await Future.delayed(const Duration(seconds: 2));

    if (index >= 0 && index < _allArticles.length) {
      final article = _allArticles[index];
      _allArticles[index] = Artikel(
        idArtikel: article.idArtikel,
        idAdmin: article.idAdmin,
        idJenisArtikel: article.idJenisArtikel,
        judul: article.judul,
        kategori: article.kategori,
        status: article.status == 'Aktif' ? 'Nonaktif' : 'Aktif',
        isDelete: article.status == 'Aktif',
        createdAt: article.createdAt,
        updatedAt: DateTime.now(),
        fotoThumbnail: article.fotoThumbnail,
        isi: article.isi,
      );
    }
    _isLoading = false;
    notifyListeners();
  }
}
