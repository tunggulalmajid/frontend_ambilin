import 'package:flutter/material.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';

class DetailCardWrapper extends StatelessWidget {
  final String title;
  final Widget child;

  const DetailCardWrapper({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.putih100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.font60),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppFont.bold().copyWith(
              fontSize: 16,
              color: AppColor.base100,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

/// Baris data label–value yang digunakan di dalam [DetailCardWrapper].
/// Label di kiri (flex 2) dan value di kanan (flex 3, rata kanan).
class DetailDataRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailDataRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppFont.semibold().copyWith(
                fontSize: 14,
                color: AppColor.font100,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppFont.regular().copyWith(
                fontSize: 14,
                color: AppColor.font80,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
