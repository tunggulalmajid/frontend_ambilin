/// Model data untuk tabel `jenis_artikel` berdasarkan ERD Ambilin.
class JenisArtikel {
  final int idJenisArtikel;
  final String nama;

  const JenisArtikel({
    required this.idJenisArtikel,
    required this.nama,
  });

  factory JenisArtikel.fromJson(Map<String, dynamic> json) {
    return JenisArtikel(
      idJenisArtikel: json['id_jenis_artikel'] ?? 0,
      nama: json['nama'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_jenis_artikel': idJenisArtikel,
      'nama': nama,
    };
  }
}
