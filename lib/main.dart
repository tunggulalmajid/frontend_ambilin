import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend_ambilin/providers/auth_provider.dart';
import 'package:frontend_ambilin/ui/screens/main_page.dart';
import 'package:frontend_ambilin/ui/screens/login_page.dart';
import 'package:frontend_ambilin/ui/screens/register_page.dart';
// import 'package:frontend_ambilin/ui/screens/splash.dart';
import 'package:frontend_ambilin/ui/screens/customer/customer_dashboard.dart';
// import 'package:frontend_ambilin/utils/app_colors.dart';
import 'package:frontend_ambilin/ui/screens/customer/subscription_page.dart';
import 'package:frontend_ambilin/utils/app_routes.dart';
import 'package:provider/provider.dart';
// import 'package:frontend_ambilin/ui/screens/admin/admin_dashboard.dart';
import 'package:frontend_ambilin/ui/screens/customer/form_pemesanan_page.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          // Tambahkan provider lain di sini nanti
        ],
        child: const MyApp(),
      ),
    ),
  );
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
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => CustomerDashboard(),
        AppRoutes.login: (context) => LoginPage(),
        AppRoutes.register: (context) => RegisterPage(),
        AppRoutes.main: (context) => MainPage(),
        AppRoutes.subscription: (context) => const SubscriptionPage(),
        AppRoutes.pemesanan: (context) => const FormPemesananPage(),
      },
    );
  }
}
