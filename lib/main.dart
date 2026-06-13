import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:frontend_ambilin/providers/auth_provider.dart';
import 'package:frontend_ambilin/providers/pickup_history_provider.dart';
import 'package:frontend_ambilin/providers/user_account_provider.dart';
import 'package:frontend_ambilin/providers/article_provider.dart';
import 'package:frontend_ambilin/providers/waste_category_provider.dart';
import 'package:frontend_ambilin/ui/screens/main_page.dart';
import 'package:frontend_ambilin/ui/screens/login_page.dart';
import 'package:frontend_ambilin/ui/screens/register_page.dart';
import 'package:frontend_ambilin/ui/screens/splash.dart';
import 'package:frontend_ambilin/ui/screens/customer/subscription_page.dart';
import 'package:frontend_ambilin/ui/screens/customer/form_pemesanan_page.dart';
import 'package:frontend_ambilin/ui/screens/admin/admin_dashboard.dart';
import 'package:frontend_ambilin/ui/screens/admin/manajemen_akun_page.dart';
import 'package:frontend_ambilin/ui/screens/admin/manajemen_artikel_page.dart';
import 'package:frontend_ambilin/ui/screens/admin/manajemen_kategori_page.dart';
import 'package:frontend_ambilin/ui/screens/customer/metode_pembayaran_page.dart';
import 'package:frontend_ambilin/ui/screens/customer/pilih_promo_page.dart';
import 'package:frontend_ambilin/ui/screens/customer/pembayaran_page.dart';
import 'package:frontend_ambilin/ui/screens/customer/transaksi_berhasil_page.dart';
import 'package:frontend_ambilin/utils/app_routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
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
        AppRoutes.subscription: (context) => const SubscriptionPage(),
        AppRoutes.pemesanan: (context) => const FormPemesananPage(),
        AppRoutes.adminDashboard: (context) => const AdminDashboard(),
        AppRoutes.manajemenUser: (context) => const ManajemenAkunPage(),
        AppRoutes.manajemenArtikel: (context) => const ManajemenArtikelPage(),
        AppRoutes.manajemenKategori: (context) => const ManajemenKategoriPage(),
        AppRoutes.metodePembayaran: (context) => const MetodePembayaranPage(),
        AppRoutes.pilihPromo: (context) => const PilihPromoPage(),
        AppRoutes.pembayaran: (context) => const PembayaranPage(
          subscriptionId: '',
          metodePembayaran: '',
          totalBayar: 0,
        ),
        AppRoutes.transaksiBerhasil: (context) => const TransaksiBerhasilPage(),
      },
    );
  }
}
