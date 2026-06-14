import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import 'profile_header.dart';

class CustomProfileScreen extends StatefulWidget {
  final String role; // 'customer', 'petugas', or 'admin'

  const CustomProfileScreen({
    super.key,
    required this.role,
  });

  @override
  State<CustomProfileScreen> createState() => _CustomProfileScreenState();
}

class _CustomProfileScreenState extends State<CustomProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<AuthProvider>().fetchProfile();
        if (widget.role == 'customer') {
          context.read<DashboardProvider>().fetchCustomerDashboard();
        } else if (widget.role == 'petugas') {
          context.read<DashboardProvider>().fetchPetugasDashboard();
        } else if (widget.role == 'admin') {
          context.read<DashboardProvider>().fetchAdminDashboard();
        }
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
      return const Scaffold(
        body: Center(child: Text('Data tidak ditemukan')),
      );
    }

    String backgroundUrl = '';
    String nama = user.nama;
    String email = user.email;

    if (widget.role == 'admin') {
      backgroundUrl = 'assets/gambar_profile.png';
    } else if (widget.role == 'petugas') {
      backgroundUrl = 'https://images.unsplash.com/photo-1601584115197-04ecc0da31d7?w=800&auto=format&fit=crop';
    } else {
      backgroundUrl = 'https://images.unsplash.com/photo-1518780664697-55e3ad937233?w=800&auto=format&fit=crop';
    }

    final inisialVal = nama.isNotEmpty ? nama[0].toUpperCase() : 'R';

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ========== Header Profil ==========
            if (widget.role == 'admin')
              _buildAdminHeader(context, inisialVal, nama, email, user)
            else
              ProfileHeaderFull(
                backgroundUrl: backgroundUrl,
                inisial: inisialVal,
                nama: nama,
                email: email,
                onBackPressed: () => Navigator.pop(context),
                onEditPressed: () {
                  if (widget.role == 'petugas') {
                    Navigator.pushNamed(context, AppRoutes.petugasEditProfil, arguments: user);
                  } else {
                    Navigator.pushNamed(context, AppRoutes.pelangganEditProfil, arguments: user);
                  }
                },
              ),

            const SizedBox(height: 70),

            // ========== Rincian Profil ==========
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: widget.role == 'admin'
                  ? _buildAdminDetails(user)
                  : _buildUserDetails(context, user),
            ),

            const SizedBox(height: 16),

            // ========== Menu Aksi ==========
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildActionMenu(context, auth),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminHeader(BuildContext context, String inisial, String nama, String email, UserModel user) {
    double headerHeight = 280;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: headerHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/gambar_profile.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: Colors.black45,
          ),
        ),
        // Tombol Back
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_left,
                color: AppColor.putih100,
                size: 24,
              ),
            ),
          ),
        ),
        // Tombol Edit
        Positioned(
          top: MediaQuery.of(context).padding.top + 14,
          right: 20,
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.adminEditProfil, arguments: user);
            },
            child: Text(
              'Edit',
              style: AppFont.bold().copyWith(
                fontSize: 16,
                color: AppColor.putih100,
              ),
            ),
          ),
        ),
        // Avatar + Nama + Email
        Positioned(
          top: 90,
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFFFFCDD2),
                    child: Text(
                      inisial,
                      style: AppFont.bold().copyWith(
                        fontSize: 36,
                        color: AppColor.redAllert,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        color: AppColor.putih100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 14,
                        color: AppColor.redAllert,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                nama,
                style: AppFont.bold().copyWith(
                  fontSize: 20,
                  color: AppColor.putih100,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: AppFont.regular().copyWith(
                  fontSize: 13,
                  color: AppColor.putih100,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdminDetails(UserModel user) {
    return Row(
      children: [
        _buildInfoCard('Alamat', user.alamat ?? '-'),
        const SizedBox(width: 12),
        _buildInfoCard('Nomor Telepon', user.nomorTelepon ?? '-'),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColor.putih100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.font60.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppFont.regular().copyWith(
                fontSize: 12,
                color: AppColor.font80,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppFont.bold().copyWith(
                fontSize: 16,
                color: AppColor.font100,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetails(BuildContext context, UserModel user) {
    final dash = context.watch<DashboardProvider>();
    return Container(
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
          if (widget.role == 'petugas') ...[
            ProfileInfoRow(label: 'Nomor Telepon', value: user.nomorTelepon ?? '-'),
            const ProfileInfoRow(label: 'Status', value: 'Aktif'),
          ] else ...[
            ProfileInfoRow(label: 'Alamat', value: user.alamat ?? '-'),
            ProfileInfoRow(label: 'No Telepon', value: user.nomorTelepon ?? '-'),
            ProfileInfoRow(label: 'Poin', value: dash.formattedPoin),
            ProfileInfoRow(label: 'Member', value: dash.isMember ? 'Aktif' : 'Tidak Aktif'),
            const ProfileInfoRow(label: 'Status', value: 'Aktif'),
          ],
        ],
      ),
    );
  }

  Widget _buildActionMenu(BuildContext context, AuthProvider auth) {
    return Container(
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
              child: Icon(Icons.lock, size: 16, color: AppColor.font100),
            ),
            title: Text(
              'Ubah Password',
              style: AppFont.medium().copyWith(
                fontSize: 14,
                color: AppColor.font100,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, color: AppColor.font80),
            onTap: () {
              if (widget.role == 'admin') {
                Navigator.pushNamed(context, AppRoutes.adminUbahPassword);
              } else if (widget.role == 'petugas') {
                Navigator.pushNamed(context, AppRoutes.petugasUbahPassword);
              } else {
                Navigator.pushNamed(context, AppRoutes.pelangganUbahPassword);
              }
            },
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const CircleAvatar(
              radius: 16,
              backgroundColor: AppColor.redAllert,
              child: Icon(Icons.logout, size: 16, color: AppColor.putih100),
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
    );
  }
}
