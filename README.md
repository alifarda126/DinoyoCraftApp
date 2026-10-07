# DinoyoCraft Mobile

Marketplace & discovery keramik lokal Kampung Keramik Dinoyo (Malang).  
Aplikasi Flutter MVP dari desain high-fi Figma.

**Design source:** [Figma — DinoyoCraft](https://www.figma.com/design/8Zi0L9aiDqJFwbrPsQsJx2/DinoyoCraft)  

## Fitur MVP

- Auth: onboarding → login / daftar → OTP → lupa password (mock)
- Shell 5-tab: Beranda, Produk, Toko, Workshop, Bantuan
- Profil, Checkout, ClayBot chatbot
- Data & pembayaran lokal (tanpa backend)

## Prerequisites

- Flutter SDK **3.13+** (`flutter doctor` harus hijau untuk device target)
- Chrome (web), emulator Android/iOS, atau perangkat fisik

## Setup & run

```bash
cd C:\dinoyocraftmobile
flutter pub get
flutter run
```

Contoh target spesifik:

```bash
flutter run -d chrome
flutter run -d windows
flutter devices   # lihat device id
```

## Navigasi cepat (demo)

| Dari | Aksi |
|---|---|
| Onboarding | **Mulai Menjelajah** → Login |
| Login | isi email + password apa saja → Beranda |
| Login | **Masuk dengan Google** → Beranda (mock) |
| Header | ikon profil → Profil; ikon search → Produk |
| Produk card | tombol **+** → Checkout |
| Workshop | **Reservasi via WhatsApp** → `wa.me` |
| FAB chat | ClayBot |

## Struktur

```
lib/
  core/          # theme, router, widgets, assets
  data/          # mock products / stores / FAQ
  features/      # auth, home, products, stores, workshop,
                 # help, profile, checkout, chatbot, shell
assets/
  images/        # foto & logo dari Figma
  icons/         # SVG ikon UI
docs/PRD.md
```

## Tes

```bash
flutter analyze
flutter test
```
