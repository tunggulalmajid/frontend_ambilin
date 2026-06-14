import 'package:flutter/material.dart';
import 'package:frontend_ambilin/models/artikel.dart';
import 'package:frontend_ambilin/ui/widgets/app_cards.dart';
import 'package:frontend_ambilin/utils/app_font.dart';
import 'package:frontend_ambilin/utils/app_color.dart';

class HomeArticleSection extends StatelessWidget {
  final List<Artikel> articles;
  final VoidCallback? onLihatSemua;
  final void Function(Artikel article)? onArticleTap;

  const HomeArticleSection({
    super.key,
    required this.articles,
    this.onLihatSemua,
    this.onArticleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Artikel',
                style: AppFont.bold().copyWith(fontSize: 18),
              ),
              GestureDetector(
                onTap: onLihatSemua,
                child: Text(
                  'Lihat lebih banyak',
                  style: AppFont.regular().copyWith(
                    fontSize: 12,
                    color: AppColor.font80,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return ArticleCard(
                title: article.judul,
                category: article.kategori,
                onTap: () => onArticleTap?.call(article),
              );
            },
          ),
        ],
      ),
    );
  }
}
