/// Model data untuk tabel `role` berdasarkan ERD Ambilin.
class Role {
  final int id;
  final String namaRole;

  const Role({
    required this.id,
    required this.namaRole,
  });

  /// Data dummy tunggal untuk keperluan data binding.
  static Role getMockData() {
    return const Role(
      id: 1,
      namaRole: 'admin',
    );
  }

  /// Data dummy list untuk keperluan data binding.
  static List<Role> getMockList() {
    return const [
      Role(id: 1, namaRole: 'admin'),
      Role(id: 2, namaRole: 'petugas'),
      Role(id: 3, namaRole: 'customer'),
    ];
  }
}
