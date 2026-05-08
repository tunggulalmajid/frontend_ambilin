import 'package:flutter/material.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';

class FormPemesananPage extends StatefulWidget {
  const FormPemesananPage({super.key});

  @override
  State<FormPemesananPage> createState() => _FormPemesananPageState();
}

class _FormPemesananPageState extends State<FormPemesananPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _beratController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();

  final List<String> _kategoriOptions = [
    'Plastik',
    'Organik',
    'Kertas',
    'Elektronik',
    'Logam',
    'Kaca',
  ];
  final List<String> _selectedKategori = [];

  @override
  void dispose() {
    _beratController.dispose();
    _kategoriController.dispose();
    super.dispose();
  }

  void _showKategoriBottomSheet() {
    final List<String> tempSelected = List.from(_selectedKategori);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.putih100,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColor.font60,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    'Pilih Kategori Sampah',
                    style: AppFont.bold().copyWith(
                      fontSize: 18,
                      color: AppColor.font100,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Anda bisa memilih lebih dari satu',
                    style: AppFont.regular().copyWith(
                      fontSize: 12,
                      color: AppColor.font80,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._kategoriOptions.map((kategori) {
                    final isChecked = tempSelected.contains(kategori);
                    return CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColor.base100,
                      title: Text(
                        kategori,
                        style: AppFont.medium().copyWith(
                          fontSize: 14,
                          color: AppColor.font100,
                        ),
                      ),
                      value: isChecked,
                      onChanged: (val) {
                        setModalState(() {
                          if (val == true) {
                            tempSelected.add(kategori);
                          } else {
                            tempSelected.remove(kategori);
                          }
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedKategori
                            ..clear()
                            ..addAll(tempSelected);
                          _kategoriController.text =
                              _selectedKategori.join(', ');
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.base100,
                        foregroundColor: AppColor.putih100,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Konfirmasi',
                        style: AppFont.semibold().copyWith(
                          fontSize: 14,
                          color: AppColor.putih100,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      appBar: AppBar(
        backgroundColor: AppColor.putihBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColor.font100),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Penjemputan Sampah',
                  style: AppFont.bold().copyWith(
                    fontSize: 24,
                    color: AppColor.font100,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Isi formulir di bawah untuk mengajukan penjemputan sampah',
                  style: AppFont.regular().copyWith(
                    fontSize: 14,
                    color: AppColor.font80,
                  ),
                ),
                const SizedBox(height: 24),
                _buildLabel('Kategori Sampah'),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _showKategoriBottomSheet,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _kategoriController,
                      readOnly: true,
                      style: AppFont.regular().copyWith(
                        fontSize: 14,
                        color: AppColor.font100,
                      ),
                      decoration: _inputDecoration(
                        hint: 'Pilih kategori sampah',
                        suffixIcon: const Icon(
                          Icons.arrow_drop_down,
                          color: AppColor.font80,
                        ),
                      ),
                    ),
                  ),
                ),
                if (_selectedKategori.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: _selectedKategori.map((k) {
                      return Chip(
                        label: Text(
                          k,
                          style: AppFont.medium().copyWith(
                            fontSize: 12,
                            color: AppColor.base100,
                          ),
                        ),
                        backgroundColor: AppColor.base20,
                        deleteIcon: const Icon(
                          Icons.close,
                          size: 16,
                          color: AppColor.base100,
                        ),
                        onDeleted: () {
                          setState(() {
                            _selectedKategori.remove(k);
                            _kategoriController.text =
                                _selectedKategori.join(', ');
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: AppColor.base40),
                        ),
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 20),
                _buildLabel('Estimasi Berat (Kg)'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _beratController,
                  keyboardType: TextInputType.number,
                  style: AppFont.regular().copyWith(
                    fontSize: 14,
                    color: AppColor.font100,
                  ),
                  decoration: _inputDecoration(
                    hint: 'Masukkan estimasi berat',
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Text(
                        'Kg',
                        style: AppFont.semibold().copyWith(
                          fontSize: 14,
                          color: AppColor.font80,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildLabel('Lokasi Penjemputan'),
                const SizedBox(height: 8),
                
                Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    color: AppColor.base20.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColor.font60),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          size: 48,
                          color: AppColor.font80.withOpacity(0.5),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Peta Lokasi',
                          style: AppFont.regular().copyWith(
                            fontSize: 12,
                            color: AppColor.font80,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                    },
                    icon: const Icon(Icons.location_on, color: AppColor.putih100),
                    label: Text(
                      'Pilih Lokasi Penjemputan',
                      style: AppFont.semibold().copyWith(
                        fontSize: 14,
                        color: AppColor.putih100,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColor.base100,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildLabel('Foto Sampah'),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColor.putih100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColor.font60,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 40,
                        color: AppColor.font80.withOpacity(0.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Upload foto sampah anda',
                        style: AppFont.regular().copyWith(
                          fontSize: 12,
                          color: AppColor.font80,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                              },
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                size: 18,
                                color: AppColor.base100,
                              ),
                              label: Text(
                                'Kamera',
                                style: AppFont.medium().copyWith(
                                  fontSize: 13,
                                  color: AppColor.base100,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColor.base100),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                              },
                              icon: const Icon(
                                Icons.photo_library_outlined,
                                size: 18,
                                color: AppColor.base100,
                              ),
                              label: Text(
                                'Galeri',
                                style: AppFont.medium().copyWith(
                                  fontSize: 13,
                                  color: AppColor.base100,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColor.base100),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Penjemputan berhasil diajukan!',
                              style: AppFont.medium().copyWith(
                                fontSize: 14,
                                color: AppColor.putih100,
                              ),
                            ),
                            backgroundColor: AppColor.base100,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.base100,
                      foregroundColor: AppColor.putih100,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Ajukan Penjemputan',
                      style: AppFont.semibold().copyWith(
                        fontSize: 16,
                        color: AppColor.putih100,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppFont.semibold().copyWith(
        fontSize: 14,
        color: AppColor.font100,
      ),
    );
  }
  InputDecoration _inputDecoration({
    required String hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppFont.regular().copyWith(
        fontSize: 14,
        color: AppColor.font80,
      ),
      filled: true,
      fillColor: AppColor.putih100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      suffixIcon: suffixIcon,
      suffixIconConstraints: const BoxConstraints(minHeight: 24),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.font60),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.base100, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }
}
