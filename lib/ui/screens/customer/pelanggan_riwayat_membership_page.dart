import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend_ambilin/providers/subscription_provider.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/ui/widgets/zoomable_image_dialog.dart';

class PelangganRiwayatMembershipPage extends StatefulWidget {
  const PelangganRiwayatMembershipPage({super.key});

  @override
  State<PelangganRiwayatMembershipPage> createState() =>
      _PelangganRiwayatMembershipPageState();
}

class _PelangganRiwayatMembershipPageState
    extends State<PelangganRiwayatMembershipPage> {
  final ScrollController _scrollController = ScrollController();
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchInitialData() {
    _page = 1;
    _hasMore = true;
    _isLoadingMore = false;
    Future.microtask(() {
      if (mounted) {
        context.read<SubscriptionProvider>().fetchCustomerHistory(
          page: 1,
          limit: 10,
          isLoadMore: false,
        );
      }
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_hasMore &&
          !_isLoadingMore &&
          !context.read<SubscriptionProvider>().isLoading) {
        _loadMoreData();
      }
    }
  }

  Future<void> _loadMoreData() async {
    setState(() {
      _isLoadingMore = true;
    });

    final provider = context.read<SubscriptionProvider>();
    final count = await provider.fetchCustomerHistory(
      page: _page + 1,
      limit: 10,
      isLoadMore: true,
    );

    if (mounted) {
      setState(() {
        _isLoadingMore = false;
        if (count < 10) {
          _hasMore = false;
        } else {
          _page++;
        }
      });
    }
  }

  Future<void> _onRefresh() async {
    _fetchInitialData();
  }

  String _formatDateTime(String rawDate) {
    if (rawDate.isEmpty) return '-';
    try {
      final dt = DateTime.parse(rawDate).toLocal();
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
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return rawDate;
    }
  }

  String _formatCurrency(int val) {
    return 'Rp. ${val.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]}.")}';
  }

  void _showDetailBottomSheet(BuildContext context, Map<String, dynamic> item) {
    final subNama =
        item['nama_paket'] ??
        item['subscribtion']?['nama'] ??
        item['nama_subscribtion'] ??
        item['paket'] ??
        'Paket';
    final int harga =
        item['harga_paket'] as int? ??
        item['subscribtion']?['harga'] as int? ??
        item['harga'] as int? ??
        0;
    final int poinDigunakan = item['poin_digunakan'] as int? ?? 0;
    final int totalBayar = harga - poinDigunakan;
    final String rawDate = item['created_at']?.toString() ?? '';
    final String formattedDate = _formatDateTime(rawDate);
    final String status = (item['status']?.toString() ?? 'pending')
        .toLowerCase();

    final paymentMethodName =
        item['metode_pembayaran']?['nama'] ??
        item['nama_metode_pembayaran'] ??
        '-';
    final paymentMethodRek =
        item['metode_pembayaran']?['nomor_rekening'] ??
        item['nomor_rekening'] ??
        '';
    final paymentMethod = paymentMethodRek.isNotEmpty
        ? '$paymentMethodName ($paymentMethodRek)'
        : paymentMethodName;

    final String? bukti = item['bukti_pembayaran']?.toString();
    final String? buktiUrl = bukti != null && bukti.isNotEmpty
        ? (bukti.startsWith('http')
              ? bukti
              : 'https://ambilin.kodetalma.my.id/${bukti.startsWith('/') ? bukti.substring(1) : bukti}')
        : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Detail Transaksi Membership',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColor.base100,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildDetailRow(
                    'Status',
                    status.toUpperCase(),
                    valueColor: status == 'success' || status == 'aktif'
                        ? Colors.green
                        : (status == 'pending' ? Colors.orange : Colors.red),
                  ),
                  const Divider(),
                  _buildDetailRow('Tanggal Transaksi', formattedDate),
                  const Divider(),
                  _buildDetailRow('Nama Paket', subNama),
                  const Divider(),
                  _buildDetailRow('Harga Paket', _formatCurrency(harga)),
                  const Divider(),
                  _buildDetailRow('Poin Digunakan', '$poinDigunakan poin'),
                  const Divider(),
                  _buildDetailRow(
                    'Total Pembayaran',
                    _formatCurrency(totalBayar),
                    isBoldValue: true,
                    valueColor: AppColor.base100,
                  ),
                  const Divider(),
                  _buildDetailRow('Metode Pembayaran', paymentMethod),
                  const Divider(),

                  const SizedBox(height: 20),
                  Text(
                    'Bukti Pembayaran',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColor.font100,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (buktiUrl != null) ...[
                    GestureDetector(
                      onTap: () =>
                          ZoomableImageDialog.show(context, imageUrl: buktiUrl),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          height: 250,
                          color: const Color(0xFFF5F5F5),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.network(
                                buktiUrl,
                                fit: BoxFit.contain,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.broken_image_outlined,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.zoom_in,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Ketuk untuk zoom',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Center(
                        child: Text(
                          'Tidak ada bukti pembayaran.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    Color? valueColor,
    bool isBoldValue = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 13, color: AppColor.font80),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: isBoldValue ? FontWeight.bold : FontWeight.w500,
                color: valueColor ?? AppColor.font100,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SubscriptionProvider>();
    final historyList = provider.history;

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColor.base100),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Riwayat Transaksi',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColor.base100,
              ),
            ),
            Text(
              'Pembelian paket membership Anda',
              style: GoogleFonts.poppins(fontSize: 11, color: AppColor.font80),
            ),
          ],
        ),
      ),
      body: provider.isLoading && _page == 1
          ? const Center(
              child: CircularProgressIndicator(color: AppColor.base100),
            )
          : RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColor.base100,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (provider.errorMessage.isNotEmpty)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          provider.errorMessage,
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFC62828),
                            fontSize: 12,
                          ),
                        ),
                      ),

                    if (historyList.isEmpty)
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.receipt_long_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Belum ada transaksi membership.',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: AppColor.font80,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else ...[
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: historyList.length,
                        itemBuilder: (context, index) {
                          final item = historyList[index];
                          final subNama =
                              item['nama_paket'] ??
                              item['subscribtion']?['nama'] ??
                              item['nama_subscribtion'] ??
                              item['paket'] ??
                              '';
                          final int harga =
                              item['harga_paket'] as int? ??
                              item['subscribtion']?['harga'] as int? ??
                              item['harga'] as int? ??
                              0;
                          final int poinDigunakan =
                              item['poin_digunakan'] as int? ?? 0;
                          final int netPayment = harga - poinDigunakan;

                          final rawDate = item['created_at']?.toString() ?? '';
                          final formattedDate = _formatDateTime(rawDate);
                          final status =
                              (item['status']?.toString() ?? 'pending')
                                  .toLowerCase();

                          Color statusColor = Colors.orange;
                          if (status == 'success' || status == 'aktif') {
                            statusColor = Colors.green;
                          } else if (status == 'failed' ||
                              status == 'dibatalkan' ||
                              status == 'ditolak') {
                            statusColor = Colors.red;
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColor.font60.withOpacity(0.5),
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              onTap: () =>
                                  _showDetailBottomSheet(context, item),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    subNama,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: AppColor.font100,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      status.toUpperCase(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: statusColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatCurrency(netPayment),
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: AppColor.base100,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formattedDate,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: AppColor.font80,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: const Icon(
                                Icons.chevron_right,
                                color: AppColor.font80,
                              ),
                            ),
                          );
                        },
                      ),

                      if (_isLoadingMore)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColor.base100,
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
