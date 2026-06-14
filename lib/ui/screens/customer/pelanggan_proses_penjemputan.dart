// ----- FILE: pelanggan_proses_penjemputan.dart -----
import 'package:flutter/material.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';
import '../../../models/setor_sampah.dart';
import '../../widgets/detail_card_wrapper.dart';

class PelangganProsesPenjemputanPage extends StatelessWidget {
  final SetorSampah data;
  const PelangganProsesPenjemputanPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Logika state berdasarkan parameter:
    // Jika 'menunggu', asumsikan belum ada driver.
    // Jika tidak 'menunggu' tapi belum 'selesai', asumsikan 'Proses Penjemputan'.
    final isMenunggu = data.status == 'menunggu';
    final statusText = isMenunggu ? 'Menunggu Kurir' : 'Proses Penjemputan';
    final driverName = isMenunggu ? '-' : data.petugasName;
    const beratText = '- kg'; // Berat selalu strip untuk status berjalan

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      appBar: AppBar(
        backgroundColor: AppColor.putihBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColor.font100),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Proses Penjemputan',
          style: AppFont.bold().copyWith(color: AppColor.base100, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Card 1: Rincian penjemputan
            DetailCardWrapper(
              title: 'Rincian penjemputan',
              child: Column(
                children: [
                  DetailDataRow(label: 'Nama', value: data.customerName),
                  DetailDataRow(label: 'Status', value: statusText),
                  DetailDataRow(label: 'Alamat', value: data.alamat ?? '-'),
                  const DetailDataRow(label: 'Waktu Pengajuan', value: '12 Mei 2026, 10:00'),
                  DetailDataRow(label: 'Driver', value: driverName),
                  DetailDataRow(label: 'Waktu Penjemputan', value: isMenunggu ? '-' : '12 Mei 2026, 15:00'),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Card 2: Catatan Pelanggan
            DetailCardWrapper(
              title: 'Catatan Pelanggan',
              child: Text(
                data.pesanCustomer.isNotEmpty ? data.pesanCustomer : 'sampah depan rumah yang ada mobil avanza hitam',
                style: AppFont.regular().copyWith(color: AppColor.font80, fontSize: 14),
              ),
            ),
            const SizedBox(height: 15),

            // Card 3: Rincian Sampah
            DetailCardWrapper(
              title: 'Rincian Sampah',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1611284446314-60a58ac0deb9?q=80&w=600&auto=format&fit=crop',
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: double.infinity,
                        height: 150,
                        color: AppColor.base20,
                        child: const Icon(Icons.image, size: 50, color: AppColor.font60),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('jenis sampah', style: AppFont.bold().copyWith(color: AppColor.font100, fontSize: 14)),
                          Text('botol', style: AppFont.regular().copyWith(color: AppColor.font80, fontSize: 14)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Berat Sampah', style: AppFont.bold().copyWith(color: AppColor.font100, fontSize: 14)),
                          Text(beratText, style: AppFont.regular().copyWith(color: AppColor.font80, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
