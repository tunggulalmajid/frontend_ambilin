import 'package:flutter/material.dart';
import '../models/riwayat_penjemputan.dart';

class PickupHistoryProvider extends ChangeNotifier {
  List<RiwayatPenjemputan> _pickupList = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<RiwayatPenjemputan> get pickupList => _pickupList;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  /// Fetch data (simulasi delay jaringan 2 detik)
  Future<void> fetchPickupHistory() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Simulasi proses loading jaringan
      await Future.delayed(const Duration(seconds: 2));

      _pickupList = RiwayatPenjemputan.getDummyData();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Gagal memuat riwayat penjemputan';
      notifyListeners();
    }
  }

  /// Tambah pickup history baru
  Future<void> addPickupHistory(RiwayatPenjemputan pickup) async {
    _isLoading = true;
    notifyListeners();

    // Simulasi proses loading jaringan
    await Future.delayed(const Duration(seconds: 2));

    _pickupList.add(pickup);
    _isLoading = false;
    notifyListeners();
  }

  /// Hapus pickup history
  Future<void> deletePickupHistory(String id) async {
    _isLoading = true;
    notifyListeners();

    // Simulasi proses loading jaringan
    await Future.delayed(const Duration(seconds: 2));

    _pickupList.removeWhere((p) => p.id == id);
    _isLoading = false;
    notifyListeners();
  }
}
