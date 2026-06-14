import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';

class PilihMapPage extends StatefulWidget {
  const PilihMapPage({super.key});

  @override
  State<PilihMapPage> createState() => _PilihMapPageState();
}

class _PilihMapPageState extends State<PilihMapPage> {
  final MapController _mapController = MapController();
  LatLng _currentLatLng = const LatLng(-8.1724, 113.7005); // Default Jember
  bool _isLoading = false;
  String _currentAddress = 'Mencari alamat...';
  bool _isLocationFound = false;

  @override
  void initState() {
    super.initState();
    // Geocode default position on open
    _reverseGeocode(_currentLatLng.latitude, _currentLatLng.longitude);
  }

  Future<void> _reverseGeocode(double lat, double lng) async {
    setState(() {
      _isLoading = true;
      _currentAddress = 'Mencari alamat...';
    });

    try {
      final dio = Dio();
      final response = await dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'format': 'jsonv2',
          'lat': lat,
          'lon': lng,
          'accept-language': 'id',
        },
        options: Options(
          headers: {
            'User-Agent': 'AmbilinApp/1.0 (contact@ambilin.com)',
          },
        ),
      );

      if (response.data != null && response.data['display_name'] != null) {
        setState(() {
          _currentAddress = response.data['display_name'].toString();
          _isLocationFound = true;
          _isLoading = false;
        });
      } else {
        setState(() {
          _currentAddress = 'Alamat tidak ditemukan ($lat, $lng)';
          _isLocationFound = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = 'Gagal memuat alamat ($lat, $lng)';
        _isLocationFound = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
          _currentAddress = 'Layanan GPS dinonaktifkan. Silakan aktifkan GPS Anda.';
          _isLocationFound = true;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoading = false;
            _currentAddress = 'Izin lokasi ditolak.';
            _isLocationFound = true;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoading = false;
          _currentAddress = 'Izin lokasi ditolak secara permanen.';
          _isLocationFound = true;
        });
        return;
      }

      // 1. Coba ambil lokasi terakhir yang diketahui (sangat cepat & andal)
      Position? position = await Geolocator.getLastKnownPosition();

      // 2. Jika tidak ada, request lokasi baru dengan akurasi medium & batas waktu
      position ??= await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 6),
      );

      final newLatLng = LatLng(position.latitude, position.longitude);
      _mapController.move(newLatLng, 15.0);
      setState(() {
        _currentLatLng = newLatLng;
      });
      await _reverseGeocode(position.latitude, position.longitude);

    } catch (e) {
      // 3. Fallback jika akurasi medium gagal/timeout: coba akurasi rendah
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: const Duration(seconds: 6),
        );
        final newLatLng = LatLng(position.latitude, position.longitude);
        _mapController.move(newLatLng, 15.0);
        setState(() {
          _currentLatLng = newLatLng;
        });
        await _reverseGeocode(position.latitude, position.longitude);
      } catch (err) {
        setState(() {
          _isLoading = false;
          _currentAddress = 'Gagal mendeteksi lokasi GPS. Pastikan GPS aktif.';
          _isLocationFound = true;
        });
      }
    }
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
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLatLng,
              initialZoom: 15.0,
              onTap: (tapPosition, latLng) {
                setState(() {
                  _currentLatLng = latLng;
                });
                _reverseGeocode(latLng.latitude, latLng.longitude);
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                additionalOptions: const {
                  'User-Agent':
                      'SeladakuApp_ByTunggulAbdulMajid_ClassOf2024_UNEJ',
                },
                userAgentPackageName: 'com.tunggul.seladaku',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentLatLng,
                    width: 50,
                    height: 50,
                    child: const Icon(
                      Icons.location_on,
                      size: 50,
                      color: AppColor.redAllert,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Positioned(
            bottom: 150,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: AppColor.base100,
              onPressed: _isLoading ? null : _getCurrentLocation,
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
                            style: AppFont.medium().copyWith(color: AppColor.font100, fontSize: 13),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
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
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.pop(context, {
                                'alamat': _currentAddress,
                                'latitude': _currentLatLng.latitude,
                                'longitude': _currentLatLng.longitude,
                              });
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
