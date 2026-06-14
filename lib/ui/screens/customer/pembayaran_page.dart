import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';
import 'package:frontend_ambilin/utils/app_routes.dart';
import 'package:frontend_ambilin/ui/widgets/w_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PembayaranPage extends StatefulWidget {
  final String subscriptionId;
  final String? promoId;
  final String metodePembayaran;
  final int totalBayar;

  const PembayaranPage({
    super.key,
    required this.subscriptionId,
    this.promoId,
    required this.metodePembayaran,
    required this.totalBayar,
  });

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  File? _buktiTransfer;
  bool _isLoading = false;

  final _currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);

  final ImagePicker _picker = ImagePicker();

  /// Ambil gambar dari kamera.
  Future<void> _ambilDariKamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1200,
      );

      // User membatalkan pengambilan gambar
      if (photo == null) return;
      if (!mounted) return;

      setState(() {
        _buktiTransfer = File(photo.path);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil foto: $e'),
          backgroundColor: AppColor.redAllert,
        ),
      );
    }
  }

  /// Ambil gambar dari galeri.
  Future<void> _ambilDariGaleri() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1200,
      );

      // User membatalkan pemilihan gambar
      if (image == null) return;
      if (!mounted) return;

      setState(() {
        _buktiTransfer = File(image.path);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih gambar: $e'),
          backgroundColor: AppColor.redAllert,
        ),
      );
    }
  }

  /// Submit konfirmasi pembayaran dengan loading overlay.
  Future<void> _konfirmasiPembayaran() async {
    if (_buktiTransfer == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulasi proses upload / API call
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // Navigasi langsung ke halaman Transaksi Berhasil
      Navigator.of(context).pushReplacementNamed(AppRoutes.transaksiBerhasil);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengirim pembayaran: $e'),
          backgroundColor: AppColor.redAllert,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isBuktiTerisi = _buktiTransfer != null;

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Scrollable Content
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
                                'Selesaikan Pembayaran',
                                style: AppFont.bold().copyWith(
                                  fontSize: 24,
                                  color: AppColor.font100,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Silakan lakukan transfer sesuai dengan detail di bawah ini',
                                style: AppFont.regular().copyWith(
                                  fontSize: 14,
                                  color: AppColor.font80,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // 3. Card Instruksi Pembayaran
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
                                  'Instruksi Pembayaran:',
                                  style: AppFont.bold().copyWith(
                                    fontSize: 15,
                                    color: AppColor.font100,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildInstruksiItem(
                                  '1.',
                                  'Salin nomor rekening tujuan di bawah ini.',
                                ),
                                const SizedBox(height: 4),
                                // Nomor Rekening
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text(
                                    '8220341982 - BCA Yanto',
                                    style: AppFont.bold().copyWith(
                                      fontSize: 14,
                                      color: AppColor.base100,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildInstruksiItem(
                                  '2.',
                                  'Pastikan data yang dimasukkan sudah benar sebelum melanjutkan.',
                                ),
                                const SizedBox(height: 8),
                                _buildInstruksiItem(
                                  '3.',
                                  'Buka aplikasi Mobile Banking atau pergi ke ATM terdekat.',
                                ),
                                const SizedBox(height: 8),
                                _buildInstruksiItem(
                                  '4.',
                                  'Lakukan transfer dengan Nominal yang Tepat.',
                                ),
                                const SizedBox(height: 8),
                                _buildInstruksiItem(
                                  '5.',
                                  'Simpan resi, lalu upload foto/tangkapan layar bukti transfer pada kolom yang disediakan.',
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 4. Total yang harus ditransfer
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Container(
                            width: double.infinity,
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
                                  'Total yang harus ditransfer',
                                  style: AppFont.medium().copyWith(
                                    fontSize: 14,
                                    color: AppColor.font80,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _currencyFormat.format(widget.totalBayar),
                                  style: AppFont.bold().copyWith(
                                    fontSize: 24,
                                    color: AppColor.base100,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // 5. Section Bukti Transfer
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bukti Transfer',
                                style: AppFont.bold().copyWith(
                                  fontSize: 16,
                                  color: AppColor.font100,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Area upload / preview gambar
                              GestureDetector(
                                onTap: isBuktiTerisi ? null : _ambilDariGaleri,
                                child: Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: AppColor.putih100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColor.font60,
                                      style: isBuktiTerisi
                                          ? BorderStyle.solid
                                          : BorderStyle.solid,
                                    ),
                                  ),
                                  child: isBuktiTerisi
                                      ? Stack(
                                          children: [
                                            // Preview gambar
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(11),
                                              child: Image.file(
                                                _buktiTransfer!,
                                                width: double.infinity,
                                                height: 200,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            // Tombol hapus
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _buktiTransfer = null;
                                                  });
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    color: AppColor.redAllert,
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.2),
                                                        blurRadius: 4,
                                                      ),
                                                    ],
                                                  ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: AppColor.putih100,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.image_outlined,
                                              size: 48,
                                              color: AppColor.font60,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Upload bukti Transfer Anda',
                                              style:
                                                  AppFont.regular().copyWith(
                                                fontSize: 14,
                                                color: AppColor.font80,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Tombol Kamera & Galeri
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildPickerButton(
                                    icon: Icons.camera_alt,
                                    label: 'Kamera',
                                    onTap: _ambilDariKamera,
                                  ),
                                  const SizedBox(width: 12),
                                  _buildPickerButton(
                                    icon: Icons.photo_library,
                                    label: 'Galeri',
                                    onTap: _ambilDariGaleri,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),

                // 6. Sticky Bottom Button "Konfirmasi Pembayaran"
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
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isBuktiTerisi
                            ? AppColor.base100
                            : AppColor.font60,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      onPressed: isBuktiTerisi ? _konfirmasiPembayaran : null,
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: AppColor.putih100,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              'Konfirmasi Pembayaran',
                              style: AppFont.bold().copyWith(
                                fontSize: 16,
                                color: AppColor.putih100,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Loading Overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColor.base100,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Helper: baris instruksi dengan nomor dan teks.
  Widget _buildInstruksiItem(String nomor, String teks) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          child: Text(
            nomor,
            style: AppFont.regular().copyWith(
              fontSize: 13,
              color: AppColor.font100,
            ),
          ),
        ),
        Expanded(
          child: Text(
            teks,
            style: AppFont.regular().copyWith(
              fontSize: 13,
              color: AppColor.font100,
            ),
          ),
        ),
      ],
    );
  }

  /// Helper: tombol kamera / galeri hijau
  Widget _buildPickerButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: AppColor.putih100),
      label: Text(
        label,
        style: AppFont.semibold().copyWith(
          fontSize: 13,
          color: AppColor.putih100,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.base100,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
      ),
    );
  }
}
