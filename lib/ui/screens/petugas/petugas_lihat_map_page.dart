// ----- FILE: petugas_lihat_map_page.dart -----
// Halaman Map Full Screen untuk petugas melacak lokasi sampah pelanggan.
// Menggunakan placeholder tile OSM statis sebagai simulasi flutter_map.

import 'package:flutter/material.dart';
import '../../../models/setor_sampah.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';

class PetugasLihatMapPage extends StatefulWidget {
  final SetorSampah data;
  const PetugasLihatMapPage({super.key, required this.data});

  @override
  State<PetugasLihatMapPage> createState() => _PetugasLihatMapPageState();
}

class _PetugasLihatMapPageState extends State<PetugasLihatMapPage> {
  bool _isLoadingLokasi = false;
  String _statusTeks = '';

  // ---------- Simulasi Async GPS ----------
  Future<void> _refreshLokasi() async {
    setState(() {
      _isLoadingLokasi = true;
      _statusTeks = '';
    });

    // Simulasi loading 1.5 detik mengambil koordinat GPS
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _isLoadingLokasi = false;
      _statusTeks = 'Lokasi diperbarui: ${widget.data.alamat ?? "Jl Semeru, Jember"}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      appBar: AppBar(
        backgroundColor: AppColor.putih100,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.font100),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Lokasi Sampah',
          style: AppFont.bold().copyWith(
            fontSize: 18,
            color: AppColor.font100,
          ),
        ),
      ),
      body: Stack(
        children: [
          // ========== Map Full Screen (Placeholder OSM Tile) ==========
          Positioned.fill(
            child: Image.network(
              'https://tile.openstreetmap.org/15/26601/17094.png',
              fit: BoxFit.cover,
              repeat: ImageRepeat.repeat,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFE0E0E0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.map, size: 64, color: AppColor.font80),
                      const SizedBox(height: 8),
                      Text(
                        'Map Placeholder (OpenStreetMap)\nJember, Jawa Timur',
                        style: AppFont.regular().copyWith(color: AppColor.font80),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Pin Lokasi Sampah statis di tengah layar
          const Center(
            child: Icon(
              Icons.location_on,
              size: 50,
              color: AppColor.redAllert,
            ),
          ),

          // ========== FAB Refresh Lokasi ==========
          Positioned(
            bottom: 90,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: AppColor.base100,
              onPressed: _refreshLokasi,
              child: _isLoadingLokasi
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: AppColor.putih100,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Icon(Icons.my_location, color: AppColor.putih100),
            ),
          ),

          // ========== Info Bar Bawah ==========
          if (_statusTeks.isNotEmpty)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColor.putih100,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: AppColor.base100, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _statusTeks,
                        style: AppFont.medium().copyWith(
                          fontSize: 13,
                          color: AppColor.font100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
