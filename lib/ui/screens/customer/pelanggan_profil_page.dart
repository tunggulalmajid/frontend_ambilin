
import 'package:flutter/material.dart';
import '../../../models/customer.dart';
import '../../../models/user_model.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';
import '../../widgets/profile_header.dart';
import 'pelanggan_edit_profil_page.dart';
import 'pelanggan_ubah_password_page.dart';

class PelangganProfilPage extends StatefulWidget {
  const PelangganProfilPage({super.key});

  @override
  State<PelangganProfilPage> createState() => _PelangganProfilPageState();
}

class _PelangganProfilPageState extends State<PelangganProfilPage> {
  late UserModel _user;
  late Customer _customer;

  @override
  void initState() {
    super.initState();
    _user = UserModel(
      idUser: 1, nama: 'Rafi Customer', email: 'customer@gmail.com',
      idRole: 3, alamat: 'Jl Halmahera', nomorTelepon: '089965423456',
    );
    _customer = Customer(
      idCustomer: 1, idUser: 1, poin: 1000,
      isMember: true, isAktif: true, nama: 'Rafi Customer',
      email: 'customer@gmail.com',
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
              backgroundUrl: 'https://images.unsplash.com/photo-1518780664697-55e3ad937233?w=800&auto=format&fit=crop',
              inisial: inisial,
              nama: _user.nama,
              email: _user.email,
              onBackPressed: () => Navigator.pop(context),
              onEditPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => PelangganEditProfilPage(user: _user),
                ));
              },
            ),
            const SizedBox(height: 80),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColor.putih100, borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColor.font60),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rincian Profil', style: AppFont.bold().copyWith(fontSize: 18, color: AppColor.base100)),
                    const SizedBox(height: 16),
                    ProfileInfoRow(label: 'Alamat', value: _user.alamat ?? '-'),
                    ProfileInfoRow(label: 'No Telepon', value: _user.nomorTelepon ?? '-'),
                    ProfileInfoRow(label: 'Poin', value: '${_customer.poin}'),
                    ProfileInfoRow(label: 'Member', value: _customer.isMember ? 'Aktif' : 'Tidak Aktif'),
                    ProfileInfoRow(label: 'Status', value: _customer.isAktif ? 'Aktif' : 'Tidak Aktif'),
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
                  color: AppColor.putih100, borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColor.font60),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const CircleAvatar(
                        radius: 16, backgroundColor: AppColor.font60,
                        child: Icon(Icons.lock, size: 16, color: AppColor.font100),
                      ),
                      title: Text('Ubah Password', style: AppFont.medium().copyWith(fontSize: 14, color: AppColor.font100)),
                      trailing: const Icon(Icons.chevron_right, color: AppColor.font80),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const PelangganUbahPasswordPage()));
                      },
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const CircleAvatar(
                        radius: 16, backgroundColor: AppColor.redAllert,
                        child: Icon(Icons.logout, size: 16, color: AppColor.putih100),
                      ),
                      title: Text('Logout', style: AppFont.medium().copyWith(fontSize: 14, color: AppColor.redAllert)),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: AppColor.base100,
        unselectedItemColor: AppColor.font80,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Pesanan'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Artikel'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        onTap: (index) {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColor.base100,
        child: const Icon(Icons.local_shipping, color: AppColor.putih100),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
