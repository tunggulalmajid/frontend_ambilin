import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String _baseUrl = "https://ambilin.kodetalma.my.id/api";
  late Dio dio;
  final _storage = const FlutterSecureStorage();

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    dio.interceptors.add(AppInterceptor(dio, _storage));
  }
}

class AppInterceptor extends Interceptor {
  final Dio dio;
  final FlutterSecureStorage storage;

  AppInterceptor(this.dio, this.storage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!options.path.contains('/auth/login') &&
        !options.path.contains('/auth/register') &&
        !options.path.contains('/auth/refresh')) {
      final token = await storage.read(key: "accessToken");
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await storage.read(key: "refreshToken");
      if (refreshToken != null) {
        try {
          final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));
          final response = await refreshDio.post(
            '/auth/refresh',
            data: {'token': refreshToken},
          );

          if (response.statusCode == 200) {
            final newAccess = response.data['data']['accessToken'];
            final newRefresh = response.data['data']['refreshToken'];

            await storage.write(key: "accessToken", value: newAccess);
            await storage.write(key: "refreshToken", value: newRefresh);

            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newAccess';

            final cloneReq = await dio.request(
              options.path,
              options: Options(
                method: options.method,
                headers: options.headers,
              ),
              data: options.data,
              queryParameters: options.queryParameters,
            );
            return handler.resolve(cloneReq);
          }
        } catch (e) {
          await storage.delete(key: "accessToken");
          await storage.delete(key: "refreshToken");
        }
      }
    }
    return handler.next(err);
  }
}
