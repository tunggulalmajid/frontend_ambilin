import 'package:flutter/material.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 320,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.base100,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: Text(
                      'Kembali',
                      style: AppFont.medium().copyWith(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Icon(
                Icons.workspace_premium,
                color: Colors.amberAccent,
                size: 48,
              ),
              const SizedBox(height: 8),
              Text(
                'Customer+',
                style: AppFont.bold().copyWith(
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Tingkatkan pengalaman Anda dengan\nfitur eksklusif dan keuntungan spesial!',
                  textAlign: TextAlign.center,
                  style: AppFont.regular().copyWith(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Langganan Bulanan',
                        style: AppFont.semibold().copyWith(
                          fontSize: 16,
                          color: AppColor.font100,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '49K',
                            style: AppFont.bold().copyWith(
                              fontSize: 40,
                              color: AppColor.base100,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '/bulan',
                            style: AppFont.regular().copyWith(
                              fontSize: 16,
                              color: AppColor.font80,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.local_offer,
                              size: 16,
                              color: AppColor.base100,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Promo: Gratis 7 hari pertama!',
                              style: AppFont.medium().copyWith(
                                fontSize: 12,
                                color: AppColor.base100,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.base100,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Mulai Berlangganan',
                            style: AppFont.semibold().copyWith(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Keuntungan Member Customer+',
                        style: AppFont.semibold().copyWith(
                          fontSize: 16,
                          color: AppColor.font100,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildFeatureRow(
                        icon: Icons.trending_up,
                        title: 'Akses Fitur Premium',
                        description:
                            'Buka fitur eksklusif yang hanya tersedia untuk member.',
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureRow(
                        icon: Icons.monetization_on_rounded,
                        title: 'Bonus Poin',
                        description:
                            'Dapatkan poin untuk setiap transaksi yang Anda lakukan.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ]),
      ),
    ));
  }
  Widget _buildFeatureRow({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColor.base20,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppColor.base100,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppFont.semibold().copyWith(
                  fontSize: 14,
                  color: AppColor.font100,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: AppFont.regular().copyWith(
                  fontSize: 12,
                  color: AppColor.font80,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
