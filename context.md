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

---

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
