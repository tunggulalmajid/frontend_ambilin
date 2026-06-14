import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'login_page.dart';

import 'admin/admin_dashboard.dart';
import 'petugas/petugas_dashboard.dart';
import 'customer/customer_dashboard.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {

    final int dummyIdRole = 2;

    switch (dummyIdRole) {
      case 1:
        return const AdminDashboard();
      case 2:
        return const PetugasDashboard();
      case 3:
        return const CustomerDashboard();
      default:

        return const Scaffold(
          body: Center(child: Text("Role tidak dikenali oleh sistem.")),
        );
    }
  }
}
