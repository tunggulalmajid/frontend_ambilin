

import 'package:flutter/material.dart';
import '../../../models/setor_sampah.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';
import '../../../utils/app_routes.dart';
import '../../widgets/navbar.dart';

class PetugasDashboard extends StatefulWidget {
  const PetugasDashboard({super.key});

  @override
  State<PetugasDashboard> createState() => _PetugasDashboardState();
}

class _PetugasDashboardState extends State<PetugasDashboard> {

  late List<SetorSampah> _daftarTugas;
  bool _isNavigating = false;

  final int _totalTugasSelesai = 5;
  final double _totalSampahDiangkut = 2.5;

  @override
  void initState() {
    super.initState();

    _daftarTugas = [
      SetorSampah(
        idSetorSampah: 10,
        idPetugas: 0,
        idCustomer: 1,
        status: 'menunggu',
        alamat: 'Jl Semeru',
        latitude: -8.1845,
        longitude: 113.6681,
        createdAt: DateTime(2026, 5, 12, 15, 22),
        pesanCustomer: 'sampah depan rumah yang ada mobil avanza hitam',
        customerName: 'Rafi',
      ),
      SetorSampah(
        idSetorSampah: 11,
        idPetugas: 0,
        idCustomer: 2,
        status: 'menunggu',
        alamat: 'Jl Semeru',
        latitude: -8.1750,
        longitude: 113.7020,
        createdAt: DateTime(2026, 5, 12, 15, 22),
        pesanCustomer: 'Taruh di depan pagar',
        customerName: 'Rafi',
      ),
      SetorSampah(
        idSetorSampah: 12,
        idPetugas: 0,
        idCustomer: 3,
        status: 'menunggu',
        alamat: 'Jl Semeru',
        latitude: -8.1900,
        longitude: 113.6900,
        createdAt: DateTime(2026, 5, 12, 15, 22),
        pesanCustomer: 'Di samping toko kelontong',
        customerName: 'Rafi',
      ),
    ];
  }

  Future<void> _lihatDetail(SetorSampah tugas) async {
    setState(() => _isNavigating = true);

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() => _isNavigating = false);

    if (!mounted) return;
    Navigator.pushNamed(
      context,
      AppRoutes.petugasDetailTugas,
      arguments: tugas,
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
                    'Halo, Driver',
                    style: AppFont.bold().copyWith(
                      fontSize: 28,
                      color: AppColor.base100,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Selamat datang di aplikasi penjemputan sampah',
                    style: AppFont.regular().copyWith(
                      fontSize: 13,
                      color: AppColor.font80,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [

                      Expanded(
                        child: _buildPerformaCard(
                          icon: Icons.lock_rounded,
                          label: 'Total Tugas Selesai',
                          value: '$_totalTugasSelesai',
                          satuan: 'Tugas',
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: _buildPerformaCard(
                          icon: Icons.lock_rounded,
                          label: 'Total Sampah Diangkut',
                          value: '$_totalSampahDiangkut',
                          satuan: 'kg',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Daftar Ambil Sampah',
                    style: AppFont.bold().copyWith(
                      fontSize: 18,
                      color: AppColor.font100,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _daftarTugas.length,
                    itemBuilder: (context, index) {
                      return _buildCardTugas(_daftarTugas[index]);
                    },
                  ),
                ],
              ),
            ),
          ),

          if (_isNavigating)
            Container(
              color: Colors.black.withOpacity(0.2),
              child: const Center(
                child: CircularProgressIndicator(color: AppColor.base100),
              ),
            ),
        ],
      ),

      bottomNavigationBar: const PetugasNavBar(currentIndex: 0),
    );
  }

  Widget _buildPerformaCard({
    required IconData icon,
    required String label,
    required String value,
    required String satuan,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.base100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColor.putih100, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: AppFont.medium().copyWith(
                    fontSize: 11,
                    color: AppColor.putih100,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: AppFont.bold().copyWith(
                    fontSize: 32,
                    color: AppColor.putih100,
                  ),
                ),
                TextSpan(
                  text: ' $satuan',
                  style: AppFont.regular().copyWith(
                    fontSize: 14,
                    color: AppColor.putih100,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardTugas(SetorSampah tugas) {
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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '12 Mei, 15:22',
                style: AppFont.regular().copyWith(
                  fontSize: 12,
                  color: AppColor.font80,
                ),
              ),
              Text(
                '0.5 km',
                style: AppFont.bold().copyWith(
                  fontSize: 12,
                  color: AppColor.base100,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'https://images.unsplash.com/photo-1611284446314-60a58ac0deb9?q=80&w=200&auto=format&fit=crop',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    color: AppColor.base20,
                    child: const Icon(Icons.delete, color: AppColor.font80),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pelanggan: ${tugas.customerName}',
                      style: AppFont.medium().copyWith(fontSize: 13, color: AppColor.font100),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Alamat : ${tugas.alamat ?? '-'}',
                      style: AppFont.regular().copyWith(fontSize: 12, color: AppColor.font100),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Jenis Sampah : Plastik',
                      style: AppFont.regular().copyWith(fontSize: 12, color: AppColor.font100),
                    ),
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
              onPressed: () => _lihatDetail(tugas),
              child: Text(
                'Lihat Detail',
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
