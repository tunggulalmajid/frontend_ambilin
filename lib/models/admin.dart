/// Model data untuk tabel `admin` berdasarkan ERD Ambilin.
class Admin {
  final int idAdmin;
  final int idUser;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Field tambahan dari relasi user (untuk kemudahan binding di UI)
  final String nama;
  final String email;

  const Admin({
    required this.idAdmin,
    required this.idUser,
    this.createdAt,
    this.updatedAt,
    this.nama = '',
    this.email = '',
  });

  /// Data dummy tunggal untuk keperluan data binding.
  static Admin getMockData() {
    return Admin(
      idAdmin: 1,
      idUser: 3,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 6, 12),
      nama: 'Admin Ambilin',
      email: 'admin@ambilin.com',
    );
  }

  /// Data dummy list untuk keperluan data binding.
  static List<Admin> getMockList() {
    return [
      Admin(
        idAdmin: 1,
        idUser: 3,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 6, 12),
        nama: 'Admin Ambilin',
        email: 'admin@ambilin.com',
      ),
    ];
  }
}
