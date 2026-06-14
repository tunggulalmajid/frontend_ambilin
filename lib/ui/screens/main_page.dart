import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'login_page.dart';

// Nanti buat 3 file ini ya di dalam folder masing-masing
import 'admin/admin_dashboard.dart';
import 'petugas/petugas_dashboard.dart';
import 'customer/customer_dashboard.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Pantau AuthProvider untuk mendapatkan data user
    // final auth = context.watch<AuthProvider>();
    // final user = auth.user;
    final int dummyIdRole = 2;

    // Fallback: Jika user null (misal karena token hilang/belum login)
    // Kembalikan ke LoginPage
    // if (user == null) {
    //   return const LoginPage();
    // }

    // Arahkan ke dashboard yang sesuai dengan id_role
    switch (dummyIdRole) {
      case 1:
        return const AdminDashboard();
      case 2:
        return const PetugasDashboard();
      case 3:
        return const CustomerDashboard();
      default:
        // Jika role tidak terdaftar (sebagai safety)
        return const Scaffold(
          body: Center(child: Text("Role tidak dikenali oleh sistem.")),
        );
    }
  }
}
