import 'package:dio/dio.dart';

class ApiService {
  // Gunakan domain hosting untuk development dengan device langsung
  final String _baseUrl = "https://ambilin.kodetalma.my.id/api";

  // Instance Dio yang bisa dipakai oleh class turunannya (child class)
  late Dio dio;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(
          seconds: 10,
        ), // Batas waktu koneksi 10 detik
        receiveTimeout: const Duration(
          seconds: 10,
        ), // Batas waktu terima data 10 detik
        // Agar Dio tidak melempar Exception saat status code 400/404
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    // Nanti kamu juga bisa menambahkan Interceptor di sini,
    // misalnya untuk otomatis menyisipkan Token di setiap request.
  }
}
