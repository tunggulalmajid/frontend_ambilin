import 'dart:developer';
import 'package:flutter/material.dart';
import '../models/setor_sampah.dart';
import '../services/petugas_service.dart';

class PetugasProvider extends ChangeNotifier {
  final PetugasService _petugasService = PetugasService();

  bool _isLoading = false;
  Map<String, dynamic> _dashboardData = {};
  List<dynamic> _activeOrders = [];
  List<dynamic> _historyOrders = [];
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  Map<String, dynamic> get dashboardData => _dashboardData;
  List<dynamic> get activeOrders => _activeOrders;
  List<dynamic> get historyOrders => _historyOrders;
  String get errorMessage => _errorMessage;

  Future<void> fetchDashboard() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _petugasService.getPetugasDashboard();
      if (response['status'] == 'success') {
        _dashboardData = response['data'] ?? {};
      } else {
        _dashboardData = {};
        _errorMessage = response['message'] ?? 'Gagal memuat dashboard petugas';
        throw Exception(_errorMessage);
      }
    } catch (e) {
      log("Fetch Dashboard Error: $e");
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      throw Exception(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchActiveOrders({
    int page = 1,
    int limit = 10,
    bool isLoadMore = false,
  }) async {
    if (!isLoadMore) {
      _isLoading = true;
      _activeOrders = [];
    }
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _petugasService.getOrderAktif(page, limit);
      if (response['status'] == 'success') {
        final List<dynamic> data = response['data'] ?? [];
        final List<SetorSampah> newOrders = data
            .map((json) => SetorSampah.fromJson(json))
            .toList();
        if (isLoadMore) {
          _activeOrders.addAll(newOrders);
        } else {
          _activeOrders = newOrders;
        }
      } else {
        if (!isLoadMore) _activeOrders = [];
        _errorMessage =
            response['message'] ?? 'Gagal mengambil antrean pesanan';
      }
    } catch (e) {
      log("Fetch Active Orders Error: $e");
      if (!isLoadMore) _activeOrders = [];
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHistoryOrders({
    int page = 1,
    int limit = 10,
    bool isLoadMore = false,
  }) async {
    if (!isLoadMore) {
      _isLoading = true;
      _historyOrders = [];
    }
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _petugasService.getRiwayatPekerjaan(page, limit);
      if (response['status'] == 'success') {
        final List<dynamic> data = response['data'] ?? [];
        final List<SetorSampah> newOrders = data
            .map((json) => SetorSampah.fromJson(json))
            .toList();
        if (isLoadMore) {
          _historyOrders.addAll(newOrders);
        } else {
          _historyOrders = newOrders;
        }
      } else {
        if (!isLoadMore) _historyOrders = [];
        _errorMessage =
            response['message'] ?? 'Gagal mengambil riwayat pekerjaan';
      }
    } catch (e) {
      log("Fetch History Orders Error: $e");
      if (!isLoadMore) _historyOrders = [];
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> processClaim(int id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _petugasService.claimOrder(id);
      if (response['status'] == 'success') {
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Gagal memproses klaim order';
        throw Exception(_errorMessage);
      }
    } catch (e) {
      log("Process Claim Error: $e");
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      throw Exception(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitCompleteOrder(
    int idSetor,
    String beratSampah,
    String imagePath,
  ) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _petugasService.completeOrder(
        idSetor,
        beratSampah,
        imagePath,
      );
      if (response['status'] == 'success') {
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Gagal menyelesaikan order';
        throw Exception(_errorMessage);
      }
    } catch (e) {
      log("Submit Complete Order Error: $e");
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      throw Exception(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
