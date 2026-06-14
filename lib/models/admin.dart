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

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      idAdmin: json['id_admin'] ?? 0,
      idUser: json['id_user'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_admin': idAdmin,
      'id_user': idUser,
      'nama': nama,
      'email': email,
    };
  }
}
