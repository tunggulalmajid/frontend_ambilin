
import 'package:flutter/material.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';
import '../../../models/setor_sampah.dart';
import '../../widgets/detail_card_wrapper.dart';

class PelangganSelesaiPenjemputanPage extends StatelessWidget {
  final SetorSampah data;
  const PelangganSelesaiPenjemputanPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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

            DetailCardWrapper(
              title: 'Rincian penjemputan',
              child: Column(
                children: [
                  DetailDataRow(label: 'Nama', value: data.customerName),
                  const DetailDataRow(label: 'Status', value: 'Selesai'),
                  DetailDataRow(label: 'Alamat', value: data.alamat ?? '-'),
                  const DetailDataRow(label: 'Waktu Pengajuan', value: 'TIMESTAMP'),
                  DetailDataRow(label: 'Driver', value: data.petugasName),
                  const DetailDataRow(label: 'Waktu Penjemputan', value: 'TIMESTAMP'),
                ],
              ),
            ),
            const SizedBox(height: 15),

            DetailCardWrapper(
              title: 'Catatan Pelanggan',
              child: Text(
                data.pesanCustomer.isNotEmpty ? data.pesanCustomer : 'sampah depan rumah yang ada mobil avanza hitam',
                style: AppFont.regular().copyWith(color: AppColor.font80, fontSize: 14),
              ),
            ),
            const SizedBox(height: 15),

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
                          Text('5 kg', style: AppFont.regular().copyWith(color: AppColor.font80, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Poin', style: AppFont.bold().copyWith(color: AppColor.font100, fontSize: 14)),
                      Text('+1000 Poin', style: AppFont.bold().copyWith(color: AppColor.base100, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            DetailCardWrapper(
              title: 'Bukti Penjemputan',
              child: ClipRRect(
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
                    child: const Icon(Icons.receipt, size: 50, color: AppColor.font60),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
