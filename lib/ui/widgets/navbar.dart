import 'package:flutter/material.dart';
import 'package:frontend_ambilin/ui/screens/admin/admin_dashboard.dart';
import 'package:frontend_ambilin/ui/screens/admin/manajemen_akun_page.dart';
import 'package:frontend_ambilin/ui/screens/admin/manajemen_artikel_page.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';
import 'package:frontend_ambilin/utils/app_routes.dart';

class AdminNavBar extends StatelessWidget {
  final int currentIndex;

  const AdminNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
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
              _buildNavItem(context, Icons.home, 'Home', 0),
              _buildNavItem(context, Icons.star_rounded, 'Users', 1),
              _buildNavItem(context, Icons.star_rounded, 'Contents', 2),
              _buildNavItem(context, Icons.star_rounded, 'Points', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, IconData icon, String label, int index) {
    final bool isActive = currentIndex == index;
    final Color color = isActive ? AppColor.base100 : AppColor.font80;

    return InkWell(
      onTap: () {
        if (index == currentIndex) return;

        Widget destination;
        switch (index) {
          case 0:
            destination = const AdminDashboard();
            break;
          case 1:
            destination = const ManajemenAkunPage();
            break;
          case 2:
            destination = const ManajemenArtikelPage();
            break;
          default:
            return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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

class PetugasNavBar extends StatelessWidget {
  final int currentIndex;

  const PetugasNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
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
              _buildNavItem(context, Icons.home, 'Beranda', 0),
              _buildNavItem(context, Icons.receipt_long, 'Pesanan', 1),
              _buildNavItem(context, Icons.person, 'Profil', 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, IconData icon, String label, int index) {
    final bool isActive = currentIndex == index;
    final Color color = isActive ? AppColor.base100 : AppColor.font80;

    return InkWell(
      onTap: () {
        if (index == currentIndex) return;

        String routeName;
        switch (index) {
          case 0:
            routeName = AppRoutes.petugasHome;
            break;
          case 1:
            routeName = AppRoutes.petugasRiwayat;
            break;
          case 2:
            routeName = AppRoutes.petugasProfil;
            break;
          default:
            return;
        }

        Navigator.pushReplacementNamed(context, routeName);
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
