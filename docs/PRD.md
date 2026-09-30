# PRD — DinoyoCraft Mobile App

| Field | Value |
|---|---|
| Product | DinoyoCraft |
| Platform | Flutter (iOS / Android) |
| Design source | [Figma — DinoyoCraft](https://www.figma.com/design/8Zi0L9aiDqJFwbrPsQsJx2/DinoyoCraft) |
| Primary design set | `High-Fi + Prototype Kasar Mobile App` (node `2:2669`) |
| Secondary / legacy | `Prototype Fix Mobile App` (node `1:33`) — reference only |
| Version | 1.0 (MVP UI) |
| Date | 2026-09-29 |

---

## 1. Product overview

DinoyoCraft adalah aplikasi mobile marketplace & discovery untuk keramik lokal Kampung Keramik Dinoyo (Malang). Pengguna dapat menjelajah produk, toko pengrajin, workshop, checkout pesanan, serta mendapat bantuan via chatbot **ClayBot** dan halaman CS/FAQ.

**Value proposition (dari onboarding):**  
*Temukan cerita di balik setiap keramik* — jelajahi karya lokal, temukan pengrajin pilihan, dan rasakan pengalaman kreatif.

---

## 2. Goals & non-goals

### Goals (MVP)
- Pixel-faithful UI dari high-fidelity Figma (viewport ~390×844).
- Alur auth: onboarding → login / daftar → verifikasi OTP → lupa password.
- Shell utama dengan **5-tab bottom navigation**: Beranda, Produk, Toko, Workshop, Bantuan. Profil via ikon header.
- Halaman Produk, Daftar Toko, Workshop, Profil, Checkout, CS/FAQ, ClayBot overlay.
- Pakai **asset asli dari Figma** (gambar produk, ikon, logo, banner).

### Non-goals (MVP)
- Backend / API nyata, auth server, payment gateway live.
- Push notification, maps, deep link.
- Admin / seller dashboard.
- Lokalisasi multi-bahasa (UI tetap Bahasa Indonesia sesuai desain).

Data & interaksi memakai **mock lokal** agar navigasi & UI bisa diuji end-to-end.

---

## 3. Personas

| Persona | Kebutuhan |
|---|---|
| Pembeli wisatawan / lokal | Cari & beli keramik, lihat toko, checkout cepat |
| Penggemar workshop | Info workshop + reservasi via WhatsApp |
| Pengguna baru | Onboarding jelas, daftar/login mudah, bantuan ClayBot |

---

## 4. Information architecture & screens

### 4.1 Auth & onboarding

| Screen | Figma node | Deskripsi |
|---|---|---|
| Onboarding / Pages | `2:2670` | Hero foto keramik, brand, CTA *Mulai Menjelajah*, link *Daftar* |
| Login | `2:2838` | Email/phone + password, lupa password, Masuk, Masuk dengan Google |
| Daftar | `2:2706` | Form: nama, username, email, telepon, tgl lahir, gender, password ×2 |
| Verif Daftar Akun | `2:5093` | OTP 6 digit setelah daftar |
| Lupa Password | `2:2965` | Input email kirim kode |
| Verif Lupa Password | `2:2906` | OTP 6 digit recovery |

### 4.2 Main app (bottom nav)

| Tab | Screen | Figma node | Notes |
|---|---|---|---|
| Beranda | Home | `2:3015` | Greeting, search, promo banner, kategori, grid *Pilihan Untukmu*, FAB ClayBot |
| Produk | Product list | `2:3727` | Search + filter chips + product cards |
| Toko | Store list | `2:3982` | Directory toko + preview image |
| Workshop | Workshop | `2:4447` | Hero, deskripsi, CTA *Reservasi via WhatsApp* |
| Bantuan | CS / FAQ | `2:4545` | FAQ accordion, kontak, entry ke ClayBot |

**Profil** bukan tab bottom nav — diakses lewat ikon profil di header app (`/profile`).

### 4.3 Secondary flows

| Screen | Figma node | Entry |
|---|---|---|
| ClayBot (Beranda) | `2:3196` | FAB / chat icon di Beranda |
| ClayBot (Toko) | `2:4132` | Variasi chat di konteks toko |
| CS / FAQ | `2:4545` | Menu bantuan / dari profil |
| Checkout (Co) | `2:4815` | Dari keranjang / *Beli* |

---

## 5. User flows (MVP)

```
Onboarding
  ├─ Mulai Menjelajah → Login
  │     ├─ Masuk (valid mock) → Beranda
  │     ├─ Lupa password → Lupa PW → Verif OTP → Login
  │     ├─ Masuk Google → Beranda (mock)
  │     └─ Daftar → Form Daftar → Verif OTP → Beranda
  └─ Daftar → Form Daftar → …

Beranda (tab)
  ├─ Search (UI only / filter lokal)
  ├─ Kategori → Produk (filtered)
  ├─ Product card → (detail stub / checkout)
  ├─ ClayBot FAB → Chat overlay
  └─ Bottom nav → Produk | Toko | Workshop | Bantuan
  └─ Header profile icon → Profil

Checkout
  ├─ Alamat, item, ongkir, metode bayar
  └─ Bayar Sekarang → success snackbar (mock)

Workshop
  └─ Reservasi via WhatsApp → launch URL (wa.me mock)

Profil
  ├─ Data Diri / Alamat / Metode Pembayaran / Pengaturan (placeholder)
  └─ Logout → Onboarding / Login
```

---

## 6. Functional requirements

### Auth
- Validasi field kosong (UI error sederhana).
- Toggle show/hide password.
- OTP: 6 kotak digit; tombol lanjut aktif jika terisi.
- Mock credentials: sembarang email+password non-kosong → sukses.

### Discovery
- Beranda: banner promo (diskon 30%), kategori horizontal, grid produk 2 kolom.
- Produk: list/grid dengan gambar, nama, lokasi, harga.
- Toko: list card nama + lokasi + thumbnail.
- Search bar: filter client-side pada mock data.

### Commerce
- Checkout menampilkan ringkasan: alamat, item+qty, pilihan ongkir (Regular/Hemat/Express), pembayaran (QRIS / VA / E-Wallet), rincian biaya, sticky *Bayar Sekarang*.

### Support
- ClayBot: bubble chat + quick replies (*Cara pesan*, *Status pesanan*, *Bantuan lainnya*).
- CS: accordion FAQ + kontak.

### Navigation
- `go_router` (atau `Navigator` + named routes) untuk auth stack vs main shell.
- Bottom nav 5 item dengan state aktif sesuai desain.

---

## 7. Non-functional requirements

| Area | Requirement |
|---|---|
| Visual | Match high-fi: warna, radius, spacing, tipografi |
| Assets | Hanya asset dari Figma (download via MCP); tidak hardcode URL sementara |
| Performance | Lazy load gambar; asset lokal |
| Accessibility | Tap target ≥ 44px di CTA utama; contrast teks sesuai desain |
| Code | Flutter 3.x, struktur `lib/{app,features,core,data}` |

---

## 8. Design tokens (dari High-Fi)

Akan diekstrak & dikunci saat implementasi, baseline:

| Token | Penggunaan |
|---|---|
| Primary black | CTA, teks utama |
| White / off-white | Background |
| Neutral gray | Border input, secondary text |
| Accent (jika ada di desain) | Promo / highlight |
| Font | Sesuai Figma (Google Fonts matching family) |
| Screen width | 390 logical px (Phone frame) |
| Corner radius | Sesuai komponen card/button di Figma |

---

## 9. Tech stack

| Layer | Choice |
|---|---|
| Framework | Flutter |
| Routing | go_router |
| State | StatefulWidget / ChangeNotifier (cukup untuk MVP) |
| Assets | `assets/images/`, `assets/icons/` |
| Fonts | google_fonts (match Figma) |
| Icons | SVG via `flutter_svg` + export Figma |
| External | `url_launcher` (WhatsApp) |

---

## 10. Mock data

- Produk: nama, harga, lokasi, image asset.
- Toko: nama, lokasi, image.
- User profil: nama + avatar dari desain.
- FAQ: Q&A dari layar CS.
- ClayBot: scripted replies berdasarkan quick-reply.

---

## 11. Success criteria

1. Semua layar high-fi di atas ter-render di Flutter tanpa placeholder abu-abu kosong.
2. Asset Figma tersimpan lokal & terdaftar di `pubspec.yaml`.
3. Navigasi auth → main tabs → checkout / ClayBot / CS berjalan tanpa crash.
4. Visual review vs screenshot Figma untuk layar prioritas: Onboarding, Login, Beranda, Produk, Checkout.

---

## 12. Implementation phases

| Phase | Scope | Status |
|---|---|---|
| **P0** | PRD + project skeleton + tokens + asset pipeline | Done |
| **P1** | Auth screens (Onboarding, Login, Daftar, OTP, Lupa PW) | Done |
| **P2** | Main shell + Beranda, Produk, Toko, Workshop, Bantuan + Profil | Done |
| **P3** | Checkout, CS/FAQ, ClayBot | Done |
| **P4** | Polish, asset QA, README run instructions | Done |

---

## 13. Open questions

1. Apakah login Google harus real OAuth atau cukup UI mock? → **MVP: mock**.
2. Apakah ada API backend yang sudah ada? → **Asumsi belum; mock only**.
3. Detail produk page tidak terlihat di high-fi set — apakah perlu stub? → **Ya, navigasi ke checkout atau snackbar “Detail segera hadir”**.

---

## 14. References

- Figma file key: `8Zi0L9aiDqJFwbrPsQsJx2`
- High-fi section: `2:2669`
- Workspace: `C:\dinoyocraftmobile`
