import 'package:dio/dio.dart';

class ApiService {
  // Gunakan 10.0.2.2 untuk Emulator Android, localhost untuk Web/iOS
  final String _baseUrl = "https://ambilin.kodetalma.my.id/api-docs/";

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
