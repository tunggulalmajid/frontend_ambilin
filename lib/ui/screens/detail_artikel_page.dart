import 'package:flutter/material.dart';
import 'package:frontend_ambilin/models/artikel.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';

class DetailArtikelPage extends StatelessWidget {
  final Artikel article;

  const DetailArtikelPage({super.key, required this.article});

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
                    child: (article.fotoThumbnail != null && article.fotoThumbnail!.isNotEmpty)
                        ? Image.network(
                            article.fotoThumbnail!,
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
                  article.judul,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColor.putih100.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    article.kategori,
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
                child: Text(
                  article.isi,
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
