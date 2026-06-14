import 'package:dio/dio.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import 'api_service.dart';

class AuthService extends ApiService {
  Future<Map<String, dynamic>> login(LoginRequest request) async {
    try {
      final response = await dio.post('/auth/login', data: request.toJson());
      return response.data;
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e, "Gagal login"));
    } catch (e) {
      throw Exception("Gagal login: tidak dapat terhubung ke server");
    }
  }

  Future<Map<String, dynamic>> register(RegisterRequest request) async {
    try {
      final response =
          await dio.post('/auth/register', data: request.toJson());
      return response.data;
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e, "Gagal registrasi"));
    } catch (e) {
      throw Exception("Gagal registrasi: tidak dapat terhubung ke server");
    }
  }

  Future<Map<String, dynamic>> loginWithGoogle(String idToken) async {
    try {
      final response =
          await dio.post('/auth/google', data: {'idToken': idToken});
      return response.data;
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e, "Gagal login dengan Google"));
    } catch (e) {
      throw Exception(
          "Gagal login dengan Google: tidak dapat terhubung ke server");
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await dio.post('/auth/logout');
      return response.data;
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e, "Gagal logout"));
    } catch (e) {
      throw Exception("Gagal logout");
    }
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));
      final response = await refreshDio.post('/auth/refresh', data: {
        'token': refreshToken,
      });
      return response.data;
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e, "Gagal memperbarui token"));
    } catch (e) {
      throw Exception("Gagal memperbarui token");
    }
  }

  Future<Map<String, dynamic>> getProfile(String token) async {
    try {
      final response = await dio.get(
        '/profile',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e, "Gagal memuat profil"));
    } catch (e) {
      throw Exception("Gagal memuat profil");
    }
  }

  Future<Map<String, dynamic>> getPendingTransactions({int page = 1, int limit = 10}) async {
    try {
      final response = await dio.get(
        '/subscriptions/transactions',
        queryParameters: {
          'status': 'menunggu',
          'page': page,
          'limit': limit,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e, "Gagal mengambil daftar antrean verifikasi"));
    } catch (e) {
      throw Exception("Gagal mengambil daftar antrean verifikasi");
    }
  }

  Future<Map<String, dynamic>> getTransactions({String? status, int page = 1, int limit = 10}) async {
    try {
      final response = await dio.get(
        '/subscriptions/transactions',
        queryParameters: {
          if (status != null && status.isNotEmpty) 'status': status,
          'page': page,
          'limit': limit,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e, "Gagal mengambil daftar transaksi"));
    } catch (e) {
      throw Exception("Gagal mengambil daftar transaksi");
    }
  }

  Future<Map<String, dynamic>> confirmTransaction(int id, String status) async {
    try {
      final response = await dio.put(
        '/subscriptions/transactions/$id/confirm',
        data: {'status': status},
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e, "Gagal memproses verifikasi transaksi"));
    } catch (e) {
      throw Exception("Gagal memproses verifikasi transaksi");
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String nama,
    required String email,
    String? alamat,
    String? nomorTelepon,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final response = await dio.put('/profile', data: {
        'nama': nama,
        'email': email,
        if (alamat != null) 'alamat': alamat,
        if (nomorTelepon != null) 'nomor_telepon': nomorTelepon,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      });
      return response.data;
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e, "Gagal mengubah profil"));
    } catch (e) {
      throw Exception("Gagal mengubah profil");
    }
  }

  Future<Map<String, dynamic>> updatePhoto(String imagePath) async {
    try {
      final fileName = imagePath.split('/').last;
      final formData = FormData.fromMap({
        'foto': await MultipartFile.fromFile(imagePath, filename: fileName),
      });
      final response = await dio.put('/profile/photo', data: formData);
      return response.data;
    } on DioException catch (e) {
      throw Exception(
          _extractErrorMessage(e, "Gagal mengunggah foto profil"));
    } catch (e) {
      throw Exception("Gagal mengunggah foto profil");
    }
  }
  Future<Map<String, dynamic>> updatePassword({
    required String passwordLama,
    required String passwordBaru,
    required String konfirmasiPassword,
  }) async {
    try {
      final response = await dio.put('/auth/update-password', data: {
        'password_lama': passwordLama,
        'password_baru': passwordBaru,
        'konfirmasi_password': konfirmasiPassword,
      });
      return response.data;
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e, "Gagal mengubah password"));
    } catch (e) {
      throw Exception("Gagal mengubah password");
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
