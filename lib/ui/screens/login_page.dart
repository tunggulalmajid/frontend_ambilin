import 'package:flutter/material.dart';
import 'package:frontend_ambilin/ui/widgets/w_button.dart';
import 'package:frontend_ambilin/ui/widgets/w_text.dart';
import 'package:frontend_ambilin/ui/widgets/w_text_fields.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../providers/auth_provider.dart';
import '../../../models/login_request.dart';
import '../../../utils/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(

            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 60),
                Text(
                  "Log In",
                  style: GoogleFonts.poppins(
                    color: AppColor.base100,
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                ),
                Text(
                  "Selamat datang kembali!",
                  style: GoogleFonts.poppins(
                    color: AppColor.font100,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 50),

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

                const SizedBox(height: 20),

                WPasswordField(
                  label: 'Password',
                  hintText: "Masukkan password Anda",
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password tidak boleh kosong";
                    }
                    if (value.length < 6) {
                      return "Password minimal 6 karakter";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                WButton(
                  text: auth.isLoading ? "Loading..." : "Sign In",
                  onPressed: auth.isLoading
                      ? () {}
                      : () async {

                          if (_formKey.currentState!.validate()) {
                            final request = LoginRequest(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                            bool success = await auth.login(request);
                            _emailController.clear();
                            _passwordController.clear();

                            if (!context.mounted) return;
                            if (success) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoutes.main,
                                (route) => false,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Center(
                                    child: WText(
                                      isi: "Login Gagal",
                                      color: AppColor.putih100,
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: AppColor.font60,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "atau login dengan",
                        style: GoogleFonts.poppins(
                          color: AppColor.font80,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: AppColor.font60,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColor.font100,
                      surfaceTintColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: AppColor.font60, width: 1),
                      ),
                      elevation: 1,
                      shadowColor: Colors.black12,
                    ),
                    onPressed: auth.isLoading
                        ? () {}
                        : () async {
                            try {
                              final GoogleSignIn googleSignIn = GoogleSignIn();
                              final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
                              if (googleUser == null) {
                                return;
                              }
                              final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
                              final String? idToken = googleAuth.idToken;

                              if (idToken == null) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Center(
                                        child: Text("Gagal mendapatkan token dari Google"),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                                return;
                              }

                              bool success = await auth.loginWithGoogle(idToken);
                              if (!context.mounted) return;

                              if (success) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  AppRoutes.main,
                                  (route) => false,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(
                                      child: WText(
                                        isi: auth.errorMessage.isNotEmpty
                                            ? auth.errorMessage
                                            : "Login Google Gagal",
                                        color: AppColor.putih100,
                                      ),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(
                                      child: Text("Error: $e"),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://developers.google.com/static/identity/images/g-logo.png',
                          height: 24,
                          width: 24,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.login,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Login dengan Google",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColor.font100,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Belum punya akun? ",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: AppColor.font80,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.register),
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColor.base100,
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
    );
  }
}
