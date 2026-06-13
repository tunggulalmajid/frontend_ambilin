/// Model data untuk tabel `detail_setor_sampah` berdasarkan ERD Ambilin.
class DetailSetorSampah {
  final int idDetailSetorSampah;
  final int idSetorSampah;
  final int idJenisSampah;
  final double beratSampah;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Field tambahan dari relasi (untuk kemudahan binding di UI)
  final String namaJenisSampah;

  const DetailSetorSampah({
    required this.idDetailSetorSampah,
    required this.idSetorSampah,
    required this.idJenisSampah,
    required this.beratSampah,
    this.createdAt,
    this.updatedAt,
    this.namaJenisSampah = '',
  });

  /// Data dummy tunggal untuk keperluan data binding.
  static DetailSetorSampah getMockData() {
    return DetailSetorSampah(
      idDetailSetorSampah: 1,
      idSetorSampah: 1,
      idJenisSampah: 1,
      beratSampah: 3.5,
      createdAt: DateTime(2026, 6, 2),
      updatedAt: DateTime(2026, 6, 2),
      namaJenisSampah: 'Plastik',
    );
  }

  /// Data dummy list untuk keperluan data binding.
  static List<DetailSetorSampah> getMockList() {
    return [
      DetailSetorSampah(
        idDetailSetorSampah: 1,
        idSetorSampah: 1,
        idJenisSampah: 1,
        beratSampah: 3.5,
        createdAt: DateTime(2026, 6, 2),
        updatedAt: DateTime(2026, 6, 2),
        namaJenisSampah: 'Plastik',
      ),
      DetailSetorSampah(
        idDetailSetorSampah: 2,
        idSetorSampah: 1,
        idJenisSampah: 2,
        beratSampah: 1.5,
        createdAt: DateTime(2026, 6, 2),
        updatedAt: DateTime(2026, 6, 2),
        namaJenisSampah: 'Kertas',
      ),
      DetailSetorSampah(
        idDetailSetorSampah: 3,
        idSetorSampah: 2,
        idJenisSampah: 3,
        beratSampah: 2.0,
        createdAt: DateTime(2026, 6, 2),
        updatedAt: DateTime(2026, 6, 2),
        namaJenisSampah: 'Kardus',
      ),
    ];
  }
}
