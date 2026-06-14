import 'package:flutter/material.dart';
import 'package:frontend_ambilin/ui/widgets/w_button.dart';
import 'package:frontend_ambilin/ui/widgets/w_text_fields.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';

class TambahAkunPage extends StatefulWidget {
  const TambahAkunPage({super.key});

  @override
  State<TambahAkunPage> createState() => _TambahAkunPageState();
}

class _TambahAkunPageState extends State<TambahAkunPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _teleponController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasiPasswordController = TextEditingController();

  String? _selectedTipeUser;
  final List<String> _tipeUserList = ['Petugas', 'Pelanggan'];

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    _passwordController.dispose();
    _konfirmasiPasswordController.dispose();
    super.dispose();
  }

  void _handleSimpan() {
    if (_formKey.currentState!.validate()) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Akun berhasil ditambahkan')),
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
                        'Tambah Pengguna',
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
                const SizedBox(height: 24),

                WDropdownField(
                  label: 'Tipe User',
                  hintText: 'Pilih tipe user',
                  value: _selectedTipeUser,
                  items: _tipeUserList,
                  onChanged: (value) {
                    setState(() {
                      _selectedTipeUser = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Pilih tipe user';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

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