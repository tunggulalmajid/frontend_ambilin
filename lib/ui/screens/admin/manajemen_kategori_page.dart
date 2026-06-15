import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend_ambilin/models/jenis_sampah.dart';
import 'package:frontend_ambilin/providers/waste_category_provider.dart';
import 'package:frontend_ambilin/ui/widgets/kategori_sampah_item.dart';
import 'package:frontend_ambilin/ui/widgets/navbar.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';

class ManajemenKategoriPage extends StatefulWidget {
  const ManajemenKategoriPage({super.key});

  @override
  State<ManajemenKategoriPage> createState() => _ManajemenKategoriPageState();
}

class _ManajemenKategoriPageState extends State<ManajemenKategoriPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    Future.microtask(() {
      _fetchData();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (_hasMore && !_isFetchingMore && !context.read<WasteCategoryProvider>().isLoading) {
        _loadMoreData();
      }
    }
  }

  void _fetchData() {
    _currentPage = 1;
    _hasMore = true;
    _isFetchingMore = false;
    context.read<WasteCategoryProvider>().fetchCategories(page: 1, limit: 10, isLoadMore: false);
  }

  Future<void> _loadMoreData() async {
    if (_isFetchingMore) return;
    setState(() {
      _isFetchingMore = true;
    });

    _currentPage++;
    final provider = context.read<WasteCategoryProvider>();
    final int beforeCount = provider.categories.length;
    await provider.fetchCategories(page: _currentPage, limit: 10, isLoadMore: true);
    final int afterCount = provider.categories.length;

    if (mounted) {
      setState(() {
        _isFetchingMore = false;
        if (afterCount == beforeCount) {
          _hasMore = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<WasteCategoryProvider>();

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColor.base100,
          onRefresh: () async => _fetchData(),
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                Text(
                  'Manajemen Poin & Kategori',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: AppColor.base100,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kelola kategori sampah, nilai poin, and konversi voucher diskon.',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColor.font80,
                  ),
                ),
                const SizedBox(height: 24),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColor.font60),
                  ),
                  child: categoryProvider.isLoading && _currentPage == 1
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: CircularProgressIndicator(
                              color: AppColor.base100,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: categoryProvider.categories.length,
                          itemBuilder: (context, index) {
                            final category = categoryProvider.categories[index];
                            return KategoriSampahItem(
                              nama: category.nama,
                              poin: category.poinPerKg,
                              onEdit: () {
                                _showEditCategoryDialog(context, category, index);
                              },
                              onDelete: () {
                                _showDeleteConfirmation(context, index);
                              },
                            );
                          },
                        ),
                ),
                if (_isFetchingMore)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColor.base100),
                    ),
                  ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCategoryDialog(context);
        },
        backgroundColor: AppColor.base100,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
      bottomNavigationBar: const AdminNavBar(currentIndex: 3),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final namaController = TextEditingController();
    final poinController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Tambah Kategori Baru',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColor.font100,
            ),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: namaController,
                  decoration: InputDecoration(
                    labelText: 'Nama Kategori',
                    labelStyle: GoogleFonts.poppins(fontSize: 14, color: AppColor.font80),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColor.font60),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColor.base100, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama kategori tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: poinController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Poin',
                    labelStyle: GoogleFonts.poppins(fontSize: 14, color: AppColor.font80),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColor.font60),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColor.base100, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Poin tidak boleh kosong';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Poin harus berupa angka';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColor.font80,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final nama = namaController.text.trim();
                  final poin = int.parse(poinController.text.trim());
                  context.read<WasteCategoryProvider>().addCategory(
                        JenisSampah(idJenisSampah: 0, nama: nama, poinPerKg: poin),
                      );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Center(child: Text('Kategori Berhasil Ditambahkan')),
                      backgroundColor: AppColor.base100,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.base100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Simpan',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditCategoryDialog(BuildContext context, JenisSampah category, int index) {
    final namaController = TextEditingController(text: category.nama);
    final poinController = TextEditingController(text: category.poinPerKg.toString());
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Ubah Kategori',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColor.font100,
            ),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: namaController,
                  decoration: InputDecoration(
                    labelText: 'Nama Kategori',
                    labelStyle: GoogleFonts.poppins(fontSize: 14, color: AppColor.font80),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColor.font60),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColor.base100, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama kategori tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: poinController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Poin',
                    labelStyle: GoogleFonts.poppins(fontSize: 14, color: AppColor.font80),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColor.font60),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColor.base100, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Poin tidak boleh kosong';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Poin harus berupa angka';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColor.font80,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final nama = namaController.text.trim();
                  final poin = int.parse(poinController.text.trim());
                  context.read<WasteCategoryProvider>().editCategory(
                        index,
                        JenisSampah(
                            idJenisSampah: category.idJenisSampah,
                            nama: nama,
                            poinPerKg: poin),
                      );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Center(child: Text('Kategori Berhasil Diperbarui')),
                      backgroundColor: AppColor.base100,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.base100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Simpan',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Hapus Kategori',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColor.font100,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus kategori ini?',
            style: GoogleFonts.poppins(fontSize: 14, color: AppColor.font100),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColor.font80,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<WasteCategoryProvider>().deleteCategory(index);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Center(child: Text('Kategori Berhasil Dihapus')),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Hapus',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
