import 'package:flutter/material.dart';
import 'package:frontend_ambilin/models/article.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';
import 'package:frontend_ambilin/utils/app_routes.dart';
import 'package:frontend_ambilin/ui/widgets/article_card.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({super.key});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}
class _CustomerDashboardState extends State<CustomerDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSubscriptionBanner(),
              _buildArticleSection(),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.pemesanan),
          backgroundColor: AppColor.base100,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.local_shipping,
            color: AppColor.putih100,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Halo, User',
            style: AppFont.bold().copyWith(
              fontSize: 24,
              color: AppColor.font100,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Halo, User',
            style: AppFont.medium().copyWith(
              fontSize: 14,
              color: AppColor.font80,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSubscriptionBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.base100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Berlangganan Customer+',
                    style: AppFont.bold().copyWith(
                      fontSize: 16,
                      color: AppColor.putih100,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Nikmati layanan premium dan diskon khusus',
                    style: AppFont.regular().copyWith(
                      fontSize: 12,
                      color: AppColor.putih100,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.subscription),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.putih100,
                foregroundColor: AppColor.base100,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: Text(
                'Langganan',
                style: AppFont.semibold().copyWith(
                  fontSize: 12,
                  color: AppColor.base100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildArticleSection() {
    final articles = Article.getArticles();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Artikel',
            style: AppFont.bold().copyWith(fontSize: 18),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return ArticleCard(
                title: article.title,
                category: article.category,
                onTap: () {
                },
              );
            },
          ),
        ],
      ),
    );
  }
  Widget _buildBottomAppBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: AppColor.putih100,
      elevation: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(Icons.home, 'Beranda', 0),
          _buildNavItem(Icons.receipt_long, 'Pesanan', 1),
          const SizedBox(width: 48),
          _buildNavItem(Icons.swap_horiz, 'Tukar', 2),
          _buildNavItem(Icons.person, 'Profil', 3),
        ],
      ),
    );
  }
  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isActive = _currentIndex == index;
    final Color color = isActive ? AppColor.base100 : AppColor.font60;
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppFont.medium().copyWith(
                fontSize: 12,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
