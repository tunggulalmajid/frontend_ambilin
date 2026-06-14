/// Model data untuk tabel `user` berdasarkan ERD Ambilin.
class UserModel {
  final int idUser;
  final String nama;
  final String email;
  final String password;
  final String? refreshToken;
  final int idRole;
  final String? foto;
  final String? alamat;
  final String? nomorTelepon;
  final double? latitude;
  final double? longitude;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.idUser,
    required this.nama,
    required this.email,
    this.password = '',
    this.refreshToken,
    required this.idRole,
    this.foto,
    this.alamat,
    this.nomorTelepon,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUser: json['id_user'] ?? 0,
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      refreshToken: json['refresh_token'],
      idRole: json['id_role'] ?? 3,
      foto: json['foto'],
      alamat: json['alamat'],
      nomorTelepon: json['nomor_telepon'],
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'nama': nama,
      'email': email,
      'id_role': idRole,
      'foto': foto,
      'alamat': alamat,
      'nomor_telepon': nomorTelepon,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
