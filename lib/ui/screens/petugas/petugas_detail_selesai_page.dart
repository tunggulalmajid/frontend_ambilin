
import 'package:flutter/material.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';
import '../../widgets/detail_card_wrapper.dart';

class PetugasDetailSelesaiPage extends StatefulWidget {
  const PetugasDetailSelesaiPage({super.key});

  @override
  State<PetugasDetailSelesaiPage> createState() =>
      _PetugasDetailSelesaiPageState();
}

class _PetugasDetailSelesaiPageState extends State<PetugasDetailSelesaiPage> {
  final Map<String, String> _rincianData = {
    'Nama': 'Yanto',
    'Status': 'Mencari Kurir',
    'Alamat': 'Jl Semeru',
    'Waktu Pengajuan': 'TIMESTAMP',
    'Driver': 'Asep',
    'Waktu penjemputan': 'TIMESTAMP',
  };

  final String _catatanPelanggan =
      'sampah depan rumah yang ada mobil avanza hitam';
  final String _jenisSampah = 'botol';
  final String _beratSampah = '5 kg';
  final String _fotoSampahUrl =
      'https://images.unsplash.com/photo-1611284446314-60a58ac0deb9?q=80&w=600&auto=format&fit=crop';
  final String _fotoBuktiUrl =
      'https://images.unsplash.com/photo-1611284446314-60a58ac0deb9?q=80&w=600&auto=format&fit=crop';

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
        title: Text('Proses Penjemputan',
            style: AppFont.bold()
                .copyWith(fontSize: 18, color: AppColor.base100)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          children: [
            DetailCardWrapper(
              title: 'Rincian penjemputan',
              child: Column(
                children: _rincianData.entries
                    .map((e) => DetailDataRow(label: e.key, value: e.value))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            DetailCardWrapper(
              title: 'Catatan Pelanggan',
              child: Text(_catatanPelanggan,
                  style: AppFont.regular()
                      .copyWith(fontSize: 14, color: AppColor.font80)),
            ),
            const SizedBox(height: 16),
            DetailCardWrapper(
              title: 'Rincian Sampah',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(_fotoSampahUrl,
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                            width: double.infinity,
                            height: 150,
                            color: AppColor.base20,
                            child: const Icon(Icons.image,
                                size: 50, color: AppColor.font60))),
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
                          Text(_jenisSampah,
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
                          Text(_beratSampah,
                              style: AppFont.regular().copyWith(
                                  fontSize: 14, color: AppColor.font80)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            DetailCardWrapper(
              title: 'Bukti Penjemputan',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(_fotoBuktiUrl,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                        width: double.infinity,
                        height: 180,
                        color: AppColor.base20,
                        child: const Icon(Icons.image,
                            size: 50, color: AppColor.font60))),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
