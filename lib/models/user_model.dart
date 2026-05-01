class UserModel {
  final int idUser;
  final String nama;
  final String email;
  final int idRole;

  UserModel({
    required this.idUser,
    required this.nama,
    required this.email,
    required this.idRole,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUser: json['id_user'] ?? 0,
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      idRole: json['id_role'] ?? 3,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id_user': idUser, 'nama': nama, 'email': email, 'id_role': idRole};
  }
}
