import 'dart:developer';
import 'package:flutter/material.dart';
import '../models/setor_sampah.dart';
import '../services/petugas_service.dart';

class PetugasProvider extends ChangeNotifier {
  final PetugasService _petugasService = PetugasService();

  // Properti internal
  bool _isLoading = false;
  Map<String, dynamic> _dashboardData = {};
  List<dynamic> _activeOrders = [];
  List<dynamic> _historyOrders = [];
  String _errorMessage = '';

  // Getters
  bool get isLoading => _isLoading;
  Map<String, dynamic> get dashboardData => _dashboardData;
  List<dynamic> get activeOrders => _activeOrders;
  List<dynamic> get historyOrders => _historyOrders;
  String get errorMessage => _errorMessage;

  /// Mengambil data dashboard ringkasan performa petugas.
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

  /// Mengambil antrean pesanan aktif berstatus 'menunggu'.
  Future<void> fetchActiveOrders({int page = 1, int limit = 10}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _petugasService.getOrderAktif(page, limit);
      if (response['status'] == 'success') {
        final List<dynamic> data = response['data'] ?? [];
        _activeOrders = data.map((json) => SetorSampah.fromJson(json)).toList();
      } else {
        _activeOrders = [];
        _errorMessage = response['message'] ?? 'Gagal mengambil antrean pesanan';
        throw Exception(_errorMessage);
      }
    } catch (e) {
      log("Fetch Active Orders Error: $e");
      _activeOrders = [];
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      throw Exception(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mengambil riwayat pekerjaan penjemputan petugas.
  Future<void> fetchHistoryOrders({int page = 1, int limit = 10}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _petugasService.getRiwayatPekerjaan(page, limit);
      if (response['status'] == 'success') {
        final List<dynamic> data = response['data'] ?? [];
        _historyOrders = data.map((json) => SetorSampah.fromJson(json)).toList();
      } else {
        _historyOrders = [];
        _errorMessage = response['message'] ?? 'Gagal mengambil riwayat pekerjaan';
        throw Exception(_errorMessage);
      }
    } catch (e) {
      log("Fetch History Orders Error: $e");
      _historyOrders = [];
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      throw Exception(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mengklaim atau memproses order penjemputan baru.
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

  /// Menyelesaikan order penjemputan dengan mengirimkan data timbangan berat sampah dan foto bukti.
  Future<bool> submitCompleteOrder(int idSetor, String beratSampah, String imagePath) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _petugasService.completeOrder(idSetor, beratSampah, imagePath);
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
