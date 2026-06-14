
import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';
import '../../widgets/w_text_fields.dart';
import '../../widgets/profile_header.dart';
import '../../widgets/async_button.dart';

class PelangganEditProfilPage extends StatefulWidget {
  final UserModel user;
  const PelangganEditProfilPage({super.key, required this.user});

  @override
  State<PelangganEditProfilPage> createState() => _PelangganEditProfilPageState();
}

class _PelangganEditProfilPageState extends State<PelangganEditProfilPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _teleponController;
  late TextEditingController _alamatController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.user.nama);
    _emailController = TextEditingController(text: widget.user.email);
    _teleponController = TextEditingController(text: widget.user.nomorTelepon ?? '');
    _alamatController = TextEditingController(text: widget.user.alamat ?? '');
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  Future<void> _simpanProfil() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 1200));

    setState(() => _isLoading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profil berhasil diperbarui', style: AppFont.medium().copyWith(color: AppColor.putih100)),
        backgroundColor: AppColor.base100,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final inisial = widget.user.nama.isNotEmpty ? widget.user.nama[0].toUpperCase() : '?';

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [

            ProfileHeaderEdit(
              backgroundUrl: 'https://images.unsplash.com/photo-1518780664697-55e3ad937233?w=800&auto=format&fit=crop',
              inisial: inisial,
              onBackPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 65),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    WTextFieldPutih(
                      label: 'Nama Lengkap',
                      hintText: 'Masukkan nama',
                      controller: _namaController,
                      validator: (v) => (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
                    ),
                    const SizedBox(height: 18),
                    WTextFieldPutih(
                      label: 'Email',
                      hintText: 'email@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => (v == null || !v.contains('@')) ? 'Email tidak valid' : null,
                    ),
                    const SizedBox(height: 18),
                    WTextFieldPutih(
                      label: 'No. Telepon',
                      hintText: 'Masukkan Nomor Telepon',
                      controller: _teleponController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 18),
                    WTextFieldPutih(
                      label: 'Alamat',
                      hintText: 'Masukkan Alamat',
                      controller: _alamatController,
                    ),
                    const SizedBox(height: 30),

                    AsyncButton(
                      text: 'Simpan',
                      isLoading: _isLoading,
                      onPressed: _simpanProfil,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
