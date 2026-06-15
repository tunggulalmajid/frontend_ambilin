import 'dart:developer';
import 'package:flutter/material.dart';
import '../models/riwayat_penjemputan.dart';
import '../models/setor_sampah.dart';
import '../services/setor_service.dart';

class PickupHistoryProvider extends ChangeNotifier {
  final _setorService = SetorService();

  List<RiwayatPenjemputan> _pickupList = [];
  List<SetorSampah> _activeOrders = [];
  List<SetorSampah> _setorHistory = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<RiwayatPenjemputan> get pickupList => _pickupList;
  List<SetorSampah> get activeOrders => _activeOrders;
  List<SetorSampah> get setorHistory => _setorHistory;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchActiveOrders({int page = 1, int limit = 10, bool isLoadMore = false}) async {
    if (!isLoadMore) {
      _isLoading = true;
      _activeOrders = [];
    }
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _setorService.dapatkanOrderAktif(page: page, limit: limit);
      _isLoading = false;

      if (response['status'] == "success") {
        final List<dynamic> data = response['data'] ?? [];
        final List<SetorSampah> newOrders = data.map((json) => SetorSampah.fromJson(json)).toList();
        if (isLoadMore) {
          _activeOrders.addAll(newOrders);
        } else {
          _activeOrders = newOrders;
        }
        notifyListeners();
      } else {
        _errorMessage = response['message'] ?? 'Gagal memuat antrean penjemputan';
        if (!isLoadMore) _activeOrders = [];
        notifyListeners();
      }
    } catch (e) {
      log("Fetch Active Orders Error: $e");
      _isLoading = false;
      _errorMessage = 'Gagal memuat antrean penjemputan';
      if (!isLoadMore) _activeOrders = [];
      notifyListeners();
    }
  }

  Future<void> fetchPickupHistory({required int roleId, int page = 1, int limit = 10, bool isLoadMore = false}) async {
    if (!isLoadMore) {
      _isLoading = true;
      _pickupList = [];
      _setorHistory = [];
    }
    _errorMessage = '';
    notifyListeners();

    try {
      final Map<String, dynamic> response;
      if (roleId == 3) {
        response = await _setorService.dapatkanRiwayatCustomer(page: page, limit: limit);
      } else if (roleId == 2) {
        response = await _setorService.dapatkanRiwayatPetugas(page: page, limit: limit);
      } else {
        response = await _setorService.dapatkanOrderAktif(page: page, limit: limit);
      }

      _isLoading = false;
      if (response['status'] == "success") {
        final List<dynamic> data = response['data'] ?? [];
        final List<SetorSampah> setorList = data.map((json) => SetorSampah.fromJson(json)).toList();
        final List<RiwayatPenjemputan> mappedList = setorList.map((setor) => RiwayatPenjemputan.fromSetorSampah(setor)).toList();
        if (isLoadMore) {
          _setorHistory.addAll(setorList);
          _pickupList.addAll(mappedList);
        } else {
          _setorHistory = setorList;
          _pickupList = mappedList;
        }
        notifyListeners();
      } else {
        _errorMessage = response['message'] ?? 'Gagal memuat riwayat penjemputan';
        if (!isLoadMore) {
          _pickupList = [];
          _setorHistory = [];
        }
        notifyListeners();
      }
    } catch (e) {
      log("Fetch Pickup History Error: $e");
      _isLoading = false;
      _errorMessage = 'Gagal memuat riwayat penjemputan';
      if (!isLoadMore) {
        _pickupList = [];
        _setorHistory = [];
      }
      notifyListeners();
    }
  }

  Future<bool> addPickup({
    required int idJenisSampah,
    required String alamat,
    required double latitude,
    required double longitude,
    required String catatan,
    required String imagePath,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _setorService.ajukanSetor(
        idJenisSampah: idJenisSampah,
        alamat: alamat,
        latitude: latitude,
        longitude: longitude,
        catatan: catatan,
        imagePath: imagePath,
      );
      _isLoading = false;
      if (response['status'] == "success") {
        notifyListeners();
        return true;
      }
      _errorMessage = response['message'] ?? "Gagal mengajukan setor sampah";
      notifyListeners();
      return false;
    } catch (e) {
      log("Add Pickup Error: $e");
      _isLoading = false;
      _errorMessage = "Terjadi kesalahan jaringan atau server";
      notifyListeners();
      return false;
    }
  }

  Future<bool> processPickup(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _setorService.prosesPenjemputan(id);
      _isLoading = false;
      if (response['status'] == "success") {
        notifyListeners();
        return true;
      }
      _errorMessage = response['message'] ?? "Gagal memproses penjemputan";
      notifyListeners();
      return false;
    } catch (e) {
      log("Process Pickup Error: $e");
      _isLoading = false;
      _errorMessage = "Terjadi kesalahan jaringan atau server";
      notifyListeners();
      return false;
    }
  }

  Future<bool> completePickup({
    required int id,
    required double beratSampah,
    required String imagePath,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _setorService.selesaikanPenjemputan(
        id: id,
        beratSampah: beratSampah,
        imagePath: imagePath,
      );
      _isLoading = false;
      if (response['status'] == "success") {
        notifyListeners();
        return true;
      }
      _errorMessage = response['message'] ?? "Gagal menyelesaikan penjemputan";
      notifyListeners();
      return false;
    } catch (e) {
      log("Complete Pickup Error: $e");
      _isLoading = false;
      _errorMessage = "Terjadi kesalahan jaringan atau server";
      notifyListeners();
      return false;
    }
  }
}
