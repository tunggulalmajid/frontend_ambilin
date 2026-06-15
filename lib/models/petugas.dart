class Petugas {
  final int idPetugas;
  final int idUser;
  final bool isAktif;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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

  factory Petugas.fromJson(Map<String, dynamic> json) {
    return Petugas(
      idPetugas: json['id_petugas'] ?? 0,
      idUser: json['id_user'] ?? 0,
      isAktif: json['is_aktif'] == true || json['is_aktif'] == 1,
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
      'id_petugas': idPetugas,
      'id_user': idUser,
      'is_aktif': isAktif ? 1 : 0,
      'nama': nama,
      'email': email,
    };
  }
}
