import 'package:dio/dio.dart';
import 'api_service.dart';

class ArticleService extends ApiService {
  Future<Map<String, dynamic>> getCategories() async {
    try {
      final response = await dio.get('/articles/categories');
      return response.data;
    } catch (e) {
      throw Exception("Gagal mengambil kategori artikel");
    }
  }

  Future<Map<String, dynamic>> getAllArticles() async {
    try {
      final response = await dio.get('/articles');
      return response.data;
    } catch (e) {
      throw Exception("Gagal mengambil daftar artikel");
    }
  }

  Future<Map<String, dynamic>> getArticleById(int id) async {
    try {
      final response = await dio.get('/articles/$id');
      return response.data;
    } catch (e) {
      throw Exception("Gagal mengambil detail artikel");
    }
  }

  Future<Map<String, dynamic>> createArticle({
    required String judul,
    required int idJenisArtikel,
    required String isi,
    required String thumbnailPath,
  }) async {
    try {
      final fileName = thumbnailPath.split('/').last;
      final formData = FormData.fromMap({
        'judul': judul,
        'id_jenis_artikel': idJenisArtikel,
        'isi': isi,
        'foto_thumbnail': await MultipartFile.fromFile(thumbnailPath, filename: fileName),
      });

      final response = await dio.post('/articles', data: formData);
      return response.data;
    } catch (e) {
      throw Exception("Gagal membuat artikel");
    }
  }

  Future<Map<String, dynamic>> updateArticle({
    required int id,
    required String judul,
    required int idJenisArtikel,
    required String isi,
    String? thumbnailPath,
  }) async {
    try {
      final Map<String, dynamic> dataMap = {
        'judul': judul,
        'id_jenis_artikel': idJenisArtikel,
        'isi': isi,
      };

      if (thumbnailPath != null && thumbnailPath.isNotEmpty) {
        final fileName = thumbnailPath.split('/').last;
        dataMap['foto_thumbnail'] = await MultipartFile.fromFile(thumbnailPath, filename: fileName);
      }

      final formData = FormData.fromMap(dataMap);
      final response = await dio.put('/articles/$id', data: formData);
      return response.data;
    } catch (e) {
      throw Exception("Gagal memperbarui artikel");
    }
  }

  Future<Map<String, dynamic>> deleteArticle(int id) async {
    try {
      final response = await dio.delete('/articles/$id');
      return response.data;
    } catch (e) {
      throw Exception("Gagal menghapus artikel");
    }
  }
}
