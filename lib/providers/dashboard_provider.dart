// ----- FILE: lib/providers/dashboard_provider.dart -----
// Provider layer untuk mengelola state UI modul Dashboard.
// Bertanggung jawab atas: loading state, error message, dan data dashboard
// untuk setiap role (Customer, Petugas, Admin).
// Memanggil DashboardService untuk semua operasi HTTP.

import 'dart:developer';
import 'package:flutter/material.dart';
import '../models/artikel.dart';
import '../services/dashboard_service.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardService _dashboardService = DashboardService();

  // ================================================================
  // STATE PROPERTIES
  // ================================================================

  bool _isLoading = false;
  String _errorMessage = '';

  // --- Data Dashboard Customer ---
  int _totalPoin = 0;
  bool _isMember = false;
  String? _expiredMemberDate;
  List<Artikel> _recentArticles = [];

  // --- Data Dashboard Petugas ---
  int _totalPesananDilayani = 0;
  double _totalSampahDiangkut = 0;

  // --- Data Dashboard Admin ---
  int _totalPendapatan = 0;
  int _totalPendingVerifikasi = 0;
  double _totalSampahTerkumpul = 0;
  int _totalArtikel = 0;
  List<Map<String, dynamic>> _recentTransactions = [];

  // ================================================================
  // GETTERS
  // ================================================================

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Customer
  int get totalPoin => _totalPoin;
  bool get isMember => _isMember;
  String? get expiredMemberDate => _expiredMemberDate;
  List<Artikel> get recentArticles => _recentArticles;

  // Petugas
  int get totalPesananDilayani => _totalPesananDilayani;
  double get totalSampahDiangkut => _totalSampahDiangkut;

  // Admin
  int get totalPendapatan => _totalPendapatan;
  int get totalPendingVerifikasi => _totalPendingVerifikasi;
  double get totalSampahTerkumpul => _totalSampahTerkumpul;
  int get totalArtikel => _totalArtikel;
  List<Map<String, dynamic>> get recentTransactions => _recentTransactions;

  // ================================================================
  // BAGIAN 1: FETCH DASHBOARD CUSTOMER
  // ================================================================

  /// Mengambil data dashboard customer dari API.
  /// Response: total_poin, is_member, expired_member_date, recent_articles
  Future<void> fetchCustomerDashboard() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _dashboardService.getCustomerDashboard();

      if (response['status'] == 'success') {
        final data = response['data'];
        _totalPoin = data['total_poin'] ?? 0;
        _isMember = data['is_member'] == true || data['is_member'] == 1;
        _expiredMemberDate = data['expired_member_date']?.toString();

        // Parse recent articles jika tersedia
        final List<dynamic> articlesJson = data['recent_articles'] ?? [];
        _recentArticles =
            articlesJson.map((json) => Artikel.fromJson(json)).toList();
      } else {
        _errorMessage = response['message'] ?? 'Gagal memuat dashboard';
      }
    } catch (e) {
      log("Fetch Customer Dashboard Error: $e");
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
    }

    _isLoading = false;
    notifyListeners();
  }

  // ================================================================
  // BAGIAN 2: FETCH DASHBOARD PETUGAS
  // ================================================================

  /// Mengambil data dashboard petugas dari API.
  /// Response: total_pesanan_dilayani, total_sampah_diangkut
  Future<void> fetchPetugasDashboard() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _dashboardService.getPetugasDashboard();

      if (response['status'] == 'success') {
        final data = response['data'];
        _totalPesananDilayani = data['total_pesanan_dilayani'] ?? 0;
        _totalSampahDiangkut =
            (data['total_sampah_diangkut'] ?? 0).toDouble();
      } else {
        _errorMessage = response['message'] ?? 'Gagal memuat dashboard';
      }
    } catch (e) {
      log("Fetch Petugas Dashboard Error: $e");
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
    }

    _isLoading = false;
    notifyListeners();
  }

  // ================================================================
  // BAGIAN 3: FETCH DASHBOARD ADMIN
  // ================================================================

  /// Mengambil data dashboard admin dari API.
  /// Response: total pendapatan, pending verifikasi, sampah terkumpul,
  ///           total artikel, dan 5 transaksi masuk terbaru.
  Future<void> fetchAdminDashboard() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _dashboardService.getAdminDashboard();

      if (response['status'] == 'success') {
        final data = response['data'];
        _totalPendapatan = data['total_pendapatan'] ?? 0;
        _totalPendingVerifikasi = data['total_pending_verifikasi'] ?? 0;
        _totalSampahTerkumpul =
            (data['total_sampah_terkumpul'] ?? 0).toDouble();
        _totalArtikel = data['total_artikel'] ?? 0;

        // Parse transaksi terbaru (raw map, karena format bervariasi)
        final List<dynamic> trxJson = data['recent_transactions'] ?? [];
        _recentTransactions =
            trxJson.map((e) => Map<String, dynamic>.from(e)).toList();
      } else {
        _errorMessage = response['message'] ?? 'Gagal memuat dashboard';
      }
    } catch (e) {
      log("Fetch Admin Dashboard Error: $e");
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
    }

    _isLoading = false;
    notifyListeners();
  }

  // ================================================================
  // BAGIAN 4: FORMAT HELPERS
  // ================================================================

  /// Format angka menjadi string rupiah ringkas (contoh: 12500000 → "Rp 12,5 jt")
  String formatRupiah(int amount) {
    if (amount >= 1000000) {
      final jt = amount / 1000000;
      if (jt == jt.roundToDouble()) {
        return 'Rp ${jt.toInt()} juta';
      }
      return 'Rp ${jt.toStringAsFixed(1)} juta';
    } else if (amount >= 1000) {
      final rb = amount / 1000;
      if (rb == rb.roundToDouble()) {
        return 'Rp ${rb.toInt()} ribu';
      }
      return 'Rp ${rb.toStringAsFixed(1)} ribu';
    }
    return 'Rp $amount';
  }

  /// Format tanggal expired member menjadi "14 Juli 2026"
  String get formattedExpiredDate {
    if (_expiredMemberDate == null) return '-';
    final dt = DateTime.tryParse(_expiredMemberDate!);
    if (dt == null) return '-';
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  /// Format angka poin ke string dengan pemisah ribuan (contoh: 1500 → "1.500")
  String get formattedPoin {
    final str = _totalPoin.toString();
    final result = StringBuffer();
    int counter = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      counter++;
      result.write(str[i]);
      if (counter % 3 == 0 && i != 0) {
        result.write('.');
      }
    }
    return result.toString().split('').reversed.join();
  }
}
