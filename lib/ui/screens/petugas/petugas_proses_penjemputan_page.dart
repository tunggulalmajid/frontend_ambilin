// ----- FILE: petugas_proses_penjemputan_page.dart -----
import 'package:flutter/material.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';
import '../../widgets/w_text_fields.dart';
import '../../widgets/detail_card_wrapper.dart';
import '../../widgets/async_button.dart';

class PetugasProsesPenjemputanPage extends StatefulWidget {
  const PetugasProsesPenjemputanPage({super.key});

  @override
  State<PetugasProsesPenjemputanPage> createState() =>
      _PetugasProsesPenjemputanPageState();
}

class _PetugasProsesPenjemputanPageState
    extends State<PetugasProsesPenjemputanPage> {
  final Map<String, String> _rincianData = {
    'Nama': 'Yanto',
    'Status': 'Mencari Kurir',
    'Alamat': 'Jl Semeru',
    'Waktu Pengajuan': 'TIMESTAMP',
    'Driver': 'Asep',
    'Waktu penjemputan': 'TIMESTAMP',
  };

  final String _catatanPelanggan =
      'sampah depan rumah yang ada mobil avanza hitam';
  final String _jenisSampah = 'botol';
  final String _beratSampah = '- kg';
  final String _fotoSampahUrl =
      'https://images.unsplash.com/photo-1611284446314-60a58ac0deb9?q=80&w=600&auto=format&fit=crop';

  final _formKey = GlobalKey<FormState>();
  final _beratController = TextEditingController();
  bool _isLoading = false;
  bool _fotoBuktiDipilih = false;

  @override
  void dispose() {
    _beratController.dispose();
    super.dispose();
  }

  Future<void> _ambilDariKamera() async {
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _fotoBuktiDipilih = true);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Foto dari kamera berhasil diambil',
            style: AppFont.medium().copyWith(color: AppColor.putih100)),
        backgroundColor: AppColor.base100,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _ambilDariGaleri() async {
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _fotoBuktiDipilih = true);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Foto dari galeri berhasil dipilih',
            style: AppFont.medium().copyWith(color: AppColor.putih100)),
        backgroundColor: AppColor.base100,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _selesaikanPenjemputan() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() => _isLoading = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Penjemputan Berhasil Diselesaikan!',
            style: AppFont.medium().copyWith(color: AppColor.putih100)),
        backgroundColor: AppColor.base100,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      appBar: AppBar(
        backgroundColor: AppColor.putihBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.font100),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Proses Penjemputan',
            style: AppFont.bold()
                .copyWith(fontSize: 18, color: AppColor.base100)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DetailCardWrapper(
                title: 'Rincian penjemputan',
                child: Column(
                  children: _rincianData.entries
                      .map((e) =>
                          DetailDataRow(label: e.key, value: e.value))
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
              DetailCardWrapper(
                title: 'Catatan Pelanggan',
                child: Text(_catatanPelanggan,
                    style: AppFont.regular()
                        .copyWith(fontSize: 14, color: AppColor.font80)),
              ),
              const SizedBox(height: 16),
              DetailCardWrapper(
                title: 'Rincian Sampah',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(_fotoSampahUrl,
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                              width: double.infinity,
                              height: 150,
                              color: AppColor.base20,
                              child: const Icon(Icons.image,
                                  size: 50, color: AppColor.font60))),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('jenis sampah',
                                style: AppFont.bold().copyWith(
                                    fontSize: 14, color: AppColor.font100)),
                            Text(_jenisSampah,
                                style: AppFont.regular().copyWith(
                                    fontSize: 14, color: AppColor.font80)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Berat Sampah',
                                style: AppFont.bold().copyWith(
                                    fontSize: 14, color: AppColor.font100)),
                            Text(_beratSampah,
                                style: AppFont.regular().copyWith(
                                    fontSize: 14, color: AppColor.font80)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildUploadCard(),
              const SizedBox(height: 24),
              AsyncButton(
                text: 'Selesaikan Penjemputan',
                isLoading: _isLoading,
                onPressed: _selesaikanPenjemputan,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadCard() {
    return DetailCardWrapper(
      title: 'Selesaikan Penjemputan',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tambahkan',
              style: AppFont.semibold()
                  .copyWith(fontSize: 14, color: AppColor.font100)),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColor.putihBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColor.font60),
            ),
            child: Column(
              children: [
                Icon(
                    _fotoBuktiDipilih
                        ? Icons.check_circle
                        : Icons.image_outlined,
                    size: 48,
                    color: _fotoBuktiDipilih
                        ? AppColor.base100
                        : AppColor.font60),
                const SizedBox(height: 10),
                Text(
                    _fotoBuktiDipilih
                        ? 'Foto Bukti Sudah Dipilih'
                        : 'Upload Bukti Penjemputan Anda',
                    style: AppFont.regular()
                        .copyWith(fontSize: 13, color: AppColor.font80)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.base100,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                      icon: const Icon(Icons.camera_alt,
                          color: AppColor.putih100, size: 18),
                      label: Text('Kamera',
                          style: AppFont.semibold().copyWith(
                              fontSize: 13, color: AppColor.putih100)),
                      onPressed: _ambilDariKamera,
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: AppColor.base100, width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                      icon: const Icon(Icons.photo_library,
                          color: AppColor.base100, size: 18),
                      label: Text('Galeri',
                          style: AppFont.semibold().copyWith(
                              fontSize: 13, color: AppColor.base100)),
                      onPressed: _ambilDariGaleri,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          WTextFieldPutih(
            label: 'Tambahkan',
            hintText: 'Berat Sampah',
            controller: _beratController,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}
