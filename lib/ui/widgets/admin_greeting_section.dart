import 'package:flutter/material.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';

class AdminGreetingSection extends StatelessWidget {
  final VoidCallback onProfileTap;

  const AdminGreetingSection({super.key, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, Admin',
                style: AppFont.bold().copyWith(
                  fontSize: 28,
                  color: AppColor.base100,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Selamat datang di Sistem Manajemen Ambilin',
                style: AppFont.regular().copyWith(
                  fontSize: 14,
                  color: AppColor.font80,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        GestureDetector(
          onTap: onProfileTap,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF008000),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ],
    );
  }
}
