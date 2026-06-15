import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../models/setor_sampah.dart';
import '../../../providers/auth_provider.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_font.dart';

class PetugasLihatMapPage extends StatefulWidget {
  final SetorSampah data;
  const PetugasLihatMapPage({super.key, required this.data});

  @override
  State<PetugasLihatMapPage> createState() => _PetugasLihatMapPageState();
}

class _PetugasLihatMapPageState extends State<PetugasLihatMapPage> {
  final MapController _mapController = MapController();
  
  List<LatLng> _routePoints = [];
  LatLng? _driverLocation;
  
  bool _isLoading = false;
  double? _distanceKm;
  double? _durationMin;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchLocationAndRoute();
  }

  Future<void> _fetchLocationAndRoute() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      LatLng? driverLatLng;

      // 1. Dapatkan lokasi driver saat ini menggunakan Geolocator
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
          final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
          driverLatLng = LatLng(position.latitude, position.longitude);
        }
      }

      // Fallback ke data koordinat driver dari profil (jika GPS gagal)
      if (driverLatLng == null) {
        final user = context.read<AuthProvider>().user;
        if (user != null && user.latitude != null && user.longitude != null) {
          driverLatLng = LatLng(user.latitude!, user.longitude!);
        }
      }

      if (driverLatLng != null) {
        setState(() {
          _driverLocation = driverLatLng;
        });

        // 2. Fetch data rute dari OSRM
        final double wasteLat = widget.data.latitude ?? -8.1724;
        final double wasteLng = widget.data.longitude ?? 113.7005;

        final response = await Dio().get(
          'https://router.project-osrm.org/route/v1/driving/${driverLatLng.longitude},${driverLatLng.latitude};$wasteLng,$wasteLat',
          queryParameters: {
            'geometries': 'geojson',
            'overview': 'full',
          },
        );

        if (response.statusCode == 200) {
          final data = response.data;
          final routes = data['routes'] as List;
          if (routes.isNotEmpty) {
            final double distance = (routes[0]['distance'] as num).toDouble();
            final double duration = (routes[0]['duration'] as num).toDouble();
            
            final geometry = routes[0]['geometry'];
            final coordinates = geometry['coordinates'] as List;
            final points = coordinates.map((coord) {
              final lon = coord[0] as double;
              final lat = coord[1] as double;
              return LatLng(lat, lon);
            }).toList();

            setState(() {
              _routePoints = points;
              _distanceKm = distance / 1000;
              _durationMin = duration / 60;
            });

            // Fokuskan kamera ke tengah-tengah rute
            final centerLat = (driverLatLng!.latitude + wasteLat) / 2;
            final centerLng = (driverLatLng!.longitude + wasteLng) / 2;
            _mapController.move(LatLng(centerLat, centerLng), 13.0);
          }
        }
      } else {
        setState(() {
          _errorMessage = 'Gagal mengakses GPS. Pastikan izin lokasi aktif.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal mengambil rute jalan: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double wasteLat = widget.data.latitude ?? -8.1724;
    final double wasteLng = widget.data.longitude ?? 113.7005;
    
    // Tentukan titik tengah peta
    LatLng initialCenter = LatLng(wasteLat, wasteLng);
    if (_driverLocation != null) {
      initialCenter = LatLng(
        (wasteLat + _driverLocation!.latitude) / 2,
        (wasteLng + _driverLocation!.longitude) / 2,
      );
    }

    return Scaffold(
      backgroundColor: AppColor.putihBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColor.base100),
        title: Text(
          'Navigasi Rute Penjemputan',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColor.base100,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColor.base100),
            onPressed: _isLoading ? null : _fetchLocationAndRoute,
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. Peta Interaktif
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: _driverLocation != null ? 13.0 : 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                additionalOptions: const {
                  'User-Agent': 'SeladakuApp_ByTunggulAbdulMajid_ClassOf2024_UNEJ',
                },
                userAgentPackageName: 'com.tunggul.seladaku',
              ),
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      color: AppColor.base100,
                      strokeWidth: 5.0,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  // Penanda lokasi sampah (Tujuan) - Merah
                  Marker(
                    point: LatLng(wasteLat, wasteLng),
                    width: 45,
                    height: 45,
                    child: const Icon(
                      Icons.location_on,
                      color: AppColor.redAllert,
                      size: 38,
                    ),
                  ),
                  // Penanda lokasi petugas (Asal) - Biru
                  if (_driverLocation != null)
                    Marker(
                      point: _driverLocation!,
                      width: 40,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.navigation_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),

          // 2. Loading indicator
          if (_isLoading)
            const Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: AppColor.base100,
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Mengalkulasi rute jalan...',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // 3. Error alert banner
          if (_errorMessage.isNotEmpty)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Card(
                color: Colors.red.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.red.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _errorMessage,
                    style: GoogleFonts.poppins(color: Colors.red.shade800, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

          // 4. Panel Info Rute & Alamat di Bagian Bawah
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColor.base20,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.directions_car_rounded,
                          color: AppColor.base100,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _distanceKm != null && _durationMin != null
                                  ? '${_distanceKm!.toStringAsFixed(2)} km (~${_durationMin!.toStringAsFixed(0)} mnt)'
                                  : 'Mencari rute...',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: AppColor.font100,
                              ),
                            ),
                            Text(
                              'Estimasi waktu berkendara',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: AppColor.font80,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: AppColor.font80,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alamat Penjemputan',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: AppColor.font80,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.data.alamat ?? 'Tidak ada alamat',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: AppColor.font100,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
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
