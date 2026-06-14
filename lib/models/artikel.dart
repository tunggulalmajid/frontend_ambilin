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

  /// Data dummy tunggal untuk keperluan data binding.
  static Artikel getMockData() {
    return Artikel(
      idArtikel: 1,
      idAdmin: 1,
      idJenisArtikel: 1,
      judul: '5 Tips Hemat Sampah',
      fotoThumbnail: 'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=200',
      isi: 'Meminimalkan produksi sampah harian sebenarnya bisa dimulai dari langkah-langkah kecil di dalam rumah.',
      isDelete: false,
      createdAt: DateTime(2026, 6, 12),
      updatedAt: DateTime(2026, 6, 12),
      kategori: 'Tips',
      status: 'Aktif',
    );
  }

  /// Data dummy list untuk keperluan data binding.
  static List<Artikel> getMockList() {
    return [
      Artikel(
        idArtikel: 1,
        idAdmin: 1,
        idJenisArtikel: 1,
        judul: '5 Tips Hemat Sampah',
        fotoThumbnail: 'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=200',
        isi: 'Meminimalkan produksi sampah harian sebenarnya bisa dimulai dari langkah-langkah kecil di dalam rumah. Langkah pertama yang paling efektif adalah selalu membawa tas belanja kain dan botol minum sendiri.',
        createdAt: DateTime(2026, 6, 12),
        updatedAt: DateTime(2026, 6, 12),
        kategori: 'Tips',
        status: 'Aktif',
      ),
      Artikel(
        idArtikel: 2,
        idAdmin: 1,
        idJenisArtikel: 2,
        judul: 'Mengenal Recycle Plastik',
        fotoThumbnail: 'https://images.unsplash.com/photo-1611284446314-60a58ac0deb9?w=200',
        isi: 'Plastik merupakan salah satu material yang paling sulit terurai secara alami. Proses daur ulang plastik membantu mengurangi pencemaran lingkungan.',
        createdAt: DateTime(2026, 6, 12),
        updatedAt: DateTime(2026, 6, 12),
        kategori: 'Edukasi',
        status: 'Aktif',
      ),
      Artikel(
        idArtikel: 3,
        idAdmin: 1,
        idJenisArtikel: 3,
        judul: 'Kisah Inspiratif Pemuda...',
        fotoThumbnail: 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=200',
        isi: 'Seorang pemuda dari kota kecil berhasil mengubah desanya menjadi contoh pengelolaan sampah terbaik di Indonesia.',
        createdAt: DateTime(2026, 6, 12),
        updatedAt: DateTime(2026, 6, 12),
        kategori: 'Inspirasi',
        status: 'Aktif',
      ),
      Artikel(
        idArtikel: 4,
        idAdmin: 1,
        idJenisArtikel: 4,
        judul: 'Pemerintah Dorong Progr...',
        fotoThumbnail: 'https://images.unsplash.com/photo-1604187351574-c75ca79f5807?w=200',
        isi: 'Pemerintah Indonesia telah mencanangkan program nasional pengurangan sampah plastik hingga 70% pada tahun 2030.',
        createdAt: DateTime(2026, 6, 12),
        updatedAt: DateTime(2026, 6, 12),
        kategori: 'Berita',
        status: 'Aktif',
      ),
      Artikel(
        idArtikel: 5,
        idAdmin: 1,
        idJenisArtikel: 4,
        judul: 'Bank Sampah Penuh!',
        fotoThumbnail: 'https://images.unsplash.com/photo-1526951521990-620dc14c0b58?w=200',
        isi: 'Beberapa bank sampah di wilayah perkotaan mengalami kelebihan kapasitas akibat meningkatnya kesadaran masyarakat.',
        isDelete: true,
        createdAt: DateTime(2026, 6, 12),
        updatedAt: DateTime(2026, 6, 12),
        kategori: 'Berita',
        status: 'Nonaktif',
      ),
    ];
  }
}
