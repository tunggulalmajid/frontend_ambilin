import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/artikel.dart';
import '../../../providers/article_provider.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';
import 'dart:developer' as dev;

class DetailArtikelPage extends StatefulWidget {
  final Artikel artikel;
  const DetailArtikelPage({super.key, required this.artikel});

  @override
  State<DetailArtikelPage> createState() => _DetailArtikelPageState();
}

class _DetailArtikelPageState extends State<DetailArtikelPage> {
  late Artikel _currentArticle;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentArticle = widget.artikel;
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final detail = await context
          .read<ArticleProvider>()
          .fetchArticleById(_currentArticle.idArtikel);
      if (detail != null && mounted) {
        setState(() {
          _currentArticle = detail;
        });
      }
    } catch (e) {
      dev.log("Error fetching article detail: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
              _getImageUrl(_currentArticle.fotoThumbnail),
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
                      Text(_currentArticle.judul, style: AppFont.bold().copyWith(fontSize: 22, color: AppColor.font100)),
                      const SizedBox(height: 8),
                      Text(_currentArticle.kategori, style: AppFont.regular().copyWith(fontSize: 13, color: AppColor.font80)),
                      const SizedBox(height: 12),
                      const Divider(color: AppColor.font60),
                      const SizedBox(height: 12),
                      _isLoading && _currentArticle.isi.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: CircularProgressIndicator(color: AppColor.base100),
                              ),
                            )
                          : Text(
                              _currentArticle.isi,
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
