import 'package:dio/dio.dart';
import 'api_service.dart';

class SubscriptionService extends ApiService {
  Future<Map<String, dynamic>> getSubscriptions() async {
    try {
      final response = await dio.get('/subscriptions');
      return response.data;
    } catch (e) {
      throw Exception("Gagal mengambil paket subscription");
    }
  }

  Future<Map<String, dynamic>> getPaymentMethods() async {
    try {
      final response = await dio.get('/subscriptions/payment-methods');
      return response.data;
    } catch (e) {
      throw Exception("Gagal mengambil metode pembayaran");
    }
  }

  Future<Map<String, dynamic>> getCustomerHistory({int page = 1, int limit = 10}) async {
    try {
      final response = await dio.get('/subscriptions/history', queryParameters: {
        'page': page,
        'limit': limit,
      });
      return response.data;
    } catch (e) {
      throw Exception("Gagal mengambil riwayat transaksi membership");
    }
  }

  Future<Map<String, dynamic>> buySubscription({
    required int idSub,
    required int idPayMethod,
    required int poinUsed,
    String? proofPath,
  }) async {
    try {
      final Map<String, dynamic> dataMap = {
        'id_subscribtion': idSub,
        'id_metode_pembayaran': idPayMethod,
        'poin_digunakan': poinUsed,
      };

      if (proofPath != null && proofPath.isNotEmpty) {
        final fileName = proofPath.split('/').last;
        dataMap['bukti_pembayaran'] = await MultipartFile.fromFile(proofPath, filename: fileName);
      }

      final formData = FormData.fromMap(dataMap);
      final response = await dio.post('/subscriptions/purchase', data: formData);
      return response.data;
    } catch (e) {
      throw Exception("Gagal membeli paket membership");
    }
  }

  Future<Map<String, dynamic>> getTransactions({String? status, int page = 1, int limit = 10}) async {
    try {
      final response = await dio.get('/subscriptions/transactions', queryParameters: {
        if (status != null) 'status': status,
        'page': page,
        'limit': limit,
      });
      return response.data;
    } catch (e) {
      throw Exception("Gagal mengambil transaksi masuk");
    }
  }

  Future<Map<String, dynamic>> confirmTransaction(int id, String status) async {
    try {
      final response = await dio.put('/subscriptions/transactions/$id/confirm', data: {
        'status': status,
      });
      return response.data;
    } catch (e) {
      throw Exception("Gagal mengonfirmasi transaksi");
    }
  }

  Future<Map<String, dynamic>> getSummary() async {
    try {
      final response = await dio.get('/subscriptions/summary');
      return response.data;
    } catch (e) {
      throw Exception("Gagal mengambil summary keuangan");
    }
  }

  Future<Map<String, dynamic>> updateSubscription(int id, String nama, int harga) async {
    try {
      final response = await dio.put('/subscriptions/$id', data: {
        'nama': nama,
        'harga': harga,
      });
      return response.data;
    } catch (e) {
      throw Exception("Gagal memperbarui harga subscription");
    }
  }
}
