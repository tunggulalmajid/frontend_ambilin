import 'dart:developer';
import 'package:flutter/material.dart';
import '../models/langganan.dart';
import '../services/subscription_service.dart';

class SubscriptionProvider extends ChangeNotifier {
  final _subscriptionService = SubscriptionService();

  List<Langganan> _subscriptions = [];
  List<dynamic> _paymentMethods = [];
  List<dynamic> _history = [];
  Map<String, dynamic>? _summary;
  bool _isLoading = false;
  String _errorMessage = '';

  List<Langganan> get subscriptions => _subscriptions;
  List<dynamic> get paymentMethods => _paymentMethods;
  List<dynamic> get history => _history;
  Map<String, dynamic>? get summary => _summary;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchSubscriptions() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _subscriptionService.getSubscriptions();
      _isLoading = false;
      if (response['status'] == 'success') {
        final List<dynamic> data = response['data'] ?? [];
        _subscriptions = data.map((json) => Langganan.fromJson(json)).toList();
        notifyListeners();
      } else {
        _errorMessage = response['message'] ?? 'Gagal memuat paket subscription';
        notifyListeners();
      }
    } catch (e) {
      log("Fetch Subscriptions Error: $e");
      _isLoading = false;
      _errorMessage = 'Gagal memuat paket subscription';
      notifyListeners();
    }
  }

  Future<void> fetchPaymentMethods() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _subscriptionService.getPaymentMethods();
      _isLoading = false;
      if (response['status'] == 'success') {
        _paymentMethods = response['data'] ?? [];
        notifyListeners();
      } else {
        _errorMessage = response['message'] ?? 'Gagal memuat metode pembayaran';
        notifyListeners();
      }
    } catch (e) {
      log("Fetch Payment Methods Error: $e");
      _isLoading = false;
      _errorMessage = 'Gagal memuat metode pembayaran';
      notifyListeners();
    }
  }

  Future<void> fetchCustomerHistory({int page = 1, int limit = 10}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _subscriptionService.getCustomerHistory(page: page, limit: limit);
      _isLoading = false;
      if (response['status'] == 'success') {
        _history = response['data'] ?? [];
        notifyListeners();
      } else {
        _errorMessage = response['message'] ?? 'Gagal memuat riwayat transaksi';
        notifyListeners();
      }
    } catch (e) {
      log("Fetch Customer History Error: $e");
      _isLoading = false;
      _errorMessage = 'Gagal memuat riwayat transaksi';
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> purchaseSubscription({
    required int idSub,
    required int idPayMethod,
    required int poinUsed,
    String? proofPath,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _subscriptionService.buySubscription(
        idSub: idSub,
        idPayMethod: idPayMethod,
        poinUsed: poinUsed,
        proofPath: proofPath,
      );
      _isLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      log("Purchase Subscription Error: $e");
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      notifyListeners();
      return {'status': 'error', 'message': _errorMessage};
    }
  }

  Future<void> fetchSummary() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _subscriptionService.getSummary();
      _isLoading = false;
      if (response['status'] == 'success') {
        _summary = response['data'];
        notifyListeners();
      } else {
        _errorMessage = response['message'] ?? 'Gagal memuat ringkasan keuangan';
        notifyListeners();
      }
    } catch (e) {
      log("Fetch Summary Error: $e");
      _isLoading = false;
      _errorMessage = 'Gagal memuat ringkasan keuangan';
      notifyListeners();
    }
  }

  Future<bool> updateSubscriptionPrice(int id, String nama, int harga) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _subscriptionService.updateSubscription(id, nama, harga);
      _isLoading = false;
      if (response['status'] == 'success') {
        await fetchSubscriptions();
        await fetchSummary();
        return true;
      }
      _errorMessage = response['message'] ?? 'Gagal memperbarui tarif';
      notifyListeners();
      return false;
    } catch (e) {
      log("Update Subscription Price Error: $e");
      _isLoading = false;
      _errorMessage = 'Terjadi kesalahan jaringan atau server';
      notifyListeners();
      return false;
    }
  }
}
