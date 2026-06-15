// ----- FILE: lib/ui/screens/petugas/petugas_detail_tugas_page.dart -----
// Halaman Detail Tugas Petugas — menampilkan detail dari API:
// - Menggunakan data SetorSampah yang dilewatkan sebagai argument.
// - Menghubungkan tombol aksi ke API process/complete via PickupHistoryProvider.
// - Menghapus mock data text.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../models/setor_sampah.dart';
import '../../../models/jenis_sampah.dart';
import '../../../providers/pickup_history_provider.dart';
import '../../../providers/waste_category_provider.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';
import '../../../utils/app_routes.dart';
import '../../widgets/detail_card_wrapper.dart';
import '../../widgets/async_button.dart';
import '../../widgets/zoomable_image_dialog.dart';

class PetugasDetailTugasPage extends StatefulWidget {
  final SetorSampah data;
  const PetugasDetailTugasPage({super.key, required this.data});

  @override
  State<PetugasDetailTugasPage> createState() => _PetugasDetailTugasPageState();
}

class _PetugasDetailTugasPageState extends State<PetugasDetailTugasPage> {
  bool _isLoading = false;

  Future<void> _ambilSampah() async {
    setState(() => _isLoading = true);

    final success = await context
        .read<PickupHistoryProvider>()
        .processPickup(widget.data.idSetorSampah);

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Berhasil mengambil tugas penjemputan!',
            style: AppFont.medium().copyWith(color: AppColor.putih100),
          ),
          backgroundColor: AppColor.base100,
          behavior: SnackBarBehavior.floating,
        ),
      );
      // Refresh list order aktif dan riwayat
      context.read<PickupHistoryProvider>().fetchActiveOrders();
      context.read<PickupHistoryProvider>().fetchPickupHistory(roleId: 2);

      // Arahkan langsung ke halaman proses penjemputan
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.petugasProsesPenjemputan,
        arguments: widget.data,
      );
    } else {
      final error = context.read<PickupHistoryProvider>().errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.isNotEmpty ? error : 'Gagal mengambil tugas penjemputan.',
            style: AppFont.medium().copyWith(color: AppColor.putih100),
          ),
          backgroundColor: AppColor.redAllert,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _navigasiKeProses() {
    Navigator.pushNamed(
      context,
      AppRoutes.petugasProsesPenjemputan,
      arguments: widget.data,
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final categoryProvider = context.watch<WasteCategoryProvider>();
    final double lat = data.latitude ?? -8.1724;
    final double lng = data.longitude ?? 113.7005;

    String getJenisSampahName(int? id) {
      if (id == null) return data.namaJenisSampah.isNotEmpty ? data.namaJenisSampah : '-';
      final cat = categoryProvider.categories.firstWhere(
        (element) => element.idJenisSampah == id,
        orElse: () => JenisSampah(
          idJenisSampah: id,
          nama: data.namaJenisSampah.isNotEmpty ? data.namaJenisSampah : 'Jenis Sampah #$id',
          poinPerKg: data.poinPerKg ?? 0,
        ),
      );
      return cat.nama;
    }

    String tanggalText = '-';
    if (data.createdAt != null) {
      final d = data.createdAt!;
      final months = [
        'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
      ];
      tanggalText = '${d.day} ${months[d.month - 1]} ${d.year}, ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    }

    // Tentukan status teks yang ramah pengguna
    String statusTeks = 'Mencari Kurir';
    if (data.status == 'proses') {
      statusTeks = 'Sedang Dijemput';
    } else if (data.status == 'selesai') {
      statusTeks = 'Selesai';
    } else if (data.status == 'dibatalkan') {
      statusTeks = 'Dibatalkan';
    }

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      appBar: AppBar(
        backgroundColor: AppColor.putihBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.font100),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detail Tugas',
          style: AppFont.bold().copyWith(
            fontSize: 18,
            color: AppColor.base100,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
        child: Column(
          children: [
            DetailCardWrapper(
              title: 'Rute',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.petugasLihatMap,
                        arguments: data,
                      );
                    },
                    child: SizedBox(
                      height: 160,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(lat, lng),
                            initialZoom: 14.0,
                            interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                              additionalOptions: const {
                                'User-Agent':
                                    'SeladakuApp_ByTunggulAbdulMajid_ClassOf2024_UNEJ',
                              },
                              userAgentPackageName: 'com.tunggul.seladaku',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(lat, lng),
                                  width: 40,
                                  height: 40,
                                  child: const Icon(
                                    Icons.location_on,
                                    color: AppColor.redAllert,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Lihat rute lokasi penjemputan di peta',
                    style: AppFont.regular().copyWith(
                      fontSize: 12,
                      color: AppColor.font80,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            DetailCardWrapper(
              title: 'Rincian penjemputan',
              child: Column(
                children: [
                  DetailDataRow(
                    label: 'Nama Pelanggan',
                    value: data.customerName.isNotEmpty ? data.customerName : '-',
                  ),
                  DetailDataRow(
                    label: 'Status',
                    value: statusTeks,
                  ),
                  DetailDataRow(
                    label: 'Alamat',
                    value: data.alamat ?? '-',
                  ),
                  DetailDataRow(
                    label: 'Waktu Pengajuan',
                    value: tanggalText,
                  ),
                  DetailDataRow(
                    label: 'Petugas',
                    value: data.petugasName.isNotEmpty ? data.petugasName : '-',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            DetailCardWrapper(
              title: 'Catatan Pelanggan',
              child: Text(
                data.pesanCustomer.isNotEmpty
                    ? data.pesanCustomer
                    : 'Tidak ada catatan tambahan.',
                style: AppFont.regular().copyWith(
                  fontSize: 14,
                  color: AppColor.font80,
                ),
              ),
            ),
            const SizedBox(height: 16),

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
                        errorBuilder: (_, __, ___) => Container(
                          width: double.infinity,
                          height: 150,
                          color: AppColor.base20,
                          child: const Icon(Icons.image, size: 50, color: AppColor.font60),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jenis Sampah',
                            style: AppFont.bold().copyWith(fontSize: 14, color: AppColor.font100),
                          ),
                          Text(
                            getJenisSampahName(data.idJenisSampah),
                            style: AppFont.regular().copyWith(fontSize: 14, color: AppColor.font80),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Berat Sampah',
                            style: AppFont.bold().copyWith(fontSize: 14, color: AppColor.font100),
                          ),
                          Text(
                            data.beratSampah != null ? '${data.beratSampah} kg' : '- kg',
                            style: AppFont.regular().copyWith(fontSize: 14, color: AppColor.font80),
                          ),
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
      bottomSheet: (data.status != 'selesai' && data.status != 'dibatalkan')
          ? Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: AppColor.putihBackground,
              ),
              child: AsyncButton(
                text: data.status == 'proses' ? 'Selesaikan Penjemputan' : 'Ambil Sampah',
                isLoading: _isLoading,
                onPressed: data.status == 'proses' ? _navigasiKeProses : _ambilSampah,
              ),
            )
          : null,
    );
  }
}
