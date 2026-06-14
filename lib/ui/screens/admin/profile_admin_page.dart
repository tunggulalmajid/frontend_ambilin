import 'package:flutter/material.dart';
import 'package:frontend_ambilin/providers/auth_provider.dart';
import 'package:frontend_ambilin/ui/screens/admin/edit_profile_admin_page.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';
import 'package:frontend_ambilin/utils/app_routes.dart';
import 'package:provider/provider.dart';

class ProfileAdminPage extends StatelessWidget {
  const ProfileAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Kita hitung tinggi dinamis header agar responsif, atau tentukan angka statis yang ideal
    double headerHeight = 310; 
    double cardOverlap = 35; // Jarak kartu masuk/menimpa ke dalam area gambar atas

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: Column(
        children: [
          // Menggunakan Stack untuk membuat efek menumpuk/menimpa
          SizedBox(
            height: headerHeight + cardOverlap, 
            child: Stack(
              clipBehavior: Clip.none, // Memastikan card tidak terpotong saat keluar batas Stack
              children: [
                // 1. Bagian Header (Gambar Background)
                _buildHeader(context, headerHeight),
                
                // 2. Bagian Card Info yang menimpa header
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 0, // Diletakkan tepat di paling bawah batas widget Stack ini
                  child: Row(
                    children: [
                      _buildInfoCard('Alamat', 'Jl Halmahera'),
                      const SizedBox(width: 12),
                      _buildInfoCard('Nomor Telepon', '0821234567'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Berikan jarak setelah stack sebelum tombol logout
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildLogoutButton(context),
          ),
        ],
      ),
    );
  }

  // Modifikasi: Tambahkan parameter height agar tingginya terkontrol dari Stack induk
  Widget _buildHeader(BuildContext context, double height) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('gambar_profile.png'),
          fit: BoxFit.cover,
        ),),
      child: SafeArea(
        bottom: false,
        child: Padding(
          // Padding bawah dikurangi atau sesuaikan agar teks email tidak terlalu mepet ke bawah
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            children: [
              // Baris atas: Tombol Back & Edit
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColor.putih100,
                      size: 24,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfileAdminPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Edit',
                      style: AppFont.medium().copyWith(
                        fontSize: 14,
                        color: AppColor.putih100,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: const Color(0xFFF4A0A0),
                    child: Text(
                      'R',
                      style: AppFont.bold().copyWith(
                        fontSize: 36,
                        color: AppColor.putih100,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColor.font100,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColor.putih100,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: AppColor.putih100,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Rafi Admin',
                style: AppFont.bold().copyWith(
                  fontSize: 20,
                  color: AppColor.putih100,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'admin@gmail.com',
                style: AppFont.regular().copyWith(
                  fontSize: 14,
                  color: AppColor.font60,
                ),
              ),
            ],
          ),
        ),
      ),
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
              color: Colors.black.withOpacity(0.05), // Sedikit dipertegas bayangannya
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
              style: AppFont.semibold().copyWith(
                fontSize: 16,
                color: AppColor.font100,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.putih100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.font60.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 36,
          height: 36,
          child: const Icon(Icons.logout, color: Colors.red, size: 20), // Tambahkan ikon logout agar mirip desain asli
        ),
        title: Text(
          'Logout',
          style: AppFont.semibold().copyWith(
            fontSize: 14,
            color: Colors.red,
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
    );
  }
}