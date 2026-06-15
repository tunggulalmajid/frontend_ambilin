class JenisSampah {
  final int idJenisSampah;
  final String nama;
  final int poinPerKg;
  final bool isDelete;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const JenisSampah({
    required this.idJenisSampah,
    required this.nama,
    required this.poinPerKg,
    this.isDelete = false,
    this.createdAt,
    this.updatedAt,
  });

  factory JenisSampah.fromJson(Map<String, dynamic> json) {
    return JenisSampah(
      idJenisSampah: json['id_jenis_sampah'] ?? 0,
      nama: json['nama_jenis_sampah'] ?? json['nama'] ?? '',
      poinPerKg: json['poin_per_kg'] ?? 0,
      isDelete:
          json['is_delete'] == true ||
          json['is_delete'] == 1 ||
          json['is_delete'] == '1',
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
      'id_jenis_sampah': idJenisSampah,
      'nama': nama,
      'poin_per_kg': poinPerKg,
      'is_delete': isDelete ? 1 : 0,
    };
  }
}
