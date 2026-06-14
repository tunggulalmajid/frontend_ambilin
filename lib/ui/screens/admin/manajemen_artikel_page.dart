import 'package:flutter/material.dart';
import 'package:frontend_ambilin/models/artikel.dart';
import 'package:frontend_ambilin/providers/article_provider.dart';
import 'package:frontend_ambilin/ui/screens/admin/edit_artikel_page.dart';
import 'package:frontend_ambilin/ui/screens/admin/tambah_artikel_page.dart';
import 'package:frontend_ambilin/ui/screens/detail_artikel_page.dart';
import 'package:frontend_ambilin/ui/widgets/app_cards.dart';
import 'package:frontend_ambilin/ui/widgets/navbar.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';
import 'package:provider/provider.dart';

class ManajemenArtikelPage extends StatefulWidget {
  const ManajemenArtikelPage({super.key});

  @override
  State<ManajemenArtikelPage> createState() => _ManajemenArtikelPageState();
}

class _ManajemenArtikelPageState extends State<ManajemenArtikelPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ArticleProvider>().fetchArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final articleProvider = context.watch<ArticleProvider>();
    final articles = articleProvider.allArticles;

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColor.base100,
          onRefresh: () => context.read<ArticleProvider>().fetchArticles(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Manajemen Artikel',
                  style: AppFont.bold().copyWith(
                    fontSize: 24,
                    color: AppColor.base100,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kelola artikel aplikasi Ambilin',
                  style: AppFont.regular().copyWith(
                    fontSize: 13,
                    color: AppColor.font80,
                  ),
                ),
                const SizedBox(height: 16),

                if (articleProvider.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: CircularProgressIndicator(
                        color: AppColor.base100,
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailArtikelPage(
                                article: articles[index],
                              ),
                            ),
                          );
                        },
                        child: ArticleManagementCard(
                          article: articles[index],
                          onMenuTap: () {
                            _showArticleMenu(context, articles[index], index);
                          },
                        ),
                      );
                    },
                  ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TambahArtikelPage(),
            ),
          );
        },
        backgroundColor: AppColor.base100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.add,
          color: AppColor.putih100,
          size: 30,
        ),
      ),
      bottomNavigationBar: const AdminNavBar(currentIndex: 2),
    );
  }

  void _showArticleMenu(BuildContext context, Artikel article, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                 ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: Text(
                    'Edit Artikel',
                    style: AppFont.medium().copyWith(fontSize: 14),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditArtikelPage(
                          article: article,
                          articleIndex: index,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFD32F2F),
                  ),
                  title: Text(
                    'Hapus Artikel',
                    style: AppFont.medium().copyWith(
                      fontSize: 14,
                      color: const Color(0xFFD32F2F),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<ArticleProvider>().deleteArticle(index);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
