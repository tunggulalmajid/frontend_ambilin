import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';
import '../../../utils/app_routes.dart';
import '../../../models/setor_sampah.dart';
import '../../../providers/pickup_history_provider.dart';
import '../../widgets/loading_overlay.dart';

class PesananPelangganPage extends StatefulWidget {
  const PesananPelangganPage({super.key});

  @override
  State<PesananPelangganPage> createState() => _PesananPelangganPageState();
}

class _PesananPelangganPageState extends State<PesananPelangganPage> {
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<PickupHistoryProvider>().fetchPickupHistory(roleId: 3);
    });
  }

  Future<void> _navigateToDetail(BuildContext context, SetorSampah data) async {
    setState(() {
      _isNavigating = true;
    });
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _isNavigating = false;
    });

    if (!context.mounted) return;

    if (data.status == 'selesai') {
      Navigator.pushNamed(
        context,
        AppRoutes.pelangganDetailSelesai,
        arguments: data,
      );
    } else {
      Navigator.pushNamed(
        context,
        AppRoutes.pelangganProsesPenjemputan,
        arguments: data,
      );
    }
  }

  Future<void> _refreshData() async {
    await context.read<PickupHistoryProvider>().fetchPickupHistory(roleId: 3);
  }

  @override
  Widget build(BuildContext context) {
    final pickupProvider = context.watch<PickupHistoryProvider>();
    final history = pickupProvider.setorHistory;

    final onGoingList = history
        .where((e) => e.status == 'menunggu' || e.status == 'proses')
        .toList();
    final selesaiList = history
        .where((e) => e.status == 'selesai' || e.status == 'dibatalkan')
        .toList();

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      appBar: AppBar(
        backgroundColor: AppColor.putih100,
        elevation: 1,
        title: Text(
          'Aktivitas',
          style: AppFont.bold().copyWith(color: AppColor.base100, fontSize: 24),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          pickupProvider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColor.base100),
                )
              : RefreshIndicator(
                  color: AppColor.base100,
                  onRefresh: _refreshData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dalam Proses',
                          style: AppFont.bold().copyWith(
                            fontSize: 18,
                            color: AppColor.font100,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (onGoingList.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text(
                                'Tidak ada penjemputan aktif.',
                                style: AppFont.regular().copyWith(
                                  color: AppColor.font80,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          )
                        else
                          ...onGoingList.map(
                            (data) => _buildCard(data, isOnGoing: true),
                          ),

                        const SizedBox(height: 24),

                        Text(
                          'Selesai & Riwayat',
                          style: AppFont.bold().copyWith(
                            fontSize: 18,
                            color: AppColor.font100,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (selesaiList.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text(
                                'Belum ada riwayat penjemputan.',
                                style: AppFont.regular().copyWith(
                                  color: AppColor.font80,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          )
                        else
                          ...selesaiList.map(
                            (data) => _buildCard(data, isOnGoing: false),
                          ),
                      ],
                    ),
                  ),
                ),
          LoadingOverlay(isLoading: _isNavigating),
        ],
      ),
    );
  }

  Widget _buildCard(SetorSampah data, {required bool isOnGoing}) {
    String tanggalText = '';
    if (data.createdAt != null) {
      final d = data.createdAt!;
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
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColor.putih100,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
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
                  color: AppColor.font80,
                  fontSize: 12,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: data.status == 'selesai'
                      ? const Color(0xFFE8F5E9)
                      : data.status == 'dibatalkan'
                      ? const Color(0xFFFFEBEE)
                      : const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  data.status.toUpperCase(),
                  style: AppFont.bold().copyWith(
                    fontSize: 10,
                    color: data.status == 'selesai'
                        ? const Color(0xFF2E7D32)
                        : data.status == 'dibatalkan'
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
                child: Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey.shade200,
                  child: Image.network(
                    data.foto ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_outlined, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pelanggan : ${data.customerName.isNotEmpty ? data.customerName : "-"}',
                      style: AppFont.medium().copyWith(
                        fontSize: 12,
                        color: AppColor.font100,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Alamat : ${data.alamat ?? "-"}',
                      style: AppFont.regular().copyWith(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Berat : ${data.beratSampah != null ? "${data.beratSampah} kg" : "-"}',
                      style: AppFont.regular().copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Driver : ${data.petugasName.isNotEmpty ? data.petugasName : "-"}',
                      style: AppFont.regular().copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.base100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(80, 35),
              ),
              onPressed: () => _navigateToDetail(context, data),
              child: Text(
                'Lihat Detail',
                style: AppFont.medium().copyWith(
                  color: AppColor.putih100,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
