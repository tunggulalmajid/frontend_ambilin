import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_routes.dart';
import 'admin/admin_dashboard.dart';
import 'petugas/petugas_dashboard.dart';
import 'customer/customer_dashboard.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isChecking = true;
  String? _role;

  @override
  void initState() {
    super.initState();
    _checkAuthAndRole();
  }

  Future<void> _checkAuthAndRole() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    await authProvider.checkLoginStatus();
    if (!mounted) return;

    if (authProvider.isLoggedIn && authProvider.user != null) {
      final role = await authProvider.getSavedRole();

      if (!mounted) return;

      if (role == 'petugas') {
        setState(() {
          _role = role;
          _isChecking = false;
        });
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.petugasHome,
          (route) => false,
        );
        return;
      }

      setState(() {
        _role = role;
        _isChecking = false;
      });
    } else {
      setState(() {
        _isChecking = false;
      });
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (_isChecking) {
      return const Scaffold(
        backgroundColor: AppColor.putihBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppColor.base100,
                strokeWidth: 3,
              ),
              SizedBox(height: 16),
              Text(
                "Memverifikasi sesi...",
                style: TextStyle(color: AppColor.font80, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    if (!auth.isLoggedIn || auth.user == null) {
      Future.microtask(() {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
        }
      });
      return const Scaffold(
        backgroundColor: AppColor.putihBackground,
        body: Center(child: CircularProgressIndicator(color: AppColor.base100)),
      );
    }

    switch (_role) {
      case 'admin':
        return const AdminDashboard();
      case 'petugas':
        return const PetugasDashboard();
      case 'customer':
        return const CustomerDashboard();
      default:
        Future.microtask(() {
          if (mounted) {
            auth.logout();
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            );
          }
        });
        return const Scaffold(
          backgroundColor: AppColor.putihBackground,
          body: Center(
            child: CircularProgressIndicator(color: AppColor.base100),
          ),
        );
    }
  }
}
