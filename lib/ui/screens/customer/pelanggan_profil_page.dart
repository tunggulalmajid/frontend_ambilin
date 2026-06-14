
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/customer.dart';
import '../../../models/user_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';
import '../../../utils/app_routes.dart';
import '../../widgets/profile_header.dart';
import 'pelanggan_edit_profil_page.dart';
import 'pelanggan_ubah_password_page.dart';

class PelangganProfilPage extends StatefulWidget {
  const PelangganProfilPage({super.key});

  @override
  State<PelangganProfilPage> createState() => _PelangganProfilPageState();
}

class _PelangganProfilPageState extends State<PelangganProfilPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<AuthProvider>().fetchProfile();
        context.read<DashboardProvider>().fetchCustomerDashboard();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final dash = context.watch<DashboardProvider>();

    if (auth.isProfileLoading || dash.isLoading) {
      return const Scaffold(
        backgroundColor: AppColor.putihBackground,
        body: Center(
          child: CircularProgressIndicator(color: AppColor.base100),
        ),
      );
    }

    if (auth.errorMessage.isNotEmpty) {
      return Scaffold(
        backgroundColor: AppColor.putihBackground,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: AppColor.redAllert, size: 48),
                const SizedBox(height: 16),
                Text(
                  auth.errorMessage,
                  textAlign: TextAlign.center,
                  style: AppFont.regular().copyWith(color: AppColor.font100, fontSize: 14),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthProvider>().fetchProfile();
                    context.read<DashboardProvider>().fetchCustomerDashboard();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColor.base100),
                  child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final user = auth.user;
    if (user == null) {
      return Scaffold(
        backgroundColor: AppColor.putihBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Data tidak ditemukan',
                style: AppFont.regular().copyWith(color: AppColor.font100, fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthProvider>().fetchProfile();
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColor.base100),
                child: const Text('Muat Ulang', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    final inisial = user.nama.isNotEmpty ? user.nama[0].toUpperCase() : '?';

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeaderFull(
              backgroundUrl: 'https://images.unsplash.com/photo-1518780664697-55e3ad937233?w=800&auto=format&fit=crop',
              inisial: inisial,
              nama: user.nama,
              email: user.email,
              onBackPressed: () => Navigator.pop(context),
              onEditPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => PelangganEditProfilPage(user: user),
                ));
              },
            ),
            const SizedBox(height: 80),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColor.putih100, borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColor.font60),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rincian Profil', style: AppFont.bold().copyWith(fontSize: 18, color: AppColor.base100)),
                    const SizedBox(height: 16),
                    ProfileInfoRow(label: 'Alamat', value: user.alamat ?? '-'),
                    ProfileInfoRow(label: 'No Telepon', value: user.nomorTelepon ?? '-'),
                    ProfileInfoRow(label: 'Poin', value: dash.formattedPoin),
                    ProfileInfoRow(label: 'Member', value: dash.isMember ? 'Aktif' : 'Tidak Aktif'),
                    const ProfileInfoRow(label: 'Status', value: 'Aktif'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.putih100, borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColor.font60),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const CircleAvatar(
                        radius: 16, backgroundColor: AppColor.font60,
                        child: Icon(Icons.lock, size: 16, color: AppColor.font100),
                      ),
                      title: Text('Ubah Password', style: AppFont.medium().copyWith(fontSize: 14, color: AppColor.font100)),
                      trailing: const Icon(Icons.chevron_right, color: AppColor.font80),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const PelangganUbahPasswordPage()));
                      },
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const CircleAvatar(
                        radius: 16, backgroundColor: AppColor.redAllert,
                        child: Icon(Icons.logout, size: 16, color: AppColor.putih100),
                      ),
                      title: Text('Logout', style: AppFont.medium().copyWith(fontSize: 14, color: AppColor.redAllert)),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(
                              'Konfirmasi Logout',
                              style: AppFont.semibold().copyWith(fontSize: 16),
                            ),
                            content: Text(
                              'Apakah Anda yakin ingin keluar?',
                              style: AppFont.regular().copyWith(fontSize: 14),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text(
                                  'Batal',
                                  style: AppFont.medium().copyWith(
                                    color: AppColor.font80,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  auth.logout();
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    AppRoutes.login,
                                    (route) => false,
                                  );
                                },
                                child: Text(
                                  'Logout',
                                  style: AppFont.medium().copyWith(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: AppColor.base100,
        unselectedItemColor: AppColor.font80,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Pesanan'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Artikel'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        onTap: (index) {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColor.base100,
        child: const Icon(Icons.local_shipping, color: AppColor.putih100),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
