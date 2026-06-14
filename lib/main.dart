import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:frontend_ambilin/providers/auth_provider.dart';
import 'package:frontend_ambilin/providers/dashboard_provider.dart';
import 'package:frontend_ambilin/providers/pickup_history_provider.dart';
import 'package:frontend_ambilin/providers/user_account_provider.dart';
import 'package:frontend_ambilin/providers/article_provider.dart';
import 'package:frontend_ambilin/providers/waste_category_provider.dart';
import 'package:frontend_ambilin/ui/screens/main_page.dart';
import 'package:frontend_ambilin/ui/screens/login_page.dart';
import 'package:frontend_ambilin/ui/screens/register_page.dart';
import 'package:frontend_ambilin/ui/screens/splash.dart';
import 'package:frontend_ambilin/ui/screens/customer/subscription_page.dart';
import 'package:frontend_ambilin/ui/screens/customer/form_pemesanan.dart';
import 'package:frontend_ambilin/ui/screens/admin/admin_dashboard.dart';
import 'package:frontend_ambilin/ui/screens/admin/manajemen_akun_page.dart';
import 'package:frontend_ambilin/ui/screens/admin/manajemen_artikel_page.dart';
import 'package:frontend_ambilin/ui/screens/admin/manajemen_kategori_page.dart';
import 'package:frontend_ambilin/ui/screens/customer/form_pembelian_langganan.dart';
import 'package:frontend_ambilin/ui/screens/customer/pembayaran_page.dart';
import 'package:frontend_ambilin/ui/screens/customer/transaksi_berhasil_page.dart';
import 'package:frontend_ambilin/utils/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:frontend_ambilin/ui/screens/customer/pilih_map.dart';
import 'package:frontend_ambilin/ui/screens/customer/pelanggan_proses_penjemputan.dart';
import 'package:frontend_ambilin/ui/screens/customer/pelanggan_selesai_penjemputan.dart';
import 'package:frontend_ambilin/ui/screens/customer/detail_artikel_page.dart';
import 'package:frontend_ambilin/ui/screens/customer/pelanggan_edit_profil_page.dart';
import 'package:frontend_ambilin/ui/screens/customer/pelanggan_ubah_password_page.dart';
import 'package:frontend_ambilin/ui/screens/petugas/petugas_dashboard.dart';
import 'package:frontend_ambilin/ui/screens/petugas/petugas_profil_page.dart';
import 'package:frontend_ambilin/ui/screens/petugas/petugas_riwayat_page.dart';
import 'package:frontend_ambilin/ui/screens/petugas/petugas_lihat_map_page.dart';
import 'package:frontend_ambilin/ui/screens/petugas/petugas_edit_profil_page.dart';
import 'package:frontend_ambilin/ui/screens/petugas/petugas_detail_tugas_page.dart';
import 'package:frontend_ambilin/ui/screens/petugas/petugas_ubah_password_page.dart';
import 'package:frontend_ambilin/ui/screens/petugas/petugas_proses_penjemputan_page.dart';
import 'package:frontend_ambilin/ui/screens/admin/profile_admin_page.dart';
import 'package:frontend_ambilin/ui/screens/admin/edit_profile_admin_page.dart';
import 'package:frontend_ambilin/ui/screens/admin/edit_password_admin_page.dart';
import 'package:frontend_ambilin/ui/screens/admin/manajemen_subscription_page.dart';
import 'package:frontend_ambilin/ui/screens/admin/admin_detail_pelanggan_page.dart';
import 'package:frontend_ambilin/ui/screens/admin/admin_detail_petugas_page.dart';
import 'package:frontend_ambilin/ui/screens/admin/admin_manajemen_konfirmasi.dart';
import 'package:frontend_ambilin/ui/screens/admin/admin_konfirmasi_pembayaran.dart';
import 'package:frontend_ambilin/models/setor_sampah.dart';
import 'package:frontend_ambilin/models/artikel.dart';
import 'package:frontend_ambilin/models/user_model.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => DashboardProvider()),
          ChangeNotifierProvider(create: (_) => PickupHistoryProvider()),
          ChangeNotifierProvider(create: (_) => UserAccountProvider()),
          ChangeNotifierProvider(create: (_) => ArticleProvider()),
          ChangeNotifierProvider(create: (_) => WasteCategoryProvider()),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class _NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  const _NoAnimationPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ambilin',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: _NoAnimationPageTransitionsBuilder(),
            TargetPlatform.iOS: _NoAnimationPageTransitionsBuilder(),
            TargetPlatform.windows: _NoAnimationPageTransitionsBuilder(),
            TargetPlatform.macOS: _NoAnimationPageTransitionsBuilder(),
            TargetPlatform.linux: _NoAnimationPageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: AppRoutes.main,
      routes: {
        AppRoutes.splash: (context) => SplashScreen(),
        AppRoutes.login: (context) => LoginPage(),
        AppRoutes.register: (context) => RegisterPage(),
        AppRoutes.main: (context) => MainPage(),
        AppRoutes.subscription: (context) {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          if (authProvider.user?.idRole == 1) {
            return const ManajemenSubscriptionPage();
          } else {
            return const SubscriptionPage();
          }
        },
        AppRoutes.pemesanan: (context) => const FormPemesanan(),
        AppRoutes.adminDashboard: (context) => const AdminDashboard(),
        AppRoutes.manajemenUser: (context) => const ManajemenAkunPage(),
        AppRoutes.manajemenArtikel: (context) => const ManajemenArtikelPage(),
        AppRoutes.manajemenKategori: (context) => const ManajemenKategoriPage(),
        AppRoutes.metodePembayaran: (context) => const FormPembelianLangganan(),
        AppRoutes.pembayaran: (context) => const PembayaranPage(
          subscriptionId: '',
          metodePembayaran: '',
          totalBayar: 0,
        ),
        AppRoutes.transaksiBerhasil: (context) => const TransaksiBerhasilPage(),
        AppRoutes.pelangganPilihMap: (context) => const PilihMapPage(),
        AppRoutes.pelangganProsesPenjemputan: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          final data = args is SetorSampah ? args : SetorSampah.getMockList().first;
          return PelangganProsesPenjemputanPage(data: data);
        },
        AppRoutes.pelangganDetailSelesai: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          final data = args is SetorSampah ? args : SetorSampah.getMockList().first;
          return PelangganSelesaiPenjemputanPage(data: data);
        },
        AppRoutes.detailArtikel: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          final data = args is Artikel ? args : Artikel.getMockList().first;
          return DetailArtikelPage(artikel: data);
        },
        AppRoutes.pelangganEditProfil: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          final user = args is UserModel ? args : UserModel(
            idUser: 1, nama: 'Rafi Customer', email: 'customer@gmail.com', idRole: 3,
          );
          return PelangganEditProfilPage(user: user);
        },
        AppRoutes.pelangganUbahPassword: (context) => const PelangganUbahPasswordPage(),
        AppRoutes.petugasHome: (context) => const PetugasDashboard(),
        AppRoutes.petugasRiwayat: (context) => const PetugasRiwayatPage(),
        AppRoutes.petugasDetailTugas: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          final data = args is SetorSampah ? args : SetorSampah.getMockList().first;
          return PetugasDetailTugasPage(data: data);
        },
        AppRoutes.petugasLihatMap: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          final data = args is SetorSampah ? args : SetorSampah.getMockList().first;
          return PetugasLihatMapPage(data: data);
        },
        AppRoutes.petugasProsesPenjemputan: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          final data = args is SetorSampah ? args : SetorSampah.getMockList().first;
          return PetugasProsesPenjemputanPage(data: data);
        },
        AppRoutes.petugasDetailSelesai: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          final data = args is SetorSampah ? args : SetorSampah.getMockList().first;
          return PetugasDetailTugasPage(data: data);
        },
        AppRoutes.petugasEditProfil: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          final user = args is UserModel ? args : UserModel(
            idUser: 2, nama: 'Rafi Petugas', email: 'driver@gmail.com', idRole: 2,
          );
          return PetugasEditProfilPage(user: user);
        },
        AppRoutes.petugasUbahPassword: (context) => const PetugasUbahPasswordPage(),
        AppRoutes.petugasProfil: (context) => const PetugasProfilPage(),
        AppRoutes.adminProfil: (context) => const ProfileAdminPage(),
        AppRoutes.adminEditProfil: (context) => const EditProfileAdminPage(),
        AppRoutes.adminUbahPassword: (context) => const EditPasswordAdminPage(),
        AppRoutes.adminDetailPelanggan: (context) => const AdminDetailPelangganPage(),
        AppRoutes.adminDetailPetugas: (context) => const AdminDetailPetugasPage(),
        AppRoutes.adminManajemenKonfirmasi: (context) => const AdminManajemenKonfirmasi(),
        AppRoutes.adminDetailKonfirmasi: (context) => const AdminKonfirmasiPembayaran(),
      },
    );
  }
}
