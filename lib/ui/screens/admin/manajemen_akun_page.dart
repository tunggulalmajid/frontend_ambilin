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
import 'package:frontend_ambilin/utils/app_routes.dart';
import 'package:provider/provider.dart';

class ManajemenAkunPage extends StatefulWidget {
  const ManajemenAkunPage({super.key});

  @override
  State<ManajemenAkunPage> createState() => _ManajemenAkunPageState();
}

class _ManajemenAkunPageState extends State<ManajemenAkunPage> {
  String _selectedFilter = 'Semua';
  final List<String> _filters = ['Semua', 'Petugas', 'Pelanggan'];

  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    Future.microtask(() {
      _fetchData();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_hasMore &&
          !_isFetchingMore &&
          !context.read<UserAccountProvider>().isLoading) {
        _loadMoreData();
      }
    }
  }

  void _fetchData() async {
    _currentPage = 1;
    _hasMore = true;
    _isFetchingMore = false;
    int? role;
    if (_selectedFilter == 'Petugas')
      role = 2;
    else if (_selectedFilter == 'Pelanggan')
      role = 3;
    final int rawCount = await context.read<UserAccountProvider>().fetchUsers(
      role: role,
      page: 1,
      limit: 10,
      isLoadMore: false,
    );
    if (mounted) {
      setState(() {
        if (rawCount < 10) {
          _hasMore = false;
        }
      });
      _checkAndLoadMoreIfNeeded();
    }
  }

  Future<void> _loadMoreData() async {
    if (_isFetchingMore) return;
    setState(() {
      _isFetchingMore = true;
    });

    _currentPage++;
    int? role;
    if (_selectedFilter == 'Petugas')
      role = 2;
    else if (_selectedFilter == 'Pelanggan')
      role = 3;

    final provider = context.read<UserAccountProvider>();
    final int rawCount = await provider.fetchUsers(
      role: role,
      page: _currentPage,
      limit: 10,
      isLoadMore: true,
    );

    if (mounted) {
      setState(() {
        _isFetchingMore = false;
        if (rawCount < 10) {
          _hasMore = false;
        }
      });
      _checkAndLoadMoreIfNeeded();
    }
  }

  void _checkAndLoadMoreIfNeeded() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final provider = context.read<UserAccountProvider>();
        final filteredUsers = provider.getFilteredUsers(_selectedFilter);
        if (filteredUsers.length < 8 &&
            _hasMore &&
            !_isFetchingMore &&
            !provider.isLoading) {
          _loadMoreData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserAccountProvider>();
    final filteredUsers = userProvider.getFilteredUsers(_selectedFilter);

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColor.base100,
          onRefresh: () async => _fetchData(),
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Manajemen Akun',
                  style: AppFont.bold().copyWith(
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
                    _fetchData();
                  },
                ),
                const SizedBox(height: 16),

                if (userProvider.isLoading && _currentPage == 1)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: CircularProgressIndicator(color: AppColor.base100),
                    ),
                  )
                else
                  ...List.generate(filteredUsers.length, (index) {
                    final user = filteredUsers[index];
                    return GestureDetector(
                      onTap: () {
                        if (user.peran == 'Petugas') {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.adminDetailPetugas,
                            arguments: user,
                          );
                        } else {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.adminDetailPelanggan,
                            arguments: user,
                          );
                        }
                      },
                      child: UserAccountCard(
                        user: user,
                        onMenuTap: () {
                          _showUserMenu(context, user, index);
                        },
                      ),
                    );
                  }),

                if (_isFetchingMore)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColor.base100),
                    ),
                  ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahAkunPage()),
          );
        },
        backgroundColor: AppColor.base100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: AppColor.putih100, size: 30),
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
                        builder: (context) =>
                            EditAkunPage(user: user, index: index),
                      ),
                    );
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
