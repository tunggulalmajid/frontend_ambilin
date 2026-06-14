import 'package:dio/dio.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import 'api_service.dart';

class AuthService extends ApiService {
  Future<Map<String, dynamic>> login(LoginRequest request) async {
    try {
      final response = await dio.post('/auth/login', data: request.toJson());
      return response.data;
    } catch (e) {
      throw Exception("Gagal login: terhubung ke server");
    }
  }

  Future<Map<String, dynamic>> register(RegisterRequest request) async {
    try {
      final response = await dio.post('/auth/register', data: request.toJson());
      return response.data;
    } catch (e) {
      throw Exception("Gagal registrasi: terhubung ke server");
    }
  }

  Future<Map<String, dynamic>> googleLogin(String idToken) async {
    try {
      final response = await dio.post('/auth/google', data: {'idToken': idToken});
      return response.data;
    } catch (e) {
      throw Exception("Gagal login Google");
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await dio.post('/auth/logout');
      return response.data;
    } catch (e) {
      throw Exception("Gagal logout");
    }
  }

  Future<Map<String, dynamic>> updatePassword(String oldPassword, String newPassword) async {
    try {
      final response = await dio.put('/auth/update-password', data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      });
      return response.data;
    } catch (e) {
      throw Exception("Gagal mengubah password");
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await dio.get('/profile');
      return response.data;
    } catch (e) {
      throw Exception("Gagal memuat profil");
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
    } catch (e) {
      throw Exception("Gagal mengunggah foto profil");
    }
  }

  Future<Map<String, dynamic>> loginWithGoogle(String idToken) async {
    try {
      final response = await dio.post('/auth/google', data: {
        'idToken': idToken,
      });
      return response.data;
    } catch (e) {
      throw Exception("Gagal terhubung ke server");
    }
  }
}
