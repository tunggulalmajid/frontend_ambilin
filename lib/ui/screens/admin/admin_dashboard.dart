import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';
import 'package:frontend_ambilin/utils/app_routes.dart';
import 'package:frontend_ambilin/ui/widgets/navbar.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();
    // Fetch data dari provider saat pertama kali masuk
    Future.microtask(() {
      context.read<PickupHistoryProvider>().fetchPickupHistory(roleId: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SafeArea(
        child: SingleChildScrollView(
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
                        'Halo, Admin',
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

              _buildStatCard(
                label: 'Total Pending Pelanggan',
                value: '5 users',
              ),
              _buildStatCard(
                label: 'Total Pendapatan',
                value: 'Rp. 12,5 juta',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.subscription);
                },
              ),
              _buildStatCard(
                label: 'Total Sampah Terkumpul',
                value: '2,847 kg',
              ),
              _buildStatCard(
                label: 'Total Artikel',
                value: '15 Artikel',
              ),
              const SizedBox(height: 24),

              Text(
                'Transaksi Masuk',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColor.font100,
                ),
              ),
              const SizedBox(height: 12),

              _buildTransactionCard(context, '12 Mei, 15:22', 'Rafi', '1 Bulan', '30.000'),
              _buildTransactionCard(context, '12 Mei, 15:22', 'Rafi', '1 Bulan', '30.000'),
              _buildTransactionCard(context, '12 Mei, 15:22', 'Rafi', '1 Bulan', '30.000'),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AdminNavBar(currentIndex: 0),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.font60.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColor.font80,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColor.font100,
                  ),
                ),
              ],
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColor.base100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.star_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(
    BuildContext context,
    String time,
    String customerName,
    String planName,
    String price,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.adminManajemenKonfirmasi);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.font60.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColor.font80,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Pending',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFE65100),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Text(
              'Pelanggan: $customerName',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColor.font80,
              ),
            ),
            const SizedBox(height: 2),

            Text(
              'Paket Langganan: $planName',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppColor.font80,
              ),
            ),
            const SizedBox(height: 12),

              // Pickup history cards dari Provider
              if (pickupProvider.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: CircularProgressIndicator(color: AppColor.base100),
                  ),
                  child: Text(
                    'Konfirmasi',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
