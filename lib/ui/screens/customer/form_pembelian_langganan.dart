import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';
import 'package:frontend_ambilin/utils/app_routes.dart';

class FormPembelianLangganan extends StatefulWidget {
  const FormPembelianLangganan({super.key});

  @override
  State<FormPembelianLangganan> createState() => _FormPembelianLanggananState();
}

class _FormPembelianLanggananState extends State<FormPembelianLangganan> {
  String? _selectedPaymentMethod;
  bool _usePoints = false;
  bool _isLoading = false;

  final int _hargaLangganan = 30000;
  final int _potonganPoin = 500;

  void _handleSelanjutnya() async {
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('Pilih metode pembayaran terlebih dahulu')),
          backgroundColor: AppColor.redAllert,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('Pengajuan Langganan Berhasil Diajukan!')),
          backgroundColor: AppColor.base100,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalBayar = _usePoints ? (_hargaLangganan - _potonganPoin) : _hargaLangganan;

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SafeArea(
        child: SingleChildScrollView(
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
                            'Langganan 1 Bulan',
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
              DropdownButtonFormField<String>(
                value: _selectedPaymentMethod,
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
                items: const [
                  DropdownMenuItem(value: 'BCA', child: Text('BCA Transfer')),
                  DropdownMenuItem(value: 'MANDIRI', child: Text('Mandiri Transfer')),
                  DropdownMenuItem(value: 'GOPAY', child: Text('GoPay')),
                  DropdownMenuItem(value: 'OVO', child: Text('OVO')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value;
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
                    _buildPriceRow('Harga Langganan', 'Rp 30.000', color: AppColor.base100),
                    const SizedBox(height: 8),
                    _buildPriceRow(
                      'Poin',
                      _usePoints ? 'Rp 500' : 'Rp 0',
                      color: AppColor.base100,
                    ),
                    const Divider(height: 24, color: AppColor.font60),
                    _buildPriceRow(
                      'Total Bayar',
                      'Rp ${totalBayar.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
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
                  Text(
                    'Gunakan Poin',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColor.base100,
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
                  onPressed: _isLoading ? null : _handleSelanjutnya,
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
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: AppColor.font100,
          ),
        ),
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
