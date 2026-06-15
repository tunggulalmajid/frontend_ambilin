import 'package:flutter/material.dart';
import 'package:frontend_ambilin/models/register_request.dart';
import 'package:frontend_ambilin/providers/auth_provider.dart';

import 'package:frontend_ambilin/ui/widgets/w_button.dart';
import 'package:frontend_ambilin/ui/widgets/w_text_fields.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _konfirmasiController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _konfirmasiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 60),
                      Text(
                        "Register",
                        style: GoogleFonts.poppins(
                          color: AppColor.base100,
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                        ),
                      ),
                      Text(
                        "Buat akun untuk melanjutkan",
                        style: GoogleFonts.poppins(
                          color: AppColor.font100,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 60),
                  WTextFieldPutih(
                    label: 'Nama Lengkap',
                    hintText: "Masukkan nama lengkap",
                    controller: _namaController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Nama tidak boleh kosong";
                      }
                      if (value.length < 4) {
                        return "Nama Tidak Boleh Kurang dari 4 karakter";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 22),
                  WTextFieldPutih(
                    label: 'Email',
                    hintText: "Masukkan email Anda",
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email tidak boleh kosong";
                      }
                      if (!value.contains("@")) {
                        return "Gunakan format email yang benar";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 22),
                  WPasswordField(
                    label: 'Password',
                    hintText: "Masukkan password",
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password tidak boleh kosong";
                      }
                      if (value.length < 8) {
                        return "Password Tidak Boleh Kurang dari 8 karakter";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 22),
                  WPasswordField(
                    label: 'Konfirmasi Password',
                    hintText: "Masukkan ulang password",
                    controller: _konfirmasiController,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return "Password Tidak Sama";
                      }
                      if (value == null || value.isEmpty) {
                        return "Konfirmasi Password tidak boleh kosong";
                      }
                      if (value.length < 8) {
                        return "Konfirmasi Password Tidak Boleh Kurang dari 8 karakter";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 22),
                  WButton(
                    text: auth.isLoading ? "Loading..." : "Sign Up",
                    onPressed: auth.isLoading
                        ? () {}
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final request = RegisterRequest(
                                nama: _namaController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                              );

                              bool success = await auth.register(request);

                              if (!context.mounted) return;
                              _namaController.clear();
                              _emailController.clear();
                              _passwordController.clear();
                              _konfirmasiController.clear();
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Registrasi Berhasil! Silakan Login",
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Center(
                                      child: Text(
                                        "Registrasi Gagal! Cek koneksi atau email sudah ada",
                                      ),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.login);
                        },
                        child: Text(
                          "Sign In",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
