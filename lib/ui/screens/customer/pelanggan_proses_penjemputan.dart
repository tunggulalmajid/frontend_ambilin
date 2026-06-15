
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';
import '../../../models/setor_sampah.dart';
import '../../../models/jenis_sampah.dart';
import '../../../providers/waste_category_provider.dart';
import '../../widgets/detail_card_wrapper.dart';
import '../../widgets/zoomable_image_dialog.dart';

class PelangganProsesPenjemputanPage extends StatelessWidget {
  final SetorSampah data;
  const PelangganProsesPenjemputanPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isMenunggu = data.status == 'menunggu';
    final statusText = isMenunggu ? 'Menunggu Kurir' : 'Proses Penjemputan';
    final driverName = isMenunggu || data.petugasName.isEmpty ? '-' : data.petugasName;
    final beratText = data.beratSampah != null ? '${data.beratSampah} kg' : '- kg';

    final categoryProvider = context.watch<WasteCategoryProvider>();
    String categoryName = data.namaJenisSampah.isNotEmpty
        ? data.namaJenisSampah
        : (data.idJenisSampah != null
            ? categoryProvider.categories
                .firstWhere(
                  (c) => c.idJenisSampah == data.idJenisSampah,
                  orElse: () => JenisSampah(
                    idJenisSampah: data.idJenisSampah!,
                    nama: 'Jenis Sampah #${data.idJenisSampah}',
                    poinPerKg: 0,
                  ),
                )
                .nama
            : 'Organik');

    String formattedCreated = '-';
    if (data.createdAt != null) {
      final d = data.createdAt!;
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      formattedCreated = '${d.day} ${months[d.month - 1]} ${d.year}, ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    }

    String formattedPickup = '-';
    if (data.pickupAt != null) {
      final d = data.pickupAt!;
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      formattedPickup = '${d.day} ${months[d.month - 1]} ${d.year}, ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    }

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
                  DetailDataRow(label: 'Nama Pelanggan', value: data.customerName.isNotEmpty ? data.customerName : '-'),
                  DetailDataRow(label: 'Status', value: statusText),
                  DetailDataRow(label: 'Alamat', value: data.alamat ?? '-'),
                  DetailDataRow(label: 'Waktu Pengajuan', value: formattedCreated),
                  DetailDataRow(label: 'Driver', value: driverName),
                  DetailDataRow(label: 'Waktu Penjemputan', value: formattedPickup),
                ],
              ),
            ),
            const SizedBox(height: 15),

            DetailCardWrapper(
              title: 'Catatan Pelanggan',
              child: Text(
                data.pesanCustomer.isNotEmpty ? data.pesanCustomer : 'Tidak ada catatan tambahan.',
                style: AppFont.regular().copyWith(color: AppColor.font80, fontSize: 14),
              ),
            ),
            const SizedBox(height: 15),

            DetailCardWrapper(
              title: 'Rincian Sampah',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (data.foto != null && data.foto!.isNotEmpty)
                        ? () => ZoomableImageDialog.show(context, imageUrl: data.foto)
                        : null,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        data.foto ?? '',
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
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Jenis Sampah', style: AppFont.bold().copyWith(color: AppColor.font100, fontSize: 14)),
                          Text(categoryName, style: AppFont.regular().copyWith(color: AppColor.font80, fontSize: 14)),
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
