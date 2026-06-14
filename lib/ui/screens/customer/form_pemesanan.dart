import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend_ambilin/providers/pickup_history_provider.dart';
import 'package:frontend_ambilin/providers/waste_category_provider.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';
import 'package:frontend_ambilin/utils/app_routes.dart';

class FormPemesanan extends StatefulWidget {
  const FormPemesanan({super.key});

  @override
  State<FormPemesanan> createState() => _FormPemesananState();
}

class _FormPemesananState extends State<FormPemesanan> {
  int? _selectedCategoryId;
  String? _selectedAddress;
  double? _latitude;
  double? _longitude;
  File? _fotoSampah;
  final ImagePicker _picker = ImagePicker();
  
  final TextEditingController _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<WasteCategoryProvider>().fetchCategories();
      }
    });
  }

  Future<void> _ambilDariKamera() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
      if (photo != null) {
        setState(() {
          _fotoSampah = File(photo.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: AppColor.redAllert),
      );
    }
  }

  Future<void> _ambilDariGaleri() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (image != null) {
        setState(() {
          _fotoSampah = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: AppColor.redAllert),
      );
    }
  }

  void _handleSubmit() async {
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('Pilih kategori sampah terlebih dahulu')),
          backgroundColor: AppColor.redAllert,
        ),
      );
      return;
    }

    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('Pilih lokasi penjemputan terlebih dahulu')),
          backgroundColor: AppColor.redAllert,
        ),
      );
      return;
    }

    if (_fotoSampah == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('Unggah foto sampah terlebih dahulu')),
          backgroundColor: AppColor.redAllert,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final pickupProvider = context.read<PickupHistoryProvider>();
    final success = await pickupProvider.addPickup(
      idJenisSampah: _selectedCategoryId!,
      alamat: _selectedAddress!,
      latitude: _latitude ?? 0.0,
      longitude: _longitude ?? 0.0,
      catatan: _notesController.text.trim(),
      imagePath: _fotoSampah!.path,
    );

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    if (success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Berhasil',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColor.base100),
            ),
            content: Text(
              'Penjemputan Sampah Berhasil Diajukan!',
              style: GoogleFonts.poppins(color: AppColor.font100),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // back to dashboard
                },
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColor.base100),
                ),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(child: Text(pickupProvider.errorMessage.isNotEmpty ? pickupProvider.errorMessage : 'Gagal mengajukan penjemputan sampah')),
          backgroundColor: AppColor.redAllert,
        ),
      );
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<WasteCategoryProvider>();

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
                'Penjemputan Sampah',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColor.base100,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Silahkan isi form berikut',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColor.font80,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Kategori Sampah',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColor.font100,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                isDense: true,
                hint: Text(
                  'Masukkan kategori sampah',
                  style: GoogleFonts.poppins(fontSize: 13, color: AppColor.font80),
                ),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                items: categoryProvider.categories.map((cat) {
                  return DropdownMenuItem<int>(
                    value: cat.idJenisSampah,
                    child: Text(
                      cat.nama,
                      style: GoogleFonts.poppins(fontSize: 13, color: AppColor.font100),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value;
                  });
                },
              ),
              const SizedBox(height: 18),
              Text(
                'Lokasi Penjemputan',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColor.font100,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColor.font60.withOpacity(0.5)),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: double.infinity,
                        height: 160,
                        color: const Color(0xFFF5F5F5),
                        child: FlutterMap(
                          key: ValueKey('${_latitude}_${_longitude}'),
                          options: MapOptions(
                            initialCenter: LatLng(_latitude ?? -8.1724, _longitude ?? 113.7005),
                            initialZoom: _latitude != null ? 15.0 : 12.0,
                            interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                              additionalOptions: const {
                                'User-Agent':
                                    'SeladakuApp_ByTunggulAbdulMajid_ClassOf2024_UNEJ',
                              },
                              userAgentPackageName: 'com.tunggul.seladaku',
                            ),
                            if (_latitude != null && _longitude != null)
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: LatLng(_latitude!, _longitude!),
                                    width: 40,
                                    height: 40,
                                    child: const Icon(
                                      Icons.location_on,
                                      color: AppColor.redAllert,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (_selectedAddress != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _selectedAddress!,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColor.font100,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.pushNamed(
                            context,
                            AppRoutes.pelangganPilihMap,
                          ) as Map<String, dynamic>?;

                          if (result != null) {
                            setState(() {
                              _selectedAddress = result['alamat'] as String?;
                              _latitude = result['latitude'] as double?;
                              _longitude = result['longitude'] as double?;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.base100,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.location_on, color: Colors.white, size: 18),
                        label: Text(
                          'Pilih Lokasi Penjemputan',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Pesan untuk Driver (opsional)',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColor.font100,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  hintText: 'Tambahkan Pesan',
                  hintStyle: GoogleFonts.poppins(fontSize: 13, color: AppColor.font80),
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
              ),
              const SizedBox(height: 18),
              Text(
                'Foto Sampah',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColor.font100,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColor.font60.withOpacity(0.5),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    _fotoSampah != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _fotoSampah!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.image_outlined,
                            size: 48,
                            color: AppColor.font80,
                          ),
                    const SizedBox(height: 8),
                    Text(
                      _fotoSampah != null
                          ? 'Foto Sampah Sudah Dipilih'
                          : 'Upload foto sampah Anda',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColor.font80,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _ambilDariKamera,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.base100,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            icon: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                            label: Text(
                              'Kamera',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _ambilDariGaleri,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColor.base100, width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(Icons.photo_library, color: AppColor.base100, size: 16),
                            label: Text(
                              'Galeri',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: AppColor.base100,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
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
                  onPressed: _isLoading ? null : _handleSubmit,
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
                          'Ajukan Penjemputan',
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
}
