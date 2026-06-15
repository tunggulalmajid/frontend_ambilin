class UserModel {
  final int idUser;
  final String nama;
  final String email;
  final String password;
  final String? refreshToken;
  final int idRole;
  final String? namaRole;
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
    this.namaRole,
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
      idUser: json['id_user'] != null
          ? (int.tryParse(json['id_user'].toString()) ?? 0)
          : 0,
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      refreshToken: json['refresh_token'],
      idRole: json['id_role'] != null
          ? (int.tryParse(json['id_role'].toString()) ?? 3)
          : (json['role'] != null && json['role']['id_role'] != null
                ? (int.tryParse(json['role']['id_role'].toString()) ?? 3)
                : 3),
      namaRole:
          json['nama_role'] ??
          (json['role'] != null ? json['role']['nama_role'] : null),
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
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'nama': nama,
      'email': email,
      'id_role': idRole,
      'nama_role': namaRole,
      'foto': foto,
      'alamat': alamat,
      'nomor_telepon': nomorTelepon,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
