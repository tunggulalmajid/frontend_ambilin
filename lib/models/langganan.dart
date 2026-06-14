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

  factory Langganan.fromJson(Map<String, dynamic> json) {
    return Langganan(
      idSubscribtion: json['id_subscribtion'] ?? 0,
      nama: json['nama'] ?? '',
      harga: json['harga'] ?? 0,
      poin: json['poin'] ?? 0,
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
      'id_subscribtion': idSubscribtion,
      'nama': nama,
      'harga': harga,
      'poin': poin,
    };
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
    return const [];
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
    return const [];
  }
}
