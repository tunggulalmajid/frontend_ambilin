
import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import '../../../models/petugas.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';
import '../../widgets/profile_header.dart';
import '../../widgets/navbar.dart';
import 'petugas_edit_profil_page.dart';
import 'petugas_ubah_password_page.dart';

class PetugasProfilPage extends StatefulWidget {
  const PetugasProfilPage({super.key});

  @override
  State<PetugasProfilPage> createState() => _PetugasProfilPageState();
}

class _PetugasProfilPageState extends State<PetugasProfilPage> {

  late UserModel _user;
  late Petugas _petugas;

  @override
  void initState() {
    super.initState();
    _user = UserModel(
      idUser: 2,
      nama: 'Rafi Petugas',
      email: 'driver@gmail.com',
      idRole: 2,
      nomorTelepon: '080765423',
    );
    _petugas = const Petugas(
      idPetugas: 1,
      idUser: 2,
      isAktif: true,
      nama: 'Rafi Petugas',
      email: 'driver@gmail.com',
    );
  }

  @override
  Widget build(BuildContext context) {
    final inisial = _user.nama.isNotEmpty ? _user.nama[0].toUpperCase() : '?';

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [

            ProfileHeaderFull(
              backgroundUrl: 'https://images.unsplash.com/photo-1601584115197-04ecc0da31d7?w=800&auto=format&fit=crop',
              inisial: inisial,
              nama: _user.nama,
              email: _user.email,
              onBackPressed: () => Navigator.pop(context),
              onEditPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PetugasEditProfilPage(user: _user),
                  ),
                );
              },
            ),
            const SizedBox(height: 80),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColor.putih100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColor.font60),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rincian Profil',
                      style: AppFont.bold().copyWith(
                        fontSize: 18,
                        color: AppColor.base100,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ProfileInfoRow(
                      label: 'Nomor Telepon',
                      value: _user.nomorTelepon ?? '-',
                    ),
                    ProfileInfoRow(
                      label: 'Status',
                      value: _petugas.isAktif ? 'Aktif' : 'Tidak Aktif',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.putih100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColor.font60),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColor.font60,
                        child: Icon(
                          Icons.lock,
                          size: 16,
                          color: AppColor.font100,
                        ),
                      ),
                      title: Text(
                        'Ubah Password',
                        style: AppFont.medium().copyWith(
                          fontSize: 14,
                          color: AppColor.font100,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: AppColor.font80,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PetugasUbahPasswordPage(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColor.redAllert,
                        child: Icon(
                          Icons.logout,
                          size: 16,
                          color: AppColor.putih100,
                        ),
                      ),
                      title: Text(
                        'Logout',
                        style: AppFont.medium().copyWith(
                          fontSize: 14,
                          color: AppColor.redAllert,
                        ),
                      ),
                      onTap: () {

                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: const PetugasNavBar(currentIndex: 2),
    );
  }
}
