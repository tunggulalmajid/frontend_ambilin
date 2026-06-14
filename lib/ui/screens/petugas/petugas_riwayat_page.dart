

import 'package:flutter/material.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/navbar.dart';
import 'petugas_proses_penjemputan_page.dart';
import 'petugas_detail_selesai_page.dart';

class PetugasRiwayatPage extends StatefulWidget {
  const PetugasRiwayatPage({super.key});

  @override
  State<PetugasRiwayatPage> createState() => _PetugasRiwayatPageState();
}

class _PetugasRiwayatPageState extends State<PetugasRiwayatPage> {

  late List<Map<String, dynamic>> _dataSedangProses;
  late List<Map<String, dynamic>> _dataSelesai;

  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();

    _dataSedangProses = [
      {
        'tanggal': '12 Mei, 15:22',
        'pelanggan': 'Rafi',
        'alamat': 'Jl Semeru',
        'jenisSampah': 'Plastik',
        'fotoUrl':
            'https://images.unsplash.com/photo-1611284446314-60a58ac0deb9?q=80&w=200&auto=format&fit=crop',
      },
    ];

    _dataSelesai = [
      {
        'tanggal': '12 Mei, 15:22',
        'pelanggan': 'Rafi',
        'alamat': 'Jl Semeru',
        'jenisSampah': 'Plastik',
        'berat': '1 kg',
        'fotoUrl':
            'https://images.unsplash.com/photo-1611284446314-60a58ac0deb9?q=80&w=200&auto=format&fit=crop',
      },
      {
        'tanggal': '12 Mei, 15:22',
        'pelanggan': 'Rafi',
        'alamat': 'Jl Semeru',
        'jenisSampah': 'Plastik',
        'berat': '1 kg',
        'fotoUrl':
            'https://images.unsplash.com/photo-1611284446314-60a58ac0deb9?q=80&w=200&auto=format&fit=crop',
      },
    ];
  }

  Future<void> _navigasiKeProses(Map<String, dynamic> data) async {
    setState(() => _isNavigating = true);

    await Future.delayed(const Duration(milliseconds: 800));

    setState(() => _isNavigating = false);

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PetugasProsesPenjemputanPage(),
      ),
    );
  }

  Future<void> _navigasiKeSelesai(Map<String, dynamic> data) async {
    setState(() => _isNavigating = true);

    await Future.delayed(const Duration(milliseconds: 800));

    setState(() => _isNavigating = false);

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PetugasDetailSelesaiPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    'Aktivitas Pesanan',
                    style: AppFont.bold().copyWith(
                      fontSize: 24,
                      color: AppColor.base100,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Sedang Proses',
                    style: AppFont.bold().copyWith(
                      fontSize: 16,
                      color: AppColor.font100,
                    ),
                  ),
                  const Divider(color: AppColor.font60),
                  const SizedBox(height: 8),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _dataSedangProses.length,
                    itemBuilder: (context, index) {
                      return _buildCardRiwayat(
                        data: _dataSedangProses[index],
                        isSelesai: false,
                        onTapLihat: () =>
                            _navigasiKeProses(_dataSedangProses[index]),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Selesai',
                    style: AppFont.bold().copyWith(
                      fontSize: 16,
                      color: AppColor.font100,
                    ),
                  ),
                  const Divider(color: AppColor.font60),
                  const SizedBox(height: 8),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _dataSelesai.length,
                    itemBuilder: (context, index) {
                      return _buildCardRiwayat(
                        data: _dataSelesai[index],
                        isSelesai: true,
                        onTapLihat: () =>
                            _navigasiKeSelesai(_dataSelesai[index]),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          LoadingOverlay(isLoading: _isNavigating),
        ],
      ),

      bottomNavigationBar: const PetugasNavBar(currentIndex: 1),
    );
  }

  Widget _buildCardRiwayat({
    required Map<String, dynamic> data,
    required bool isSelesai,
    required VoidCallback onTapLihat,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.putih100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.font60),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            data['tanggal'] ?? '',
            style: AppFont.regular().copyWith(
              fontSize: 12,
              color: AppColor.font80,
            ),
          ),
          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  data['fotoUrl'] ?? '',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    color: AppColor.base20,
                    child: const Icon(Icons.image,
                        size: 30, color: AppColor.font80),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pelanggan: ${data['pelanggan'] ?? '-'}',
                      style: AppFont.medium().copyWith(
                        fontSize: 13,
                        color: AppColor.font100,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Alamat : ${data['alamat'] ?? '-'}',
                      style: AppFont.regular().copyWith(
                        fontSize: 12,
                        color: AppColor.font100,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Jenis Sampah : ${data['jenisSampah'] ?? '-'}',
                      style: AppFont.regular().copyWith(
                        fontSize: 12,
                        color: AppColor.font100,
                      ),
                    ),

                    if (isSelesai) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Berat : ${data['berat'] ?? '-'}',
                        style: AppFont.regular().copyWith(
                          fontSize: 12,
                          color: AppColor.font100,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.base100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onPressed: onTapLihat,
              child: Text(
                'Lihat',
                style: AppFont.semibold().copyWith(
                  fontSize: 13,
                  color: AppColor.putih100,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
