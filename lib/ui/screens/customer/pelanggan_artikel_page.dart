// ----- FILE: pelanggan_artikel_page.dart -----
// Halaman Daftar Artikel untuk pelanggan (Customer).
// Menampilkan daftar artikel dengan filter kategori horizontal.

import 'package:flutter/material.dart';
import '../../../models/artikel.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';
import '../../widgets/loading_overlay.dart';
import 'detail_artikel_page.dart';

class PelangganArtikelPage extends StatefulWidget {
  const PelangganArtikelPage({super.key});

  @override
  State<PelangganArtikelPage> createState() => _PelangganArtikelPageState();
}

class _PelangganArtikelPageState extends State<PelangganArtikelPage> {
  // ---------- Data Dummy ----------
  late List<Artikel> _semuaArtikel;
  List<Artikel> _artikelTampil = [];
  String _kategoriAktif = 'Semua';
  bool _isNavigating = false;

  final List<String> _daftarKategori = [
    'Semua',
    'Tips',
    'Edukasi',
    'Berita',
  ];

  @override
  void initState() {
    super.initState();
    // Ambil data dummy dari model, hanya tampilkan yang aktif (isDelete == false)
    _semuaArtikel =
        Artikel.getMockList().where((a) => !a.isDelete).toList();
    _artikelTampil = List.from(_semuaArtikel);
  }

  // ---------- Filter Kategori ----------
  void _filterKategori(String kategori) {
    setState(() {
      _kategoriAktif = kategori;
      if (kategori == 'Semua') {
        _artikelTampil = List.from(_semuaArtikel);
      } else {
        _artikelTampil =
            _semuaArtikel.where((a) => a.kategori == kategori).toList();
      }
    });
  }

  // ---------- Navigasi Async ke Detail ----------
  Future<void> _bukaDetailArtikel(Artikel artikel) async {
    setState(() => _isNavigating = true);

    // Simulasi loading async sebelum navigasi
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() => _isNavigating = false);

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailArtikelPage(artikel: artikel),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ========== Header Judul ==========
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jelajahi Informasi Terbaru',
                        style: AppFont.bold().copyWith(
                          fontSize: 24,
                          color: AppColor.font100,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Edukasi dan tips seputar kelola sampah jadi cuan',
                        style: AppFont.regular().copyWith(
                          fontSize: 13,
                          color: AppColor.font80,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ========== Baris Kategori Filter ==========
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _daftarKategori.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final kategori = _daftarKategori[index];
                      final isAktif = kategori == _kategoriAktif;
                      return GestureDetector(
                        onTap: () => _filterKategori(kategori),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            color:
                                isAktif ? AppColor.base100 : AppColor.putih100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isAktif
                                  ? AppColor.base100
                                  : AppColor.font60,
                            ),
                          ),
                          child: Text(
                            kategori,
                            style: AppFont.medium().copyWith(
                              fontSize: 13,
                              color: isAktif
                                  ? AppColor.putih100
                                  : AppColor.font100,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // ========== Daftar Card Artikel ==========
                Expanded(
                  child: _artikelTampil.isEmpty
                      ? Center(
                          child: Text(
                            'Belum ada artikel di kategori ini.',
                            style: AppFont.regular()
                                .copyWith(color: AppColor.font80),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: _artikelTampil.length,
                          itemBuilder: (context, index) {
                            final artikel = _artikelTampil[index];
                            return _buildCardArtikel(artikel);
                          },
                        ),
                ),
              ],
            ),
          ),

          // Overlay loading saat navigasi
          LoadingOverlay(isLoading: _isNavigating),
        ],
      ),

      // ========== Bottom Navigation Bar ==========
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Menu "Artikel" aktif
        selectedItemColor: AppColor.base100,
        unselectedItemColor: AppColor.font80,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: 'Pesanan'),
          BottomNavigationBarItem(
              icon: Icon(Icons.article), label: 'Artikel'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        onTap: (index) {
          // Navigasi antar tab — stub
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

  // ---------- Widget Card Artikel ----------
  Widget _buildCardArtikel(Artikel artikel) {
    // Dummy jumlah views acak berdasarkan id
    final jumlahViews = (artikel.idArtikel * 37 + 15) % 200;

    return GestureDetector(
      onTap: () => _bukaDetailArtikel(artikel),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: AppColor.putih100,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Foto Artikel
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                artikel.fotoThumbnail ?? '',
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: double.infinity,
                  height: 180,
                  color: AppColor.base20,
                  child: const Icon(Icons.image,
                      size: 48, color: AppColor.font60),
                ),
              ),
            ),

            // Konten Teks
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artikel.judul,
                    style: AppFont.bold()
                        .copyWith(fontSize: 16, color: AppColor.font100),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tag Kategori
                      Text(
                        artikel.kategori,
                        style: AppFont.regular().copyWith(
                          fontSize: 12,
                          color: AppColor.font80,
                        ),
                      ),
                      // Indikator Views
                      Row(
                        children: [
                          const Icon(Icons.remove_red_eye_outlined,
                              size: 16, color: AppColor.base100),
                          const SizedBox(width: 4),
                          Text(
                            '$jumlahViews',
                            style: AppFont.medium().copyWith(
                              fontSize: 12,
                              color: AppColor.base100,
                            ),
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
    );
  }
}
