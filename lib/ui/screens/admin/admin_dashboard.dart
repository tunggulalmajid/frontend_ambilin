import 'package:flutter/material.dart';
import 'package:frontend_ambilin/providers/pickup_history_provider.dart';
import 'package:frontend_ambilin/ui/screens/admin/manajemen_kategori_page.dart';
import 'package:frontend_ambilin/ui/screens/admin/profile_admin_page.dart';
import 'package:frontend_ambilin/ui/widgets/admin_greeting_section.dart';
import 'package:frontend_ambilin/ui/widgets/kelola_sampah_tile.dart';
import 'package:frontend_ambilin/ui/widgets/navbar.dart';
import 'package:frontend_ambilin/ui/widgets/app_cards.dart';
import 'package:frontend_ambilin/ui/widgets/riwayat_header.dart';
import 'package:frontend_ambilin/ui/widgets/stat_card.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';
import 'package:provider/provider.dart';

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
    final pickupProvider = context.watch<PickupHistoryProvider>();

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              AdminGreetingSection(
                onProfileTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileAdminPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              const StatCard(
                label: 'Total User Aktif',
                value: '1,234',
                unit: 'users',
                icon: Icons.supervised_user_circle_rounded,
              ),
              const SizedBox(height: 12),
              const StatCard(
                label: 'Pendapatan Subscription',
                value: 'Rp 48.5',
                unit: 'juta',
                icon: Icons.star_rounded,
              ),
              const SizedBox(height: 12),
              const StatCard(
                label: 'Total Sampah Terkumpul',
                value: '2,847',
                unit: 'kg',
                icon: Icons.star_rounded,
              ),
              const SizedBox(height: 12),
              const StatCard(
                label: 'Total Article',
                value: '15',
                unit: 'post',
                icon: Icons.star_rounded,
              ),
              const SizedBox(height: 24),

              // --- Pengaturan Sampah Section ---
              Text(
                'Pengaturan Sampah',
                style: AppFont.semibold().copyWith(
                  fontSize: 16,
                  color: AppColor.font100,
                ),
              ),
              const SizedBox(height: 12),
              KelolaSampahTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManajemenKategoriPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // --- Riwayat Penjemputan Section ---
              RiwayatHeader(
                onLihatSemua: () {
                  // TODO: Navigate to full riwayat page
                },
              ),
              const SizedBox(height: 12),

              // Pickup history cards dari Provider
              if (pickupProvider.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: CircularProgressIndicator(color: AppColor.base100),
                  ),
                )
              else
                ...List.generate(
                  pickupProvider.pickupList.length,
                  (index) => PickupHistoryCard(
                    pickup: pickupProvider.pickupList[index],
                  ),
                ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AdminNavBar(currentIndex: 0),
    );
  }
}
