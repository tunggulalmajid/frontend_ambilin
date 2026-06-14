/// Model data untuk tabel `customer` berdasarkan ERD Ambilin.
class Customer {
  final int idCustomer;
  final int idUser;
  final int poin;
  final bool isMember;
  final bool isAktif;
  final DateTime? expiredMemberDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Field tambahan dari relasi user (untuk kemudahan binding di UI)
  final String nama;
  final String email;

  const Customer({
    required this.idCustomer,
    required this.idUser,
    required this.poin,
    required this.isMember,
    this.isAktif = true,
    this.expiredMemberDate,
    this.createdAt,
    this.updatedAt,
    this.nama = '',
    this.email = '',
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      idCustomer: json['id_customer'] ?? 0,
      idUser: json['id_user'] ?? 0,
      poin: json['poin'] ?? 0,
      isMember: json['is_member'] == true || json['is_member'] == 1,
      isAktif: json['is_aktif'] == true || json['is_aktif'] == 1,
      expiredMemberDate: json['expired_member_date'] != null
          ? DateTime.tryParse(json['expired_member_date'])
          : null,
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
      'id_customer': idCustomer,
      'id_user': idUser,
      'poin': poin,
      'is_member': isMember ? 1 : 0,
      'is_aktif': isAktif ? 1 : 0,
      'expired_member_date': expiredMemberDate?.toIso8601String(),
      'nama': nama,
      'email': email,
    };
  }

  /// Format masa berlaku member menjadi teks yang mudah dibaca.
  String? get masaBerlaku {
    if (expiredMemberDate == null) return null;
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    final d = expiredMemberDate!;
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  /// Data dummy tunggal untuk keperluan data binding di dashboard.
  static Customer getMockData() {
    return const Customer(
      idCustomer: 0,
      idUser: 0,
      poin: 0,
      isMember: false,
      isAktif: false,
      nama: '',
      email: '',
    );
  }

  /// Alias agar backward-compatible dengan kode lama.
  static Customer getDummyCustomer() => getMockData();
}
