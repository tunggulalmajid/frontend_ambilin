class DetailSetorSampah {
  final int idDetailSetorSampah;
  final int idSetorSampah;
  final int idJenisSampah;
  final double beratSampah;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
