import 'api_service.dart';

class DashboardService extends ApiService {
  Future<Map<String, dynamic>> getDashboard() async {
    try {
      final response = await dio.get('/dashboard');
      return response.data;
    } catch (e) {
      throw Exception("Gagal mengambil data dashboard");
    }
  }
}
