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

class EditArtikelPage extends StatefulWidget {
  final Artikel article;
  final int articleIndex;

  const EditArtikelPage({
    super.key,
    required this.article,
    required this.articleIndex,
  });

  @override
  State<EditArtikelPage> createState() => _EditArtikelPageState();
}

class _EditArtikelPageState extends State<EditArtikelPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _judulController;
  late final TextEditingController _isiController;

  String? _selectedKategori;
  final List<String> _kategoriList = [
    'Tips',
    'Edukasi',
    'Inspirasi',
    'Berita',
    'Pengelolaan',
  ];

  File? _selectedImage;
  String _existingImageUrl = '';
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    _judulController = TextEditingController(text: widget.article.judul);
    _isiController = TextEditingController(text: widget.article.isi);
    _selectedKategori = widget.article.kategori;
    _existingImageUrl = widget.article.fotoThumbnail ?? '';
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
        _existingImageUrl = '';
      });
    }
  }

  void _handleSimpan() {
    if (_formKey.currentState!.validate()) {
      final updatedArticle = Artikel(
        idArtikel: widget.article.idArtikel,
        idAdmin: widget.article.idAdmin,
        idJenisArtikel: widget.article.idJenisArtikel,
        judul: _judulController.text,
        kategori: _selectedKategori ?? widget.article.kategori,
        status: widget.article.status,
        createdAt: widget.article.createdAt,
        updatedAt: DateTime.now(),
        fotoThumbnail: _existingImageUrl,
        isi: _isiController.text,
      );

      context
          .read<ArticleProvider>()
          .editArticle(widget.articleIndex, updatedArticle);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Artikel berhasil diperbarui')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        'Edit Artikel',
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
                  value: _selectedKategori,
                  items: _kategoriList,
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
                  'Foto Sampah',
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
                  maxLines: 8,
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
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                WButton(
                  text: 'Simpan',
                  onPressed: _handleSimpan,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {

    if (_selectedImage != null) {
      return _buildImagePreview(
        child: Image.file(
          _selectedImage!,
          width: double.infinity,
          height: 180,
          fit: BoxFit.cover,
        ),
      );
    }

    if (_existingImageUrl.isNotEmpty) {
      return _buildImagePreview(
        child: Image.network(
          _existingImageUrl,
          width: double.infinity,
          height: 180,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 180,
              color: const Color(0xFFE0E0E0),
              child: const Center(
                child: Icon(
                  Icons.broken_image_outlined,
                  size: 48,
                  color: AppColor.font80,
                ),
              ),
            );
          },
        ),
      );
    }

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
        child: Column(
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

  Widget _buildImagePreview({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.font60),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: child,
          ),

          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedImage = null;
                  _existingImageUrl = '';
                });
              },
              child: Container(
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
          ),
        ],
      ),
    );
  }
}
