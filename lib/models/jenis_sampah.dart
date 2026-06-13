/// Model data untuk tabel `jenis_sampah` berdasarkan ERD Ambilin.
class JenisSampah {
  final int idJenisSampah;
  final String nama;
  final int poinPerKg;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const JenisSampah({
    required this.idJenisSampah,
    required this.nama,
    required this.poinPerKg,
    this.createdAt,
    this.updatedAt,
  });

  /// Data dummy tunggal untuk keperluan data binding.
  static JenisSampah getMockData() {
    return JenisSampah(
      idJenisSampah: 1,
      nama: 'Plastik',
      poinPerKg: 50,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 6, 12),
    );
  }

  /// Data dummy list untuk keperluan data binding.
  static List<JenisSampah> getMockList() {
    return [
      JenisSampah(
        idJenisSampah: 1,
        nama: 'Plastik',
        poinPerKg: 50,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 6, 12),
      ),
      JenisSampah(
        idJenisSampah: 2,
        nama: 'Kertas',
        poinPerKg: 100,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 6, 12),
      ),
      JenisSampah(
        idJenisSampah: 3,
        nama: 'Kardus',
        poinPerKg: 100,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 6, 12),
      ),
      JenisSampah(
        idJenisSampah: 4,
        nama: 'Kaca',
        poinPerKg: 50,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 6, 12),
      ),
      JenisSampah(
        idJenisSampah: 5,
        nama: 'Elektronik',
        poinPerKg: 75,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 6, 12),
      ),
    ];
  }
}
