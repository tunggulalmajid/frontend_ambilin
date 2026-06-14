import 'package:flutter/material.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';
import '../../../models/setor_sampah.dart';
import '../../widgets/loading_overlay.dart';
import 'pelanggan_proses_penjemputan.dart';
import 'pelanggan_selesai_penjemputan.dart';

class PesananPelangganPage extends StatefulWidget {
  const PesananPelangganPage({super.key});

  @override
  State<PesananPelangganPage> createState() => _PesananPelangganPageState();
}

class _PesananPelangganPageState extends State<PesananPelangganPage> {
  bool _isLoading = false;

  final List<SetorSampah> onGoingList = SetorSampah.getMockList().where((e) => e.status != 'selesai').toList();
  final List<SetorSampah> selesaiList = SetorSampah.getMockList().where((e) => e.status == 'selesai').toList();

  Future<void> _navigateToDetail(BuildContext context, SetorSampah data) async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isLoading = false;
    });

    if (!context.mounted) return;

    if (data.status == 'selesai') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PelangganSelesaiPenjemputanPage(data: data),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PelangganProsesPenjemputanPage(data: data),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      appBar: AppBar(
        backgroundColor: AppColor.putih100,
        elevation: 1,
        title: Text(
          'Aktivitas',
          style: AppFont.bold().copyWith(color: AppColor.base100, fontSize: 24),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('On Going', style: AppFont.bold().copyWith(fontSize: 18, color: AppColor.font100)),
                const SizedBox(height: 10),
                ...onGoingList.map((data) => _buildCard(data, isOnGoing: true)),

                const SizedBox(height: 20),
                Text('Selesai', style: AppFont.bold().copyWith(fontSize: 18, color: AppColor.font100)),
                const SizedBox(height: 10),
                ...selesaiList.map((data) => _buildCard(data, isOnGoing: false)),
              ],
            ),
          ),
          LoadingOverlay(isLoading: _isLoading),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: AppColor.base100,
        unselectedItemColor: AppColor.font80,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Pesanan'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Artikel'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        onTap: (index) {

        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColor.base100,
        child: const Icon(Icons.local_shipping, color: AppColor.putih100),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildCard(SetorSampah data, {required bool isOnGoing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColor.putih100,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '12 Mei, 15:22',
                style: AppFont.regular().copyWith(color: AppColor.font80, fontSize: 12),
              ),
              if (!isOnGoing)
                Text(
                  '+1.000 Poin',
                  style: AppFont.bold().copyWith(color: AppColor.base100, fontSize: 12),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey.shade200,
                  child: Image.network(
                    'https://images.unsplash.com/photo-1611284446314-60a58ac0deb9?q=80&w=200&auto=format&fit=crop',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.delete, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Alamat : ${data.alamat ?? "-"}', style: AppFont.regular().copyWith(fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                    Text('Berat : ${isOnGoing ? "-" : "5"} kg', style: AppFont.regular().copyWith(fontSize: 12)),
                    Text('Jenis Sampah : Plastik', style: AppFont.regular().copyWith(fontSize: 12)),
                    Text('Driver : ${data.status == 'menunggu' ? "-" : data.petugasName}', style: AppFont.regular().copyWith(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.base100,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                minimumSize: const Size(80, 35),
              ),
              onPressed: () => _navigateToDetail(context, data),
              child: Text('Lihat', style: AppFont.medium().copyWith(color: AppColor.putih100, fontSize: 12)),
            ),
          )
        ],
      ),
    );
  }
}
