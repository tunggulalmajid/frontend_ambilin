import 'package:flutter/material.dart';
import 'package:frontend_ambilin/models/transaksi.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';
import 'package:frontend_ambilin/utils/app_routes.dart';
import 'package:frontend_ambilin/ui/widgets/w_button.dart';

class TransaksiBerhasilPage extends StatelessWidget {
  const TransaksiBerhasilPage({super.key});

  Future<void> _onSelesaiPressed(BuildContext context) async {
    try {
      await Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.main,
        (route) => false,
      );
    } catch (e) {
      debugPrint('Navigasi error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final int idTransaksi = args?['id_transaksi'] as int? ?? 1;
    final String metodePembayaran = args?['metode_pembayaran']?.toString() ?? 'BCA';
    final String namaPaket = args?['nama_paket']?.toString() ?? 'Gold Membership 30 Hari';
    final int harga = args?['harga'] as int? ?? 15000;

    final formattedHarga = 'Rp ${harga.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]}.")}';

    return Scaffold(
      backgroundColor: AppColor.base100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),

                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColor.putih100,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppColor.base100,
                    size: 56,
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'Terimakasih telah membeli\n$namaPaket',
                  textAlign: TextAlign.center,
                  style: AppFont.bold().copyWith(
                    fontSize: 20,
                    color: AppColor.putih100,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 32),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColor.putih100,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [

                      Text(
                        'Transaksi berhasil!',
                        style: AppFont.bold().copyWith(
                          fontSize: 16,
                          color: AppColor.base100,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: AppColor.font60),
                      const SizedBox(height: 16),

                      _buildDetailRow(
                        'ID Transaksi',
                        idTransaksi.toString(),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Metode Pembayaran',
                        metodePembayaran,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Harga',
                        formattedHarga,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'Silahkan tunggu konfirmasi pengajuan\nCustomer+ oleh admin',
                  textAlign: TextAlign.center,
                  style: AppFont.regular().copyWith(
                    fontSize: 13,
                    color: AppColor.putih100.withOpacity(0.85),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 32),

                WButton(
                  text: 'Selesai',
                  textSize: 16,
                  backgroundColor: AppColor.putih100,
                  textColor: AppColor.base100,
                  onPressed: () async {
                    await _onSelesaiPressed(context);
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppFont.regular().copyWith(
              fontSize: 13,
              color: AppColor.font80,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: AppFont.semibold().copyWith(
            fontSize: 13,
            color: AppColor.font100,
          ),
        ),
      ],
    );
  }
}
