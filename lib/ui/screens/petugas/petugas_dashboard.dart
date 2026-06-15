import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../../models/setor_sampah.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../providers/pickup_history_provider.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';
import '../../../utils/app_routes.dart';
import '../../widgets/navbar.dart';

class PetugasDashboard extends StatefulWidget {
  const PetugasDashboard({super.key});

  @override
  State<PetugasDashboard> createState() => _PetugasDashboardState();
}

class _PetugasDashboardState extends State<PetugasDashboard> {
  bool _isNavigating = false;

  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isFetchingMore = false;
  Timer? _locationTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    Future.microtask(() {
      _fetchData();
      _startLocationTracking();
    });
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _startLocationTracking() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (mounted) {
        await context.read<AuthProvider>().updateLocationSilent(
          position.latitude,
          position.longitude,
        );
      }

      _locationTimer = Timer.periodic(const Duration(seconds: 30), (
        timer,
      ) async {
        try {
          final pos = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
          if (mounted) {
            await context.read<AuthProvider>().updateLocationSilent(
              pos.latitude,
              pos.longitude,
            );
          }
        } catch (e) {
          debugPrint("Gagal memperbarui lokasi berkala: $e");
        }
      });
    } catch (e) {
      debugPrint("Setup pelacakan lokasi error: $e");
    }
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
    context.read<DashboardProvider>().fetchPetugasDashboard();
    context.read<PickupHistoryProvider>().fetchActiveOrders(
      page: 1,
      limit: 10,
      isLoadMore: false,
    );
  }

  Future<void> _loadMoreData() async {
    if (_isFetchingMore) return;
    setState(() {
      _isFetchingMore = true;
    });

    _currentPage++;
    final provider = context.read<PickupHistoryProvider>();
    final int beforeCount = provider.activeOrders.length;
    await provider.fetchActiveOrders(
      page: _currentPage,
      limit: 10,
      isLoadMore: true,
    );
    final int afterCount = provider.activeOrders.length;

    if (mounted) {
      setState(() {
        _isFetchingMore = false;
        if (afterCount == beforeCount) {
          _hasMore = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final dashProvider = context.watch<DashboardProvider>();
    final pickupProvider = context.watch<PickupHistoryProvider>();

    final String userName = authProvider.user?.nama ?? 'Driver';
    final int totalTugas = dashProvider.totalPesananDilayani;
    final double totalSampah = dashProvider.totalSampahDiangkut;
    final List<SetorSampah> daftarTugas = pickupProvider.activeOrders;

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
                      'Halo, $userName',
                      style: AppFont.bold().copyWith(
                        fontSize: 28,
                        color: AppColor.base100,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Selamat datang di aplikasi penjemputan sampah',
                      style: AppFont.regular().copyWith(
                        fontSize: 13,
                        color: AppColor.font80,
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (dashProvider.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: CircularProgressIndicator(
                            color: AppColor.base100,
                          ),
                        ),
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: _buildPerformaCard(
                              icon: Icons.check_circle_rounded,
                              label: 'Total Tugas Selesai',
                              value: '$totalTugas',
                              satuan: 'Tugas',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildPerformaCard(
                              icon: Icons.scale_rounded,
                              label: 'Total Sampah Diangkut',
                              value: totalSampah % 1 == 0
                                  ? '${totalSampah.toInt()}'
                                  : totalSampah.toStringAsFixed(1),
                              satuan: 'kg',
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 24),

                    if (dashProvider.errorMessage.isNotEmpty ||
                        pickupProvider.errorMessage.isNotEmpty)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColor.redLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          dashProvider.errorMessage.isNotEmpty
                              ? dashProvider.errorMessage
                              : pickupProvider.errorMessage,
                          style: AppFont.regular().copyWith(
                            fontSize: 12,
                            color: AppColor.redAllert,
                          ),
                        ),
                      ),

                    Text(
                      'Daftar Ambil Sampah',
                      style: AppFont.bold().copyWith(
                        fontSize: 18,
                        color: AppColor.font100,
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (pickupProvider.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: CircularProgressIndicator(
                            color: AppColor.base100,
                          ),
                        ),
                      )
                    else if (daftarTugas.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.inbox_rounded,
                              size: 48,
                              color: AppColor.font60,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Belum ada order masuk saat ini.',
                              style: AppFont.regular().copyWith(
                                fontSize: 14,
                                color: AppColor.font80,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: daftarTugas.length,
                        itemBuilder: (context, index) {
                          return _buildCardTugas(daftarTugas[index]);
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
                  ],
                ),
              ),
            ),
          ),

          if (_isNavigating)
            Container(
              color: Colors.black.withOpacity(0.2),
              child: const Center(
                child: CircularProgressIndicator(color: AppColor.base100),
              ),
            ),
        ],
      ),
      bottomNavigationBar: const PetugasNavBar(currentIndex: 0),
    );
  }

  Widget _buildPerformaCard({
    required IconData icon,
    required String label,
    required String value,
    required String satuan,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.base100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColor.putih100, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: AppFont.medium().copyWith(
                    fontSize: 11,
                    color: AppColor.putih100,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: AppFont.bold().copyWith(
                    fontSize: 32,
                    color: AppColor.putih100,
                  ),
                ),
                TextSpan(
                  text: ' $satuan',
                  style: AppFont.regular().copyWith(
                    fontSize: 14,
                    color: AppColor.putih100,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _lihatDetail(SetorSampah tugas) async {
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

  Widget _buildCardTugas(SetorSampah tugas) {
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
          '${d.day} ${months[d.month - 1]}, ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
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
                  color: AppColor.yellowLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tugas.status.toUpperCase(),
                  style: AppFont.bold().copyWith(
                    fontSize: 10,
                    color: const Color(0xFFE65100),
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
                    child: const Icon(Icons.delete, color: AppColor.font80),
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
                      'Catatan : ${tugas.pesanCustomer.isNotEmpty ? tugas.pesanCustomer : '-'}',
                      style: AppFont.regular().copyWith(
                        fontSize: 12,
                        color: AppColor.font80,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Driver : ${tugas.petugasName.isNotEmpty ? tugas.petugasName : '-'}',
                      style: AppFont.regular().copyWith(
                        fontSize: 12,
                        color: AppColor.font80,
                      ),
                    ),
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
              onPressed: () => _lihatDetail(tugas),
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
