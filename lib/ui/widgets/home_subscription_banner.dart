import 'package:flutter/material.dart';
import 'package:frontend_ambilin/models/customer.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';

class HomeSubscriptionBanner extends StatelessWidget {
  final bool isMember;
  final String statusTransaksi;
  final Customer? customer;
  final VoidCallback? onLanggananTap;
  final VoidCallback? onTukarPoinTap;

  const HomeSubscriptionBanner({
    super.key,
    required this.isMember,
    required this.statusTransaksi,
    this.customer,
    this.onLanggananTap,
    this.onTukarPoinTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isMember && statusTransaksi == 'success') {
      return _buildPremiumMemberCard();
    }

    if (!isMember && statusTransaksi == 'pending') {
      return _buildPendingBanner();
    }

    return _buildDefaultBanner();
  }

  Widget _buildDefaultBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.base100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Berlangganan Customer+',
                        style: AppFont.bold().copyWith(
                          fontSize: 16,
                          color: AppColor.putih100,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Nikmati layanan premium dan diskon khusus',
                        style: AppFont.regular().copyWith(
                          fontSize: 12,
                          color: AppColor.putih100,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: onLanggananTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.putih100,
                    foregroundColor: AppColor.base100,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    'Langganan',
                    style: AppFont.semibold().copyWith(
                      fontSize: 12,
                      color: AppColor.base100,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColor.yellowLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Silakan aktifkan langganan Anda untuk mulai melakukan pemesanan.',
              style: AppFont.regular().copyWith(
                fontSize: 13,
                color: AppColor.font80,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.font60,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Berlangganan Customer+',
                        style: AppFont.bold().copyWith(
                          fontSize: 16,
                          color: AppColor.putih100,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Nikmati layanan premium dan diskon khusus',
                        style: AppFont.regular().copyWith(
                          fontSize: 12,
                          color: AppColor.putih100,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.putih100,
                    disabledBackgroundColor: AppColor.putih100.withOpacity(0.5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    'Langganan',
                    style: AppFont.semibold().copyWith(
                      fontSize: 12,
                      color: AppColor.font60,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColor.yellowLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Silahkan tunggu konfirmasi pengajuan Customer+ oleh admin!',
              style: AppFont.medium().copyWith(
                fontSize: 13,
                color: AppColor.font100,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumMemberCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF006B09), AppColor.base100, Color(0xFF33A03D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColor.base100.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColor.putih100.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.workspace_premium,
                      color: AppColor.putih100,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Member Customer+',
                          style: AppFont.bold().copyWith(
                            fontSize: 16,
                            color: AppColor.putih100,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Masa Berlaku hingga',
                          style: AppFont.regular().copyWith(
                            fontSize: 11,
                            color: AppColor.putih100.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColor.putih100.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Poin Anda',
                          style: AppFont.semibold().copyWith(
                            fontSize: 13,
                            color: AppColor.putih100,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${customer?.poin ?? 0} poin',
                          style: AppFont.bold().copyWith(
                            fontSize: 15,
                            color: AppColor.putih100,
                          ),
                        ),
                      ],
                    ),

                    ElevatedButton(
                      onPressed: onTukarPoinTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.putih100,
                        foregroundColor: AppColor.base100,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: Text(
                        'Tukarkan',
                        style: AppFont.semibold().copyWith(
                          fontSize: 12,
                          color: AppColor.base100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
