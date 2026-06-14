// ----- FILE: loading_overlay.dart -----
// Widget reusable untuk overlay loading semi-transparan.
// Digunakan di: pesanan_pelanggan, petugas_dashboard, petugas_riwayat,
//               pelanggan_artikel.

import 'package:flutter/material.dart';
import '../../utils/app_color.dart';

/// Overlay loading semi-transparan yang menutupi seluruh layar.
/// Biasanya ditampilkan saat navigasi async sedang berlangsung.
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    return Container(
      color: Colors.black.withOpacity(0.2),
      child: const Center(
        child: CircularProgressIndicator(color: AppColor.base100),
      ),
    );
  }
}
