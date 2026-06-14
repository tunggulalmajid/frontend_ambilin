// ----- FILE: detail_artikel_page.dart -----
import 'package:flutter/material.dart';
import '../../../models/artikel.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';

class DetailArtikelPage extends StatelessWidget {
  final Artikel artikel;
  const DetailArtikelPage({super.key, required this.artikel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: Stack(
        children: [
          // Banner Gambar Full Atas
          Positioned(
            top: 0, left: 0, right: 0,
            height: MediaQuery.of(context).size.height * 0.40,
            child: Image.network(
              artikel.fotoThumbnail ?? '',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColor.font100,
                child: const Center(child: Icon(Icons.image, size: 64, color: AppColor.font60)),
              ),
            ),
          ),
          // Gradient overlay
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
          // Konten Artikel dari Bawah
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
                        _getIsiPanjang(),
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
          // Tombol Back Floating
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

  String _getIsiPanjang() {
    final isi = artikel.isi;
    if (isi.length > 200) return isi;
    return '$isi\n\nMeminimalkan produksi sampah harian sebenarnya bisa dimulai dari langkah-langkah kecil di dalam rumah. Langkah pertama yang paling efektif adalah selalu membawa tas belanja kain dan botol minum sendiri saat bepergian demi mengurangi plastik sekali pakai. Selanjutnya, Anda bisa beralih dari penggunaan tisu sekali pakai ke kain lap atau sapu tangan yang dapat dicuci ulang.\n\nUntuk sampah dapur, cobalah memisahkan sisa makanan organik untuk diolah menjadi pupuk kompos tanaman yang kaya nutrisi. Selain itu, belilah produk dalam kemasan besar atau curah (bulk) untuk mengurangi akumulasi limbah pembungkus plastik di tempat sampah. Terakhir, dukung gerakan sirkular dengan memanfaatkan kembali wadah bekas layak pakai atau menyalurkan barang tak terpakai ke bank sampah terdekat.\n\nDengan konsisten menerapkan kelima kebiasaan ini, kita tidak hanya menghemat pengeluaran tetapi juga berkontribusi nyata dalam menjaga kelestarian bumi.';
  }
}
