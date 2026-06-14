import 'setor_sampah.dart';

class RiwayatPenjemputan {
  final String id;
  final String namaCustomer;
  final String namaPetugas;
  final String tanggal;
  final String berat;
  final String status; // 'Selesai', 'Diproses', 'Dijemput'

  const RiwayatPenjemputan({
    required this.id,
    required this.namaCustomer,
    required this.namaPetugas,
    required this.tanggal,
    required this.berat,
    required this.status,
  });

  factory RiwayatPenjemputan.fromSetorSampah(SetorSampah setor) {
    String localStatus = 'Dijemput';
    if (setor.status == 'proses') localStatus = 'Diproses';
    if (setor.status == 'selesai') localStatus = 'Selesai';
    if (setor.status == 'dibatalkan') localStatus = 'Dibatalkan';

    String tgl = '';
    if (setor.createdAt != null) {
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      final d = setor.createdAt!;
      tgl = '${d.day} ${months[d.month - 1]} ${d.year}';
    }

    return RiwayatPenjemputan(
      id: 'ID Pemesanan ${setor.idSetorSampah}',
      namaCustomer: setor.customerName.isNotEmpty ? setor.customerName : 'Pelanggan',
      namaPetugas: setor.petugasName.isNotEmpty ? setor.petugasName : '-',
      tanggal: tgl,
      berat: '${setor.beratSampah ?? 0} kg',
      status: localStatus,
    );
  }
}
