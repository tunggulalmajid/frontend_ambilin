import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_routes.dart';
import '../../providers/auth_provider.dart';
import 'profile_header.dart';

class CustomProfileScreen extends StatelessWidget {
  final String role; // 'customer', 'petugas', or 'admin'

  const CustomProfileScreen({
    super.key,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    // Determine details based on role
    String backgroundUrl = '';
    String nama = '';
    String email = '';

    if (role == 'admin') {
      backgroundUrl = 'assets/gambar_profile.png';
      nama = 'Rafi Admin';
      email = 'admin@gmail.com';
    } else if (role == 'petugas') {
      backgroundUrl = 'https://images.unsplash.com/photo-1601584115197-04ecc0da31d7?w=800&auto=format&fit=crop';
      nama = 'Rafi Petugas';
      email = 'driver@gmail.com';
    } else {
      backgroundUrl = 'https://images.unsplash.com/photo-1518780664697-55e3ad937233?w=800&auto=format&fit=crop';
      nama = 'Rafi Customer';
      email = 'customer@gmail.com';
    }

    final inisialVal = nama.isNotEmpty ? nama[0].toUpperCase() : 'R';

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ========== Header Profil ==========
            if (role == 'admin')
              // Custom Header for Admin using Stack to support AssetImage
              _buildAdminHeader(context, inisialVal, nama, email)
            else
              ProfileHeaderFull(
                backgroundUrl: backgroundUrl,
                inisial: inisialVal,
                nama: nama,
                email: email,
                onBackPressed: () => Navigator.pop(context),
                onEditPressed: () {
                  if (role == 'petugas') {
                    Navigator.pushNamed(context, AppRoutes.petugasEditProfil);
                  } else {
                    Navigator.pushNamed(context, AppRoutes.pelangganEditProfil);
                  }
                },
              ),

            const SizedBox(height: 70),

            // ========== Rincian Profil ==========
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: role == 'admin'
                  ? _buildAdminDetails()
                  : _buildUserDetails(),
            ),

            const SizedBox(height: 16),

            // ========== Menu Aksi ==========
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildActionMenu(context),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminHeader(BuildContext context, String inisial, String nama, String email) {
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
            color: Colors.black.withOpacity(0.45),
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
              Navigator.pushNamed(context, AppRoutes.adminEditProfil);
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

  Widget _buildAdminDetails() {
    return Row(
      children: [
        _buildInfoCard('Alamat', 'Jl Halmahera'),
        const SizedBox(width: 12),
        _buildInfoCard('Nomor Telepon', '0821234567'),
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

  Widget _buildUserDetails() {
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
          if (role == 'petugas') ...[
            const ProfileInfoRow(label: 'Nomor Telepon', value: '080765423'),
            const ProfileInfoRow(label: 'Status', value: 'Aktif'),
          ] else ...[
            const ProfileInfoRow(label: 'Alamat', value: 'Jl Halmahera'),
            const ProfileInfoRow(label: 'No Telepon', value: '089965423456'),
            const ProfileInfoRow(label: 'Poin', value: '1000'),
            const ProfileInfoRow(label: 'Member', value: 'Aktif'),
            const ProfileInfoRow(label: 'Status', value: 'Aktif'),
          ],
        ],
      ),
    );
  }

  Widget _buildActionMenu(BuildContext context) {
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
              if (role == 'admin') {
                Navigator.pushNamed(context, AppRoutes.adminUbahPassword);
              } else if (role == 'petugas') {
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
                        context.read<AuthProvider>().logout();
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
