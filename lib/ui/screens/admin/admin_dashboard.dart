import 'package:flutter/material.dart';
import 'package:frontend_ambilin/providers/auth_provider.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';
import 'package:frontend_ambilin/utils/app_routes.dart';
import 'package:provider/provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      appBar: AppBar(
        backgroundColor: AppColor.putihBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout, color: AppColor.font80),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header Section ---
              Text(
                'Halo, Admin',
                style: AppFont.bold().copyWith(
                  fontSize: 24,
                  color: AppColor.font100,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Selamat datang di Sistem Manajemen Ambilin',
                style: AppFont.regular().copyWith(
                  fontSize: 14,
                  color: AppColor.font80,
                ),
              ),
              const SizedBox(height: 24),

              // --- Statistic Cards ---
              _buildStatCard(
                label: 'Total User Aktif',
                value: '1,234',
                unit: 'users',
                icon: Icons.people_alt_outlined,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                label: 'Pendapatan Subscription',
                value: 'Rp 48.5',
                unit: 'juta',
                icon: Icons.attach_money,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                label: 'Total Sampah Terkumpul',
                value: '2,847',
                unit: 'kg',
                icon: Icons.inventory_2_outlined,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                label: 'Total Article',
                value: '15',
                unit: 'post',
                icon: Icons.article_outlined,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // --------------------------------------------------
  // Reusable Stat Card Widget
  // --------------------------------------------------
  Widget _buildStatCard({
    required String label,
    required String value,
    required String unit,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.putih100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.font60.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side — texts
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppFont.medium().copyWith(
                  fontSize: 12,
                  color: AppColor.font80,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: AppFont.bold().copyWith(
                      fontSize: 28,
                      color: AppColor.font100,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    unit,
                    style: AppFont.regular().copyWith(
                      fontSize: 14,
                      color: AppColor.font80,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Right side — icon container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColor.base20,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColor.base100, size: 26),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // Bottom Navigation Bar
  // --------------------------------------------------
  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.putih100,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', 0),
              _buildNavItem(Icons.people_outline, 'Users', 1),
              _buildNavItem(Icons.description_outlined, 'Contents', 2),
              _buildNavItem(Icons.stars_outlined, 'Points', 3),
            ],
          ),
        ),
      ),
    );
  }

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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Green top indicator line for active item
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: isActive ? 24 : 0,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: AppColor.base100,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
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
