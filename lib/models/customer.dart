/// Model data untuk tabel `customer` berdasarkan ERD Ambilin.
class Customer {
  final int idCustomer;
  final int idUser;
  final int poin;
  final bool isMember;
  final bool isAktif;
  final DateTime? expiredMemberDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Field tambahan dari relasi user (untuk kemudahan binding di UI)
  final String nama;
  final String email;

  const Customer({
    required this.idCustomer,
    required this.idUser,
    required this.poin,
    required this.isMember,
    this.isAktif = true,
    this.expiredMemberDate,
    this.createdAt,
    this.updatedAt,
    this.nama = '',
    this.email = '',
  });

  /// Format masa berlaku member menjadi teks yang mudah dibaca.
  String? get masaBerlaku {
    if (expiredMemberDate == null) return null;
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    final d = expiredMemberDate!;
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  /// Data dummy tunggal untuk keperluan data binding di dashboard.
  static Customer getMockData() {
    return Customer(
      idCustomer: 1,
      idUser: 1,
      poin: 1000,
      isMember: true,
      isAktif: true,
      expiredMemberDate: DateTime(2026, 7, 12),
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 6, 12),
      nama: 'User',
      email: 'user@gmail.com',
    );
  }

  /// Alias agar backward-compatible dengan kode lama.
  static Customer getDummyCustomer() => getMockData();

  /// Data dummy list untuk keperluan data binding.
  static List<Customer> getMockList() {
    return [
      Customer(
        idCustomer: 1,
        idUser: 1,
        poin: 1000,
        isMember: true,
        isAktif: true,
        expiredMemberDate: DateTime(2026, 7, 12),
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 6, 12),
        nama: 'Tunggul Almajid',
        email: 'tunggul@gmail.com',
      ),
      Customer(
        idCustomer: 2,
        idUser: 4,
        poin: 250,
        isMember: false,
        isAktif: true,
        createdAt: DateTime(2026, 3, 10),
        updatedAt: DateTime(2026, 6, 12),
        nama: 'Rafi Ananta',
        email: 'rafi@gmail.com',
      ),
    ];
  }
}
