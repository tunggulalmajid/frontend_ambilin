import 'package:flutter/material.dart';
import 'package:frontend_ambilin/models/artikel.dart';
import 'package:frontend_ambilin/providers/article_provider.dart';
import 'package:frontend_ambilin/ui/widgets/w_button.dart';
import 'package:frontend_ambilin/ui/widgets/w_text_fields.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class TambahArtikelPage extends StatefulWidget {
  const TambahArtikelPage({super.key});

  @override
  State<TambahArtikelPage> createState() => _TambahArtikelPageState();
}

class _TambahArtikelPageState extends State<TambahArtikelPage> {
  final _formKey = GlobalKey<FormState>();

  final _judulController = TextEditingController();
  final _isiController = TextEditingController();

  String? _selectedKategori;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<ArticleProvider>().fetchCategories();
      }
    });
  }

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _handleSimpan() async {
    if (_formKey.currentState!.validate()) {
      final newArticle = Artikel(
        idArtikel: 0,
        idAdmin: 1,
        idJenisArtikel: 1,
        judul: _judulController.text,
        kategori: _selectedKategori ?? '',
        status: 'Aktif',
        createdAt: DateTime.now(),
        fotoThumbnail: '',
        isi: _isiController.text,
      );

      final success = await context.read<ArticleProvider>().addArticle(
        newArticle,
        imagePath: _selectedImage?.path,
      );

      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Artikel berhasil ditambahkan')),
        );
        Navigator.pop(context);
      } else {
        final error = context.read<ArticleProvider>().errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.isNotEmpty ? error : 'Gagal menambahkan artikel',
            ),
          ),
        );
      }
    }
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      '',
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
    return '${now.day} ${months[now.month]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final articleProvider = context.watch<ArticleProvider>();
    final List<String> kategoriList = articleProvider.categories
        .map((c) => c['nama']?.toString() ?? '')
        .where((n) => n.isNotEmpty)
        .toList();

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Center(
                      child: Text(
                        'Tambah Artikel',
                        style: AppFont.bold().copyWith(
                          fontSize: 22,
                          color: AppColor.font100,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.chevron_left,
                        size: 35,
                        color: AppColor.font100,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                WTextFieldPutih(
                  label: 'Judul Artikel',
                  hintText: 'Masukkan Judul',
                  controller: _judulController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Judul artikel tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                WDropdownField(
                  label: 'Kategori',
                  hintText: 'Pilih Kategori Artikel',
                  value: kategoriList.contains(_selectedKategori)
                      ? _selectedKategori
                      : null,
                  items: kategoriList,
                  onChanged: (value) {
                    setState(() {
                      _selectedKategori = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Pilih kategori artikel';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                Text(
                  'Foto Artikel',
                  style: AppFont.semibold().copyWith(
                    fontSize: 14,
                    color: AppColor.font100,
                  ),
                ),
                const SizedBox(height: 8),
                _buildImagePicker(),
                const SizedBox(height: 16),

                Text(
                  'Isi Artikel',
                  style: AppFont.semibold().copyWith(
                    fontSize: 14,
                    color: AppColor.font100,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _isiController,
                  maxLines: 6,
                  style: AppFont.regular().copyWith(
                    fontSize: 14,
                    color: AppColor.font100,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Isi artikel tidak boleh kosong';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Masukkan Isi Artikel',
                    hintStyle: AppFont.regular().copyWith(
                      fontSize: 14,
                      color: AppColor.font80,
                    ),
                    filled: true,
                    fillColor: AppColor.putih100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColor.font60),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColor.base100,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                WButton(text: 'Simpan', onPressed: _handleSimpan),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: AppColor.putih100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.font60),
        ),
        child: _selectedImage != null
            ? Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _selectedImage!,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImage = null;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: 48,
                    color: AppColor.font80.withOpacity(0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload Gambar Artikel',
                    style: AppFont.regular().copyWith(
                      fontSize: 13,
                      color: AppColor.font80,
                    ),
                  ),
                  const SizedBox(height: 12),

                  OutlinedButton.icon(
                    onPressed: _pickImage,
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
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
