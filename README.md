# Ambilin - Waste Management & Subscription Platform

Ambilin is a comprehensive waste management and pickup scheduling system built with Flutter. It streamlines garbage pickup logistics and manages the premium subscription model (Ambilin+) for users, officers, and administrators.

---

## 🚀 Key Features by User Roles

### 1. Pelanggan (Customer)
* **Form Pemesanan Penjemputan**: Book garbage pickup tasks easily using integrated location pins and maps.
* **Ambilin+ (Premium Subscription)**: Subscribe to premium packages to access bonus points, instant priority pick-up services, and exclusive benefits.
* **Point Rewards**: Collect points from waste deposits and redeem them during subscription renewals.
* **Articles Feed**: Access informative sustainability and recycling articles.

### 2. Petugas (Officer)
* **Peta Penjemputan**: Pinpoint customer coordinates and plot routing lines for pick-ups.
* **Manajemen Status**: Update task progress in real-time (On-Progress, Selesai).
* **Riwayat Tugas**: Keep track of total garbage collections and tasks successfully completed.

### 3. Admin
* **Dashboard Panel**: Monitor revenue statistics, pending payment verifications, and waste collection metrics (in kg).
* **Manajemen User**: Complete CMS to register, manage, and soft-delete Customer and Officer accounts.
* **Manajemen Subscription**: Adjust membership subscription fee package details.
* **Konfirmasi Pembayaran**: Review transfer slips and approve/reject premium subscription payments.
* **Manajemen Artikel & Kategori**: Manage blogs and garbage weight classifications.

---

## 🛠️ Technology Stack
* **Framework**: Flutter (Dart)
* **State Management**: Provider
* **Networking**: Dio
* **Launcher Icon**: configured with `flutter_launcher_icons` using `assets/logo_apps.png`

---

## ⚙️ Getting Started

### Prerequisites
* Flutter SDK (compatible with SDK constraints defined in `pubspec.yaml`)
* Android Studio / VS Code with Dart & Flutter extensions

### Installation & Run

1. Clone or download this project.
2. Pull the dependencies:
   ```bash
   flutter pub get
   ```
3. Generate assets and launcher icons:
   ```bash
   dart run flutter_launcher_icons
   ```
4. Run the project in development mode:
   ```bash
   flutter run
   ```
