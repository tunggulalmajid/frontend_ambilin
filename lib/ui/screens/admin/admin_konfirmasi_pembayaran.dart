import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  void _handleSetujui() async {
    setState(() {
      _isApproving = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isApproving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('Pembayaran Berhasil Disetujui')),
          backgroundColor: AppColor.base100,
        ),
      );
      Navigator.pop(context);
    }
  }

  void _handleTolak() async {
    setState(() {
      _isRejecting = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isRejecting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('Pembayaran Telah Ditolak')),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          'T',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: const Color(0xFF1565C0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'Tunggul Nadzif',
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

                  _buildInfoRow('ID Transaksi', '1'),
                  const Divider(color: AppColor.font60),
                  _buildInfoRow('Paket Langganan', '1 Bulan'),
                  const Divider(color: AppColor.font60),
                  _buildInfoRow('Harga Total', 'Rp. 30.000'),
                  const Divider(color: AppColor.font60),
                  _buildInfoRow('Metode Pembayaran', 'BCA - 192920930'),
                  const Divider(color: AppColor.font60),
                  _buildInfoRow('Tanggal dan Waktu', '13 Juni 2026, 14:00'),
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
                      child: Image.network(
                        'https://images.unsplash.com/photo-1554415707-6e8cfc93fe23?w=800&auto=format&fit=crop',
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
