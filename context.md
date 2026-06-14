# Dokumentasi Proyek "Ambilin"
**Sistem Informasi Manajemen Pengelolaan Sampah Ekonomis Menggunakan Geolocation, Subscription, dan Point Reward Berbasis Mobile App**

Dokumentasi ini disusun berdasarkan **Use Case Diagram** dan **Skema Database (SQL DDL)** hasil revisi terbaru untuk membantu proses pembangunan backend menggunakan Express.js.

---

## 1. Arsitektur Aktor & Hak Akses (Role)
Terdapat **3 Role Utama** yang tersimpan di dalam tabel `role` dan terhubung melalui tabel `user`:

1. **Pelanggan (Customer)**: Pengguna aplikasi mobile yang melakukan manajemen profil, pembelian paket subskripsi (membership) dengan pilihan diskon poin reward, pemesanan penjemputan sampah, dan membaca artikel.
2. **Petugas (Courier/Staff)**: Aktor lapangan yang bertugas mengklaim order penjemputan sampah, menimbang berat sampah di lokasi, mengunggah bukti jemput, menyelesaikan order, dan mengalirkan reward poin ke customer.
3. **Admin**: Aktor pengelola sistem yang memiliki hak penuh untuk manajemen data master (pelanggan, petugas, kategori sampah, harga subskripsi, artikel, verifikasi transaksi membership manual, dan melihat dashboard statistik).

---

## 2. Daftar Fitur Berdasarkan Use Case Diagram

### A. Fitur Umum (Semua Pengguna)
* **Mendaftar Akun (Register)**: Khusus untuk Pelanggan baru (bisa secara manual maupun menggunakan Google Sign-In).
* **Melakukan Login**: Autentikasi untuk Pelanggan, Petugas, dan Admin (manual dan Google Sign-In).
* **Melakukan Logout**: Penghapusan sesi/token dari sistem.
* **Melihat Profil & Mengubah Profil**: Manajemen informasi personal masing-masing aktor.
* **Mengubah Password**: Mengganti kata sandi lama dengan kata sandi baru.
* **Melihat Dashboard**: Tampilan utama/ringkasan informasi sesuai dengan hak akses masing-masing (Admin: statistik sistem, Petugas: total tugas & order aktif, Customer: saldo poin, status member, & 5 riwayat terakhir).
* **Auto-Expiry Check**: Sistem otomatis mengubah `is_member` menjadi `false` (0) saat login, get profile, atau dashboard diakses jika `expired_member_date` telah berlalu dari hari ini.

### B. Fitur Pelanggan (Customer)
* **Melihat Paket & Metode Pembayaran**: Mengambil paket premium dan jenis metode bayar yang tersedia (Transfer Bank / Potongan Poin).
* **Membeli Paket Subscription**: Berlangganan membership menggunakan diskon poin. Poin terpotong seketika. Jika sisa bayar > 0, wajib menyertakan bukti bayar transfer. Jika sisa bayar = 0 (lunas poin), transaksi langsung berstatus 'berhasil' dan membership aktif.
* **Memesan Penjemputan Sampah**: Mengajukan request penjemputan sampah berdasarkan lokasi koordinat (*Geolocation*) dengan memilih satu jenis sampah awal yang akan disetor.
* **Melihat History Permintaan Penjemputan**: Melacak riwayat pengajuan penjemputan sampah miliknya sendiri.
* **Melihat Artikel**: Membaca konten edukasi seputar sampah dan lingkungan. Listing artikel memotong preview isi artikel menjadi maksimal 150 karakter.

### C. Fitur Petugas (Petugas)
* **Melihat Order Penjemputan Aktif**: Petugas lapangan melihat pesanan masuk berstatus `'menunggu'`.
* **Mengklaim & Memproses Order**: Mengunci pesanan penjemputan menjadi status `'proses'`.
* **Melihat Histori Penjemputan Sampah**: Melihat daftar riwayat tugas penjemputan yang telah diselesaikan.
* **Selesaikan Order & Input Timbangan**: Petugas menginput timbangan berat sampah (kg) dan mengunggah foto bukti penjemputan. Status order diupdate menjadi `'selesai'` dan customer mendapat reward poin (berat_sampah * rate poin kategori).

### D. Fitur Admin (Back-Office)
* **Manajemen Data Pelanggan & Petugas**: Tambah, edit, dan soft-delete (nonaktifkan `is_aktif`) akun.
* **Manajemen Paket Subscription**: Mengubah harga/skema paket subskripsi.
* **Verifikasi Transaksi Subscription**: Admin menyetujui (`berhasil`) atau menolak (`gagal`) transaksi. Jika berhasil, membership customer diperpanjang +30 hari (dari tanggal expired lama jika masih aktif, atau dari sekarang jika sudah tidak aktif). Jika gagal, poin diskon dikembalikan penuh ke saldo customer.
* **Manajemen Kategori Sampah**: CRUD Master jenis sampah (nama dan rate poin per kg).
* **Manajemen Artikel**: CRUD postingan artikel lingkungan (dengan upload thumbnail gambar Cloudinary, soft-delete).

---

## 3. Kamus Data & Relasi Database (Database Schema)

### 3.1. Tabel Utama Pengguna & Otorisasi

#### `role`
* `id` (BIGINT UNSIGNED, PK, Auto Increment)
* `nama_role` (VARCHAR 255)

#### `user`
* `id_user` (BIGINT UNSIGNED, PK, Auto Increment)
* `nama` (VARCHAR 255)
* `email` (VARCHAR 255, UNIQUE)
* `password` (TEXT)
* `id_role` (BIGINT UNSIGNED, FK -> `role.id`)
* `foto` (VARCHAR 255, Nullable)
* `alamat` (TEXT, Nullable)
* `nomor_telepon` (VARCHAR 255, Nullable)
* `latitude` (DECIMAL 10,8, Nullable)
* `longitude` (DECIMAL 11,8, Nullable)
* `refresh_token` (TEXT, Nullable)
* `created_at` / `updated_at` (TIMESTAMP)

#### `customer`
* `id_customer` (BIGINT UNSIGNED, PK, Auto Increment)
* `id_user` (BIGINT UNSIGNED, FK -> `user.id_user`)
* `poin` (BIGINT, Default: 0) - Saldo poin terupdate.
* `is_member` (BOOLEAN, Default: 0) - Status keanggotaan.
* `is_aktif` (BOOLEAN, Default: 1)
* `expired_member_date` (DATETIME, Nullable) - Batas waktu keanggotaan.

#### `petugas`
* `id_petugas` (BIGINT UNSIGNED, PK, Auto Increment)
* `id_user` (BIGINT UNSIGNED, FK -> `user.id_user`)
* `is_aktif` (BOOLEAN, Default: 1)

#### `admin`
* `id_admin` (BIGINT UNSIGNED, PK, Auto Increment)
* `id_user` (BIGINT UNSIGNED, FK -> `user.id_user`)

---

### 3.2. Tabel Fitur Bisnis & Transaksi

#### `subscribtion`
* `id_subscribtion` (BIGINT UNSIGNED, PK, Auto Increment)
* `nama` (VARCHAR 255)
* `harga` (BIGINT)

#### `metode_pembayaran`
* `id_metode_pembayaran` (BIGINT UNSIGNED, PK, Auto Increment)
* `nama` (VARCHAR 255)
* `keterangan` (TEXT)
* `created_at` (TIMESTAMP)

#### `transaksi`
* `id_transaksi` (BIGINT UNSIGNED, PK, Auto Increment)
* `id_customer` (BIGINT UNSIGNED, FK -> `customer.id_customer`)
* `id_admin` (BIGINT UNSIGNED, Nullable, FK -> `admin.id_admin`)
* `id_metode_pembayaran` (BIGINT UNSIGNED, FK -> `metode_pembayaran.id_metode_pembayaran`)
* `id_subscribtion` (BIGINT UNSIGNED, FK -> `subscribtion.id_subscribtion`)
* `bukti_pembayaran` (VARCHAR 255, Nullable)
* `poin_digunakan` (BIGINT, Default: 0) - Poin pemotong harga.
* `status` (ENUM: 'menunggu', 'berhasil', 'gagal')
* `created_at` (TIMESTAMP)
* `confirmed_at` (TIMESTAMP, Nullable)

#### `jenis_sampah`
* `id_jenis_sampah` (BIGINT UNSIGNED, PK, Auto Increment)
* `nama` (VARCHAR 255)
* `poin_per_kg` (BIGINT) - Rate poin per kilogram.
* `is_delete` (BOOLEAN) - Soft-delete flag.

#### `setor_sampah`
* `id_setor_sampah` (BIGINT UNSIGNED, PK, Auto Increment)
* `id_petugas` (BIGINT UNSIGNED, Nullable, FK -> `petugas.id_petugas`)
* `id_customer` (BIGINT UNSIGNED, FK -> `customer.id_customer`)
* `id_jenis_sampah` (BIGINT UNSIGNED, Nullable, FK -> `jenis_sampah.id_jenis_sampah`)
* `status` (ENUM: 'menunggu', 'proses', 'selesai', 'dibatalkan')
* `alamat` (TEXT)
* `catatan` (TEXT, Nullable)
* `latitude` / `longitude` (DECIMAL 10,8)
* `berat_sampah` (DECIMAL 8,2, Nullable) - Diisi oleh petugas lapangan.
* `foto` (VARCHAR 255) - Foto tumpukan sampah dari customer.
* `foto_bukti_penjemputan` (VARCHAR 255, Nullable) - Diunggah oleh petugas lapangan.
* `created_at` (TIMESTAMP)
* `pickup_at` (TIMESTAMP, Nullable)

---

### 3.3. Tabel Konten & Informasi

#### `jenis_artikel`
* `id_jenis_artikel` (BIGINT UNSIGNED, PK, Auto Increment)
* `nama` (VARCHAR 255)

#### `artikel`
* `id_artikel` (BIGINT UNSIGNED, PK, Auto Increment)
* `id_admin` (BIGINT UNSIGNED, FK -> `admin.id_admin`)
* `id_jenis_artikel` (BIGINT UNSIGNED, FK -> `jenis_artikel.id_jenis_artikel`)
* `judul` (VARCHAR 255)
* `foto_thumbnail` (VARCHAR 255)
* `isi` (TEXT)
* `is_delete` (BOOLEAN)

---

# Context & Integration Guide: Ambilin Flutter Application

Dokumen ini menjelaskan struktur proyek Flutter **Ambilin**, arsitektur kode saat ini, serta daftar endpoint backend dan panduan integrasi API berdasarkan [integrasi.md](file:///e:/code%20code/MobileITDev/Frontend/frontend_ambilin/integrasi.md).

---

## 1. Struktur Proyek Flutter

Aplikasi ini menggunakan pola arsitektur **Model-View-Controller/Service-Provider** untuk manajemen state dan komunikasi API:

*   **`lib/main.dart`**: Entry point utama aplikasi, mendefinisikan rute dan konfigurasi global seperti `DevicePreview` dan `MultiProvider`. Lihat [main.dart](file:///e:/code%20code/MobileITDev/Frontend/frontend_ambilin/lib/main.dart). 
*   **`lib/models/`**: Representasi data/objek JSON ke kelas Dart. Contohnya:
    *   [login_request.dart](file:///e:/code%20code/MobileITDev/Frontend/frontend_ambilin/lib/models/login_request.dart) & [register_request.dart](file:///e:/code%20code/MobileITDev/Frontend/frontend_ambilin/lib/models/register_request.dart)
    *   [user_model.dart](file:///e:/code%20code/MobileITDev/Frontend/frontend_ambilin/lib/models/user_model.dart)
    *   [article.dart](file:///e:/code%20code/MobileITDev/Frontend/frontend_ambilin/lib/models/article.dart)
*   **`lib/services/`**: Menangani pemanggilan API HTTP menggunakan library `dio`:
    *   [api_service.dart](file:///e:/code%20code/MobileITDev/Frontend/frontend_ambilin/lib/services/api_service.dart) (Base Service dengan konfigurasi Dio instance).
    *   [auth_service.dart](file:///e:/code%20code/MobileITDev/Frontend/frontend_ambilin/lib/services/auth_service.dart) (Service khusus otentikasi).
*   **`lib/providers/`**: Menggunakan `provider` untuk state management:
    *   [auth_provider.dart](file:///e:/code%20code/MobileITDev/Frontend/frontend_ambilin/lib/providers/auth_provider.dart) (State untuk login, register, token, dan logout).
*   **`lib/ui/`**: Berisi antarmuka pengguna:
    *   `lib/ui/screens/`: Halaman utama aplikasi (seperti Login, Register, Splash, serta sub-folder per peran: `customer`, `petugas`, `admin`).
    *   `lib/ui/widgets/`: Komponen UI reusable.
*   **`lib/utils/`**: Utilitas tambahan seperti warna ([app_color.dart](file:///e:/code%20code/MobileITDev/Frontend/frontend_ambilin/lib/utils/app_color.dart)), font ([app_font.dart](file:///e:/code%20code/MobileITDev/Frontend/frontend_ambilin/lib/utils/app_font.dart)), dan rute navigasi ([app_routes.dart](file:///e:/code%20code/MobileITDev/Frontend/frontend_ambilin/lib/utils/app_routes.dart)).

---

## 2. Standar Integrasi API & Penanganan Token (JWT)

### Base URL
*   **Domain API Backend (Development via Device Fisik & Production)**: `https://ambilin.kodetalma.my.id`
*   **Dokumentasi Swagger**: `https://ambilin.kodetalma.my.id/api-docs`

### Otomatisasi Token dengan Dio Interceptor
Untuk mempermudah penanganan refresh token ketika token akses kedaluwarsa (`401 Unauthorized`), direkomendasikan mengimplementasikan interceptor pada `dio` di [api_service.dart](file:///e:/code%20code/MobileITDev/Frontend/frontend_ambilin/lib/services/api_service.dart) dengan logika seperti berikut:

1. Menyisipkan `Authorization: Bearer <token>` secara otomatis ke setiap request terproteksi.
2. Mendeteksi error `401 Unauthorized`, melakukan pemanggilan otomatis ke `/api/auth/refresh` menggunakan `refreshToken`, menyimpan token baru menggunakan `flutter_secure_storage`, lalu mengulang request awal.

### Format Standar Response Pagination
Setiap list data dibungkus dalam bentuk JSON terstandarisasi:
```json
{
  "status": "success",
  "message": "Berhasil mengambil data",
  "pagination": {
    "total_items": 35,
    "total_pages": 4,
    "current_page": 1,
    "limit": 10
  },
  "data": [ ... ]
}
```
## 3. Daftar Endpoint & Alur Peran (Multi-Role)

### A. Fitur OOTB / Auth (Semua Peran)
1.  **Register Customer Baru**:
    *   **Method & Endpoint**: `POST /api/auth/register`
    *   **Body**: `{"nama": "...", "email": "...", "password": "..."}`
2.  **Login Akun Biasa**:
    *   **Method & Endpoint**: `POST /api/auth/login`
    *   **Body**: `{"email": "...", "password": "..."}`
    *   **Response**: Mengembalikan token akses, token refresh, dan data info peran user (`id_role`: `1` = Admin, `2` = Petugas, `3` = Customer).
3.  **Login Google**:
    *   **Method & Endpoint**: `POST /api/auth/google`
    *   **Body**: `{"idToken": "FIREBASE_ID_TOKEN_DARI_FLUTTER"}`

### B. Alur Customer (Role ID: 3)
1.  **Dashboard Customer**:
    *   **Method & Endpoint**: `GET /api/dashboard/customer`
    *   **Response**: Menampilkan total poin, status member, tanggal kedaluwarsa member, dan daftar artikel terbaru.
2.  **Get Jenis Sampah**:
    *   **Method & Endpoint**: `GET /api/jenis-sampah?page=1&limit=10` (Untuk dropdown setoran).
3.  **Pengajuan Setor Sampah (Multipart Form-Data)**:
    *   **Method & Endpoint**: `POST /api/setor`
    *   **Fields**: `id_jenis_sampah`, `alamat`, `latitude`, `longitude`, `catatan`, `foto` (File/Binary).
4.  **Riwayat Penjemputan**:
    *   **Method & Endpoint**: `GET /api/setor/history/customer?page=1&limit=10`
5.  **Pembelian Membership / Subscription**:
    *   **Method & Endpoint**: `POST /api/subscriptions/purchase` (Multipart Form-Data)
    *   **Fields**: `id_subscribtion`, `id_metode_pembayaran`, `poin_digunakan`, `bukti_pembayaran` (File, opsional jika sisa bayar = 0).
6.  **Riwayat Pembelian Membership**:
    *   **Method & Endpoint**: `GET /api/subscriptions/history?page=1&limit=10`

### C. Alur Petugas Lapangan (Role ID: 2)
1.  **Dashboard Petugas**:
    *   **Method & Endpoint**: `GET /api/dashboard/petugas`
    *   **Response**: Total pesanan dilayani, total berat sampah diangkut.
2.  **Order Aktif (Antrean)**:
    *   **Method & Endpoint**: `GET /api/setor/active?page=1&limit=10` (Pesanan berstatus `menunggu` terdekat).
3.  **Klaim / Proses Order**:
    *   **Method & Endpoint**: `PUT /api/setor/:id/process` (Mengubah status menjadi `proses`).
4.  **Selesaikan Order (Timbang & Foto Bukti)**:
    *   **Method & Endpoint**: `PUT /api/setor/:id/complete` (Multipart Form-Data)
    *   **Fields**: `berat_sampah` (String/Number), `foto_bukti_penjemputan` (File).
5.  **Riwayat Pekerjaan Petugas**:
    *   **Method & Endpoint**: `GET /api/setor/history/petugas?page=1&limit=10` (Berstatus `proses` di atas, diikuti `selesai`).

### D. Alur Super Admin (Role ID: 1)
1.  **Dashboard Admin**:
    *   **Method & Endpoint**: `GET /api/dashboard/admin`
    *   **Response**: Total nominal transaksi berhasil, total pending verifikasi pembayaran, total sampah yang terkumpul, dll.
2.  **Manajemen Akun Petugas & Customer (CRUD)**:
    *   **Get**: `GET /api/manajemen-akun?role=2&page=1&limit=10`
    *   **Detail**: `GET /api/manajemen-akun/:id_user`
    *   **Create**: `POST /api/manajemen-akun`
    *   **Update**: `PUT /api/manajemen-akun/:id_user`
    *   **Soft Delete**: `DELETE /api/manajemen-akun/:id_user` (Kirim body: `{"id_role": 2}` atau `{"id_role": 3}`).
3.  **Verifikasi Transaksi Membership**:
    *   **List Pending**: `GET /api/subscriptions/transactions?status=menunggu&page=1&limit=10`
    *   **Verifikasi**: `PUT /api/subscriptions/transactions/:id/confirm`
        *   **Body**: `{"status": "berhasil"}` atau `{"status": "gagal"}`
4.  **Pengelolaan Jenis Sampah & Artikel**:
    *   Mengakses route `/api/jenis-sampah` & `/api/articles`.

---

## 4. Penanganan Status Error HTTP
Aplikasi mobile wajib memiliki penanganan kesalahan visual (dialog atau snackbar) untuk kode status berikut:
*   **`400 Bad Request`**: Data masukan/form-data tidak valid atau berkas tidak pas.
*   **`401 Unauthorized`**: Token kadaluwarsa (picu proses refresh token otomatis).
*   **`403 Forbidden`**: Peran tidak sesuai untuk mengakses rute.
*   **`404 Not Found`**: Sumber daya (ID order/user) tidak ada di server.
*   **`500 Internal Server Error`**: Masalah di basis data atau server (tampilkan pesan umum).

