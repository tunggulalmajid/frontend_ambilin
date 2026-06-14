import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/artikel.dart';
import '../../../providers/article_provider.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';
import '../../../utils/app_routes.dart';
import '../../widgets/loading_overlay.dart';

class PelangganArtikelPage extends StatefulWidget {
  const PelangganArtikelPage({super.key});

  @override
  State<PelangganArtikelPage> createState() => _PelangganArtikelPageState();
}

class _PelangganArtikelPageState extends State<PelangganArtikelPage> {
  String _kategoriAktif = 'Semua';
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<ArticleProvider>().fetchArticles();
      }
    });
  }

  Future<void> _bukaDetailArtikel(Artikel artikel) async {
    setState(() => _isNavigating = true);
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _isNavigating = false);

    if (!mounted) return;
    Navigator.pushNamed(context, AppRoutes.detailArtikel, arguments: artikel);
  }

  String _getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return 'https://ambilin.kodetalma.my.id/$cleanPath';
  }

  @override
  Widget build(BuildContext context) {
    final articleProvider = context.watch<ArticleProvider>();
    
    final List<String> daftarKategori = [
      'Semua',
      ...articleProvider.categories
          .map((c) => c['nama']?.toString() ?? '')
          .where((name) => name.isNotEmpty),
    ];

    final semuaArtikel = articleProvider.allArticles
        .where((a) => !a.isDelete)
        .toList();
    final artikelTampil = _kategoriAktif == 'Semua'
        ? semuaArtikel
        : semuaArtikel.where((a) => a.kategori == _kategoriAktif).toList();

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jelajahi Informasi Terbaru',
                        style: AppFont.bold().copyWith(
                          fontSize: 24,
                          color: AppColor.base100,
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

                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: daftarKategori.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final kategori = daftarKategori[index];
                      final isAktif = kategori == _kategoriAktif;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _kategoriAktif = kategori;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isAktif
                                ? AppColor.base100
                                : AppColor.putih100,
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

                Expanded(
                  child: articleProvider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.base100,
                          ),
                        )
                      : artikelTampil.isEmpty
                      ? Center(
                          child: Text(
                            'Belum ada artikel di kategori ini.',
                            style: AppFont.regular().copyWith(
                              color: AppColor.font80,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: artikelTampil.length,
                          itemBuilder: (context, index) {
                            final artikel = artikelTampil[index];
                            return _buildCardArtikel(artikel);
                          },
                        ),
                ),
              ],
            ),
          ),

          LoadingOverlay(isLoading: _isNavigating),
        ],
      ),
    );
  }

  Widget _buildCardArtikel(Artikel artikel) {
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
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                _getImageUrl(artikel.fotoThumbnail),
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: double.infinity,
                  height: 180,
                  color: AppColor.base20,
                  child: const Icon(
                    Icons.image,
                    size: 48,
                    color: AppColor.font60,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artikel.judul,
                    style: AppFont.bold().copyWith(
                      fontSize: 16,
                      color: AppColor.font100,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    artikel.kategori,
                    style: AppFont.regular().copyWith(
                      fontSize: 12,
                      color: AppColor.font80,
                    ),
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
