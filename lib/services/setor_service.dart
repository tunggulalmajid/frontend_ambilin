import 'package:dio/dio.dart';
import 'api_service.dart';

class SetorService extends ApiService {
  Future<Map<String, dynamic>> ajukanSetor({
    required int idJenisSampah,
    required String alamat,
    required double latitude,
    required double longitude,
    required String catatan,
    required String imagePath,
  }) async {
    try {
      final fileName = imagePath.split('/').last;
      final formData = FormData.fromMap({
        'id_jenis_sampah': idJenisSampah,
        'alamat': alamat,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'catatan': catatan,
        'foto': await MultipartFile.fromFile(imagePath, filename: fileName),
      });

      final response = await dio.post('/setor', data: formData);
      return response.data;
    } catch (e) {
      throw Exception("Gagal mengajukan setor sampah");
    }
  }

  Future<Map<String, dynamic>> dapatkanRiwayatCustomer({int page = 1, int limit = 10}) async {
    try {
      final response = await dio.get('/setor/history/customer', queryParameters: {
        'page': page,
        'limit': limit,
      });
      return response.data;
    } catch (e) {
      throw Exception("Gagal mengambil riwayat customer");
    }
  }

  Future<Map<String, dynamic>> dapatkanOrderAktif({int page = 1, int limit = 10}) async {
    try {
      final response = await dio.get('/setor/active', queryParameters: {
        'page': page,
        'limit': limit,
      });
      return response.data;
    } catch (e) {
      throw Exception("Gagal mengambil antrean penjemputan");
    }
  }

  Future<Map<String, dynamic>> dapatkanRiwayatPetugas({int page = 1, int limit = 10}) async {
    try {
      final response = await dio.get('/setor/history/petugas', queryParameters: {
        'page': page,
        'limit': limit,
      });
      return response.data;
    } catch (e) {
      throw Exception("Gagal mengambil riwayat petugas");
    }
  }

  Future<Map<String, dynamic>> dapatkanDetailSetor(int id) async {
    try {
      final response = await dio.get('/setor/$id');
      return response.data;
    } catch (e) {
      throw Exception("Gagal mengambil detail penjemputan");
    }
  }

  Future<Map<String, dynamic>> prosesPenjemputan(int id) async {
    try {
      final response = await dio.put('/setor/$id/process');
      return response.data;
    } catch (e) {
      throw Exception("Gagal mengklaim penjemputan");
    }
  }

  Future<Map<String, dynamic>> selesaikanPenjemputan({
    required int id,
    required double beratSampah,
    required String imagePath,
  }) async {
    try {
      final fileName = imagePath.split('/').last;
      final formData = FormData.fromMap({
        'berat_sampah': beratSampah.toString(),
        'foto_bukti_penjemputan': await MultipartFile.fromFile(imagePath, filename: fileName),
      });

      final response = await dio.put('/setor/$id/complete', data: formData);
      return response.data;
    } catch (e) {
      throw Exception("Gagal menyelesaikan penjemputan");
    }
  }
}
