import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/setor_sampah.dart';
import '../../../models/jenis_sampah.dart';
import '../../../providers/pickup_history_provider.dart';
import '../../../providers/waste_category_provider.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';
import '../../../utils/app_routes.dart';
import '../../widgets/w_text_fields.dart';
import '../../widgets/detail_card_wrapper.dart';
import '../../widgets/async_button.dart';
import '../../widgets/zoomable_image_dialog.dart';

class PetugasProsesPenjemputanPage extends StatefulWidget {
  final SetorSampah data;
  const PetugasProsesPenjemputanPage({super.key, required this.data});

  @override
  State<PetugasProsesPenjemputanPage> createState() =>
      _PetugasProsesPenjemputanPageState();
}

class _PetugasProsesPenjemputanPageState
    extends State<PetugasProsesPenjemputanPage> {
  final _formKey = GlobalKey<FormState>();
  final _beratController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? _fotoBukti;
  bool _isLoading = false;

  @override
  void dispose() {
    _beratController.dispose();
    super.dispose();
  }

  Future<void> _ambilDariKamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1200,
      );

      if (photo == null) return;
      if (!mounted) return;

      setState(() {
        _fotoBukti = File(photo.path);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Foto bukti berhasil diambil!',
            style: AppFont.medium().copyWith(color: AppColor.putih100),
          ),
          backgroundColor: AppColor.base100,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil foto: $e'),
          backgroundColor: AppColor.redAllert,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _ambilDariGaleri() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1200,
      );

      if (image == null) return;
      if (!mounted) return;

      setState(() {
        _fotoBukti = File(image.path);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Foto bukti berhasil dipilih!',
            style: AppFont.medium().copyWith(color: AppColor.putih100),
          ),
          backgroundColor: AppColor.base100,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih gambar: $e'),
          backgroundColor: AppColor.redAllert,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _selesaikanPenjemputan() async {
    if (!_formKey.currentState!.validate()) return;

    if (_fotoBukti == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Wajib mengunggah foto bukti penjemputan.',
            style: AppFont.medium().copyWith(color: AppColor.putih100),
          ),
          backgroundColor: AppColor.redAllert,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final double? berat = double.tryParse(_beratController.text.trim());
    if (berat == null || berat <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Input berat sampah tidak valid.',
            style: AppFont.medium().copyWith(color: AppColor.putih100),
          ),
          backgroundColor: AppColor.redAllert,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await context.read<PickupHistoryProvider>().completePickup(
      id: widget.data.idSetorSampah,
      beratSampah: berat,
      imagePath: _fotoBukti!.path,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Penjemputan Berhasil Diselesaikan!',
            style: AppFont.medium().copyWith(color: AppColor.putih100),
          ),
          backgroundColor: AppColor.base100,
          behavior: SnackBarBehavior.floating,
        ),
      );

      context.read<PickupHistoryProvider>().fetchActiveOrders();
      context.read<PickupHistoryProvider>().fetchPickupHistory(roleId: 2);

      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      final error = context.read<PickupHistoryProvider>().errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.isNotEmpty ? error : 'Gagal menyelesaikan penjemputan.',
            style: AppFont.medium().copyWith(color: AppColor.putih100),
          ),
          backgroundColor: AppColor.redAllert,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final categoryProvider = context.watch<WasteCategoryProvider>();

    String getJenisSampahName(int? id) {
      if (id == null)
        return data.namaJenisSampah.isNotEmpty ? data.namaJenisSampah : '-';
      final cat = categoryProvider.categories.firstWhere(
        (element) => element.idJenisSampah == id,
        orElse: () => JenisSampah(
          idJenisSampah: id,
          nama: data.namaJenisSampah.isNotEmpty
              ? data.namaJenisSampah
              : 'Jenis Sampah #$id',
          poinPerKg: data.poinPerKg ?? 0,
        ),
      );
      return cat.nama;
    }

    String tanggalText = '-';
    if (data.createdAt != null) {
      final d = data.createdAt!;
      final months = [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember',
      ];
      tanggalText =
          '${d.day} ${months[d.month - 1]} ${d.year}, ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
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
        title: Text(
          'Proses Penjemputan',
          style: AppFont.bold().copyWith(fontSize: 18, color: AppColor.base100),
        ),
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
                  children: [
                    DetailDataRow(
                      label: 'Nama Pelanggan',
                      value: data.customerName.isNotEmpty
                          ? data.customerName
                          : '-',
                    ),
                    DetailDataRow(label: 'Status', value: 'Sedang Dijemput'),
                    DetailDataRow(label: 'Alamat', value: data.alamat ?? '-'),
                    DetailDataRow(label: 'Waktu Pengajuan', value: tanggalText),
                    DetailDataRow(
                      label: 'Petugas',
                      value: data.petugasName.isNotEmpty
                          ? data.petugasName
                          : '-',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              DetailCardWrapper(
                title: 'Catatan Pelanggan',
                child: Text(
                  data.pesanCustomer.isNotEmpty
                      ? data.pesanCustomer
                      : 'Tidak ada catatan tambahan.',
                  style: AppFont.regular().copyWith(
                    fontSize: 14,
                    color: AppColor.font80,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DetailCardWrapper(
                title: 'Rincian Sampah',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (data.foto != null && data.foto!.isNotEmpty)
                          ? () => ZoomableImageDialog.show(
                              context,
                              imageUrl: data.foto,
                            )
                          : null,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          data.foto ?? '',
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: double.infinity,
                            height: 150,
                            color: AppColor.base20,
                            child: const Icon(
                              Icons.image,
                              size: 50,
                              color: AppColor.font60,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jenis Sampah',
                              style: AppFont.bold().copyWith(
                                fontSize: 14,
                                color: AppColor.font100,
                              ),
                            ),
                            Text(
                              getJenisSampahName(data.idJenisSampah),
                              style: AppFont.regular().copyWith(
                                fontSize: 14,
                                color: AppColor.font80,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Berat Sampah',
                              style: AppFont.bold().copyWith(
                                fontSize: 14,
                                color: AppColor.font100,
                              ),
                            ),
                            Text(
                              '- kg',
                              style: AppFont.regular().copyWith(
                                fontSize: 14,
                                color: AppColor.font80,
                              ),
                            ),
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
    final bool _fotoBuktiDipilih = _fotoBukti != null;
    return DetailCardWrapper(
      title: 'Unggah Bukti Penjemputan',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Foto Timbangan / Sampah Terangkut',
            style: AppFont.semibold().copyWith(
              fontSize: 14,
              color: AppColor.font100,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColor.putihBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColor.font60),
            ),
            child: Column(
              children: [
                _fotoBuktiDipilih
                    ? GestureDetector(
                        onTap: () => ZoomableImageDialog.show(
                          context,
                          imageFile: _fotoBukti!,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _fotoBukti!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.image_outlined,
                        size: 48,
                        color: AppColor.font60,
                      ),
                const SizedBox(height: 10),
                Text(
                  _fotoBuktiDipilih
                      ? 'Foto Bukti Sudah Dipilih'
                      : 'Upload Bukti Penjemputan Anda',
                  style: AppFont.regular().copyWith(
                    fontSize: 13,
                    color: AppColor.font80,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.base100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      icon: const Icon(
                        Icons.camera_alt,
                        color: AppColor.putih100,
                        size: 18,
                      ),
                      label: Text(
                        'Kamera',
                        style: AppFont.semibold().copyWith(
                          fontSize: 13,
                          color: AppColor.putih100,
                        ),
                      ),
                      onPressed: _ambilDariKamera,
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColor.base100,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      icon: const Icon(
                        Icons.photo_library,
                        color: AppColor.base100,
                        size: 18,
                      ),
                      label: Text(
                        'Galeri',
                        style: AppFont.semibold().copyWith(
                          fontSize: 13,
                          color: AppColor.base100,
                        ),
                      ),
                      onPressed: _ambilDariGaleri,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          WTextFieldPutih(
            label: 'Input Berat Sampah (kg)',
            hintText: 'Contoh: 4.5',
            controller: _beratController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Berat sampah wajib diisi.';
              }
              if (double.tryParse(value.trim()) == null) {
                return 'Format angka tidak valid.';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
