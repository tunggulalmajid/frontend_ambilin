import 'package:flutter/material.dart';
import 'package:frontend_ambilin/models/langganan.dart';
import 'package:frontend_ambilin/ui/screens/customer/pilih_promo_page.dart';
import 'package:frontend_ambilin/ui/screens/customer/pembayaran_page.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';
import 'package:frontend_ambilin/ui/widgets/w_button.dart';
import 'package:intl/intl.dart';

class MetodePembayaranPage extends StatefulWidget {
  /// [subscriptionId] — ID paket langganan yang dipilih dari SubscriptionPage.
  /// Jika null, default ke paket pertama.
  final String? subscriptionId;

  const MetodePembayaranPage({super.key, this.subscriptionId});

  @override
  State<MetodePembayaranPage> createState() => _MetodePembayaranPageState();
}

class _MetodePembayaranPageState extends State<MetodePembayaranPage> {
  String? _selectedPaymentMethod;
  Promo? _selectedPromo;
  late PaketLangganan _plan;

  // Format angka ke Rupiah
  final _currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  // List opsi untuk dropdown metode pembayaran
  final List<String> _paymentMethods = [
    'BCA Virtual Account',
    'Mandiri Virtual Account',
    'BRI Virtual Account',
    'GoPay',
    'OVO',
  ];

  @override
  void initState() {
    super.initState();
    // Cari paket berdasarkan ID, jika tidak ditemukan gunakan paket pertama
    final plans = PaketLangganan.getPlans();
    _plan = plans.firstWhere(
      (p) => p.id == widget.subscriptionId,
      orElse: () => plans.first,
    );
  }

  /// Harga sebelum diskon
  int get _hargaLangganan => _plan.totalHarga;

  /// Jumlah diskon
  int get _diskon =>
      _selectedPromo != null ? _selectedPromo!.hitungDiskon(_hargaLangganan) : 0;

  /// Total bayar setelah diskon
  int get _totalBayar => _hargaLangganan - _diskon;

  /// Navigasi ke halaman Pilih Promo dan terima hasilnya.
  Future<void> _navigasiPilihPromo() async {
    final result = await Navigator.push<Promo>(
      context,
      MaterialPageRoute(
        builder: (context) => PilihPromoPage(selectedPromo: _selectedPromo),
      ),
    );

    // result bisa null jika user tidak memilih / membatalkan
    if (result != null && mounted) {
      setState(() {
        _selectedPromo = result;
      });
    }
  }

  /// Navigasi ke halaman Pembayaran (Halaman 3).
  void _navigasiPembayaran() {
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih metode pembayaran terlebih dahulu'),
          backgroundColor: AppColor.redAllert,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PembayaranPage(
          subscriptionId: _plan.id,
          promoId: _selectedPromo?.id,
          metodePembayaran: _selectedPaymentMethod!,
          totalBayar: _totalBayar,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable Content area
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Back Button
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 12),
                      child: TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColor.font100,
                          size: 20,
                        ),
                        label: Text(
                          'Kembali',
                          style: AppFont.medium().copyWith(
                            color: AppColor.font100,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // 2. Title & Subtitle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Checkout Langganan',
                            style: AppFont.bold().copyWith(
                              fontSize: 24,
                              color: AppColor.font100,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Langkah awal untuk menikmati fitur penuh Ambilin+',
                            style: AppFont.regular().copyWith(
                              fontSize: 14,
                              color: AppColor.font80,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 3. Card Item Pembelian
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColor.putih100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColor.font60),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColor.base100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Item Pembelian',
                                  style: AppFont.bold().copyWith(
                                    fontSize: 16,
                                    color: AppColor.font100,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Langganan ${_plan.durasi}',
                                  style: AppFont.regular().copyWith(
                                    fontSize: 14,
                                    color: AppColor.font80,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 4. Dropdown Metode Pembayaran
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Metode Pembayaran',
                            style: AppFont.bold().copyWith(
                              fontSize: 14,
                              color: AppColor.font100,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButtonFormField<String>(
                              value: _selectedPaymentMethod,
                              hint: Text(
                                'Metode Pembayaran',
                                style: AppFont.regular().copyWith(
                                  color: AppColor.font80,
                                  fontSize: 14,
                                ),
                              ),
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  color: AppColor.font80),
                              decoration: InputDecoration(
                                fillColor: AppColor.putih100,
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColor.font60, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColor.base100, width: 1.5),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              items: _paymentMethods.map((String method) {
                                return DropdownMenuItem<String>(
                                  value: method,
                                  child: Text(
                                    method,
                                    style: AppFont.medium()
                                        .copyWith(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedPaymentMethod = newValue;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 5. Card Rincian Harga
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColor.putih100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColor.font60),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rincian Harga',
                              style: AppFont.bold().copyWith(
                                fontSize: 16,
                                color: AppColor.font100,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildPriceRow(
                              'Harga Langganan',
                              _currencyFormat.format(_hargaLangganan),
                              AppColor.font80,
                            ),
                            const SizedBox(height: 12),
                            _buildPriceRow(
                              'Diskon',
                              _diskon > 0
                                  ? '- ${_currencyFormat.format(_diskon)}'
                                  : _currencyFormat.format(0),
                              AppColor.base100,
                            ),
                            Divider(
                              height: 24,
                              thickness: 1,
                              color: AppColor.font60.withOpacity(0.5),
                            ),
                            _buildPriceRow(
                              'Total Bayar',
                              _currencyFormat.format(_totalBayar),
                              AppColor.base100,
                              isTotal: true,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 6. Section Promo
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _navigasiPilihPromo,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Cek promo lainnya',
                                  style: AppFont.bold().copyWith(
                                    fontSize: 14,
                                    color: AppColor.base100,
                                  ),
                                ),
                                const Icon(Icons.arrow_forward,
                                    color: AppColor.base100, size: 18),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _selectedPromo != null
                                  ? AppColor.base20
                                  : AppColor.yellowLight,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _selectedPromo != null
                                    ? AppColor.base100
                                    : AppColor.yellowAllert,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _selectedPromo != null
                                    ? 'Promo "${_selectedPromo!.nama}" diterapkan'
                                    : 'Belum menggunakan promo!!',
                                style: AppFont.medium().copyWith(
                                  color: _selectedPromo != null
                                      ? AppColor.base100
                                      : AppColor.yellowAllert,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // 7. Sticky Bottom Button "Selanjutnya"
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              decoration: BoxDecoration(
                color: AppColor.putih100,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: WButton(
                text: 'Selanjutnya',
                textSize: 16,
                onPressed: _navigasiPembayaran,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk baris rincian harga
  Widget _buildPriceRow(String label, String value, Color valueColor,
      {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppFont.bold()
                  .copyWith(fontSize: 16, color: AppColor.font100)
              : AppFont.regular()
                  .copyWith(fontSize: 14, color: AppColor.font80),
        ),
        Text(
          value,
          style: isTotal
              ? AppFont.bold().copyWith(fontSize: 16, color: valueColor)
              : AppFont.medium().copyWith(fontSize: 14, color: valueColor),
        ),
      ],
    );
  }
}