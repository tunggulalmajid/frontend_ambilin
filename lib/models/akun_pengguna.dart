import 'package:flutter/material.dart';

class AkunPengguna {
  final String nama;
  final String email;
  final String peran; // 'Petugas' or 'Pelanggan'
  final String status; // 'Aktif' or 'Nonaktif'
  final Color warnaAvatar;

  const AkunPengguna({
    required this.nama,
    required this.email,
    required this.peran,
    required this.status,
    required this.warnaAvatar,
  });

  /// Initial letter for avatar
  String get inisial => nama.isNotEmpty ? nama[0].toUpperCase() : '?';

  /// Dummy data matching the design
  static List<AkunPengguna> getDummyData() {
    return const [
      AkunPengguna(
        nama: 'Hadianto',
        email: 'Hadianto@gmail.com',
        peran: 'Petugas',
        status: 'Aktif',
        warnaAvatar: Color(0xFF4CAF50), // green
      ),
      AkunPengguna(
        nama: 'Roihan Abdul',
        email: 'Roihan@gmail.com',
        peran: 'Petugas',
        status: 'Nonaktif',
        warnaAvatar: Color(0xFFF44336), // red
      ),
      AkunPengguna(
        nama: 'Tunggul Nadzif',
        email: 'Tunggul@gmail.com',
        peran: 'Pelanggan',
        status: 'Aktif',
        warnaAvatar: Color(0xFFFFC107), // amber/yellow
      ),
      AkunPengguna(
        nama: 'Rafi Ananta',
        email: 'Rafi@gmail.com',
        peran: 'Pelanggan',
        status: 'Nonaktif',
        warnaAvatar: Color(0xFF9C27B0), // purple
      ),
    ];
  }
}
