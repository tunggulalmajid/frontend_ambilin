import 'package:flutter/material.dart';
import 'package:frontend_ambilin/models/langganan.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';
import 'package:frontend_ambilin/ui/widgets/w_button.dart';
import 'package:frontend_ambilin/utils/app_routes.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {

  int _selectedPlanIndex = 0;

  final List<PaketLangganan> _subscriptionPlans = PaketLangganan.getPlans();

  final List<Map<String, String>> _plans = [
    {'durasi': '1 Bulan', 'harga': 'Rp. 30.000/Bulan'},
    {'durasi': '3 Bulan', 'harga': 'Rp. 90.000/Bulan'},
    {'durasi': '6 Bulan', 'harga': 'Rp. 180.000/Bulan'},
  ];

  final List<Map<String, String>> _keuntungan = [
    {
      'title': 'Bonus Poin',
      'desc': 'Dapatkan poin dari setiap penjemputan',
    },
    {
      'title': 'Akses Fitur Premium',
      'desc': 'Nikmati semua fitur Ambilin tanpa batasan',
    },
    {
      'title': 'Gratis Ongkir Instan Tanpa Batas',
      'desc': 'Jadikan pesananmu selalu Gratis Ongkir',
    },
    {
      'title': 'Redeem poin',
      'desc': 'test',
    },
  ];

  void _showPaketLanggananSheet() {
    int tempSelected = _selectedPlanIndex;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Pilih Paket Langganan',
                    style: AppFont.bold().copyWith(
                      fontSize: 18,
                      color: AppColor.font100,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(_plans.length, (index) {
                    final plan = _plans[index];
                    final isSelected = tempSelected == index;

                    return GestureDetector(
                      onTap: () {
                        setModalState(() {
                          tempSelected = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColor.base100 : AppColor.font60,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              plan['durasi']!,
                              style: AppFont.semibold().copyWith(
                                fontSize: 14,
                                color: AppColor.font100,
                              ),
                            ),
                            Text(
                              plan['harga']!,
                              style: AppFont.medium().copyWith(
                                fontSize: 14,
                                color: AppColor.font100,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  WButton(
                    text: 'Konfirmasi',
                    textSize: 16,
                    onPressed: () {
                      setState(() {
                        _selectedPlanIndex = tempSelected;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: AppColor.base100,
      body: SafeArea(
        bottom: false,
        child: Container(

          color: Colors.white,
          child: Column(
            children: [

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      Container(
                        color: AppColor.base100,
                        child: Column(
                          children: [
                            Container(
                              height: 70,
                              width: double.infinity,
                              child: Stack(
                                children: [

                                  Positioned(
                                    left: 8,
                                    top: 0,
                                    bottom: 0,
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () => Navigator.pop(context),
                                        icon: const Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Center(
                                    child: Image.asset(
                                      'assets/ambilin.png',
                                      height: 32,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),
                          ],
                        ),
                      ),

                      transformContentCard(),
                    ],
                  ),
                ),
              ),

              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget transformContentCard() {
    return Container(
      width: double.infinity,

      transform: Matrix4.translationValues(0.0, -16.0, 0.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(

        padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/bonus.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/Free.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            Text(
              'Keuntungan:',
              style: AppFont.bold().copyWith(
                fontSize: 16,
                color: AppColor.font100,
              ),
            ),
            const SizedBox(height: 16),

            ...List.generate(_keuntungan.length, (index) {
              final item = _keuntungan[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildKeuntunganRow(
                  title: item['title']!,
                  description: item['desc']!,
                ),
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildKeuntunganRow({
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFFE8FFF0),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppFont.bold().copyWith(
                  fontSize: 15,
                  color: AppColor.font100,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppFont.regular().copyWith(
                  fontSize: 13,
                  color: AppColor.font80,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [

              Expanded(
                child: GestureDetector(
                  onTap: _showPaketLanggananSheet,
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _plans[_selectedPlanIndex]['durasi']!,
                            style: AppFont.bold().copyWith(
                              fontSize: 18,
                              color: AppColor.font100,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.keyboard_arrow_up,
                            size: 22,
                            color: AppColor.font100,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _plans[_selectedPlanIndex]['harga']!,
                        style: AppFont.regular().copyWith(
                          fontSize: 13,
                          color: AppColor.font60,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                width: 180,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.metodePembayaran,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.base100,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Langganan',
                    textAlign: TextAlign.center,
                    style: AppFont.bold().copyWith(
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'deskripsi pembayaran',
              style: AppFont.regular().copyWith(
                fontSize: 12,
                color: AppColor.font60,
              ),
            ),
          ),
        ],
      ),
    );
  }
}