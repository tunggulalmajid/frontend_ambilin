import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_ambilin/models/artikel.dart';
import 'package:frontend_ambilin/providers/article_provider.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';
import 'dart:developer' as dev;

class DetailArtikelPage extends StatefulWidget {
  final Artikel article;

  const DetailArtikelPage({super.key, required this.article});

  @override
  State<DetailArtikelPage> createState() => _DetailArtikelPageState();
}

class _DetailArtikelPageState extends State<DetailArtikelPage> {
  late Artikel _currentArticle;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentArticle = widget.article;
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final detail = await context.read<ArticleProvider>().fetchArticleById(
        _currentArticle.idArtikel,
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.font100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.chevron_left,
                        size: 35,
                        color: AppColor.putih100,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Detail Artikel',
                      style: AppFont.bold().copyWith(
                        fontSize: 22,
                        color: AppColor.putih100,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    color: const Color(0xFF616161),
                    child:
                        (_currentArticle.fotoThumbnail != null &&
                            _currentArticle.fotoThumbnail!.isNotEmpty)
                        ? Image.network(
                            _currentArticle.fotoThumbnail!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.image,
                                  color: AppColor.font80,
                                  size: 48,
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Icon(
                              Icons.image,
                              color: AppColor.font80,
                              size: 48,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _currentArticle.judul,
                  style: AppFont.bold().copyWith(
                    fontSize: 20,
                    color: AppColor.putih100,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.putih100.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _currentArticle.kategori,
                    style: AppFont.medium().copyWith(
                      fontSize: 12,
                      color: AppColor.putih100.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _isLoading && _currentArticle.isi.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.base100,
                        ),
                      )
                    : Text(
                        _currentArticle.isi,
                        textAlign: TextAlign.justify,
                        style: AppFont.regular().copyWith(
                          fontSize: 14,
                          color: AppColor.putih100.withOpacity(0.9),
                          height: 1.6,
                        ),
                      ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
