import 'package:flutter/material.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';

class RiwayatHeader extends StatelessWidget {
  final VoidCallback? onLihatSemua;

  const RiwayatHeader({
    super.key,
    this.onLihatSemua,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Riwayat Penjemputan',
          style: AppFont.semibold().copyWith(
            fontSize: 16,
            color: AppColor.font100,
          ),
        ),
        GestureDetector(
          onTap: onLihatSemua,
          child: Text(
            'LIHAT SEMUA',
            style: AppFont.semibold().copyWith(
              fontSize: 12,
              color: AppColor.base100,
            ),
          ),
        ),
      ],
    );
  }
}
