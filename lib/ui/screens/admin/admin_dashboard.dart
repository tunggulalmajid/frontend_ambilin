import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend_ambilin/providers/auth_provider.dart';
import 'package:frontend_ambilin/providers/dashboard_provider.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_routes.dart';
import 'package:frontend_ambilin/ui/widgets/navbar.dart';
import 'package:frontend_ambilin/ui/widgets/admin_stat_card.dart';
import 'package:frontend_ambilin/ui/widgets/admin_transaction_card.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<DashboardProvider>().fetchAdminDashboard();
    });
  }

  Future<void> _refreshData() async {
    await context.read<DashboardProvider>().fetchAdminDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final dashProvider = context.watch<DashboardProvider>();

    final String adminName = authProvider.user?.nama ?? 'Admin';
    final String totalPendapatanText = dashProvider.formatRupiah(dashProvider.totalPendapatan);
    final String totalPendingText = '${dashProvider.totalPendingVerifikasi} Pengguna';
    final double totalSampah = dashProvider.totalSampahTerkumpul;
    final String totalSampahText = totalSampah % 1 == 0
        ? '${totalSampah.toInt()} kg'
        : '${totalSampah.toStringAsFixed(1)} kg';
    final String totalArtikelText = '${dashProvider.totalArtikel} Artikel';
    final List<Map<String, dynamic>> transactions = dashProvider.recentTransactions
        .where((trx) {
          final status = (trx['status'] ?? 'pending').toString().toLowerCase();
          return status != 'berhasil' && status != 'gagal';
        })
        .toList();

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SafeArea(
        child: dashProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColor.base100),
              )
            : RefreshIndicator(
                color: AppColor.base100,
                onRefresh: _refreshData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Halo, $adminName',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.base100,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Selamat datang di Sistem Manajemen Ambilin',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppColor.font80,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.adminProfil,
                              );
                            },
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                color: AppColor.base100,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      AdminStatCard(
                        label: 'Total Pending Pelanggan',
                        value: totalPendingText,
                        icon: Icons.people_outline_rounded,
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.adminManajemenKonfirmasi);
                        },
                      ),
                      AdminStatCard(
                        label: 'Total Pendapatan',
                        value: totalPendapatanText,
                        icon: Icons.monetization_on_outlined,
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.adminManajemenSubscription);
                        },
                      ),
                      AdminStatCard(
                        label: 'Total Sampah Terkumpul',
                        value: totalSampahText,
                        icon: Icons.delete_outline_rounded,
                      ),
                      AdminStatCard(
                        label: 'Total Artikel',
                        value: totalArtikelText,
                        icon: Icons.article_outlined,
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.manajemenArtikel);
                        },
                      ),
                      const SizedBox(height: 24),

                      if (dashProvider.errorMessage.isNotEmpty)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 24),
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Transaksi Masuk',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColor.font100,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.adminManajemenKonfirmasi,
                              );
                            },
                            child: Text(
                              'Lihat Selengkapnya',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColor.base100,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      if (transactions.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: Text(
                              'Belum ada transaksi masuk.',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: AppColor.font80,
                              ),
                            ),
                          ),
                        )
                      else
                        ...transactions.map((trx) => AdminTransactionCard(trx: trx)),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: const AdminNavBar(currentIndex: 0),
    );
  }
}