import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';
import '../../widgets/w_text_fields.dart';
import '../../widgets/profile_header.dart';
import '../../widgets/async_button.dart';

class PelangganUbahPasswordPage extends StatefulWidget {
  const PelangganUbahPasswordPage({super.key});

  @override
  State<PelangganUbahPasswordPage> createState() =>
      _PelangganUbahPasswordPageState();
}

class _PelangganUbahPasswordPageState extends State<PelangganUbahPasswordPage> {
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

  Future<void> _simpanPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.updatePassword(
        passwordLama: _passwordLamaController.text,
        passwordBaru: _passwordBaruController.text,
        konfirmasiPassword: _konfirmasiPasswordController.text,
      );

      setState(() => _isLoading = false);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Password berhasil diubah',
              style: AppFont.medium().copyWith(color: AppColor.putih100),
            ),
            backgroundColor: AppColor.base100,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authProvider.errorMessage.isNotEmpty
                  ? authProvider.errorMessage
                  : 'Gagal memperbarui password',
              style: AppFont.medium().copyWith(color: AppColor.putih100),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Terjadi kesalahan: $e',
            style: AppFont.medium().copyWith(color: AppColor.putih100),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeaderSimple(
              backgroundUrl:
                  'https://images.unsplash.com/photo-1518780664697-55e3ad937233?w=800&auto=format&fit=crop',
              onBackPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 30),

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
                        if (v == null || v.isEmpty)
                          return 'Password baru wajib diisi';
                        if (v.length < 6) return 'Minimal 6 karakter';
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    WPasswordField(
                      label: 'Konfirmasi Password Baru',
                      hintText: 'Konfirmasi Password Baru',
                      controller: _konfirmasiPasswordController,
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Konfirmasi wajib diisi';
                        if (v != _passwordBaruController.text)
                          return 'Password tidak cocok';
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
