import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_color.dart';
import '../../utils/app_routes.dart';

class AdminTransactionCard extends StatelessWidget {
  final Map<String, dynamic> trx;

  const AdminTransactionCard({super.key, required this.trx});

  @override
  Widget build(BuildContext context) {
    String timeText = '';
    if (trx['created_at'] != null) {
      final dt = DateTime.tryParse(trx['created_at'].toString());
      if (dt != null) {
        final months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'Mei',
          'Jun',
          'Jul',
          'Agu',
          'Sep',
          'Okt',
          'Nov',
          'Des',
        ];
        timeText =
            '${dt.day} ${months[dt.month - 1]} ${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      }
    }

    final String customerName =
        trx['nama_customer'] ??
        trx['customer_name'] ??
        trx['Customer']?['User']?['nama'] ??
        'Pelanggan';
    final String planName =
        trx['nama_paket'] ??
        trx['plan_name'] ??
        trx['Subscription']?['nama'] ??
        'Membership';

    final int packagePrice =
        trx['harga_paket'] as int? ?? trx['harga'] as int? ?? 0;
    final int poinDigunakan = trx['poin_digunakan'] as int? ?? 0;
    final int totalPaid = packagePrice - poinDigunakan;

    String formatHarga(int price) {
      return price.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
    }

    final String priceText = formatHarga(totalPaid);
    final String status = trx['status'] ?? 'pending';

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.adminDetailKonfirmasi,
          arguments: trx,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.font60.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timeText,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColor.font80,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: status == 'berhasil'
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: status == 'berhasil'
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFE65100),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Pelanggan: $customerName',
              style: GoogleFonts.poppins(fontSize: 13, color: AppColor.font80),
            ),
            const SizedBox(height: 2),
            Text(
              'Paket Langganan: $planName',
              style: GoogleFonts.poppins(fontSize: 11, color: AppColor.font80),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rp $priceText',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColor.base100,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.base100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Konfirmasi',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
}
