import 'dart:developer';
import 'package:flutter/material.dart';
import '../models/artikel.dart';
import '../services/dashboard_service.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardService _dashboardService = DashboardService();

  bool _isLoading = false;
  String _errorMessage = '';

  int _totalPoin = 0;
  bool _isMember = false;
  String? _expiredMemberDate;
  List<Artikel> _recentArticles = [];

  int _totalPesananDilayani = 0;
  double _totalSampahDiangkut = 0;

  int _totalPendapatan = 0;
  int _totalPendingVerifikasi = 0;
  double _totalSampahTerkumpul = 0;
  int _totalArtikel = 0;
  List<Map<String, dynamic>> _recentTransactions = [];

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  int get totalPoin => _totalPoin;
  bool get isMember => _isMember;
  String? get expiredMemberDate => _expiredMemberDate;
  List<Artikel> get recentArticles => _recentArticles;

  int get totalPesananDilayani => _totalPesananDilayani;
  double get totalSampahDiangkut => _totalSampahDiangkut;

  int get totalPendapatan => _totalPendapatan;
  int get totalPendingVerifikasi => _totalPendingVerifikasi;
  double get totalSampahTerkumpul => _totalSampahTerkumpul;
  int get totalArtikel => _totalArtikel;
  List<Map<String, dynamic>> get recentTransactions => _recentTransactions;

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

        final List<dynamic> articlesJson = data['recent_articles'] ?? [];
        _recentArticles = articlesJson
            .map((json) => Artikel.fromJson(json))
            .toList();
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

  Future<void> fetchPetugasDashboard() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _dashboardService.getPetugasDashboard();

      if (response['status'] == 'success') {
        final data = response['data'];
        _totalPesananDilayani = data['total_pesanan_dilayani'] ?? 0;
        _totalSampahDiangkut = (data['total_sampah_diangkut'] ?? 0).toDouble();
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

  Future<void> fetchAdminDashboard() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _dashboardService.getAdminDashboard();

      if (response['status'] == 'success') {
        final data = response['data'];
        _totalPendapatan = data['total_pendapatan'] ?? 0;
        _totalPendingVerifikasi = data['total_pending_transaksi'] ?? 0;
        _totalSampahTerkumpul = (data['total_sampah_terkumpul'] ?? 0)
            .toDouble();
        _totalArtikel = data['total_artikel'] ?? 0;

        final List<dynamic> trxJson = data['recent_transactions'] ?? [];
        _recentTransactions = trxJson
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
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

  String get formattedExpiredDate {
    if (_expiredMemberDate == null) return '-';
    final dt = DateTime.tryParse(_expiredMemberDate!);
    if (dt == null) return '-';
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

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
