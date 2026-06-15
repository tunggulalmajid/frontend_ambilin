import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend_ambilin/models/akun_pengguna.dart';
import 'package:frontend_ambilin/services/user_management_service.dart';
import 'package:frontend_ambilin/providers/user_account_provider.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';

class AdminDetailPetugasPage extends StatefulWidget {
  final AkunPengguna user;
  const AdminDetailPetugasPage({super.key, required this.user});

  @override
  State<AdminDetailPetugasPage> createState() => _AdminDetailPetugasPageState();
}

class _AdminDetailPetugasPageState extends State<AdminDetailPetugasPage> {
  final _userService = UserManagementService();
  Map<String, dynamic>? _userDetail;
  bool _isLoadingDetail = true;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _loadUserDetail();
  }

  Future<void> _loadUserDetail() async {
    if (widget.user.idUser == null) {
      setState(() => _isLoadingDetail = false);
      return;
    }
    try {
      final res = await _userService.getAkunDetail(widget.user.idUser!);
      if (res['status'] == 'success') {
        setState(() {
          _userDetail = res['data'];
          _isLoadingDetail = false;
        });
      } else {
        setState(() => _isLoadingDetail = false);
      }
    } catch (e) {
      setState(() => _isLoadingDetail = false);
    }
  }

  void _handleHapusAkun() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Konfirmasi Hapus',
          style: AppFont.bold().copyWith(fontSize: 16),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus akun ini?',
          style: AppFont.regular().copyWith(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Batal', style: TextStyle(color: Colors.grey[600])),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isDeleting = true;
    });

    final success = await context.read<UserAccountProvider>().deleteUserById(
      widget.user.idUser!,
      2,
    );

    if (mounted) {
      setState(() {
        _isDeleting = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Akun Petugas Berhasil Dihapus'),
            backgroundColor: AppColor.redAllert,
          ),
        );
        Navigator.pop(context);
      } else {
        final err = context.read<UserAccountProvider>().errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err.isNotEmpty ? err : 'Gagal menghapus akun'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double headerHeight = 280;
    final inisial = widget.user.inisial;

    final String? foto = _userDetail?['foto'];
    final String? fotoUrl = foto != null && foto.isNotEmpty
        ? (foto.startsWith('http')
              ? foto
              : 'https://ambilin.kodetalma.my.id/${foto.startsWith('/') ? foto.substring(1) : foto}')
        : null;

    final String wilayahTugas = _userDetail?['alamat'] ?? '-';
    final String telepon =
        _userDetail?['nomor_telepon'] ?? widget.user.nomorTelepon ?? '-';

    final bool isAktif =
        _userDetail?['petugas_profile']?['is_aktif'] == 1 ||
        _userDetail?['petugas_profile']?['is_aktif'] == true;
    final String statusAkun = isAktif ? 'Aktif' : 'Nonaktif';

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: headerHeight,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1601584115197-04ecc0da31d7?w=800&auto=format&fit=crop',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(color: Colors.black.withOpacity(0.55)),
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
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: widget.user.warnaAvatar,
                        backgroundImage: fotoUrl != null
                            ? NetworkImage(fotoUrl)
                            : null,
                        child: fotoUrl == null
                            ? Text(
                                inisial,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 36,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.user.nama,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.user.email,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _isLoadingDetail
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: CircularProgressIndicator(
                          color: AppColor.base100,
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildInfoCard(
                              title: 'Wilayah Tugas / Alamat',
                              value: wilayahTugas,
                              icon: Icons.map_outlined,
                            ),
                            const SizedBox(width: 12),
                            _buildInfoCard(
                              title: 'Nomor Telepon',
                              value: telepon,
                              icon: Icons.phone_outlined,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC62828),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            onPressed: _isDeleting ? null : _handleHapusAkun,
                            child: _isDeleting
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    'Hapus Akun Petugas',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColor.font60.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColor.base100, size: 20),
            const Spacer(),
            Text(
              title,
              style: GoogleFonts.poppins(fontSize: 11, color: AppColor.font80),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColor.font100,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 13, color: AppColor.font80),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: AppColor.font100,
          ),
        ),
      ],
    );
  }
}
