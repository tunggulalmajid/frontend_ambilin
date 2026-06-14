import 'package:flutter/material.dart';
import 'package:frontend_ambilin/models/langganan.dart';
import 'package:frontend_ambilin/ui/widgets/app_cards.dart';
import 'package:frontend_ambilin/ui/widgets/w_button.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';

class PilihPromoPage extends StatefulWidget {
  /// Promo yang sebelumnya sudah dipilih (dari MetodePembayaranPage).
  final Promo? selectedPromo;

  const PilihPromoPage({super.key, this.selectedPromo});

  @override
  State<PilihPromoPage> createState() => _PilihPromoPageState();
}

class _PilihPromoPageState extends State<PilihPromoPage> {
  late List<Promo> _promos;
  Promo? _selectedPromo;

  @override
  void initState() {
    super.initState();
    _promos = Promo.getPromos();
    _selectedPromo = widget.selectedPromo;
  }

  /// Kembalikan promo yang dipilih ke halaman sebelumnya.
  void _simpanPromo() {
    Navigator.pop(context, _selectedPromo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Back Button
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 12),
                      child: TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColor.font100,
                          size: 20,
                        ),
                        label: Text(
                          'Kembali',
                          style: AppFont.medium().copyWith(
                            color: AppColor.font100,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // 2. Title & Subtitle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pilih Promo',
                            style: AppFont.bold().copyWith(
                              fontSize: 24,
                              color: AppColor.font100,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Promo terbaik untuk pembelian langganan',
                            style: AppFont.regular().copyWith(
                              fontSize: 14,
                              color: AppColor.font80,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 3. Section Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Promo yang bisa kamu pakai',
                        style: AppFont.bold().copyWith(
                          fontSize: 16,
                          color: AppColor.font100,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 4. List Promo Cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: _promos.map((promo) {
                          final isSelected = _selectedPromo?.id == promo.id;
                          return PromoCard(
                            namaPromo: promo.nama,
                            berlaku: 'Berlaku dalam ${promo.berlakuHari} hari',
                            isSelected: isSelected,
                            onPakai: () {
                              setState(() {
                                // Toggle: jika yang sama di-tap ulang, batalkan
                                if (isSelected) {
                                  _selectedPromo = null;
                                } else {
                                  _selectedPromo = promo;
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // 5. Sticky Bottom Button "Simpan"
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              decoration: BoxDecoration(
                color: AppColor.putih100,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: WButton(
                text: 'Simpan',
                textSize: 16,
                onPressed: _simpanPromo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
