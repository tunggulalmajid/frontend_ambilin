class RiwayatPenjemputan {
  final String id;
  final String namaCustomer;
  final String namaPetugas;
  final String tanggal;
  final String berat;
  final String status; // 'Selesai', 'Diproses', 'Dijemput'

  const RiwayatPenjemputan({
    required this.id,
    required this.namaCustomer,
    required this.namaPetugas,
    required this.tanggal,
    required this.berat,
    required this.status,
  });

  /// Dummy data matching the design
  static List<RiwayatPenjemputan> getDummyData() {
    return const [
      RiwayatPenjemputan(
        id: 'ID Pemesanan',
        namaCustomer: 'Fahri Ananta',
        namaPetugas: 'Hadianto',
        tanggal: '2 Jun 2025',
        berat: '5 kg',
        status: 'Selesai',
      ),
      RiwayatPenjemputan(
        id: 'ID Pemesanan',
        namaCustomer: 'Naufal Hakim',
        namaPetugas: 'Hadianto',
        tanggal: '2 Jun 2025',
        berat: '5 kg',
        status: 'Diproses',
      ),
      RiwayatPenjemputan(
        id: 'ID Pemesanan',
        namaCustomer: 'Tangga Panjili',
        namaPetugas: 'Hadianto',
        tanggal: '2 Jun 2025',
        berat: '5 kg',
        status: 'Dijemput',
      ),
    ];
  }
}
