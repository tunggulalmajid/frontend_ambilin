import 'package:flutter/material.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';

class InstruksiPembayaranCard extends StatelessWidget {
  final String keterangan;
  const InstruksiPembayaranCard({super.key, required this.keterangan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.putih100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.font60),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Instruksi Pembayaran:',
            style: AppFont.bold().copyWith(
              fontSize: 15,
              color: AppColor.font100,
            ),
          ),
          const SizedBox(height: 12),
          _buildInstruksiItem(
            '1.',
            'Salin nomor rekening tujuan di bawah ini.',
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              keterangan.isNotEmpty ? keterangan : '8220341982 - BCA Yanto',
              style: AppFont.bold().copyWith(
                fontSize: 14,
                color: AppColor.base100,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildInstruksiItem(
            '2.',
            'Pastikan data yang dimasukkan sudah benar sebelum melanjutkan.',
          ),
          const SizedBox(height: 8),
          _buildInstruksiItem(
            '3.',
            'Buka aplikasi Mobile Banking atau pergi ke ATM terdekat.',
          ),
          const SizedBox(height: 8),
          _buildInstruksiItem(
            '4.',
            'Lakukan transfer dengan Nominal yang Tepat.',
          ),
          const SizedBox(height: 8),
          _buildInstruksiItem(
            '5.',
            'Simpan resi, lalu upload foto/tangkapan layar bukti transfer pada kolom yang disediakan.',
          ),
        ],
      ),
    );
  }

  Widget _buildInstruksiItem(String nomor, String teks) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          child: Text(
            nomor,
            style: AppFont.regular().copyWith(
              fontSize: 13,
              color: AppColor.font100,
            ),
          ),
        ),
        Expanded(
          child: Text(
            teks,
            style: AppFont.regular().copyWith(
              fontSize: 13,
              color: AppColor.font100,
            ),
          ),
        ),
      ],
    );
  }
}
