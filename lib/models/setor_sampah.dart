/// Model data untuk tabel `setor_sampah` berdasarkan ERD Ambilin.
/// Kolom `pesan_customer` ditambahkan sebagai field tambahan (String).
class SetorSampah {
  final int idSetorSampah;
  final int idPetugas;
  final int idCustomer;
  final String status; // enum: 'menunggu', 'dijemput', 'diproses', 'selesai', 'ditolak'
  final String? alamat;
  final double? latitude;
  final double? longitude;
  final String? foto;
  final DateTime? createdAt;
  final DateTime? pickupAt;
  final String pesanCustomer; // Kolom tambahan sesuai permintaan

  // Field tambahan dari relasi (untuk kemudahan binding di UI)
  final String customerName;
  final String petugasName;

  const SetorSampah({
    required this.idSetorSampah,
    required this.idPetugas,
    required this.idCustomer,
    required this.status,
    this.alamat,
    this.latitude,
    this.longitude,
    this.foto,
    this.createdAt,
    this.pickupAt,
    this.pesanCustomer = '',
    this.customerName = '',
    this.petugasName = '',
  });

  /// Data dummy tunggal untuk keperluan data binding.
  static SetorSampah getMockData() {
    return SetorSampah(
      idSetorSampah: 1,
      idPetugas: 1,
      idCustomer: 1,
      status: 'selesai',
      alamat: 'Jl. Sudirman No. 10, Padang',
      latitude: -0.9471,
      longitude: 100.4172,
      createdAt: DateTime(2026, 6, 2),
      pickupAt: DateTime(2026, 6, 2, 10, 30),
      pesanCustomer: 'Tolong jemput di depan pagar ya, terima kasih.',
      customerName: 'Fahri Ananta',
      petugasName: 'Hadianto',
    );
  }

  /// Data dummy list untuk keperluan data binding.
  static List<SetorSampah> getMockList() {
    return [
      SetorSampah(
        idSetorSampah: 1,
        idPetugas: 1,
        idCustomer: 1,
        status: 'selesai',
        alamat: 'Jl. Sudirman No. 10, Padang',
        latitude: -0.9471,
        longitude: 100.4172,
        createdAt: DateTime(2026, 6, 2),
        pickupAt: DateTime(2026, 6, 2, 10, 30),
        pesanCustomer: 'Tolong jemput di depan pagar.',
        customerName: 'Fahri Ananta',
        petugasName: 'Hadianto',
      ),
      SetorSampah(
        idSetorSampah: 2,
        idPetugas: 1,
        idCustomer: 2,
        status: 'diproses',
        alamat: 'Jl. Rasuna Said No. 5, Padang',
        latitude: -0.9500,
        longitude: 100.4200,
        createdAt: DateTime(2026, 6, 2),
        pesanCustomer: 'Sampah sudah ditaruh di samping rumah.',
        customerName: 'Naufal Hakim',
        petugasName: 'Hadianto',
      ),
      SetorSampah(
        idSetorSampah: 3,
        idPetugas: 1,
        idCustomer: 3,
        status: 'dijemput',
        alamat: 'Jl. Ahmad Yani No. 15, Padang',
        latitude: -0.9480,
        longitude: 100.4180,
        createdAt: DateTime(2026, 6, 2),
        pesanCustomer: '',
        customerName: 'Tangga Panjili',
        petugasName: 'Hadianto',
      ),
    ];
  }
}
