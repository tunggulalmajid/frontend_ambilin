

import 'package:flutter/material.dart';
import '../../../models/setor_sampah.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';
import '../../widgets/detail_card_wrapper.dart';
import '../../widgets/async_button.dart';
import 'petugas_lihat_map_page.dart';

class PetugasDetailTugasPage extends StatefulWidget {
  final SetorSampah data;
  const PetugasDetailTugasPage({super.key, required this.data});

  @override
  State<PetugasDetailTugasPage> createState() =>
      _PetugasDetailTugasPageState();
}

class _PetugasDetailTugasPageState extends State<PetugasDetailTugasPage> {
  bool _isLoading = false;

  Future<void> _ambilSampah() async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);

    if (!mounted) return;

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
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PetugasLihatMapPage(data: data),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          Image.network(
                            'https://tile.openstreetmap.org/14/13300/8547.png',
                            width: double.infinity,
                            height: 160,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: double.infinity,
                              height: 160,
                              color: AppColor.base20,
                              child: const Center(
                                child: Text('Map Preview'),
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: 40,
                            left: 30,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColor.yellowAllert,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.navigation,
                                color: AppColor.putih100,
                                size: 18,
                              ),
                            ),
                          ),

                          Positioned(
                            top: 30,
                            right: 60,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColor.base100,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: AppColor.putih100,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '0.5 km dari lokasi anda',
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
                    label: 'Nama',
                    value: data.customerName.isNotEmpty
                        ? data.customerName
                        : 'Yanto',
                  ),
                  const DetailDataRow(label: 'Status', value: 'Mencari Kurir'),
                  DetailDataRow(label: 'Alamat', value: data.alamat ?? 'Jl Semeru'),
                  const DetailDataRow(label: 'Waktu Pengajuan', value: 'TIMESTAMP'),
                  const DetailDataRow(label: 'Driver', value: '-'),
                  const DetailDataRow(label: 'Waktu Penjemputan', value: '-'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            DetailCardWrapper(
              title: 'Catatan Pelanggan',
              child: Text(
                data.pesanCustomer.isNotEmpty
                    ? data.pesanCustomer
                    : 'sampah depan rumah yang ada mobil avanza hitam',
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1611284446314-60a58ac0deb9?q=80&w=600&auto=format&fit=crop',
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: double.infinity,
                        height: 150,
                        color: AppColor.base20,
                        child: const Icon(Icons.image,
                            size: 50, color: AppColor.font60),
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
                          Text('jenis sampah',
                              style: AppFont.bold().copyWith(
                                  fontSize: 14, color: AppColor.font100)),
                          Text('botol',
                              style: AppFont.regular().copyWith(
                                  fontSize: 14, color: AppColor.font80)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Berat Sampah',
                              style: AppFont.bold().copyWith(
                                  fontSize: 14, color: AppColor.font100)),
                          Text('- kg',
                              style: AppFont.regular().copyWith(
                                  fontSize: 14, color: AppColor.font80)),
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

      bottomSheet: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: const BoxDecoration(
          color: AppColor.putihBackground,
        ),
        child: AsyncButton(
          text: 'Ambil Sampah',
          isLoading: _isLoading,
          onPressed: _ambilSampah,
        ),
      ),
    );
  }
}
