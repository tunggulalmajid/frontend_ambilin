import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';
import 'package:frontend_ambilin/utils/app_routes.dart';

class AdminManajemenKonfirmasi extends StatelessWidget {
  const AdminManajemenKonfirmasi({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, String>> pendingList = [
      {
        'nama': 'Hadianto',
        'inisial': 'H',
        'id': 'ID Transaksi: 1',
        'paket': 'Paket Langganan: 1 Bulan',
      },
      {
        'nama': 'Intan',
        'inisial': 'I',
        'id': 'ID Transaksi: 2',
        'paket': 'Paket Langganan: 3 Bulan',
      },
      {
        'nama': 'Joko',
        'inisial': 'J',
        'id': 'ID Transaksi: 3',
        'paket': 'Paket Langganan: 3 Bulan',
      },
      {
        'nama': 'Kartika',
        'inisial': 'K',
        'id': 'ID Transaksi: 4',
        'paket': 'Paket Langganan: 3 Bulan',
      },
    ];

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      appBar: AppBar(
        backgroundColor: AppColor.putihBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.font100),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Konfirmasi Langganan',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColor.base100,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daftar Langganan Pending',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColor.font100,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pendingList.length,
              itemBuilder: (context, index) {
                final item = pendingList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.adminDetailKonfirmasi);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColor.font60.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [

                        CircleAvatar(
                          radius: 24,
                          backgroundColor: const Color(0xFFFFCDD2),
                          child: Text(
                            item['inisial']!,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColor.redAllert,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['nama']!,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppColor.font100,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item['id']!,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: AppColor.font80,
                                ),
                              ),
                              Text(
                                item['paket']!,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: AppColor.font80,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppColor.font80,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
