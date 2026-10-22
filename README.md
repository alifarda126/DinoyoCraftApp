# 🏺 DinoyoCraft Mobile

[![Flutter](https://img.shields.io/badge/Flutter-3.13+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows-blue)](https://flutter.dev)
[![Tests](https://img.shields.io/badge/Tests-34%20Passed-success)](https://github.com/alifarda126/DinoyoCraftApp)
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
  - [4. ClayBot & Layanan Pelanggan](#4-claybot--layanan-pelanggan)
  - [5. Profil, Transaksi & Pesanan](#5-profil-transaksi--pesanan)
  - [6. Pengaturan Tingkat Lanjut & Keamanan](#6-pengaturan-tingkat-lanjut--keamanan)
- [Arsitektur & Struktur Proyek](#-arsitektur--struktur-proyek)
- [Teknologi & Dependensi](#-teknologi--dependensi)
- [Panduan Instalasi & Menjalankan](#-panduan-instalasi--menjalankan)
- [Pengujian Kualitas (Testing & QA)](#-pengujian-kualitas-testing--qa)
- [Navigasi & Demo Alur Aplikasi](#-navigasi--demo-alur-aplikasi)

---

## 🌟 Fitur Utama

### 1. Autentikasi & Onboarding
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
- **Keranjang (Cart) & Checkout**:
  - Ringkasan daftar belanja keramik, pemilihan alamat tersimpan, dan opsi pembayaran lokal (QRIS, Transfer Bank, GoPay).

### 3. Workshop & Kelas Seni Keramik
- **Jelajah Workshop Dinoyo**:
  - Informasi lengkap sesi seni putar tanah liat (*pottery throwing*) dan *handbuilding*.
  - Rincian durasi, fasilitas pembakaran (*glazing & firing*), dan instruktur pengrajin.
  - Integrasi reservasi instan langsung ke **WhatsApp** resmi studio (`url_launcher`).

### 4. ClayBot & Layanan Pelanggan
- **ClayBot (AI Ceramic Assistant)**:
  - Chatbot asisten pintar yang siap memandu rekomendasi cangkir, vas bunga, studio terdekat, hingga jadwal workshop tanah liat.
  - Quick action chips untuk pertanyaan umum seputar kerajinan Dinoyo.
- **Direct Chat Pengrajin**:
  - Percakapan langsung dengan penjual/studio keramik untuk pesanan khusus (*custom order*).

### 5. Profil, Transaksi & Pesanan
- **Manajemen Status Pesanan**:
  - 5 tab status interaktif: *Belum Bayar, Dikemas, Dikirim, Selesai, Dibatalkan* lengkap dengan rincian invoice dan pelacakan status.
- **Kelola Data Diri**:
  - Edit profil, foto profil, nama lengkap, username (dinoyocraft.id/@customer), dan nomor WhatsApp.
- **Buku Alamat Pengiriman**:
  - Daftar alamat pengiriman lengkap dengan penanda alamat utama (*Default Address*).
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
  - Seluruh teks UI (navigasi, form, dialog, status, tombol) otomatis berganti bahasa secara reaktif lewat `AppText`.
- **Two-Factor Authentication (2FA)**:
  - Proteksi akun tambahan; saat aktif, setiap logout atau masuk dari perangkat berbeda wajib memverifikasi kode OTP email.
- **Kelola Perangkat Terhubung**:
  - Pemantauan sesi perangkat lain yang terhubung ke akun beserta opsi cabut akses satu per satu atau cabut seluruhnya.
- **Pembersihan Cache Nyata**:
  - Indikator ukuran cache aplikasi (misal 26 MB $\rightarrow$ 0 B) dengan umpan balik pembersihan instan.
- **Pull to Refresh**:
  - Komponen `RefreshIndicator` tersedia di seluruh layar utama scrollable (*Beranda, Produk, Toko, Workshop, Profil*).

---

## 🏗 Arsitektur & Struktur Proyek

Aplikasi dirancang dengan arsitektur **Feature-First** yang modular, rapi, dan mudah dikembangkan:

```
c:\dinoyocraftapp/
├── assets/
│   ├── icons/            # Ikon grafis vektor SVG (navigasi, aksi, status)
│   └── images/           # Foto produk, studio, banner, dan logo DinoyoCraft
├── lib/
│   ├── app/              # Konfigurasi aplikasi & routing fallback
│   ├── core/             # Fondasi global aplikasi
│   │   ├── app_settings.dart      # Singleton state: Tema, Bahasa, 2FA, Cache, Sesi
│   │   ├── app_text.dart          # Kamus dwibahasa reaktif (ID & EN)
│   │   ├── assets.dart            # Registry path aset gambar & ikon
│   │   ├── router/app_router.dart # Konfigurasi GoRouter dengan live screen wrapper
│   │   ├── theme/                 # AppColors (token warna dinamis) & AppTheme
│   │   └── widgets/               # Komponen UI global (DcButton, Header, BottomNav, dll.)
│   ├── data/             # Mock data repository (Produk, Toko, Workshop, Ulasan)
│   ├── features/         # Modul fitur fungsional
│   │   ├── auth/         # Onboarding, Login, Register, OTP, Forgot/New Password
│   │   ├── cart/         # Keranjang belanja
│   │   ├── chat/         # Daftar obrolan & ruang chat pengrajin
│   │   ├── chatbot/      # Layanan asisten cerdas ClayBot
│   │   ├── checkout/     # Konfirmasi pesanan & pembayaran
│   │   ├── help/         # Pusat bantuan & FAQ
│   │   ├── home/         # Layar Beranda utama
│   │   ├── notification/ # Pusat notifikasi pesanan & promosi
│   │   ├── product/      # Detail produk & modal pemilihan variasi
│   │   ├── products/     # Katalog & filter pencarian produk
│   │   ├── profile/      # Profil, tab pesanan, data diri, alamat, pengaturan
│   │   ├── review/       # Ulasan pembeli & form tulis review
│   │   ├── shell/        # MainShell berisikan IndexedStack Bottom Navigation
│   │   ├── stores/       # Direktori & detail studio keramik Dinoyo
│   │   └── workshop/     # Layar reservasi & info workshop tanah liat
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
| **url_launcher** | `^6.3.2` | Integrasi tautan luar (WhatsApp Reservasi Workshop) |
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

# Menjalankan seluruh test suite otomatis (34+ tests lolos)
flutter test
```

### Rincian Skenario Test Utama:
- `test/onboarding_animation_test.dart`: Memvalidasi animasi masuk elemen halaman onboarding (*fade-in & slide-up*).
- `test/register_google_flow_test.dart`: Memvalidasi tombol Google di Register, auto-fill nama & username, penguncian email, penutupan kolom kata sandi, serta aksi pembatalan.
- `test/app_theme_mode_test.dart`: Memverifikasi transisi tema terang/gelap pada token warna `AppColors` dan caching `ThemeData`.
- `test/app_language_switch_test.dart`: Menguji pergantian bahasa instan (ID $\leftrightarrow$ EN) di seluruh komponen.
- `test/profile_order_tabs_test.dart`: Memvalidasi navigasi tab status pesanan dan pull-to-refresh pada profil.
- `test/auth_register_flow_test.dart`: Memverifikasi kelengkapan alur registrasi hingga verifikasi kode OTP.

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
| **Workshop** | Klik **Reservasi via WhatsApp** | Membuka WhatsApp chat dengan nomor studio |
| **FAB Mengambang** | Klik tombol chat bulat | Membuka percakapan dengan **ClayBot** |
| **Profil $\rightarrow$ Pengaturan** | Pilih Tema / Bahasa | Mengubah tampilan & bahasa seluruh aplikasi realtime |
| **Semua Layar Utama** | Tarik ke bawah (*swipe down*) | Menjalankan indikator **Pull-to-Refresh** |

---

## 📄 Lisensi

Proyek ini dikembangkan untuk kebutuhan portofolio, pameran produk digital, dan pemberdayaan UMKM Sentra Keramik Dinoyo. Hak cipta identitas lokal dan karya keramik dilindungi oleh pengrajin terkait.
