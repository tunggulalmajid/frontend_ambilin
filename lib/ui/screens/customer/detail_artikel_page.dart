import 'package:flutter/material.dart';
import '../../../models/artikel.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';

class DetailArtikelPage extends StatelessWidget {
  final Artikel artikel;
  const DetailArtikelPage({super.key, required this.artikel});

  String _getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return 'https://ambilin.kodetalma.my.id/$cleanPath';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0,
            height: MediaQuery.of(context).size.height * 0.40,
            child: Image.network(
              _getImageUrl(artikel.fotoThumbnail),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColor.font100,
                child: const Center(child: Icon(Icons.image, size: 64, color: AppColor.font60)),
              ),
            ),
          ),

          Positioned(
            top: 0, left: 0, right: 0,
            height: MediaQuery.of(context).size.height * 0.40,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.45), Colors.transparent],
                ),
              ),
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.62, minChildSize: 0.55, maxChildSize: 0.92,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppColor.putih100,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40, height: 4,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(color: AppColor.font60, borderRadius: BorderRadius.circular(2)),
                        ),
                      ),
                      Text(artikel.judul, style: AppFont.bold().copyWith(fontSize: 22, color: AppColor.font100)),
                      const SizedBox(height: 8),
                      Text(artikel.kategori, style: AppFont.regular().copyWith(fontSize: 13, color: AppColor.font80)),
                      const SizedBox(height: 12),
                      const Divider(color: AppColor.font60),
                      const SizedBox(height: 12),
                      Text(
                        artikel.isi,
                        style: AppFont.regular().copyWith(fontSize: 15, color: AppColor.font100, height: 1.7),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            },
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 8, left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.35), shape: BoxShape.circle),
                child: const Icon(Icons.chevron_left, color: AppColor.putih100, size: 26),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
