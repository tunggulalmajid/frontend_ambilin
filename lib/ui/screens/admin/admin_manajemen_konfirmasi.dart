import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend_ambilin/providers/auth_provider.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';
import 'package:frontend_ambilin/utils/app_routes.dart';

class AdminManajemenKonfirmasi extends StatefulWidget {
  const AdminManajemenKonfirmasi({super.key});

  @override
  State<AdminManajemenKonfirmasi> createState() => _AdminManajemenKonfirmasiState();
}

class _AdminManajemenKonfirmasiState extends State<AdminManajemenKonfirmasi> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<AuthProvider>().fetchPendingTransactions();
      }
    });
  }

  Future<void> _onRefresh() async {
    await context.read<AuthProvider>().fetchPendingTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final pendingList = authProvider.pendingTransactions;

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
          'Konfirmasi Langganan',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColor.base100,
          ),
        ),
      ),
      body: authProvider.isTransactionsLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColor.base100),
            )
          : RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColor.base100,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daftar Langganan Pending',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColor.font100,
                      ),
                    ),
                    const SizedBox(height: 16),
                    pendingList.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Center(
                              child: Text(
                                'Tidak ada antrean konfirmasi pembayaran.',
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
                            itemCount: pendingList.length,
                            itemBuilder: (context, index) {
                              final item = pendingList[index];
                              final userName = item['user']?['nama'] ?? item['nama_user'] ?? item['nama'] ?? 'User';
                              final inisial = userName.isNotEmpty ? userName[0].toUpperCase() : '?';
                              final transId = item['id_riwayat_subscribtion'] ?? item['id'] ?? 0;
                              final subNama = item['subscribtion']?['nama'] ?? item['nama_subscribtion'] ?? item['paket'] ?? '';

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
                                        child: Text(
                                          inisial,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: AppColor.redAllert,
                                          ),
                                        ),
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
                  ],
                ),
              ),
            ),
    );
  }
}
