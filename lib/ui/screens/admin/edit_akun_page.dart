import 'package:flutter/material.dart';
import 'package:frontend_ambilin/models/akun_pengguna.dart';
import 'package:frontend_ambilin/ui/widgets/w_button.dart';
import 'package:frontend_ambilin/ui/widgets/w_text_fields.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';

class EditAkunPage extends StatefulWidget {
  final AkunPengguna user;

  const EditAkunPage({super.key, required this.user});

  @override
  State<EditAkunPage> createState() => _EditAkunPageState();
}

class _EditAkunPageState extends State<EditAkunPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late final TextEditingController _namaController;
  late final TextEditingController _emailController;
  late final TextEditingController _teleponController;

  @override
  void initState() {
    super.initState();
    // Pre-fill data dari user yang dipilih
    _namaController = TextEditingController(text: widget.user.nama);
    _emailController = TextEditingController(text: widget.user.email);
    _teleponController = TextEditingController();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    super.dispose();
  }

  void _handleSimpan() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement update logic via API
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Akun berhasil diperbarui')),
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
                // --- Header: Back + Judul ---
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.chevron_left,
                        size: 35,
                        color: AppColor.font100,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Edit Pengguna',
                      style: AppFont.bold().copyWith(
                        fontSize: 22,
                        color: AppColor.font100,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

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
    );
  }
}
