class Article {
  final String title;
  final String category;
  final String foto_tumbnail;
  // final String isi;

  const Article({
    required this.title,
    required this.category,
    required this.foto_tumbnail,
    // required this.isi,
  });

  static List<Article> getArticles() {
    return const [
      Article(
        title: 'Tips Memilah Sampah Organik dengan Benar',
        category: 'Tips',
        foto_tumbnail: 'assets/foto_3.jpg',
        // isi: "",
      ),
      Article(
        title: 'Cara Mengurangi Sampah Plastik di Rumah',
        category: 'Pengelolaan',
        foto_tumbnail: 'assets/foto_2.jpg',
        // isi: "",
      ),
      Article(
        title: 'Manfaat Daur Ulang untuk Lingkungan',
        category: 'Edukasi',
        foto_tumbnail: 'assets/foto_1.jpg',
        // isi: "",
      ),
    ];
  }
}
