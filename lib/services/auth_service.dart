import '../models/login_request.dart';
import '../models/register_request.dart';
import 'api_service.dart'; // Import base service-nya

// Extend ApiService agar mewarisi properti 'dio'
class AuthService extends ApiService {
  Future<Map<String, dynamic>> login(LoginRequest request) async {
    try {
      final response = await dio.post('/auth/login', data: request.toJson());
      return response.data;
    } catch (e) {
      throw Exception("Gagal terhubung ke server");
    }
  }

  Future<Map<String, dynamic>> register(RegisterRequest request) async {
    try {
      final response = await dio.post('/auth/register', data: request.toJson());
      return response.data;
    } catch (e) {
      throw Exception("Gagal terhubung ke server");
    }
  }
}
