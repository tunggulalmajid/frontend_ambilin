import 'package:flutter/material.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';

class PilihMapPage extends StatefulWidget {
  const PilihMapPage({super.key});

  @override
  State<PilihMapPage> createState() => _PilihMapPageState();
}

class _PilihMapPageState extends State<PilihMapPage> {
  bool _isLoading = false;
  String _currentAddress = 'Menunggu lokasi...';
  bool _isLocationFound = false;

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _isLoading = false;
      _currentAddress = 'Jl. Semeru, Jember\nRumah Sakit Perkebunan Jember Klinik';
      _isLocationFound = true;
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
          'Pilih Lokasi Penjemputan',
          style: AppFont.bold().copyWith(color: AppColor.font100, fontSize: 18),
        ),
      ),
      body: Stack(
        children: [

          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFFE0E0E0),
            child: Image.network(
              'https://tile.openstreetmap.org/15/26601/17094.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Text('Map Placeholder (OpenStreetMap)', style: TextStyle(color: Colors.black54)),
                );
              },
            ),
          ),

          const Center(
            child: Icon(
              Icons.location_on,
              size: 50,
              color: AppColor.redAllert,
            ),
          ),

          Positioned(
            bottom: 120,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: AppColor.base100,
              onPressed: _getCurrentLocation,
              child: _isLoading
                  ? const CircularProgressIndicator(color: AppColor.putih100)
                  : const Icon(Icons.my_location, color: AppColor.putih100),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColor.putih100,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  )
                ]
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isLocationFound) ...[
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: AppColor.base100),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _currentAddress,
                            style: AppFont.medium().copyWith(color: AppColor.font100),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.base100,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Simpan Lokasi',
                        style: AppFont.semibold().copyWith(color: AppColor.putih100, fontSize: 16),
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
