/// Model data untuk tabel `subscribtion` berdasarkan ERD Ambilin,
/// serta model pendukung untuk paket langganan dan promo.
class Langganan {
  final int idSubscribtion;
  final String nama;
  final int harga;
  final int poin;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Langganan({
    required this.idSubscribtion,
    required this.nama,
    required this.harga,
    required this.poin,
    this.createdAt,
    this.updatedAt,
  });

  /// Data dummy tunggal untuk keperluan data binding.
  static Langganan getMockData() {
    return Langganan(
      idSubscribtion: 1,
      nama: '1 Bulan',
      harga: 30000,
      poin: 100,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 6, 12),
    );
  }

  /// Data dummy list untuk keperluan data binding.
  static List<Langganan> getMockList() {
    return [
      Langganan(
        idSubscribtion: 1,
        nama: '1 Bulan',
        harga: 30000,
        poin: 100,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 6, 12),
      ),
      Langganan(
        idSubscribtion: 2,
        nama: '3 Bulan',
        harga: 90000,
        poin: 350,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 6, 12),
      ),
      Langganan(
        idSubscribtion: 3,
        nama: '6 Bulan',
        harga: 180000,
        poin: 800,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 6, 12),
      ),
    ];
  }
}

/// Model data untuk paket langganan Ambilin+.
class PaketLangganan {
  final String id;
  final String durasi;
  final int hargaPerBulan; // dalam Rupiah
  final int totalBulan;

  const PaketLangganan({
    required this.id,
    required this.durasi,
    required this.hargaPerBulan,
    required this.totalBulan,
  });

  /// Total harga langganan sebelum diskon.
  int get totalHarga => hargaPerBulan * totalBulan;

  /// Dummy data paket langganan.
  static List<PaketLangganan> getPlans() {
    return const [
      PaketLangganan(
        id: 'plan_1',
        durasi: '1 Bulan',
        hargaPerBulan: 30000,
        totalBulan: 1,
      ),
      PaketLangganan(
        id: 'plan_3',
        durasi: '3 Bulan',
        hargaPerBulan: 30000,
        totalBulan: 3,
      ),
      PaketLangganan(
        id: 'plan_6',
        durasi: '6 Bulan',
        hargaPerBulan: 30000,
        totalBulan: 6,
      ),
    ];
  }
}

/// Model data untuk promo diskon.
class Promo {
  final String id;
  final String nama;
  final int diskonPersen; // persentase diskon
  final int berlakuHari; // berlaku dalam N hari

  const Promo({
    required this.id,
    required this.nama,
    required this.diskonPersen,
    required this.berlakuHari,
  });

  /// Hitung jumlah diskon dari harga asli.
  int hitungDiskon(int hargaAsli) {
    return (hargaAsli * diskonPersen / 100).round();
  }

  /// Dummy data promo yang tersedia.
  static List<Promo> getPromos() {
    return const [
      Promo(
        id: 'promo_50',
        nama: 'Diskon 50%',
        diskonPersen: 50,
        berlakuHari: 2,
      ),
      Promo(
        id: 'promo_25',
        nama: 'Diskon 25%',
        diskonPersen: 25,
        berlakuHari: 4,
      ),
      Promo(
        id: 'promo_10',
        nama: 'Diskon 10%',
        diskonPersen: 10,
        berlakuHari: 7,
      ),
      Promo(
        id: 'promo_5',
        nama: 'Diskon 5%',
        diskonPersen: 5,
        berlakuHari: 7,
      ),
    ];
  }
}
