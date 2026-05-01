import 'package:flutter/material.dart';
import 'package:frontend_ambilin/providers/auth_provider.dart';
import 'package:frontend_ambilin/utils/app_routes.dart';
import 'package:provider/provider.dart';

class PetugasDashboard extends StatelessWidget {
  const PetugasDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Petugas"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(
        child: Text("Selamat datang di halaman pemesanan sampah!"),
      ),
    );
  }
}
