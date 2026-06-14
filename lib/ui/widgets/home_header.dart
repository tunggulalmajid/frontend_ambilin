import 'package:flutter/material.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';

/// Widget header sapaan untuk halaman customer dashboard.
class HomeHeader extends StatelessWidget {
  final String namaUser;

  const HomeHeader({
    super.key,
    this.namaUser = 'User',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Halo, $namaUser',
            style: AppFont.bold().copyWith(
              fontSize: 24,
              color: AppColor.font100,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Selamat datang di aplikasi penjemputan sampah',
            style: AppFont.medium().copyWith(
              fontSize: 14,
              color: AppColor.font80,
            ),
          ),
        ],
      ),
    );
  }
}
