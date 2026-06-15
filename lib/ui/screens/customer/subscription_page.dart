import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_ambilin/models/langganan.dart';
import 'package:frontend_ambilin/providers/subscription_provider.dart';
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

  final List<Map<String, String>> _keuntungan = [
    {'title': 'Bonus Poin', 'desc': 'Dapatkan poin dari setiap penjemputan'},
    {
      'title': 'Akses Fitur Premium',
      'desc': 'Nikmati semua fitur Ambilin+ tanpa batasan',
    },
    {
      'title': 'Gratis Ongkir Instan Tanpa Batas',
      'desc': 'Jadikan pesananmu selalu Gratis Ongkir',
    },
    {
      'title': 'Redeem poin',
      'desc': 'Tukarkan poin dengan potongan paket langganan',
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<SubscriptionProvider>().fetchSubscriptions();
      }
    });
  }

  void _showPaketLanggananSheet(List<Langganan> plans) {
    if (plans.isEmpty) return;
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
              child: SingleChildScrollView(
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
                    ...List.generate(plans.length, (index) {
                      final plan = plans[index];
                      final isSelected = tempSelected == index;

                      final formattedHarga =
                          'Rp ${plan.harga.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]}.")}';

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
                              color: isSelected
                                  ? AppColor.base100
                                  : AppColor.font60,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                plan.nama,
                                style: AppFont.semibold().copyWith(
                                  fontSize: 14,
                                  color: AppColor.font100,
                                ),
                              ),
                              Text(
                                formattedHarga,
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
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final subProvider = context.watch<SubscriptionProvider>();
    final plans = subProvider.subscriptions;

    return Scaffold(
      backgroundColor: AppColor.base100,
      body: SafeArea(
        bottom: false,
        child: Container(
          color: Colors.white,
          child: subProvider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColor.base100),
                )
              : Column(
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
                                              onPressed: () =>
                                                  Navigator.pop(context),
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
                    _buildBottomBar(plans),
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
                    child: Image.asset('assets/bonus.png', fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset('assets/Free.png', fit: BoxFit.contain),
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
                  icon: _getKeuntunganIcon(index),
                ),
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  IconData _getKeuntunganIcon(int index) {
    switch (index) {
      case 0:
        return Icons.monetization_on_outlined;
      case 1:
        return Icons.star_border_rounded;
      case 2:
        return Icons.local_shipping_outlined;
      case 3:
        return Icons.redeem_outlined;
      default:
        return Icons.star_border_rounded;
    }
  }

  Widget _buildKeuntunganRow({
    required String title,
    required String description,
    required IconData icon,
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
          child: Icon(icon, color: AppColor.base100, size: 20),
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

  Widget _buildBottomBar(List<Langganan> plans) {
    if (plans.isEmpty) {
      return Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        color: Colors.white,
        child: const Center(
          child: Text('Tidak ada paket subskripsi yang tersedia saat ini.'),
        ),
      );
    }

    if (_selectedPlanIndex >= plans.length) {
      _selectedPlanIndex = 0;
    }
    final plan = plans[_selectedPlanIndex];
    final formattedHarga =
        'Rp ${plan.harga.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]}.")}';

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
                  onTap: () => _showPaketLanggananSheet(plans),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              plan.nama,
                              overflow: TextOverflow.ellipsis,
                              style: AppFont.bold().copyWith(
                                fontSize: 18,
                                color: AppColor.font100,
                              ),
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
                        formattedHarga,
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
                width: 140,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.metodePembayaran,
                      arguments: plan,
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
              'Tekan paket di atas untuk mengubah durasi langganan.',
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
