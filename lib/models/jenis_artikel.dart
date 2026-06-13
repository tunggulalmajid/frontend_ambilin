/// Model data untuk tabel `jenis_artikel` berdasarkan ERD Ambilin.
class JenisArtikel {
  final int idJenisArtikel;
  final String nama;

  const JenisArtikel({
    required this.idJenisArtikel,
    required this.nama,
  });

  /// Data dummy tunggal untuk keperluan data binding.
  static JenisArtikel getMockData() {
    return const JenisArtikel(
      idJenisArtikel: 1,
      nama: 'Tips',
    );
  }

  /// Data dummy list untuk keperluan data binding.
  static List<JenisArtikel> getMockList() {
    return const [
      JenisArtikel(idJenisArtikel: 1, nama: 'Tips'),
      JenisArtikel(idJenisArtikel: 2, nama: 'Edukasi'),
      JenisArtikel(idJenisArtikel: 3, nama: 'Inspirasi'),
      JenisArtikel(idJenisArtikel: 4, nama: 'Berita'),
    ];
  }
}
