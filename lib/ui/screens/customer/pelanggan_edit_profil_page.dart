import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../providers/auth_provider.dart';
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

      setState(() => _isLoading = false);

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
      setState(() => _isLoading = false);
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
    final inisial = currentUser.nama.isNotEmpty ? currentUser.nama[0].toUpperCase() : '?';

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [

            ProfileHeaderEdit(
              backgroundUrl: 'https://images.unsplash.com/photo-1518780664697-55e3ad937233?w=800&auto=format&fit=crop',
              inisial: inisial,
              fotoUrl: currentUser.foto != null && currentUser.foto!.isNotEmpty
                  ? (currentUser.foto!.startsWith('http')
                      ? currentUser.foto
                      : 'https://ambilin.kodetalma.my.id/${currentUser.foto!.startsWith('/') ? currentUser.foto!.substring(1) : currentUser.foto}')
                  : null,
              onBackPressed: () => Navigator.pop(context),
              onAvatarEditPressed: () async {
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
              },
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
                    WTextFieldPutih(
                      label: 'Email',
                      hintText: 'email@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(v)) return 'Format email tidak sesuai';
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    WTextFieldPutih(
                      label: 'No. Telepon',
                      hintText: 'Masukkan Nomor Telepon',
                      controller: _teleponController,
                      keyboardType: TextInputType.phone,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Nomor telepon wajib diisi' : null,
                    ),
                    const SizedBox(height: 18),
                    WTextFieldPutih(
                      label: 'Alamat',
                      hintText: 'Masukkan Alamat',
                      controller: _alamatController,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Alamat wajib diisi' : null,
                    ),
                    const SizedBox(height: 18),

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
