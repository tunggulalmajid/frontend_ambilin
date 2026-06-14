// ----- FILE: petugas_ubah_password_page.dart -----
import 'package:flutter/material.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';
import '../../widgets/w_text_fields.dart';
import '../../widgets/profile_header.dart';
import '../../widgets/async_button.dart';

class PetugasUbahPasswordPage extends StatefulWidget {
  const PetugasUbahPasswordPage({super.key});

  @override
  State<PetugasUbahPasswordPage> createState() =>
      _PetugasUbahPasswordPageState();
}

class _PetugasUbahPasswordPageState extends State<PetugasUbahPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _passwordLamaController = TextEditingController();
  final _passwordBaruController = TextEditingController();
  final _konfirmasiPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordLamaController.dispose();
    _passwordBaruController.dispose();
    _konfirmasiPasswordController.dispose();
    super.dispose();
  }

  /// Fungsi async simulasi ubah password ke server.
  Future<void> _simpanPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulasi proses hit ke server API (1.2 detik)
    await Future.delayed(const Duration(milliseconds: 1200));

    setState(() => _isLoading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Kata sandi petugas berhasil diubah',
          style: AppFont.medium().copyWith(color: AppColor.putih100),
        ),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ========== Header Background Truk ==========
            ProfileHeaderSimple(
              backgroundUrl: 'https://images.unsplash.com/photo-1601584115197-04ecc0da31d7?w=800&auto=format&fit=crop',
              onBackPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 30),

            // ========== Form Ubah Password ==========
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    WPasswordField(
                      label: 'Password lama',
                      hintText: 'Masukkan Password Lama',
                      controller: _passwordLamaController,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Password lama wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 18),

                    WPasswordField(
                      label: 'Password Baru',
                      hintText: 'Masukkan Password Baru',
                      controller: _passwordBaruController,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Password baru wajib diisi';
                        }
                        if (v.length < 6) return 'Minimal 6 karakter';
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),

                    WPasswordField(
                      label: 'Password Baru',
                      hintText: 'Konfirmasi Password Baru',
                      controller: _konfirmasiPasswordController,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Konfirmasi wajib diisi';
                        }
                        if (v != _passwordBaruController.text) {
                          return 'Password tidak cocok';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    AsyncButton(
                      text: 'Simpan',
                      isLoading: _isLoading,
                      onPressed: _simpanPassword,
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
