// ----- FILE: lib/ui/screens/customer/customer_dashboard.dart -----
// Dashboard utama Customer — menampilkan data dari API:
// - Status member & poin dari DashboardProvider
// - Nama user dari AuthProvider
// - Artikel terbaru dari DashboardProvider
// Semua data dummy telah dihapus dan diganti dengan data real dari API.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend_ambilin/models/artikel.dart';
import 'package:frontend_ambilin/providers/auth_provider.dart';
import 'package:frontend_ambilin/providers/dashboard_provider.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';
import 'package:frontend_ambilin/utils/app_routes.dart';
import 'pesanan_pelanggan.dart';
import 'pelanggan_artikel_page.dart';
import 'pelanggan_profil_page.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({super.key});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch data dashboard customer dari API saat pertama kali masuk
    Future.microtask(() {
      context.read<DashboardProvider>().fetchCustomerDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashProvider = context.watch<DashboardProvider>();
    final bool isMember = dashProvider.isMember;

    Widget content;
    switch (_currentIndex) {
      case 1:
        content = const PesananPelangganPage();
        break;
      case 2:
        content = const PelangganArtikelPage();
        break;
      case 3:
        content = const PelangganProfilPage();
        break;
      default:
        content = _buildHomeContent(context);
        break;
    }

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: content,
      floatingActionButton: SizedBox(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          onPressed: () {
            if (isMember) {
              Navigator.pushNamed(context, AppRoutes.pemesanan);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Center(
                      child: Text(
                          'Silakan aktifkan langganan Anda terlebih dahulu')),
                  backgroundColor: AppColor.redAllert,
                ),
              );
            }
          },
          backgroundColor: isMember ? AppColor.base100 : AppColor.font60,
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.local_shipping,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        elevation: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(Icons.home, 'Beranda', 0),
            _buildNavItem(Icons.receipt_long, 'Pesanan', 1),
            const SizedBox(width: 48),
            _buildNavItem(Icons.description, 'Artikel', 2),
            _buildNavItem(Icons.person, 'Profil', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final dashProvider = context.watch<DashboardProvider>();

    final String userName = authProvider.user?.nama ?? 'User';
    final bool isMember = dashProvider.isMember;
    final String poinText = '${dashProvider.formattedPoin} poin';
    final String expiredText = dashProvider.formattedExpiredDate;
    final List<Artikel> articles = dashProvider.recentArticles;

    return SafeArea(
      child: dashProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColor.base100),
            )
          : RefreshIndicator(
              color: AppColor.base100,
              onRefresh: () => dashProvider.fetchCustomerDashboard(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // ============================================
                    // HEADER: Greeting
                    // ============================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo, $userName',
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColor.base100,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Selamat datang di aplikasi penjemputan sampah',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppColor.font80,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ============================================
                    // CARD: Member & Poin Info
                    // ============================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.pelangganRiwayatMembership);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColor.base100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColor.yellow,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.star_rounded,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isMember
                                              ? 'Member Customer+'
                                              : 'Member Customer',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          isMember
                                              ? 'Masa Berlaku hingga $expiredText'
                                              : 'Nikmati layanan premium dan diskon khusus',
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color:
                                                Colors.white.withOpacity(0.85),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Poin Anda',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color:
                                                Colors.white.withOpacity(0.9),
                                          ),
                                        ),
                                        Text(
                                          poinText,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, AppRoutes.subscription);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: AppColor.base100,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 8),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        'Beli',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ============================================
                    // BANNER: Info status membership
                    // ============================================
                    if (!isMember) ...[
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8E1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color:
                                    AppColor.yellowAllert.withOpacity(0.6)),
                          ),
                          child: Text(
                            'Silakan aktifkan langganan Anda untuk mulai melakukan pemesanan.',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: const Color(0xFFE65100),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),

                    // ============================================
                    // SECTION: Artikel Terbaru dari API
                    // ============================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Artikel',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColor.font100,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() => _currentIndex = 2);
                            },
                            child: Text(
                              'Lihat lebih banyak',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppColor.font80,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Error state
                    if (dashProvider.errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColor.redLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            dashProvider.errorMessage,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColor.redAllert,
                            ),
                          ),
                        ),
                      ),

                    // Artikel cards
                    if (articles.isNotEmpty)
                      ...articles.map((artikel) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 6),
                            child: _buildArtikelCard(artikel),
                          ))
                    else if (!dashProvider.isLoading &&
                        dashProvider.errorMessage.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: Text(
                            'Belum ada artikel terbaru.',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppColor.font80,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
    );
  }

  // ================================================================
  // WIDGET BUILDER: Artikel Card
  // ================================================================

  String _getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return 'https://ambilin.kodetalma.my.id/$cleanPath';
  }

  Widget _buildArtikelCard(Artikel artikel) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.detailArtikel,
          arguments: artikel,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.font60.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                height: 180,
                color: const Color(0xFFE0E0E0),
                child: Image.network(
                  _getImageUrl(artikel.fotoThumbnail),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 48,
                        color: AppColor.font80,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artikel.judul,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColor.font100,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    artikel.kategori.isNotEmpty ? artikel.kategori : 'Artikel',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
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

  // ================================================================
  // WIDGET BUILDER: Bottom Nav Item
  // ================================================================

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isActive = _currentIndex == index;
    final Color color = isActive ? AppColor.base100 : AppColor.font80;
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
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: color,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
