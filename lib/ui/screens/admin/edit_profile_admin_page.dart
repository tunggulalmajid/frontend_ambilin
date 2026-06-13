import 'package:flutter/material.dart';
import 'package:frontend_ambilin/ui/widgets/w_button.dart';
import 'package:frontend_ambilin/ui/widgets/w_text_fields.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';

class EditProfileAdminPage extends StatefulWidget {
  const EditProfileAdminPage({super.key});

  @override
  State<EditProfileAdminPage> createState() => _EditProfileAdminPageState();
}

class _EditProfileAdminPageState extends State<EditProfileAdminPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _teleponController = TextEditingController();
  final _alamatController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasiPasswordController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    _alamatController.dispose();
    _passwordController.dispose();
    _konfirmasiPasswordController.dispose();
    super.dispose();
  }

  void _handleSimpan() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement update profile logic via API
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: Column(
        children: [
          // --- Green Header with Avatar ---
          _buildHeader(context),

          // --- Form Fields ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Nama Lengkap ---
                    WTextFieldPutih(
                      label: 'Nama Lengkap',
                      hintText: 'Masukkan nama',
                      controller: _namaController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama lengkap tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // --- Email ---
                    WTextFieldPutih(
                      label: 'Email',
                      hintText: 'email@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        if (!value.contains('@')) {
                          return 'Email tidak valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // --- No. Telepon ---
                    WTextFieldPutih(
                      label: 'No. Telepon',
                      hintText: 'Masukkan Nomor Telepon',
                      controller: _teleponController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor telepon tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // --- Alamat ---
                    WTextFieldPutih(
                      label: 'Alamat',
                      hintText: 'Masukkan Nomor Telepon',
                      controller: _alamatController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Alamat tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // --- Password ---
                    WPasswordField(
                      label: 'Password',
                      hintText: 'Masukkan Password',
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        if (value.length < 6) {
                          return 'Password minimal 6 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // --- Konfirmasi Password ---
                    WPasswordField(
                      label: 'Konfirmasi Password',
                      hintText: 'Konfirmasi Password',
                      controller: _konfirmasiPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Konfirmasi password tidak boleh kosong';
                        }
                        if (value != _passwordController.text) {
                          return 'Password tidak cocok';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // --- Simpan Button ---
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
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColor.base100,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColor.putih100,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: const Color(0xFFF4A0A0),// perlu diganti
                    child: Text(
                      'R', //perlu diganti
                      style: AppFont.bold().copyWith(
                        fontSize: 36,
                        color: AppColor.putih100,
                      ),
                    ),
                  ),
                  // Edit badge on avatar
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColor.font100,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColor.putih100,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: AppColor.putih100,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
