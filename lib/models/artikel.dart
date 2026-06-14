/// Model data untuk tabel `artikel` berdasarkan ERD Ambilin.
class Artikel {
  final int idArtikel;
  final int idAdmin;
  final int idJenisArtikel;
  final String judul;
  final String? fotoThumbnail;
  final String isi;
  final bool isDelete;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Field tambahan dari relasi (untuk kemudahan binding di UI)
  final String kategori; // nama jenis artikel
  final String status;   // 'Aktif' / 'Nonaktif' berdasarkan isDelete

  const Artikel({
    required this.idArtikel,
    required this.idAdmin,
    required this.idJenisArtikel,
    required this.judul,
    this.fotoThumbnail,
    this.isi = '',
    this.isDelete = false,
    this.createdAt,
    this.updatedAt,
    this.kategori = '',
    this.status = 'Aktif',
  });

  factory Artikel.fromJson(Map<String, dynamic> json) {
    final isDel = json['is_delete'] == true || json['is_delete'] == 1 || json['is_delete'] == '1';
    return Artikel(
      idArtikel: json['id_artikel'] ?? 0,
      idAdmin: json['id_admin'] ?? 0,
      idJenisArtikel: json['id_jenis_artikel'] ?? 0,
      judul: json['judul'] ?? '',
      fotoThumbnail: json['foto_thumbnail'],
      isi: json['isi'] ?? '',
      isDelete: isDel,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      kategori: json['kategori_nama'] ?? json['JenisArtikel']?['nama'] ?? '',
      status: isDel ? 'Nonaktif' : 'Aktif',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_artikel': idArtikel,
      'id_admin': idAdmin,
      'id_jenis_artikel': idJenisArtikel,
      'judul': judul,
      'foto_thumbnail': fotoThumbnail,
      'isi': isi,
      'is_delete': isDelete ? 1 : 0,
    };
  }

  /// Format tanggal menjadi teks yang mudah dibaca.
  String get tanggalFormatted {
    if (createdAt == null) return '';
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    final d = createdAt!;
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  /// Data dummy list untuk keperluan data binding.
  static List<Artikel> getMockList() {
    return const [
      Artikel(
        idArtikel: 0,
        idAdmin: 0,
        idJenisArtikel: 0,
        judul: '',
        isi: '',
        kategori: '',
        status: 'Aktif',
      ),
    ];
  }
}
