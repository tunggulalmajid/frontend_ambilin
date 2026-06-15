import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend_ambilin/providers/auth_provider.dart';
import 'package:frontend_ambilin/ui/widgets/filter_chips.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_routes.dart';

class AdminManajemenKonfirmasi extends StatefulWidget {
  const AdminManajemenKonfirmasi({super.key});

  @override
  State<AdminManajemenKonfirmasi> createState() => _AdminManajemenKonfirmasiState();
}

class _AdminManajemenKonfirmasiState extends State<AdminManajemenKonfirmasi> {
  String _selectedFilter = 'Semua';
  final List<String> _filters = ['Semua', 'Menunggu', 'Berhasil', 'Gagal'];

  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    Future.microtask(() {
      if (mounted) {
        _fetchData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (_hasMore && !_isFetchingMore && !context.read<AuthProvider>().isTransactionsLoading) {
        _loadMoreData();
      }
    }
  }

  void _fetchData() {
    _currentPage = 1;
    _hasMore = true;
    _isFetchingMore = false;
    String? status;
    if (_selectedFilter == 'Menunggu') status = 'menunggu';
    else if (_selectedFilter == 'Berhasil') status = 'berhasil';
    else if (_selectedFilter == 'Gagal') status = 'gagal';
    context.read<AuthProvider>().fetchTransactions(status: status, page: 1, limit: 10, isLoadMore: false);
  }

  Future<void> _loadMoreData() async {
    if (_isFetchingMore) return;
    setState(() {
      _isFetchingMore = true;
    });

    _currentPage++;
    String? status;
    if (_selectedFilter == 'Menunggu') status = 'menunggu';
    else if (_selectedFilter == 'Berhasil') status = 'berhasil';
    else if (_selectedFilter == 'Gagal') status = 'gagal';

    final authProvider = context.read<AuthProvider>();
    final int beforeCount = authProvider.allTransactions.length;
    await authProvider.fetchTransactions(status: status, page: _currentPage, limit: 10, isLoadMore: true);
    final int afterCount = authProvider.allTransactions.length;

    if (mounted) {
      setState(() {
        _isFetchingMore = false;
        if (afterCount == beforeCount) {
          _hasMore = false;
        }
      });
    }
  }

  Future<void> _onRefresh() async {
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final transactionList = authProvider.allTransactions;

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      appBar: AppBar(
        backgroundColor: AppColor.putihBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.font100),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Daftar Transaksi',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColor.base100,
          ),
        ),
      ),
      body: authProvider.isTransactionsLoading && _currentPage == 1
          ? const Center(
              child: CircularProgressIndicator(color: AppColor.base100),
            )
          : RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColor.base100,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: FilterChips(
                        filters: _filters,
                        selectedFilter: _selectedFilter,
                        onFilterChanged: (filter) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                          _fetchData();
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Rincian Transaksi',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColor.font100,
                      ),
                    ),
                    const SizedBox(height: 16),
                    transactionList.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Center(
                              child: Text(
                                'Tidak ada data transaksi.',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: AppColor.font80,
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: transactionList.length,
                            itemBuilder: (context, index) {
                              final item = transactionList[index];
                              final userName = item['nama_customer'] ?? item['user']?['nama'] ?? item['nama_user'] ?? item['nama'] ?? 'User';
                              final inisial = userName.isNotEmpty ? userName[0].toUpperCase() : '?';
                              final transId = item['id_transaksi'] ?? item['id_riwayat_subscribtion'] ?? item['id'] ?? 0;
                              final subNama = item['nama_paket'] ?? item['subscribtion']?['nama'] ?? item['nama_subscribtion'] ?? item['paket'] ?? '';
                              final String? foto = item['foto'] ??
                                  item['user']?['foto'] ??
                                  item['Customer']?['User']?['foto'] ??
                                  item['Customer']?['foto'] ??
                                  item['customer_foto'] ??
                                  item['foto_user']?.toString();
                              final String? fotoUrl = foto != null && foto.isNotEmpty
                                  ? (foto.startsWith('http')
                                      ? foto
                                      : 'https://ambilin.kodetalma.my.id/${foto.startsWith('/') ? foto.substring(1) : foto}')
                                  : null;

                              return GestureDetector(
                                onTap: () async {
                                  await Navigator.pushNamed(
                                    context,
                                    AppRoutes.adminDetailKonfirmasi,
                                    arguments: item,
                                  );
                                  _onRefresh();
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColor.font60.withOpacity(0.5)),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundColor: const Color(0xFFFFCDD2),
                                        backgroundImage: fotoUrl != null ? NetworkImage(fotoUrl) : null,
                                        child: fotoUrl == null
                                            ? Text(
                                                inisial,
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: AppColor.redAllert,
                                                ),
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              userName,
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: AppColor.font100,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'ID Transaksi: $transId',
                                              style: GoogleFonts.poppins(
                                                fontSize: 11,
                                                color: AppColor.font80,
                                              ),
                                            ),
                                            Text(
                                              'Paket Langganan: $subNama',
                                              style: GoogleFonts.poppins(
                                                fontSize: 11,
                                                color: AppColor.font80,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: AppColor.font80,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                    if (_isFetchingMore)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: CircularProgressIndicator(color: AppColor.base100),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
