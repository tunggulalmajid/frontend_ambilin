class Transaksi {
  final int idTransaksi;
  final int idCustomer;
  final int? idAdmin;
  final int idSubscription;
  final String? buktiPembayaran;
  final String metodePembayaran;
  final String status;
  final DateTime? createdAt;
  final DateTime? confirmedAt;

  final int harga;

  const Transaksi({
    required this.idTransaksi,
    required this.idCustomer,
    this.idAdmin,
    required this.idSubscription,
    this.buktiPembayaran,
    required this.metodePembayaran,
    required this.status,
    this.createdAt,
    this.confirmedAt,
    this.harga = 0,
  });

  static Transaksi getMockData() {
    return Transaksi(
      idTransaksi: 1,
      idCustomer: 1,
      idAdmin: null,
      idSubscription: 1,
      buktiPembayaran: null,
      metodePembayaran: 'BCA',
      status: 'pending',
      createdAt: DateTime(2026, 6, 12),
      harga: 15000,
    );
  }

  static List<Transaksi> getMockList() {
    return [
      Transaksi(
        idTransaksi: 1,
        idCustomer: 1,
        idSubscription: 1,
        metodePembayaran: 'BCA',
        status: 'pending',
        createdAt: DateTime(2026, 6, 12),
        harga: 15000,
      ),
      Transaksi(
        idTransaksi: 2,
        idCustomer: 2,
        idAdmin: 1,
        idSubscription: 2,
        buktiPembayaran: 'bukti_tf_002.jpg',
        metodePembayaran: 'Dana',
        status: 'success',
        createdAt: DateTime(2026, 6, 10),
        confirmedAt: DateTime(2026, 6, 11),
        harga: 30000,
      ),
      Transaksi(
        idTransaksi: 3,
        idCustomer: 1,
        idSubscription: 3,
        metodePembayaran: 'GoPay',
        status: 'failed',
        createdAt: DateTime(2026, 6, 8),
        harga: 30000,
      ),
    ];
  }
}
