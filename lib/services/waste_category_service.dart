import 'api_service.dart';

class WasteCategoryService extends ApiService {
  Future<Map<String, dynamic>> getAllJenisSampah({int page = 1, int limit = 10}) async {
    try {
      final response = await dio.get('/jenis-sampah', queryParameters: {
        'page': page,
        'limit': limit,
      });
      return response.data;
    } catch (e) {
      throw Exception("Gagal mengambil kategori sampah");
    }
  }

  Future<Map<String, dynamic>> create({required String nama, required int poinPerKg}) async {
    try {
      final response = await dio.post('/jenis-sampah', data: {
        'nama': nama,
        'poin_per_kg': poinPerKg,
      });
      return response.data;
    } catch (e) {
      throw Exception("Gagal membuat kategori sampah");
    }
  }

  Future<Map<String, dynamic>> update(int id, {required String nama, required int poinPerKg}) async {
    try {
      final response = await dio.put('/jenis-sampah/$id', data: {
        'nama': nama,
        'poin_per_kg': poinPerKg,
      });
      return response.data;
    } catch (e) {
      throw Exception("Gagal memperbarui kategori sampah");
    }
  }

  Future<Map<String, dynamic>> delete(int id) async {
    try {
      final response = await dio.delete('/jenis-sampah/$id');
      return response.data;
    } catch (e) {
      throw Exception("Gagal menghapus kategori sampah");
    }
  }
}
