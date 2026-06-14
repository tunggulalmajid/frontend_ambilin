import 'package:flutter/material.dart';
import 'package:frontend_ambilin/models/akun_pengguna.dart';
import 'package:frontend_ambilin/providers/user_account_provider.dart';
import 'package:frontend_ambilin/ui/screens/admin/edit_akun_page.dart';
import 'package:frontend_ambilin/ui/screens/admin/tambah_akun_page.dart';
import 'package:frontend_ambilin/ui/widgets/filter_chips.dart';
import 'package:frontend_ambilin/ui/widgets/navbar.dart';
import 'package:frontend_ambilin/ui/widgets/app_cards.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';
import 'package:provider/provider.dart';

class ManajemenAkunPage extends StatefulWidget {
  const ManajemenAkunPage({super.key});

  @override
  State<ManajemenAkunPage> createState() => _ManajemenAkunPageState();
}

class _ManajemenAkunPageState extends State<ManajemenAkunPage> {
  String _selectedFilter = 'Semua';
  final List<String> _filters = ['Semua', 'Petugas', 'Pelanggan'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<UserAccountProvider>().fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserAccountProvider>();
    final filteredUsers = userProvider.getFilteredUsers(_selectedFilter);

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text('Manajemen Akun', style:
                AppFont.bold().copyWith(
                  fontSize: 24,
                  color: AppColor.base100,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Kelola pengguna dan petugas aplikasi Ambilin',
                style: AppFont.regular().copyWith(
                  fontSize: 13,
                  color: AppColor.font80,
                ),
              ),
              const SizedBox(height: 16),

              FilterChips(
                filters: _filters,
                selectedFilter: _selectedFilter,
                onFilterChanged: (filter) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
              ),
              const SizedBox(height: 16),

              if (userProvider.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: CircularProgressIndicator(
                      color: AppColor.base100,
                    ),
                  ),
                )
              else
                ...List.generate(
                  filteredUsers.length,
                  (index) {
                    final user = filteredUsers[index];
                    return GestureDetector(
                      onTap: () {
                        if (user.peran == 'Petugas') {
                          Navigator.pushNamed(context, AppRoutes.adminDetailPetugas);
                        } else {
                          Navigator.pushNamed(context, AppRoutes.adminDetailPelanggan);
                        }
                      },
                      child: UserAccountCard(
                        user: user,
                        onMenuTap: () {
                          _showUserMenu(context, user, index);
                        },
                      ),
                    );
                  },
                ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TambahAkunPage(),
            ),
          );
        },
        backgroundColor: AppColor.base100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.add,
          color: AppColor.putih100,
          size: 30,
        ),
      ),
      bottomNavigationBar: const AdminNavBar(currentIndex: 1),
    );
  }

  void _showUserMenu(BuildContext context, AkunPengguna user, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: Text(
                    'Edit Akun',
                    style: AppFont.medium().copyWith(fontSize: 14),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditAkunPage(user: user),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    user.status == 'Aktif'
                        ? Icons.block
                        : Icons.check_circle_outline,
                    color: user.status == 'Aktif'
                        ? const Color(0xFFD32F2F)
                        : AppColor.base100,
                  ),
                  title: Text(
                    user.status == 'Aktif'
                        ? 'Nonaktifkan Akun'
                        : 'Aktifkan Akun',
                    style: AppFont.medium().copyWith(fontSize: 14),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<UserAccountProvider>().toggleUserStatus(index);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFD32F2F),
                  ),
                  title: Text(
                    'Hapus Akun',
                    style: AppFont.medium().copyWith(
                      fontSize: 14,
                      color: const Color(0xFFD32F2F),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<UserAccountProvider>().deleteUser(index);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
