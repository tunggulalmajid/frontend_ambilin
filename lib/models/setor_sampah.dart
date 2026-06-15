class SetorSampah {
  final int idSetorSampah;
  final int? idPetugas;
  final int idCustomer;
  final int? idJenisSampah;
  final String status;
  final String? alamat;
  final double? latitude;
  final double? longitude;
  final double? beratSampah;
  final String? foto;
  final String? fotoBuktiPenjemputan;
  final DateTime? createdAt;
  final DateTime? pickupAt;
  final String pesanCustomer;

  final String customerName;
  final String petugasName;
  final String namaJenisSampah;
  final int? poinPerKg;

  const SetorSampah({
    required this.idSetorSampah,
    this.idPetugas,
    required this.idCustomer,
    this.idJenisSampah,
    required this.status,
    this.alamat,
    this.latitude,
    this.longitude,
    this.beratSampah,
    this.foto,
    this.fotoBuktiPenjemputan,
    this.createdAt,
    this.pickupAt,
    this.pesanCustomer = '',
    this.customerName = '',
    this.petugasName = '',
    this.namaJenisSampah = '',
    this.poinPerKg,
  });

  factory SetorSampah.fromJson(Map<String, dynamic> json) {
    return SetorSampah(
      idSetorSampah: json['id_setor_sampah'] ?? 0,
      idPetugas: json['id_petugas'],
      idCustomer: json['id_customer'] ?? 0,
      idJenisSampah: json['id_jenis_sampah'],
      status: json['status'] ?? 'menunggu',
      alamat: json['alamat'],
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      beratSampah: json['berat_sampah'] != null
          ? double.tryParse(json['berat_sampah'].toString())
          : null,
      foto: json['foto'],
      fotoBuktiPenjemputan: json['foto_bukti_penjemputan'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      pickupAt: json['pickup_at'] != null
          ? DateTime.tryParse(json['pickup_at'])
          : null,
      pesanCustomer: json['catatan'] ?? '',
      customerName:
          json['nama_customer'] ??
          json['customer_name'] ??
          json['Customer']?['nama'] ??
          json['Customer']?['User']?['nama'] ??
          '',
      petugasName:
          json['nama_petugas'] ??
          json['petugas_name'] ??
          json['Petugas']?['nama'] ??
          json['Petugas']?['User']?['nama'] ??
          '',
      namaJenisSampah:
          json['nama_jenis_sampah'] ??
          json['JenisSampah']?['nama_jenis_sampah'] ??
          '',
      poinPerKg: json['poin_per_kg'] != null
          ? int.tryParse(json['poin_per_kg'].toString())
          : json['JenisSampah']?['poin_per_kg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_setor_sampah': idSetorSampah,
      'id_petugas': idPetugas,
      'id_customer': idCustomer,
      'id_jenis_sampah': idJenisSampah,
      'status': status,
      'alamat': alamat,
      'latitude': latitude,
      'longitude': longitude,
      'berat_sampah': beratSampah,
      'foto': foto,
      'foto_bukti_penjemputan': fotoBuktiPenjemputan,
      'catatan': pesanCustomer,
    };
  }

  static List<SetorSampah> getMockList() {
    return const [
      SetorSampah(
        idSetorSampah: 0,
        idCustomer: 0,
        status: 'selesai',
        pesanCustomer: '',
        customerName: '',
        petugasName: '',
      ),
    ];
  }
}
