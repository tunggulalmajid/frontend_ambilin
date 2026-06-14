import 'package:flutter/material.dart';
import 'package:frontend_ambilin/models/jenis_sampah.dart';
import 'package:frontend_ambilin/providers/waste_category_provider.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';
import 'package:provider/provider.dart';

class ManajemenKategoriPage extends StatefulWidget {
  const ManajemenKategoriPage({super.key});

  @override
  State<ManajemenKategoriPage> createState() => _ManajemenKategoriPageState();
}

class _ManajemenKategoriPageState extends State<ManajemenKategoriPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<WasteCategoryProvider>().fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<WasteCategoryProvider>();

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // --- Header: Back + Judul + Subtitle ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Icon(
                        Icons.chevron_left,
                        size: 35,
                        color: AppColor.font100,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kategori Sampah',
                          style: AppFont.bold().copyWith(
                            fontSize: 24,
                            color: AppColor.font100,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Kelola jenis sampah dan poin per kg',
                          style: AppFont.regular().copyWith(
                            fontSize: 13,
                            color: AppColor.font80,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- Daftar Kategori dari Provider ---
              if (categoryProvider.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: CircularProgressIndicator(
                      color: AppColor.base100,
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categoryProvider.categories.length,
                  separatorBuilder: (context, index) =>
                      Divider(color: AppColor.font60.withOpacity(0.5), height: 1),
                  itemBuilder: (context, index) {
                    return _buildCategoryItem(categoryProvider.categories[index], index);
                  },
                ),

              const SizedBox(height: 80), // space for FAB
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCategoryDialog(context);
        },
        backgroundColor: AppColor.base100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.add,
          color: AppColor.putih100,
          size: 30,
        ),
      ),
    );
  }

  // --------------------------------------------------
  // Item Kategori Sampah
  // --------------------------------------------------
  Widget _buildCategoryItem(JenisSampah category, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          // Nama + Poin
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.nama,
                  style: AppFont.semibold().copyWith(
                    fontSize: 15,
                    color: AppColor.font100,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${category.poinPerKg} poin/kg',
                  style: AppFont.regular().copyWith(
                    fontSize: 12,
                    color: AppColor.font80,
                  ),
                ),
              ],
            ),
          ),

          // Titik 3 menu
          GestureDetector(
            onTap: () => _showCategoryMenu(context, category, index),
            child: const Icon(
              Icons.more_vert,
              color: AppColor.font80,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // Menu Bottom Sheet untuk kategori
  // --------------------------------------------------
  void _showCategoryMenu(BuildContext context, JenisSampah category, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: Text(
                    'Edit Kategori',
                    style: AppFont.medium().copyWith(fontSize: 14),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showEditCategoryDialog(context, category, index);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFD32F2F),
                  ),
                  title: Text(
                    'Hapus Kategori',
                    style: AppFont.medium().copyWith(
                      fontSize: 14,
                      color: const Color(0xFFD32F2F),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<WasteCategoryProvider>().deleteCategory(index);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --------------------------------------------------
  // Dialog Tambah Kategori
  // --------------------------------------------------
  void _showAddCategoryDialog(BuildContext context) {
    final namaController = TextEditingController();
    final poinController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Tambah Kategori',
            style: AppFont.bold().copyWith(
              fontSize: 18,
              color: AppColor.font100,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: InputDecoration(
                  labelText: 'Nama Kategori',
                  labelStyle: AppFont.regular().copyWith(
                    fontSize: 14,
                    color: AppColor.font80,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColor.font60),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColor.base100, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: poinController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Poin per Kg',
                  labelStyle: AppFont.regular().copyWith(
                    fontSize: 14,
                    color: AppColor.font80,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColor.font60),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColor.base100, width: 2),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: AppFont.medium().copyWith(
                  fontSize: 14,
                  color: AppColor.font80,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final nama = namaController.text.trim();
                final poin = int.tryParse(poinController.text.trim()) ?? 0;
                if (nama.isNotEmpty && poin > 0) {
                  context.read<WasteCategoryProvider>().addCategory(
                    JenisSampah(idJenisSampah: 0, nama: nama, poinPerKg: poin),
                  );
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.base100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Simpan',
                style: AppFont.semibold().copyWith(
                  fontSize: 14,
                  color: AppColor.putih100,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // --------------------------------------------------
  // Dialog Edit Kategori
  // --------------------------------------------------
  void _showEditCategoryDialog(BuildContext context, JenisSampah category, int index) {
    final namaController = TextEditingController(text: category.nama);
    final poinController =
        TextEditingController(text: category.poinPerKg.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Edit Kategori',
            style: AppFont.bold().copyWith(
              fontSize: 18,
              color: AppColor.font100,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: InputDecoration(
                  labelText: 'Nama Kategori',
                  labelStyle: AppFont.regular().copyWith(
                    fontSize: 14,
                    color: AppColor.font80,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColor.font60),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColor.base100, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: poinController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Poin per Kg',
                  labelStyle: AppFont.regular().copyWith(
                    fontSize: 14,
                    color: AppColor.font80,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColor.font60),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColor.base100, width: 2),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: AppFont.medium().copyWith(
                  fontSize: 14,
                  color: AppColor.font80,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final nama = namaController.text.trim();
                final poin = int.tryParse(poinController.text.trim()) ?? 0;
                if (nama.isNotEmpty && poin > 0) {
                  context.read<WasteCategoryProvider>().editCategory(
                    index,
                    JenisSampah(idJenisSampah: category.idJenisSampah, nama: nama, poinPerKg: poin),
                  );
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.base100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Simpan',
                style: AppFont.semibold().copyWith(
                  fontSize: 14,
                  color: AppColor.putih100,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
