import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_ambilin/providers/subscription_provider.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/ui/widgets/w_text_fields.dart';
import 'package:provider/provider.dart';

class ManajemenSubscriptionPage extends StatefulWidget {
  const ManajemenSubscriptionPage({super.key});

  @override
  State<ManajemenSubscriptionPage> createState() =>
      _ManajemenSubscriptionPageState();
}

class _ManajemenSubscriptionPageState extends State<ManajemenSubscriptionPage> {
  final _priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      final subProvider = context.read<SubscriptionProvider>();
      subProvider.fetchSubscriptions().then((_) {
        if (!mounted) return;
        final subs = subProvider.subscriptions;
        final premiumSubs = subs.where((sub) => sub.idSubscribtion == 1);
        if (premiumSubs.isNotEmpty) {
          _priceController.text = premiumSubs.first.harga.toString();
        } else if (subs.isNotEmpty) {
          _priceController.text = subs.first.harga.toString();
        }
      });
      subProvider.fetchSummary();
    });
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _handlePerbaruiHarga() async {
    if (_formKey.currentState!.validate()) {
      final subProvider = context.read<SubscriptionProvider>();
      final subs = subProvider.subscriptions;

      final premiumSubs = subs.where((sub) => sub.idSubscribtion == 1);
      if (premiumSubs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text('Paket subscription premium (ID 1) tidak ditemukan'),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final targetSub = premiumSubs.first;
      final int newPrice = int.parse(_priceController.text);

      final success = await subProvider.updateSubscriptionPrice(
        targetSub.idSubscribtion,
        targetSub.nama,
        newPrice,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(
                child: Text('Harga Paket Premium Berhasil Diperbarui'),
              ),
              backgroundColor: AppColor.base100,
            ),
          );
        } else {
          final error = subProvider.errorMessage;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: Text(
                  error.isNotEmpty ? error : 'Gagal memperbarui harga',
                ),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final subProvider = context.watch<SubscriptionProvider>();
    final subs = subProvider.subscriptions;
    final totalPendapatan = subProvider.summary?['total_pendapatan'] ?? 0;
    final totalMember = subProvider.summary?['total_member'] ?? 0;
    final premiumSubs = subs.where((sub) => sub.idSubscribtion == 1);
    final currentPrice = premiumSubs.isNotEmpty ? premiumSubs.first.harga : 0;

    String formatHarga(int harga) {
      return harga.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
    }

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      appBar: AppBar(
        backgroundColor: AppColor.putihBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.font100),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manajemen Subscription',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColor.base100,
              ),
            ),
            Text(
              'Manajemen Paket Subscription Customer+',
              style: GoogleFonts.poppins(fontSize: 11, color: AppColor.font80),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildStatCard(
                    title: 'Total Pendapatan',
                    value: 'Rp. ${formatHarga(totalPendapatan)}',
                    icon: Icons.account_balance_wallet_rounded,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    title: 'Pengguna Aktif',
                    value: '$totalMember Pengguna',
                    icon: Icons.people_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColor.font60),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Paket Premium Ambilin+',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColor.base100,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Benefit Subscription',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColor.font100,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildBulletPoint('Bonus Poin'),
                    _buildBulletPoint('Akses Fitur Premium'),
                    _buildBulletPoint('Gratis Ongkir Instan Tanpa Batas'),
                    const SizedBox(height: 16),
                    const Divider(color: AppColor.font60),
                    const SizedBox(height: 12),
                    Text(
                      'Tarif Subscription saat ini',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColor.font100,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Rp. ${formatHarga(currentPrice)}/bulan',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: AppColor.base100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColor.font60),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Masukkan Harga Baru (Rp)',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColor.base100,
                      ),
                    ),
                    const SizedBox(height: 12),
                    WTextFieldPutih(
                      label: '',
                      hintText: 'Rp. 30000',
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harga tidak boleh kosong';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Harga harus berupa angka';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.base100,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        onPressed: subProvider.isLoading
                            ? null
                            : _handlePerbaruiHarga,
                        child: subProvider.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                'Perbarui Harga Paket',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.base100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppColor.yellow,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColor.base100, size: 18),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6, left: 6, right: 8),
            child: Icon(Icons.circle, size: 6, color: AppColor.font80),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColor.font80,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
