import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend_ambilin/models/user_model.dart';
import 'package:frontend_ambilin/providers/auth_provider.dart';
import 'package:frontend_ambilin/ui/widgets/w_text_fields.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';

class EditProfileAdminPage extends StatefulWidget {
  final UserModel user;
  const EditProfileAdminPage({super.key, required this.user});

  @override
  State<EditProfileAdminPage> createState() => _EditProfileAdminPageState();
}

class _EditProfileAdminPageState extends State<EditProfileAdminPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _teleponController;
  late TextEditingController _alamatController;

  bool _isLoading = false;

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

  Future<void> _changeProfilePhoto() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
      );
      if (image == null) return;

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mengunggah foto profil...'),
          duration: Duration(seconds: 2),
        ),
      );

      final success = await context.read<AuthProvider>().updateProfilePhoto(image.path);
      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto profil berhasil diperbarui!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final errMsg = context.read<AuthProvider>().errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errMsg.isNotEmpty ? errMsg : 'Gagal memperbarui foto profil'),
            backgroundColor: AppColor.redAllert,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih gambar: $e'),
          backgroundColor: AppColor.redAllert,
        ),
      );
    }
  }

  Future<void> _handleSimpan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.updateProfile(
        nama: _namaController.text,
        email: _emailController.text,
        nomorTelepon: _teleponController.text,
        alamat: _alamatController.text,
        latitude: widget.user.latitude,
        longitude: widget.user.longitude,
      );

      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profil berhasil diperbarui', style: AppFont.medium().copyWith(color: AppColor.putih100)),
            backgroundColor: AppColor.base100,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authProvider.errorMessage.isNotEmpty ? authProvider.errorMessage : 'Gagal memperbarui profil',
              style: AppFont.medium().copyWith(color: AppColor.putih100),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e', style: AppFont.medium().copyWith(color: AppColor.putih100)),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final currentUser = auth.user ?? widget.user;

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: Column(
        children: [

          _buildHeader(context, currentUser),

          const SizedBox(height: 55),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

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

                    WTextFieldPutih(
                      label: 'Alamat',
                      hintText: 'Masukkan Alamat',
                      controller: _alamatController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Alamat tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.base100,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _isLoading ? null : _handleSimpan,
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                'Simpan',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                      ),
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

  Widget _buildHeader(BuildContext context, UserModel currentUser) {
    final String? fotoUrl = currentUser.foto != null && currentUser.foto!.isNotEmpty
        ? (currentUser.foto!.startsWith('http')
            ? currentUser.foto
            : 'https://ambilin.kodetalma.my.id/${currentUser.foto!.startsWith('/') ? currentUser.foto!.substring(1) : currentUser.foto}')
        : null;

    final String inisial = currentUser.nama.isNotEmpty ? currentUser.nama[0].toUpperCase() : 'R';

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 180,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/gambar_profile.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: Colors.black.withOpacity(0.45),
          ),
        ),

        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_left,
                color: AppColor.putih100,
                size: 24,
              ),
            ),
          ),
        ),

        Positioned(
          bottom: -45,
          child: GestureDetector(
            onTap: _changeProfilePhoto,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFFFFCDD2),
                  backgroundImage: fotoUrl != null ? NetworkImage(fotoUrl) : null,
                  child: fotoUrl == null
                      ? Text(
                          inisial,
                          style: AppFont.bold().copyWith(
                            fontSize: 36,
                            color: AppColor.redAllert,
                          ),
                        )
                      : null,
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: AppColor.putih100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 15,
                      color: AppColor.redAllert,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
