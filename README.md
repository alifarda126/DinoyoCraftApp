# 🏺 DinoyoCraft Mobile

[![Flutter](https://img.shields.io/badge/Flutter-3.13+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows-blue)](https://flutter.dev)
[![Tests](https://img.shields.io/badge/Tests-92%20Passed-success)](https://github.com/alifarda126/DinoyoCraftApp)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> **Platform Marketplace & Discovery Keramik Lokal Sentra Keramik Dinoyo, Kota Malang.**  
> Menghubungkan pecinta seni, kolektor gerabah, dan wisatawan dengan para pengrajin keramik lokal Dinoyo dalam satu ekosistem digital yang modern, estetis, dan kaya fitur.

**Design Source:** [Figma — DinoyoCraft](https://www.figma.com/design/8Zi0L9aiDqJFwbrPsQsJx2/DinoyoCraft)

---

## 📑 Daftar Isi

- [Fitur Utama](#-fitur-utama)
  - [1. Autentikasi & Onboarding](#1-autentikasi--onboarding)
  - [2. Eksplorasi Produk & Toko](#2-eksplorasi-produk--toko)
  - [3. Workshop & Kelas Seni Keramik](#3-workshop--kelas-seni-keramik)
  - [4. ClayBot, Asisten Toko & Realtime Chat](#4-claybot-asisten-toko--realtime-chat)
  - [5. Profil, Transaksi & Pesanan](#5-profil-transaksi--pesanan)
  - [6. Pengaturan Tingkat Lanjut & Keamanan](#6-pengaturan-tingkat-lanjut--keamanan)
  - [7. Kestabilan Jaringan & Respon Notifikasi](#7-kestabilan-jaringan--respon-notifikasi)
- [Arsitektur & Struktur Proyek](#-arsitektur--struktur-proyek)
- [Teknologi & Dependensi](#-teknologi--dependensi)
- [Panduan Instalasi & Menjalankan](#-panduan-instalasi--menjalankan)
- [Pengujian Kualitas (Testing & QA)](#-pengujian-kualitas-testing--qa)
- [Navigasi & Demo Alur Aplikasi](#-navigasi--demo-alur-aplikasi)

---

## 🌟 Fitur Utama

### 1. Autentikasi & Onboarding
- **Motion Graphic Logo Splash & Entrance Otentik**:
  - Animasi pembuka dinamis menggunakan siluet otentik `logo_white.png` yang terdekonstruksi menjadi 3 kepingan: *Leher & Bibir Vas (Atas)*, *Tangan Pengrajin (Kiri Bawah)*, dan *Helai Daun Keramik (Kanan Bawah)*.
  - Kepingan meluncur dari 3 sudut berbeda, bertaut secara magnetik (*kintsugi golden glow*), menampilkan teks identitas merek *"DinoyoCraft"*, lalu melesat melengkung dan mengunci presisi ke dalam *frosted glass badge* di sudut kiri atas Onboarding.
  - Dilengkapi tombol *Lewati (Skip)* interaktif untuk pengalaman pengguna yang gesit.
- **Onboarding Interaktif**:
  - Animasi masuk bertahap (*staggered entrance*) untuk gambar latar, badge merek, judul artistik, deskripsi, tombol aksi (*scale bounce*), dan tautan daftar.
- **Login Fleksibel**:
  - Masuk dengan email & kata sandi dengan validasi instan.
  - Opsi masuk cepat via **Google Sign-In** (mock interaktif).
  - Integrasi keamanan **Two-Factor Authentication (2FA)** dengan tantangan OTP saat berpindah perangkat.
- **Registrasi Cerdas**:
  - Pendaftaran manual lengkap (Nama, Username, Email, Kata Sandi, Konfirmasi).
  - **Pendaftaran via Google**: Mengisi otomatis nama & username, mengunci kolom email, serta menutup kolom kata sandi secara dinamis dengan banner pembatalan yang dapat di-reset sewaktu-waktu.
- **Pemulihan Akun**:
  - Alur Lupa Kata Sandi (*Forgot Password*) $\rightarrow$ Verifikasi OTP 4-Digit $\rightarrow$ Pembuatan Kata Sandi Baru.

### 2. Eksplorasi Produk & Toko
- **Beranda (Home)**:
  - Banner promosi interaktif carousel, pill kategori dinamis, dan produk rekomendasi pengrajin lokal.
  - *Pull-to-refresh* untuk memuat ulang konten teranyar.
- **Katalog Produk Dinoyo**:
  - Pencarian langsung (*real-time search*).
  - Filter kategori kerajinan: *Vas Bunga, Piring & Cangkir, Guci & Pot, Dekorasi, Alat Makan, Aksesoris, Souvenir*.
- **Detail Produk**:
  - Galeri visual karya keramik berkualitas tinggi, deskripsi otentik, dan ulasan pembeli.
  - **Modal Pemilihan Variasi (`ModalPilihVariasi`)**: Pemilihan warna/motif, penyesuaian kuantitas interaktif, dan estimasi total harga.
- **Keranjang (Cart), Checkout & Metode Pembayaran**:
  - Ringkasan belanja keramik, pemilihan alamat tersimpan, dan catatan pembeli.
  - **Metode Pembayaran Lengkap dengan Ikon Resmi**: Pilihan QRIS, Virtual Account (BCA, Mandiri, BRI, BNI), dan E-Wallet (GoPay, OVO, ShopeePay, DANA) yang tersusun rapi secara horizontal.
  - **Opsi Bayar Nanti**: Pengguna dapat memilih pembayaran langsung atau menyimpan transaksi sebagai status *"Menunggu Pembayaran"*.

### 3. Workshop & Kelas Seni Keramik
- **Jelajah Workshop Dinoyo**:
  - Informasi lengkap sesi seni putar tanah liat (*pottery throwing*) dan *handbuilding*.
  - Jadwal operasional terpadu (Sabtu–Kamis: 08.00–15.00 WIB, Jumat: 08.00–10.30 & 13.30–14.30 WIB).
  - Rincian durasi, fasilitas pembakaran (*glazing & firing*), serta informasi lokasi di Kampung Wisata Keramik Dinoyo.
  - Integrasi kontak & reservasi langsung via **WhatsApp** resmi studio (`url_launcher`).

### 4. ClayBot, Asisten Toko & Realtime Chat
- **ClayBot (AI Ceramic Assistant)**:
  - Chatbot asisten pintar yang siap memandu rekomendasi cangkir, vas bunga, studio terdekat, hingga jadwal workshop tanah liat.
  - Quick action chips untuk pertanyaan umum seputar kerajinan Dinoyo.
- **Asisten Bot Toko (Toko Siaga)**:
  - Asisten otomatis pada percakapan dengan studio pengrajin, membalas pertanyaan pelanggan secara instan ketika toko sedang offline/sibuk.
  - Tersedia opsi beralih ke pemilik toko secara manual.
- **Realtime WebSocket (Pusher Channels)**:
  - Layanan komunikasi pesan real-time menggunakan `pusher_channels_flutter`.

### 5. Profil, Transaksi & Pesanan
- **Manajemen Riwayat Pesanan**:
  - 4 tab status terpadu: **Belum Bayar (Menunggu Pembayaran)**, **Dikemas**, **Dikirim**, dan **Diterima (Selesai)**.
  - Transaksi dengan metode "Bayar Nanti" otomatis tercatat di tab *Belum Bayar*.
- **Kelola Data Diri & Alamat**:
  - Edit profil, foto profil, nama lengkap, username (dinoyocraft.id/@customer), dan nomor WhatsApp.
  - Buku alamat pengiriman dengan penanda alamat utama (*Default Address*).
- **Ulasan & Review**:
  - Riwayat ulasan produk serta form penulisan review berperingkat bintang 1–5.
- **Keamanan Akun**:
  - Fasilitas penghapusan akun permanen (*Delete Account*) dengan modal konfirmasi protektif.

### 6. Pengaturan Tingkat Lanjut & Keamanan
- **Sistem Tema Dinamis (Theme Engine)**:
  - Pilihan **Mode Terang**, **Mode Gelap**, atau **Ikuti Sistem**.
  - Sinkronisasi instan ke seluruh token warna `AppColors` tanpa reload halaman dan mempertahankan posisi navigasi.
  - Desain kontras tinggi (*high contrast borders & subtle glow*) untuk keterbacaan sempurna pada mode gelap.
- **Sistem Dwibahasa Reaktif (Localization Engine)**:
  - Pilihan bahasa **Bahasa Indonesia (Default)** dan **English**.
  - Seluruh teks UI otomatis berganti bahasa secara reaktif lewat `AppText`.
- **Two-Factor Authentication (2FA)**:
  - Proteksi akun tambahan dengan verifikasi kode OTP saat login dari perangkat berbeda.
- **Info Versi Dinamis**:
  - Membaca metadata nama aplikasi dan versi rilis langsung dari platform OS via `package_info_plus`.

### 7. Kestabilan Jaringan & Respon Notifikasi
- **Banner Deteksi Internet Otomatis**:
  - Indikator koneksi internet ala YouTube/Shopee: banner merah meluncur turun saat internet terputus (🔴 *Tidak ada koneksi internet*), dan berubah hijau (🟢 *Koneksi tersambung kembali*) sebelum menghilang otomatis 2.5 detik kemudian.
- **5 State UI Standar**:
  - Komponen visual terpadu untuk *Loading State*, *No Internet State*, *Server Error State*, *Empty State*, dan *Success State* via `DcStateView`.
- **Universal Caching & Shimmer Loader**:
  - Pemuatan gambar pintar via `DcCachedImage` dengan disk cache otomatis dan skeleton loading `DcShimmer`.
- **In-App Heads-Up Push Notification (FCM)**:
  - Banner notifikasi mengambang dengan slide-down animation untuk pesan chat, info promo, dan pembaruan pesanan.
- **Global Crash Reporting**:
  - Integrasi pelaporan fatal exception otomatis melalui `firebase_crashlytics`.

---

## 🏗 Arsitektur & Struktur Proyek

Aplikasi dirancang dengan arsitektur **Feature-First** yang modular, rapi, dan mudah dikembangkan:

```
c:\dinoyocraftapp/
├── assets/
│   ├── icons/            # Ikon grafis vektor SVG (payment, nav, auth, common)
│   ├── images/           # Foto produk, branding logo, banner, dan studio
│   └── stickers/         # Koleksi stiker DinoyoCraft (Si Clay)
├── lib/
│   ├── app/              # Konfigurasi aplikasi & routing fallback
│   ├── core/             # Fondasi global aplikasi
│   │   ├── app_settings.dart      # Singleton state: Tema, Bahasa, 2FA, Cache, Sesi
│   │   ├── app_text.dart          # Kamus dwibahasa reaktif (ID & EN)
│   │   ├── assets.dart            # Registry path aset gambar, logo & ikon
│   │   ├── router/app_router.dart # Konfigurasi GoRouter dengan live screen wrapper
│   │   ├── services/              # Connectivity, FCM, Pusher, AppInfo, PhotoPicker
│   │   ├── theme/                 # AppColors (token warna dinamis) & AppTheme
│   │   └── widgets/               # Komponen UI global (DcButton, Header, Banner, Shimmer, dll.)
│   ├── data/             # Mock data repository (Produk, Toko, Workshop, Ulasan)
│   ├── features/         # Modul fitur fungsional
│   │   ├── auth/         # Onboarding, Login, Register, OTP, Forgot/New Password
│   │   ├── cart/         # Keranjang belanja
│   │   ├── chat/         # Daftar obrolan & ruang chat pengrajin
│   │   ├── chatbot/      # Layanan asisten cerdas ClayBot & Bot Toko
│   │   ├── checkout/     # Konfirmasi pesanan & pembayaran (QRIS, VA, E-Wallet)
│   │   ├── help/         # Pusat bantuan & FAQ
│   │   ├── home/         # Layar Beranda utama & Carousel Banner
│   │   ├── notification/ # Pusat notifikasi pesanan & promosi
│   │   ├── product/      # Detail produk & modal pemilihan variasi
│   │   ├── products/     # Katalog & filter pencarian produk
│   │   ├── profile/      # Profil, tab pesanan (Belum Bayar, Dikemas, dll.), data diri, alamat
│   │   ├── review/       # Ulasan pembeli & form tulis review
│   │   ├── shell/        # MainShell berisikan IndexedStack Bottom Navigation
│   │   ├── stores/       # Direktori & detail studio keramik Dinoyo
│   │   └── workshop/     # Layar reservasi & jadwal workshop tanah liat
│   └── main.dart         # Entry point aplikasi Flutter
└── test/                 # Test suite otomatis (Unit, Widget, dan Flow Tests)
```

---

## 🛠 Teknologi & Dependensi

| Paket / Library | Versi | Kegunaan |
|---|---|---|
| **Flutter SDK** | `^3.13.4` | UI Toolkit multiplatform |
| **Dart** | `^3.13.0` | Bahasa pemrograman utama |
| **go_router** | `^18.0.2` | Declarative routing & deep navigation |
| **google_fonts** | `^9.0.0` | Tipografi modern (*Plus Jakarta Sans*) |
| **flutter_svg** | `^2.3.0` | Rendering aset vektor ikon SVG berkualitas tinggi |
| **cached_network_image** | `^4.0.6` | Manajemen cache gambar disk & memori otomatis |
| **shimmer** | `^4.0.0` | Animasi skeleton loading halus adaptif tema |
| **connectivity_plus** | `^7.3.2` | Pemantauan status jaringan internet real-time |
| **package_info_plus** | `^10.2.2` | Pembacaan informasi versi rilis & package aplikasi |
| **pusher_channels_flutter** | `^2.6.0` | WebSocket realtime untuk chat & bot toko |
| **firebase_messaging** | `^17.0.1` | Push notification FCM |
| **firebase_crashlytics** | `^6.0.1` | Pelaporan crash & fatal exception otomatis |
| **url_launcher** | `^6.3.2` | Integrasi tautan luar (WhatsApp Reservasi Workshop & Maps) |
| **flutter_native_splash** | `^2.4.8` | Tampilan splash screen native instan (Android 12+ & iOS) |
| **flutter_launcher_icons** | `^0.14.4` | Konfigurasi ikon aplikasi Android & iOS adaptif |

---

## 🚀 Panduan Instalasi & Menjalankan

### Prasyarat
1. Telah menginstal **Flutter SDK** versi 3.13+ (`flutter --version`).
2. Target lingkungan siap: Google Chrome, Android Emulator/Device, atau Windows Desktop.

### Langkah Menjalankan

```bash
# 1. Masuk ke direktori proyek
cd c:\dinoyocraftapp

# 2. Ambil seluruh dependensi
flutter pub get

# 3. Jalankan aplikasi pada target yang diinginkan
flutter run

# Atau tentukan target perangkat secara spesifik:
flutter run -d chrome      # Jalankan di Google Chrome (Web)
flutter run -d windows     # Jalankan di Windows Desktop
flutter run -d <device_id> # Jalankan di emulator / ponsel Android
```

---

## 🧪 Pengujian Kualitas (Testing & QA)

Proyek ini dilengkapi dengan cakupan pengujian komprehensif untuk memastikan seluruh alur transaksi, autentikasi, tema, dan animasi berjalan tanpa hambatan:

```bash
# Menjalankan static analysis (0 issues)
flutter analyze

# Menjalankan seluruh test suite otomatis (92 tests lolos 100%)
flutter test
```

### Rincian Skenario Test Utama:
- `test/onboarding_animation_test.dart`: Memvalidasi animasi masuk elemen halaman onboarding (*fade-in & slide-up*).
- `test/register_google_flow_test.dart`: Memvalidasi tombol Google di Register, auto-fill nama & username, penguncian email, penutupan kolom kata sandi, serta aksi pembatalan.
- `test/app_theme_mode_test.dart`: Memverifikasi transisi tema terang/gelap pada token warna `AppColors` dan caching `ThemeData`.
- `test/app_language_switch_test.dart`: Menguji pergantian bahasa instan (ID $\leftrightarrow$ EN) di seluruh komponen.
- `test/profile_order_tabs_test.dart`: Memvalidasi navigasi tab status pesanan dan pull-to-refresh pada profil.
- `test/auth_register_flow_test.dart`: Memverifikasi kelengkapan alur registrasi hingga verifikasi kode OTP.
- `test/theme_live_switch_test.dart`: Memverifikasi perubahan tema secara real-time tanpa refresh layar.
- `test/direct_buy_flow_test.dart`: Memvalidasi alur checkout pembelian langsung produk.

---

## 🗺 Navigasi & Demo Alur Aplikasi

| Dari Layar | Tindakan Pengguna | Tujuan / Hasil |
|---|---|---|
| **Onboarding** | Klik **Mulai Menjelajah** | Masuk ke halaman **Login** |
| **Onboarding** | Klik **Daftar** | Masuk ke halaman **Register** |
| **Login** | Isi data atau pilih **Masuk dengan Google** | Masuk langsung ke **Beranda** (Mock Auth) |
| **Register** | Klik **Daftar dengan Google** | Form auto-fill, email locked, password hide |
| **Header Atas** | Klik ikon Profil / Search | Langsung membuka layar **Profil** atau **Produk** |
| **Katalog Produk** | Klik kartu produk | Membuka **Detail Produk** |
| **Detail Produk** | Klik tombol variasi / **+** | Menampilkan **Modal Pemilihan Variasi** |
| **Checkout** | Pilih Metode Pembayaran & Klik **Bayar Sekarang** | Proses pembayaran selesai $\rightarrow$ masuk tab **Dikemas** |
| **Checkout** | Pilih **Bayar Nanti** | Menyimpan pesanan $\rightarrow$ masuk tab **Belum Bayar** |
| **Workshop** | Klik **Reservasi via WhatsApp** | Membuka WhatsApp chat dengan nomor studio |
| **FAB Mengambang** | Klik tombol chat bulat | Membuka percakapan dengan **ClayBot** |
| **Ruang Chat Toko** | Toko belum membalas | **Asisten Bot Toko** otomatis menjawab pesan |
| **Profil $\rightarrow$ Pengaturan** | Pilih Tema / Bahasa | Mengubah tampilan & bahasa seluruh aplikasi realtime |
| **Semua Layar Utama** | Tarik ke bawah (*swipe down*) | Menjalankan indikator **Pull-to-Refresh** |

---

## 📄 Lisensi

Proyek ini dikembangkan untuk kebutuhan portofolio, pameran produk digital, dan pemberdayaan UMKM Sentra Keramik Dinoyo. Hak cipta identitas lokal dan karya keramik dilindungi oleh pengrajin terkait.
