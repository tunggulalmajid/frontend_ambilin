// ----- FILE: lib/services/dashboard_service.dart -----
// Service layer murni untuk HTTP/Dio request modul Dashboard.
// Setiap role memiliki endpoint dashboard berbeda sesuai integrasi.md.
// Hanya mengembalikan Map<String, dynamic> (JSON) ke pemanggil (Provider).

import 'package:dio/dio.dart';
import 'api_service.dart';

class DashboardService extends ApiService {
  // ================================================================
  // BAGIAN 1: DASHBOARD PER ROLE
  // ================================================================

  /// Dashboard Customer — menampilkan total poin, status member,
  /// expired member date, dan daftar artikel terbaru.
  /// Endpoint: GET /api/dashboard/customer
  Future<Map<String, dynamic>> getCustomerDashboard() async {
    try {
      final response = await dio.get('/dashboard/customer');
      return response.data;
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e, "Gagal memuat dashboard customer"));
    } catch (e) {
      throw Exception("Gagal memuat dashboard customer");
    }
  }

  /// Dashboard Petugas — menampilkan total pesanan dilayani
  /// dan total berat sampah yang diangkut.
  /// Endpoint: GET /api/dashboard/petugas
  Future<Map<String, dynamic>> getPetugasDashboard() async {
    try {
      final response = await dio.get('/dashboard/petugas');
      return response.data;
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e, "Gagal memuat dashboard petugas"));
    } catch (e) {
      throw Exception("Gagal memuat dashboard petugas");
    }
  }

  /// Dashboard Admin — menampilkan total nominal transaksi berhasil,
  /// total pending verifikasi, total sampah terkumpul, total artikel,
  /// dan list 5 transaksi masuk terbaru.
  /// Endpoint: GET /api/dashboard/admin
  Future<Map<String, dynamic>> getAdminDashboard() async {
    try {
      final response = await dio.get('/dashboard/admin');
      return response.data;
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e, "Gagal memuat dashboard admin"));
    } catch (e) {
      throw Exception("Gagal memuat dashboard admin");
    }
  }

  // ================================================================
  // BAGIAN 2: UTILITAS INTERNAL
  // ================================================================

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
