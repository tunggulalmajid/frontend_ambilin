/// Model data untuk tabel `petugas` berdasarkan ERD Ambilin.
class Petugas {
  final int idPetugas;
  final int idUser;
  final bool isAktif;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Field tambahan dari relasi user (untuk kemudahan binding di UI)
  final String nama;
  final String email;

  const Petugas({
    required this.idPetugas,
    required this.idUser,
    this.isAktif = true,
    this.createdAt,
    this.updatedAt,
    this.nama = '',
    this.email = '',
  });

  /// Data dummy tunggal untuk keperluan data binding.
  static Petugas getMockData() {
    return Petugas(
      idPetugas: 1,
      idUser: 2,
      isAktif: true,
      createdAt: DateTime(2026, 2, 15),
      updatedAt: DateTime(2026, 6, 12),
      nama: 'Hadianto',
      email: 'hadianto@gmail.com',
    );
  }

  /// Data dummy list untuk keperluan data binding.
  static List<Petugas> getMockList() {
    return [
      Petugas(
        idPetugas: 1,
        idUser: 2,
        isAktif: true,
        createdAt: DateTime(2026, 2, 15),
        updatedAt: DateTime(2026, 6, 12),
        nama: 'Hadianto',
        email: 'hadianto@gmail.com',
      ),
      Petugas(
        idPetugas: 2,
        idUser: 5,
        isAktif: false,
        createdAt: DateTime(2026, 3, 1),
        updatedAt: DateTime(2026, 6, 12),
        nama: 'Roihan Abdul',
        email: 'roihan@gmail.com',
      ),
    ];
  }
}
