import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend_ambilin/models/langganan.dart';
import 'package:frontend_ambilin/providers/subscription_provider.dart';
import 'package:frontend_ambilin/providers/dashboard_provider.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';
import 'package:frontend_ambilin/utils/app_routes.dart';

class FormPembelianLangganan extends StatefulWidget {
  const FormPembelianLangganan({super.key});

  @override
  State<FormPembelianLangganan> createState() => _FormPembelianLanggananState();
}

class _FormPembelianLanggananState extends State<FormPembelianLangganan> {
  int? _selectedPaymentMethodId;
  String? _selectedPaymentMethodName;
  String? _selectedPaymentMethodKeterangan;
  bool _usePoints = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<SubscriptionProvider>().fetchPaymentMethods();
        context.read<DashboardProvider>().fetchCustomerDashboard();
      }
    });
  }

  void _handleSelanjutnya(Langganan langganan, int userPoints) async {
    if (_selectedPaymentMethodId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('Pilih metode pembayaran terlebih dahulu')),
          backgroundColor: AppColor.redAllert,
        ),
      );
      return;
    }

    final int pointsUsed = _usePoints ? min(userPoints, langganan.harga) : 0;
    final int totalBayar = langganan.harga - pointsUsed;

    if (totalBayar == 0) {
      // Pembayaran penuh dengan poin (lunas)
      setState(() {
        _isLoading = true;
      });

      final subProvider = context.read<SubscriptionProvider>();
      final result = await subProvider.purchaseSubscription(
        idSub: langganan.idSubscribtion,
        idPayMethod: _selectedPaymentMethodId!,
        poinUsed: pointsUsed,
      );

      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      if (result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(child: Text('Pembayaran Langganan Sukses (Lunas Poin)!')),
            backgroundColor: AppColor.base100,
          ),
        );
        // Refresh dashboard customer
        context.read<DashboardProvider>().fetchCustomerDashboard();
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.transaksiBerhasil,
          (route) => route.isFirst,
          arguments: {
            'id_transaksi': result['data']?['id_transaksi'],
            'id_subscription': langganan.idSubscribtion,
            'metode_pembayaran': _selectedPaymentMethodName,
            'nama_paket': langganan.nama,
            'harga': langganan.harga,
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text(result['message'] ?? 'Gagal memproses langganan')),
            backgroundColor: AppColor.redAllert,
          ),
        );
      }
    } else {
      // Pembayaran transfer (ada sisa bayar)
      Navigator.pushNamed(
        context,
        AppRoutes.pembayaran,
        arguments: {
          'subscriptionId': langganan.idSubscribtion,
          'idMetodePembayaran': _selectedPaymentMethodId,
          'metodePembayaran': _selectedPaymentMethodName,
          'namaPaket': langganan.nama,
          'keterangan': _selectedPaymentMethodKeterangan,
          'totalBayar': totalBayar,
          'poinUsed': pointsUsed,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final langganan = ModalRoute.of(context)?.settings.arguments as Langganan?;
    if (langganan == null) {
      return const Scaffold(
        body: Center(
          child: Text('Error: Informasi paket langganan tidak valid'),
        ),
      );
    }

    final dashProvider = context.watch<DashboardProvider>();
    final subProvider = context.watch<SubscriptionProvider>();

    final int userPoints = dashProvider.totalPoin;
    final int pointsUsed = _usePoints ? min(userPoints, langganan.harga) : 0;
    final int totalBayar = langganan.harga - pointsUsed;

    final formattedHarga = 'Rp ${langganan.harga.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]}.")}';
    final formattedPotongan = 'Rp ${pointsUsed.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]}.")}';
    final formattedTotal = 'Rp ${totalBayar.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]}.")}';

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SafeArea(
        child: subProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColor.base100),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.arrow_back, size: 16, color: AppColor.font100),
                          const SizedBox(width: 4),
                          Text(
                            'Kembali',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColor.font100,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Checkout Langganan',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColor.font100,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Langkah awal untuk menikmati fitur penuh Ambilin+',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColor.font80,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColor.font60.withOpacity(0.5)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColor.base100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Item Pembelian',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColor.font100,
                                  ),
                                ),
                                Text(
                                  'Langganan ${langganan.nama}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColor.font80,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Metode Pembayaran',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColor.font100,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      isExpanded: true,
                      value: _selectedPaymentMethodId,
                      hint: Text(
                        'Metode Pembayaran',
                        style: GoogleFonts.poppins(fontSize: 13, color: AppColor.font80),
                      ),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColor.font60.withOpacity(0.5)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColor.font60.withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColor.base100),
                        ),
                      ),
                      items: subProvider.paymentMethods.map<DropdownMenuItem<int>>((method) {
                        return DropdownMenuItem<int>(
                          value: method['id_metode_pembayaran'] as int?,
                          child: Text(method['nama']?.toString() ?? '-'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        final chosen = subProvider.paymentMethods.firstWhere(
                          (m) => m['id_metode_pembayaran'] == value,
                          orElse: () => null,
                        );
                        setState(() {
                          _selectedPaymentMethodId = value;
                          _selectedPaymentMethodName = chosen?['nama']?.toString();
                          _selectedPaymentMethodKeterangan = chosen?['keterangan']?.toString();
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColor.font60.withOpacity(0.5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rincian Harga',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColor.font100,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildPriceRow('Harga Langganan', formattedHarga, color: AppColor.base100),
                          const SizedBox(height: 8),
                          _buildPriceRow(
                            'Poin',
                            _usePoints ? '- $formattedPotongan' : 'Rp 0',
                            color: AppColor.base100,
                          ),
                          const Divider(height: 24, color: AppColor.font60),
                          _buildPriceRow(
                            'Total Bayar',
                            formattedTotal,
                            color: AppColor.base100,
                            isBold: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: _usePoints,
                          activeColor: AppColor.base100,
                          onChanged: (value) {
                            setState(() {
                              _usePoints = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            'Gunakan Poin (Saldo Anda: ${dashProvider.formattedPoin} poin)',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColor.base100,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
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
                        onPressed: _isLoading ? null : () => _handleSelanjutnya(langganan, userPoints),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                'Selanjutnya',
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
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {required Color color, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: AppColor.font100,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
