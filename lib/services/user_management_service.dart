import 'api_service.dart';

class UserManagementService extends ApiService {
  Future<Map<String, dynamic>> getAllUsers({int? role, int page = 1, int limit = 10}) async {
    try {
      final response = await dio.get('/manajemen-akun', queryParameters: {
        if (role != null) 'role': role,
        'page': page,
        'limit': limit,
      });
      return response.data;
    } catch (e) {
      throw Exception("Gagal mengambil data user");
    }
  }

  Future<Map<String, dynamic>> getAkunDetail(int idUser) async {
    try {
      final response = await dio.get('/manajemen-akun/$idUser');
      return response.data;
    } catch (e) {
      throw Exception("Gagal mengambil detail user");
    }
  }

  Future<Map<String, dynamic>> createUserAccount({
    required String nama,
    required String email,
    required String password,
    required int idRole,
  }) async {
    try {
      final response = await dio.post('/manajemen-akun', data: {
        'nama': nama,
        'email': email,
        'password': password,
        'id_role': idRole,
      });
      return response.data;
    } catch (e) {
      throw Exception("Gagal membuat user");
    }
  }

  Future<Map<String, dynamic>> updateUser(
    int idUser, {
    required String nama,
    required String email,
    String? password,
    required int idRole,
  }) async {
    try {
      final response = await dio.put('/manajemen-akun/$idUser', data: {
        'nama': nama,
        'email': email,
        if (password != null && password.isNotEmpty) 'password': password,
        'id_role': idRole,
      });
      return response.data;
    } catch (e) {
      throw Exception("Gagal memperbarui user");
    }
  }

  Future<Map<String, dynamic>> deleteUser(int idUser, int idRole) async {
    try {
      final response = await dio.delete('/manajemen-akun/$idUser', data: {
        'id_role': idRole,
      });
      return response.data;
    } catch (e) {
      throw Exception("Gagal menghapus user");
    }
  }
}
