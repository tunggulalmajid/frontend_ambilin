import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:frontend_ambilin/providers/auth_provider.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';

class AdminKonfirmasiPembayaran extends StatefulWidget {
  const AdminKonfirmasiPembayaran({super.key});

  @override
  State<AdminKonfirmasiPembayaran> createState() => _AdminKonfirmasiPembayaranState();
}

class _AdminKonfirmasiPembayaranState extends State<AdminKonfirmasiPembayaran> {
  bool _isApproving = false;
  bool _isRejecting = false;
  Map<String, dynamic>? _item;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _item ??= ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
  }

  String _formatDateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      return DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(dt);
    } catch (e) {
      try {
        final dt = DateTime.parse(dateStr).toLocal();
        return '${dt.day}-${dt.month}-${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      } catch (_) {
        return dateStr;
      }
    }
  }

  String _getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return 'https://ambilin.kodetalma.my.id/$cleanPath';
  }

  void _handleSetujui() async {
    if (_item == null) return;
    final id = _item!['id_riwayat_subscribtion'] ?? _item!['id'] ?? 0;

    setState(() {
      _isApproving = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.confirmTransaction(id, 'berhasil');

      setState(() {
        _isApproving = false;
      });

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(child: Text('Pembayaran Berhasil Disetujui')),
            backgroundColor: AppColor.base100,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text(authProvider.errorMessage.isNotEmpty ? authProvider.errorMessage : 'Gagal menyetujui pembayaran')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isApproving = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(child: Text('Terjadi kesalahan: $e')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleTolak() async {
    if (_item == null) return;
    final id = _item!['id_riwayat_subscribtion'] ?? _item!['id'] ?? 0;

    setState(() {
      _isRejecting = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.confirmTransaction(id, 'gagal');

      setState(() {
        _isRejecting = false;
      });

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(child: Text('Pembayaran Telah Ditolak')),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text(authProvider.errorMessage.isNotEmpty ? authProvider.errorMessage : 'Gagal menolak pembayaran')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isRejecting = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(child: Text('Terjadi kesalahan: $e')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = _item;
    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Konfirmasi')),
        body: const Center(child: Text('Data transaksi tidak ditemukan')),
      );
    }

    final userName = item['user']?['nama'] ?? item['nama_user'] ?? item['nama'] ?? 'User';
    final inisial = userName.isNotEmpty ? userName[0].toUpperCase() : '?';
    final transId = item['id_riwayat_subscribtion'] ?? item['id'] ?? 0;
    final subNama = item['subscribtion']?['nama'] ?? item['nama_subscribtion'] ?? '';
    
    final int harga = item['subscribtion']?['harga'] as int? ?? item['harga'] as int? ?? 0;
    final int poinDigunakan = item['poin_digunakan'] as int? ?? 0;
    final int totalBayar = harga - poinDigunakan;

    final formattedTotal = 'Rp. ${totalBayar.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]}.")}';
    
    final paymentMethodName = item['metode_pembayaran']?['nama'] ?? item['nama_metode_pembayaran'] ?? '';
    final paymentMethodRek = item['metode_pembayaran']?['nomor_rekening'] ?? item['nomor_rekening'] ?? '';
    final paymentMethod = paymentMethodRek.isNotEmpty ? '$paymentMethodName - $paymentMethodRek' : paymentMethodName;

    final rawDate = item['created_at']?.toString() ?? '';
    final formattedDate = _formatDateTime(rawDate);
    final buktiUrl = _getImageUrl(item['bukti_pembayaran']?.toString());

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      appBar: AppBar(
        backgroundColor: AppColor.putihBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.font100),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Konfirmasi',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColor.base100,
              ),
            ),
            Text(
              'Periksa dan konfirmasi pembayaran',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppColor.font80,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColor.font60.withOpacity(0.5)),
              ),
              child: Column(
                children: [

                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: const Color(0xFFE3F2FD),
                        child: Text(
                          inisial,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: const Color(0xFF1565C0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        userName,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColor.font100,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppColor.font60),

                  _buildInfoRow('ID Transaksi', transId.toString()),
                  const Divider(color: AppColor.font60),
                  _buildInfoRow('Paket Langganan', subNama),
                  const Divider(color: AppColor.font60),
                  _buildInfoRow('Harga Total', formattedTotal),
                  const Divider(color: AppColor.font60),
                  _buildInfoRow('Metode Pembayaran', paymentMethod),
                  const Divider(color: AppColor.font60),
                  _buildInfoRow('Tanggal dan Waktu', formattedDate),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColor.font60.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bukti Transfer',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColor.font100,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      color: const Color(0xFFE0E0E0),
                      child: buktiUrl.isNotEmpty
                          ? Image.network(
                              buktiUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.receipt_long,
                                    color: AppColor.font80,
                                    size: 48,
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Icon(
                                Icons.receipt_long,
                                color: AppColor.font80,
                                size: 48,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [

                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red, width: 1.5),
                      backgroundColor: const Color(0xFFFFEBEE),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: (_isApproving || _isRejecting) ? null : _handleTolak,
                    child: _isRejecting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.red,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            'Tolak',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.red,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.base100,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    onPressed: (_isApproving || _isRejecting) ? null : _handleSetujui,
                    child: _isApproving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            'Setujui',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColor.font80,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: AppColor.font100,
            ),
          ),
        ],
      ),
    );
  }
}
