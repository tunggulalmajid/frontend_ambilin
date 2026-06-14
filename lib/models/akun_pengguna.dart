import 'package:flutter/material.dart';
import 'user_model.dart';

class AkunPengguna {
  final int? idUser;
  final String nama;
  final String email;
  final String peran; // 'Petugas' or 'Pelanggan'
  final String status; // 'Aktif' or 'Nonaktif'
  final Color warnaAvatar;

  const AkunPengguna({
    this.idUser,
    required this.nama,
    required this.email,
    required this.peran,
    required this.status,
    required this.warnaAvatar,
  });

  factory AkunPengguna.fromUserModel(UserModel user, {bool? active}) {
    final roleName = user.idRole == 2 ? 'Petugas' : (user.idRole == 3 ? 'Pelanggan' : 'Admin');
    final activeStatus = active == false ? 'Nonaktif' : 'Aktif';
    final avatarColor = user.idRole == 2 ? const Color(0xFF4CAF50) : const Color(0xFFFFC107);
    return AkunPengguna(
      idUser: user.idUser,
      nama: user.nama,
      email: user.email,
      peran: roleName,
      status: activeStatus,
      warnaAvatar: avatarColor,
    );
  }

  /// Initial letter for avatar
  String get inisial => nama.isNotEmpty ? nama[0].toUpperCase() : '?';
}
