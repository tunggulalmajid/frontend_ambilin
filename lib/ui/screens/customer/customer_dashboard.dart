import 'package:flutter/material.dart';
import 'package:frontend_ambilin/models/artikel.dart';
import 'package:frontend_ambilin/models/customer.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';
import 'package:frontend_ambilin/utils/app_routes.dart';
import 'package:frontend_ambilin/ui/widgets/home_header.dart';
import 'package:frontend_ambilin/ui/widgets/home_subscription_banner.dart';
import 'package:frontend_ambilin/ui/widgets/home_article_section.dart';
import 'package:frontend_ambilin/ui/screens/detail_artikel_page.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({super.key});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}


class _CustomerDashboardState extends State<CustomerDashboard> {
  int _currentIndex = 0;

  // ========== STATE MOCK CONTROL ==========
  // Ubah variabel ini secara manual untuk menguji 3 kondisi:
  // Kondisi 1: isMember = false, statusTransaksi = 'none'
  // Kondisi 2: isMember = false, statusTransaksi = 'pending'
  // Kondisi 3: isMember = true, statusTransaksi = 'success'
  bool isMember = false;
  String statusTransaksi = 'none'; // 'none', 'pending', 'success'

  // Dummy data customer untuk binding di Kondisi 3
  final Customer _customer = Customer.getDummyCustomer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),
              HomeSubscriptionBanner(
                isMember: isMember,
                statusTransaksi: statusTransaksi,
                customer: _customer,
                onLanggananTap: () async {
                  try {
                    await Navigator.pushNamed(
                        context, AppRoutes.subscription);
                  } catch (e) {
                    debugPrint('Navigasi subscription error: $e');
                  }
                },
                onTukarPoinTap: () async {
                  try {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Halaman Tukar Poin segera hadir!',
                          style: AppFont.regular().copyWith(
                            fontSize: 13,
                            color: AppColor.putih100,
                          ),
                        ),
                        backgroundColor: AppColor.base100,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  } catch (e) {
                    debugPrint('Tukar poin error: $e');
                  }
                },
              ),
              HomeArticleSection(
                articles: Artikel.getMockList(),
                onArticleTap: (article) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailArtikelPage(article: article),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  // ========== FAB KURIR DINAMIS ==========
  Widget _buildFAB() {
    return SizedBox(
      width: 56,
      height: 56,
      child: FloatingActionButton(
        onPressed: () async {
          try {
            if (isMember) {
              await Navigator.pushNamed(context, AppRoutes.pemesanan);
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Silakan aktifkan langganan Customer+ Anda terlebih dahulu untuk mulai melakukan pemesanan kurir!',
                    style: AppFont.regular().copyWith(
                      fontSize: 13,
                      color: AppColor.putih100,
                    ),
                  ),
                  backgroundColor: AppColor.font100,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          } catch (e) {
            debugPrint('FAB error: $e');
          }
        },
        backgroundColor: isMember ? AppColor.base100 : AppColor.font60,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.local_shipping,
          color: AppColor.putih100,
        ),
      ),
    );
  }

  // ========== BOTTOM APP BAR ==========
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
              style: AppFont.medium().copyWith(fontSize: 12, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
