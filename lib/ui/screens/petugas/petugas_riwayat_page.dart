import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/setor_sampah.dart';
import '../../../models/jenis_sampah.dart';
import '../../../providers/pickup_history_provider.dart';
import '../../../providers/waste_category_provider.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';
import '../../../utils/app_routes.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/navbar.dart';

class PetugasRiwayatPage extends StatefulWidget {
  const PetugasRiwayatPage({super.key});

  @override
  State<PetugasRiwayatPage> createState() => _PetugasRiwayatPageState();
}

class _PetugasRiwayatPageState extends State<PetugasRiwayatPage> {
  bool _isNavigating = false;

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
          !context.read<PickupHistoryProvider>().isLoading) {
        _loadMoreData();
      }
    }
  }

  void _fetchData() {
    _currentPage = 1;
    _hasMore = true;
    _isFetchingMore = false;
    context.read<PickupHistoryProvider>().fetchPickupHistory(
      roleId: 2,
      page: 1,
      limit: 10,
      isLoadMore: false,
    );
    context.read<WasteCategoryProvider>().fetchCategories();
  }

  Future<void> _loadMoreData() async {
    if (_isFetchingMore) return;
    setState(() {
      _isFetchingMore = true;
    });

    _currentPage++;
    final provider = context.read<PickupHistoryProvider>();
    final int beforeCount = provider.setorHistory.length;
    await provider.fetchPickupHistory(
      roleId: 2,
      page: _currentPage,
      limit: 10,
      isLoadMore: true,
    );
    final int afterCount = provider.setorHistory.length;

    if (mounted) {
      setState(() {
        _isFetchingMore = false;
        if (afterCount == beforeCount) {
          _hasMore = false;
        }
      });
    }
  }

  Future<void> _navigasiKeDetail(SetorSampah tugas) async {
    setState(() => _isNavigating = true);
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _isNavigating = false);

    if (!mounted) return;
    if (tugas.status == 'selesai') {
      Navigator.pushNamed(
        context,
        AppRoutes.petugasDetailSelesai,
        arguments: tugas,
      );
    } else {
      Navigator.pushNamed(
        context,
        AppRoutes.petugasDetailTugas,
        arguments: tugas,
      );
    }
  }

  Future<void> _refreshData() async {
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final pickupProvider = context.watch<PickupHistoryProvider>();
    final categoryProvider = context.watch<WasteCategoryProvider>();
    final history = pickupProvider.setorHistory;

    final dataSedangProses = history
        .where((e) => e.status == 'proses')
        .toList();
    final dataSelesai = history
        .where((e) => e.status == 'selesai' || e.status == 'dibatalkan')
        .toList();

    String getJenisSampahName(SetorSampah tugas) {
      final id = tugas.idJenisSampah;
      if (id == null)
        return tugas.namaJenisSampah.isNotEmpty ? tugas.namaJenisSampah : '-';
      final cat = categoryProvider.categories.firstWhere(
        (element) => element.idJenisSampah == id,
        orElse: () => JenisSampah(
          idJenisSampah: id,
          nama: tugas.namaJenisSampah.isNotEmpty
              ? tugas.namaJenisSampah
              : 'Jenis Sampah #$id',
          poinPerKg: tugas.poinPerKg ?? 0,
        ),
      );
      return cat.nama;
    }

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: Stack(
        children: [
          SafeArea(
            child: RefreshIndicator(
              color: AppColor.base100,
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aktivitas Pesanan',
                      style: AppFont.bold().copyWith(
                        fontSize: 24,
                        color: AppColor.base100,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'Sedang Proses',
                      style: AppFont.bold().copyWith(
                        fontSize: 16,
                        color: AppColor.font100,
                      ),
                    ),
                    const Divider(color: AppColor.font60),
                    const SizedBox(height: 8),

                    if (pickupProvider.isLoading && _currentPage == 1)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: CircularProgressIndicator(
                            color: AppColor.base100,
                          ),
                        ),
                      )
                    else if (dataSedangProses.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'Tidak ada penjemputan yang sedang diproses.',
                            style: AppFont.regular().copyWith(
                              fontSize: 13,
                              color: AppColor.font80,
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: dataSedangProses.length,
                        itemBuilder: (context, index) {
                          final tugas = dataSedangProses[index];
                          return _buildCardRiwayat(
                            tugas: tugas,
                            jenisSampahName: getJenisSampahName(tugas),
                            isSelesai: false,
                            onTapLihat: () => _navigasiKeDetail(tugas),
                          );
                        },
                      ),
                    const SizedBox(height: 24),

                    Text(
                      'Riwayat Selesai',
                      style: AppFont.bold().copyWith(
                        fontSize: 16,
                        color: AppColor.font100,
                      ),
                    ),
                    const Divider(color: AppColor.font60),
                    const SizedBox(height: 8),

                    if (pickupProvider.isLoading && _currentPage == 1)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: CircularProgressIndicator(
                            color: AppColor.base100,
                          ),
                        ),
                      )
                    else if (dataSelesai.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'Belum ada riwayat penjemputan selesai.',
                            style: AppFont.regular().copyWith(
                              fontSize: 13,
                              color: AppColor.font80,
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: dataSelesai.length,
                        itemBuilder: (context, index) {
                          final tugas = dataSelesai[index];
                          return _buildCardRiwayat(
                            tugas: tugas,
                            jenisSampahName: getJenisSampahName(tugas),
                            isSelesai: true,
                            onTapLihat: () => _navigasiKeDetail(tugas),
                          );
                        },
                      ),
                    if (_isFetchingMore)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColor.base100,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          if (pickupProvider.errorMessage.isNotEmpty)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColor.redLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColor.redAllert.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  pickupProvider.errorMessage,
                  style: AppFont.regular().copyWith(
                    fontSize: 12,
                    color: AppColor.redAllert,
                  ),
                ),
              ),
            ),

          LoadingOverlay(isLoading: _isNavigating),
        ],
      ),
      bottomNavigationBar: const PetugasNavBar(currentIndex: 1),
    );
  }

  Widget _buildCardRiwayat({
    required SetorSampah tugas,
    required String jenisSampahName,
    required bool isSelesai,
    required VoidCallback onTapLihat,
  }) {
    String tanggalText = '';
    if (tugas.createdAt != null) {
      final d = tugas.createdAt!;
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      tanggalText =
          '${d.day} ${months[d.month - 1]} ${d.year}, ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.putih100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.font60),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tanggalText.isNotEmpty ? tanggalText : '-',
                style: AppFont.regular().copyWith(
                  fontSize: 12,
                  color: AppColor.font80,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: tugas.status == 'selesai'
                      ? const Color(0xFFE8F5E9)
                      : tugas.status == 'dibatalkan'
                      ? const Color(0xFFFFEBEE)
                      : const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tugas.status.toUpperCase(),
                  style: AppFont.bold().copyWith(
                    fontSize: 10,
                    color: tugas.status == 'selesai'
                        ? const Color(0xFF2E7D32)
                        : tugas.status == 'dibatalkan'
                        ? const Color(0xFFC62828)
                        : const Color(0xFFE65100),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  tugas.foto ?? '',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    color: AppColor.base20,
                    child: const Icon(
                      Icons.image,
                      size: 30,
                      color: AppColor.font80,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pelanggan: ${tugas.customerName.isNotEmpty ? tugas.customerName : '-'}',
                      style: AppFont.medium().copyWith(
                        fontSize: 13,
                        color: AppColor.font100,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Alamat : ${tugas.alamat ?? '-'}',
                      style: AppFont.regular().copyWith(
                        fontSize: 12,
                        color: AppColor.font100,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Jenis Sampah : $jenisSampahName',
                      style: AppFont.regular().copyWith(
                        fontSize: 12,
                        color: AppColor.font100,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Driver : ${tugas.petugasName.isNotEmpty ? tugas.petugasName : "-"}',
                      style: AppFont.regular().copyWith(
                        fontSize: 12,
                        color: AppColor.font100,
                      ),
                    ),
                    if (isSelesai && tugas.beratSampah != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Berat : ${tugas.beratSampah} kg',
                        style: AppFont.regular().copyWith(
                          fontSize: 12,
                          color: AppColor.font100,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.base100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onPressed: onTapLihat,
              child: Text(
                'Lihat Detail',
                style: AppFont.semibold().copyWith(
                  fontSize: 13,
                  color: AppColor.putih100,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
