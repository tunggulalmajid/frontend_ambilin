import 'package:dio/dio.dart';
import 'api_service.dart';

class PetugasService extends ApiService {
  Future<Map<String, dynamic>> getPetugasDashboard() async {
    try {
      final response = await dio.get('/dashboard/petugas');
      return response.data;
    } on DioException catch (e) {
      throw Exception(
        _extractErrorMessage(e, "Gagal memuat dashboard petugas"),
      );
    } catch (e) {
      throw Exception("Gagal memuat dashboard petugas");
    }
  }

  Future<Map<String, dynamic>> getOrderAktif(int page, int limit) async {
    try {
      final response = await dio.get(
        '/setor/active',
        queryParameters: {'page': page, 'limit': limit},
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(
        _extractErrorMessage(e, "Gagal mengambil daftar antrean pesanan aktif"),
      );
    } catch (e) {
      throw Exception("Gagal mengambil daftar antrean pesanan aktif");
    }
  }

  Future<Map<String, dynamic>> getRiwayatPekerjaan(int page, int limit) async {
    try {
      final response = await dio.get(
        '/setor/history/petugas',
        queryParameters: {'page': page, 'limit': limit},
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(
        _extractErrorMessage(e, "Gagal mengambil riwayat pekerjaan petugas"),
      );
    } catch (e) {
      throw Exception("Gagal mengambil riwayat pekerjaan petugas");
    }
  }

  Future<Map<String, dynamic>> claimOrder(int idSetor) async {
    try {
      final response = await dio.put('/setor/$idSetor/process');
      return response.data;
    } on DioException catch (e) {
      throw Exception(
        _extractErrorMessage(e, "Gagal mengklaim/memproses order penjemputan"),
      );
    } catch (e) {
      throw Exception("Gagal mengklaim/memproses order penjemputan");
    }
  }

  Future<Map<String, dynamic>> completeOrder(
    int idSetor,
    String beratSampah,
    String imagePath,
  ) async {
    try {
      final fileName = imagePath.split('/').last;
      final formData = FormData.fromMap({
        'berat_sampah': beratSampah,
        'foto_bukti_penjemputan': await MultipartFile.fromFile(
          imagePath,
          filename: fileName,
        ),
      });

      final response = await dio.put(
        '/setor/$idSetor/complete',
        data: formData,
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(
        _extractErrorMessage(e, "Gagal menyelesaikan order penjemputan"),
      );
    } catch (e) {
      throw Exception("Gagal menyelesaikan order penjemputan");
    }
  }

  String _extractErrorMessage(DioException e, String fallback) {
    if (e.response?.data != null && e.response?.data is Map) {
      final serverMessage = e.response?.data['message'];
      if (serverMessage != null && serverMessage.toString().isNotEmpty) {
        return serverMessage.toString();
      }
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return "Koneksi ke server timeout. Periksa jaringan Anda.";
    }
    if (e.type == DioExceptionType.connectionError) {
      return "Tidak dapat terhubung ke server. Periksa koneksi internet Anda.";
    }
    return fallback;
  }
}
