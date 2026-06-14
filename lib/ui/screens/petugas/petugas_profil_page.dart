import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/user_model.dart';
import '../../../models/petugas.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';
import '../../../utils/app_routes.dart';
import '../../widgets/profile_header.dart';
import '../../widgets/navbar.dart';

class PetugasProfilPage extends StatefulWidget {
  const PetugasProfilPage({super.key});

  @override
  State<PetugasProfilPage> createState() => _PetugasProfilPageState();
}

class _PetugasProfilPageState extends State<PetugasProfilPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<AuthProvider>().fetchProfile();
        context.read<DashboardProvider>().fetchPetugasDashboard();
      }
    });
  }

  Future<void> _changeProfilePhoto() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
      );
      if (image == null) return;

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mengunggah foto profil...'),
          duration: Duration(seconds: 2),
        ),
      );

      final success = await context.read<AuthProvider>().updateProfilePhoto(image.path);
      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto profil berhasil diperbarui!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final errMsg = context.read<AuthProvider>().errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errMsg.isNotEmpty ? errMsg : 'Gagal memperbarui foto profil'),
            backgroundColor: AppColor.redAllert,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih gambar: $e'),
          backgroundColor: AppColor.redAllert,
        ),
      );
    }
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
                    context.read<DashboardProvider>().fetchPetugasDashboard();
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
              backgroundUrl: 'https://images.unsplash.com/photo-1601584115197-04ecc0da31d7?w=800&auto=format&fit=crop',
              inisial: inisial,
              nama: user.nama,
              email: user.email,
              fotoUrl: user.foto != null && user.foto!.isNotEmpty
                  ? (user.foto!.startsWith('http')
                      ? user.foto
                      : 'https://ambilin.kodetalma.my.id/${user.foto!.startsWith('/') ? user.foto!.substring(1) : user.foto}')
                  : null,
              onBackPressed: () => Navigator.pop(context),
              onEditPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.petugasEditProfil,
                  arguments: user,
                );
              },
              onAvatarEditPressed: _changeProfilePhoto,
            ),
            const SizedBox(height: 80),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColor.putih100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColor.font60),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rincian Profil',
                      style: AppFont.bold().copyWith(
                        fontSize: 18,
                        color: AppColor.base100,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ProfileInfoRow(
                      label: 'Nomor Telepon',
                      value: user.nomorTelepon ?? '-',
                    ),
                    const ProfileInfoRow(
                      label: 'Status',
                      value: 'Aktif',
                    ),
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
                  color: AppColor.putih100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColor.font60),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColor.font60,
                        child: Icon(
                          Icons.lock,
                          size: 16,
                          color: AppColor.font100,
                        ),
                      ),
                      title: Text(
                        'Ubah Password',
                        style: AppFont.medium().copyWith(
                          fontSize: 14,
                          color: AppColor.font100,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: AppColor.font80,
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.petugasUbahPassword,
                        );
                      },
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColor.redAllert,
                        child: Icon(
                          Icons.logout,
                          size: 16,
                          color: AppColor.putih100,
                        ),
                      ),
                      title: Text(
                        'Logout',
                        style: AppFont.medium().copyWith(
                          fontSize: 14,
                          color: AppColor.redAllert,
                        ),
                      ),
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
      bottomNavigationBar: const PetugasNavBar(currentIndex: 2),
    );
  }
}
