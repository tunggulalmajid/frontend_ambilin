library;

import 'package:flutter/material.dart';
import 'package:frontend_ambilin/models/artikel.dart';
import 'package:frontend_ambilin/models/riwayat_penjemputan.dart';
import 'package:frontend_ambilin/models/akun_pengguna.dart';
import 'package:frontend_ambilin/utils/app_color.dart';
import 'package:frontend_ambilin/utils/app_font.dart';

class ArticleCard extends StatelessWidget {
  final String title;
  final String category;
  final VoidCallback? onTap;

  const ArticleCard({
    super.key,
    required this.title,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColor.putih100,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              decoration: const BoxDecoration(
                color: Color(0xFFFF0000),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppFont.semibold().copyWith(
                      fontSize: 14,
                      color: AppColor.font100,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        category,
                        style: AppFont.regular().copyWith(
                          fontSize: 12,
                          color: AppColor.font80,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 2. PromoCard — Kartu promo untuk halaman pilih promo.
// ============================================================================

class PromoCard extends StatelessWidget {
  final String namaPromo;
  final String berlaku;
  final bool isSelected;
  final VoidCallback onPakai;

  const PromoCard({
    super.key,
    required this.namaPromo,
    required this.berlaku,
    this.isSelected = false,
    required this.onPakai,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColor.putih100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? AppColor.base100 : AppColor.font60,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ikon promo bulat merah
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColor.redAllert,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 14),

          // Nama promo & masa berlaku
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  namaPromo,
                  style: AppFont.bold().copyWith(
                    fontSize: 16,
                    color: AppColor.font100,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  berlaku,
                  style: AppFont.regular().copyWith(
                    fontSize: 12,
                    color: AppColor.font80,
                  ),
                ),
              ],
            ),
          ),

          // Tombol "Pakai"
          SizedBox(
            height: 34,
            child: ElevatedButton(
              onPressed: onPakai,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isSelected ? AppColor.base60 : AppColor.base100,
                foregroundColor: AppColor.putih100,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              child: Text(
                isSelected ? 'Dipakai' : 'Pakai',
                style: AppFont.semibold().copyWith(
                  fontSize: 13,
                  color: AppColor.putih100,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 3. PaymentMethodCard — Kartu metode pembayaran.
// ============================================================================

class PaymentMethodCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColor.base100 : AppColor.font60,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColor.base100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 24, color: Colors.white),
            ),
            const SizedBox(width: 14),

            // Title & subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppFont.semibold().copyWith(
                      fontSize: 14,
                      color: AppColor.font100,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppFont.regular().copyWith(
                      fontSize: 12,
                      color: AppColor.font80,
                    ),
                  ),
                ],
              ),
            ),

            // Chevron
            const Icon(
              Icons.chevron_right,
              size: 24,
              color: AppColor.font80,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 4. UserAccountCard — Kartu akun pengguna untuk halaman manajemen akun.
// ============================================================================

class UserAccountCard extends StatelessWidget {
  final AkunPengguna user;
  final VoidCallback? onMenuTap;

  const UserAccountCard({
    super.key,
    required this.user,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColor.putih100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.font60.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar circle with initial
          CircleAvatar(
            radius: 22,
            backgroundColor: user.warnaAvatar.withOpacity(0.15),
            child: Text(
              user.inisial,
              style: AppFont.bold().copyWith(
                fontSize: 18,
                color: user.warnaAvatar,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name, email, badges
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.nama,
                  style: AppFont.semibold().copyWith(
                    fontSize: 14,
                    color: AppColor.font100,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user.email,
                  style: AppFont.regular().copyWith(
                    fontSize: 12,
                    color: AppColor.font80,
                  ),
                ),
                const SizedBox(height: 6),
                // Role + Status badges
                Row(
                  children: [
                    _buildBadge(
                      label: user.peran,
                      textColor: _roleTextColor(),
                      backgroundColor: _roleBackgroundColor(),
                    ),
                    const SizedBox(width: 6),
                    _buildBadge(
                      label: user.status,
                      textColor: _statusTextColor(),
                      backgroundColor: _statusBackgroundColor(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Three-dot menu
          GestureDetector(
            onTap: onMenuTap,
            child: const Icon(
              Icons.more_vert,
              color: AppColor.font80,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  // --- Role badge colors ---
  Color _roleTextColor() {
    switch (user.peran) {
      case 'Petugas':
        return const Color(0xFFE65100); // deep orange
      case 'Pelanggan':
        return const Color(0xFF1565C0); // blue
      default:
        return AppColor.font80;
    }
  }

  Color _roleBackgroundColor() {
    switch (user.peran) {
      case 'Petugas':
        return const Color(0xFFFFF3E0); // light orange
      case 'Pelanggan':
        return const Color(0xFFE3F2FD); // light blue
      default:
        return AppColor.font60;
    }
  }

  // --- Status badge colors ---
  Color _statusTextColor() {
    switch (user.status) {
      case 'Aktif':
        return AppColor.base100;
      case 'Nonaktif':
        return const Color(0xFFD32F2F); // red
      default:
        return AppColor.font80;
    }
  }

  Color _statusBackgroundColor() {
    switch (user.status) {
      case 'Aktif':
        return AppColor.base20;
      case 'Nonaktif':
        return const Color(0xFFFFEBEE); // light red
      default:
        return AppColor.font60;
    }
  }

  // --- Badge builder ---
  Widget _buildBadge({
    required String label,
    required Color textColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppFont.medium().copyWith(
          fontSize: 10,
          color: textColor,
        ),
      ),
    );
  }
}

// ============================================================================
// 5. ArticleManagementCard — Kartu artikel untuk halaman manajemen artikel.
// ============================================================================

class ArticleManagementCard extends StatelessWidget {
  final Artikel article;
  final VoidCallback? onMenuTap;

  const ArticleManagementCard({
    super.key,
    required this.article,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.putih100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.font60.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 95,
              height: 65,
              color: const Color(0xFFE0E0E0),
              child: (article.fotoThumbnail != null && article.fotoThumbnail!.isNotEmpty)
                  ? Image.network(
                      article.fotoThumbnail!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.image,
                          color: AppColor.font80,
                          size: 24,
                        );
                      },
                    )
                  : const Icon(
                      Icons.image,
                      color: AppColor.font80,
                      size: 24,
                    ),
            ),
          ),
          const SizedBox(width: 12),

          // Area Konten: Judul, Badges, Tanggal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Judul Artikel
                Text(
                  article.judul,
                  style: AppFont.bold().copyWith(
                    fontSize: 14,
                    color: AppColor.font100,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                // Baris Badges Kategori & Status
                Row(
                  children: [
                    // Badge Kategori
                    _buildBadge(
                      label: article.kategori,
                      textColor: _categoryTextColor(),
                      backgroundColor: Colors.white,
                      borderColor: _categoryTextColor(),
                    ),
                    const SizedBox(width: 6),
                    // Badge Status
                    _buildBadge(
                      label: article.status,
                      textColor: _statusTextColor(),
                      backgroundColor: _statusBackgroundColor(),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Tanggal Pembuatan
                Text(
                  article.tanggalFormatted,
                  style: AppFont.regular().copyWith(
                    fontSize: 10,
                    color: AppColor.font80,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),

          // Menu Titik Tiga
          GestureDetector(
            onTap: onMenuTap,
            child: const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(
                Icons.more_vert,
                color: AppColor.font80,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Pewarnaan Teks Kategori ---
  Color _categoryTextColor() {
    switch (article.kategori) {
      case 'Tips':
        return const Color(0xFF2196F3);
      case 'Edukasi':
        return const Color(0xFF03A9F4);
      case 'Inspirasi':
        return const Color(0xFF29B6F6);
      case 'Berita':
        return const Color(0xFF4FC3F7);
      default:
        return AppColor.font80;
    }
  }

  // --- Pewarnaan Teks Status ---
  Color _statusTextColor() {
    switch (article.status) {
      case 'Aktif':
        return const Color(0xFF4CAF50);
      case 'Nonaktif':
        return const Color(0xFFEF5350);
      default:
        return AppColor.font80;
    }
  }

  // --- Pewarnaan Latar Belakang Status ---
  Color _statusBackgroundColor() {
    switch (article.status) {
      case 'Aktif':
        return const Color(0xFFE8F5E9);
      case 'Nonaktif':
        return const Color(0xFFFFEBEE);
      default:
        return AppColor.font60;
    }
  }

  // --- Pembentuk Badge Fleksibel ---
  Widget _buildBadge({
    required String label,
    required Color textColor,
    required Color backgroundColor,
    Color? borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
        border: borderColor != null
            ? Border.all(color: borderColor, width: 0.8)
            : null,
      ),
      child: Text(
        label,
        style: AppFont.medium().copyWith(
          fontSize: 9,
          color: textColor,
        ),
      ),
    );
  }
}

// ============================================================================
// 6. PickupHistoryCard — Kartu riwayat penjemputan.
// ============================================================================

class PickupHistoryCard extends StatelessWidget {
  final RiwayatPenjemputan pickup;

  const PickupHistoryCard({
    super.key,
    required this.pickup,
  });

  Color _statusColor() {
    switch (pickup.status) {
      case 'Selesai':
        return Colors.green;
      case 'Diproses':
        return Colors.amber;
      case 'Dijemput':
        return Colors.blue;
      default:
        return AppColor.font80;
    }
  }

  Color _statusBackgroundColor() {
    switch (pickup.status) {
      case 'Selesai':
        return const Color(0xFFE8F5E9);
      case 'Diproses':
        return const Color(0xFFFFF8E1);
      case 'Dijemput':
        return const Color(0xFFE3F2FD);
      default:
        return AppColor.font60;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.putih100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.font60.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pickup.id,
                    style: AppFont.semibold().copyWith(
                      fontSize: 13,
                      color: AppColor.font100,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    pickup.namaCustomer,
                    style: AppFont.regular().copyWith(
                      fontSize: 11,
                      color: AppColor.font80,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _statusBackgroundColor(),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  pickup.status,
                  style: AppFont.medium().copyWith(
                    fontSize: 11,
                    color: _statusColor(),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          // Divider
          Divider(color: AppColor.font60.withOpacity(0.5), height: 1),
          const SizedBox(height: 10),

          // Bottom row: Petugas, Tanggal, Berat
          Row(
            children: [
              // Petugas
              _buildInfoColumn(
                icon: Icons.star_rounded,
                label: 'Petugas',
                value: pickup.namaPetugas,
              ),
              const SizedBox(width: 20),
              // Tanggal
              _buildInfoColumn(
                icon: Icons.star_rounded,
                label: 'Tanggal',
                value: pickup.tanggal,
              ),
              const Spacer(),
              // Berat
              _buildInfoColumn(
                icon: Icons.star_rounded,
                label: 'Berat',
                value: pickup.berat,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColor.font80),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppFont.regular().copyWith(
                fontSize: 10,
                color: AppColor.font80,
              ),
            ),
            Text(
              value,
              style: AppFont.medium().copyWith(
                fontSize: 11,
                color: AppColor.font100,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
