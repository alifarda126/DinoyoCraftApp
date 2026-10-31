import 'app_settings.dart';

/// Sistem lokalisasi DinoyoCraft.
/// Default bahasa aplikasi adalah Indonesia ('id').
/// Saat pengguna memilih English ('en') di Pengaturan, seluruh teks UI
/// otomatis diterjemahkan ke bahasa Inggris secara reaktif.
abstract final class AppText {
  /// Cek apakah bahasa aktif adalah English.
  static bool get isEnglish => AppSettings.instance.locale == 'en';

  /// Mengambil teks berdasarkan kunci terstruktur atau teks langsung.
  static String get(String key) {
    if (isEnglish) {
      return _lookup['en']?[key] ?? _dict[key] ?? _lookup['id']?[key] ?? key;
    }
    return _lookup['id']?[key] ?? key;
  }

  /// Menerjemahkan string dari Bahasa Indonesia ke Bahasa Inggris.
  /// Bila bahasa saat ini adalah 'id' (default), teks dikembalikan seperti semula.
  /// Bila 'en', teks diterjemahkan via kamus dwibahasa.
  static String tr(String text) {
    if (!isEnglish) return text;

    // 1. Cek kunci terstruktur di _lookup
    final byKey = _lookup['en']?[text];
    if (byKey != null) return byKey;

    // 2. Cek kamus teks langsung
    final direct = _dict[text];
    if (direct != null) return direct;

    // 3. Cek dengan menghiraukan spasi / newline di ujung
    final trimmed = text.trim();
    final trimmedDirect = _dict[trimmed];
    if (trimmedDirect != null) {
      final startIdx = text.indexOf(trimmed);
      final leading = text.substring(0, startIdx);
      final trailing = text.substring(startIdx + trimmed.length);
      return '$leading$trimmedDirect$trailing';
    }

    // 4. Fallback pencarian case-insensitive
    final lower = _lowerDict[trimmed.toLowerCase()];
    if (lower != null) {
      return lower;
    }

    return text;
  }

  static const _lookup = <String, Map<String, String>>{
    'id': {
      'nav.home': 'Beranda',
      'nav.products': 'Produk',
      'nav.stores': 'Toko',
      'nav.workshop': 'Workshop',
      'nav.profile': 'Profil',
      'settings.security': 'Keamanan Akun',
      'settings.password': 'Ubah Kata Sandi',
      'settings.password.sub': 'Terakhir diubah 3 bulan lalu',
      'settings.2fa': 'Autentikasi 2 Langkah (2FA)',
      'settings.2fa.on': 'Aktif via Email',
      'settings.2fa.off': 'Tingkatkan keamanan akun via Email OTP',
      'settings.devices': 'Perangkat Terhubung',
      'settings.devices.many': '2 perangkat aktif saat ini',
      'settings.devices.one': '1 perangkat aktif saat ini',
      'settings.delete': 'Hapus Akun',
      'settings.delete.sub': 'Nonaktifkan akun secara permanen',
      'settings.notifications': 'Notifikasi',
      'settings.notif.order': 'Status Pesanan & Pengiriman',
      'settings.notif.order.sub': 'Notifikasi status pesanan dan pengiriman',
      'settings.notif.wa': 'Notifikasi via WhatsApp',
      'settings.notif.wa.sub': 'Terima update pesanan melalui WhatsApp',
      'settings.preferences': 'Preferensi Aplikasi',
      'settings.language': 'Bahasa Aplikasi',
      'settings.theme': 'Tema Tampilan',
      'settings.cache': 'Bersihkan Cache',
      'settings.cache.sub': 'Bersihkan file sementara aplikasi',
      'settings.legal': 'Informasi & Kebijakan',
      'settings.privacy': 'Kebijakan Privasi',
      'settings.terms': 'Syarat & Ketentuan',
      'settings.warranty': 'Kebijakan Garansi',
      'settings.logout': 'Keluar dari Akun',
      'common.clear': 'Bersihkan',
      'common.close': 'Tutup',
      'common.cancel': 'Batal',
      'common.ok': 'OK',
      'theme.title': 'Tema Tampilan',
      'theme.light': 'Terang (Light Mode)',
      'theme.dark': 'Gelap (Dark Mode)',
      'theme.system': 'Ikuti Sistem',
      'lang.title': 'Bahasa Aplikasi',
    },
    'en': {
      'nav.home': 'Home',
      'nav.products': 'Products',
      'nav.stores': 'Stores',
      'nav.workshop': 'Workshop',
      'nav.profile': 'Profile',
      'settings.security': 'Account Security',
      'settings.password': 'Change Password',
      'settings.password.sub': 'Last changed 3 months ago',
      'settings.2fa': 'Two-Factor Authentication (2FA)',
      'settings.2fa.on': 'Active via Email',
      'settings.2fa.off': 'Increase account security via Email OTP',
      'settings.devices': 'Connected Devices',
      'settings.devices.many': '2 devices currently active',
      'settings.devices.one': '1 device currently active',
      'settings.delete': 'Delete Account',
      'settings.delete.sub': 'Permanently deactivate your account',
      'settings.notifications': 'Notifications',
      'settings.notif.order': 'Order & Shipping Status',
      'settings.notif.order.sub': 'Notifications for order and shipping status',
      'settings.notif.wa': 'WhatsApp Notifications',
      'settings.notif.wa.sub': 'Receive order updates via WhatsApp',
      'settings.preferences': 'App Preferences',
      'settings.language': 'App Language',
      'settings.theme': 'Display Theme',
      'settings.cache': 'Clear Cache',
      'settings.cache.sub': 'Clear temporary app files',
      'settings.legal': 'Information & Policies',
      'settings.privacy': 'Privacy Policy',
      'settings.terms': 'Terms & Conditions',
      'settings.warranty': 'Warranty Policy',
      'settings.logout': 'Log Out',
      'common.clear': 'Clear',
      'common.close': 'Close',
      'common.cancel': 'Cancel',
      'common.ok': 'OK',
      'theme.title': 'Display Theme',
      'theme.light': 'Light Mode',
      'theme.dark': 'Dark Mode',
      'theme.system': 'Follow System',
      'lang.title': 'App Language',
    },
  };

  /// Kamus komprehensif Bahasa Indonesia -> English untuk seluruh aplikasi
  static const Map<String, String> _dict = {
    // ── Navigation & Common ─────────────────────────────────────────────────
    'Beranda': 'Home',
    'Produk': 'Products',
    'Toko': 'Stores',
    'Workshop': 'Workshop',
    'Profil': 'Profile',
    'Kembali': 'Back',
    'Batal': 'Cancel',
    'Tutup': 'Close',
    'Bersihkan': 'Clear',
    'Bersih': 'Clean',
    'Simpan': 'Save',
    'Simpan Perubahan': 'Save Changes',
    'Hapus': 'Delete',
    'Ya': 'Yes',
    'Tidak': 'No',
    'OK': 'OK',
    'Selesai': 'Done',
    'Lihat Semua': 'See All',
    'Lihat semua': 'See all',
    'Cari': 'Search',
    'Detail': 'Details',
    'Pesan': 'Messages',
    'Ditanyakan': 'Inquired',
    'Kirim': 'Send',
    'Kirim Produk': 'Send Product',
    'Lihat Produk': 'View Product',
    'Hapus Preview': 'Remove Preview',
    ' • Terjual 340+': ' • 340+ sold',

    // ── Filter & Kategori ───────────────────────────────────────────────────
    'Semua': 'All',
    'Vas Bunga': 'Flower Vases',
    'Piring & Cangkir': 'Plates & Cups',
    'Guci & Pot': 'Jars & Pots',
    'Dekorasi': 'Decor',
    'Alat Makan': 'Tableware',
    'Aksesoris': 'Accessories',
    'Souvenir': 'Souvenirs',

    // ── Home Screen ─────────────────────────────────────────────────────────
    'Sentra Keramik Dinoyo, Kota Malang':
        'Dinoyo Ceramic Center, Malang City',
    'Tanah liat Dinoyo, dari roda\npemutar langsung ke\ntanganmu.':
        'Dinoyo clay, from the pottery wheel\nstraight to\nyour hands.',
    'Tanah liat Dinoyo, dari roda pemutar langsung ke tanganmu.':
        'Dinoyo clay, from the pottery wheel straight to your hands.',
    'Temukan karya keramik lokal dan pengalaman kreatif dari pengrajin Dinoyo.':
        'Discover local ceramic crafts and creative experiences from Dinoyo artisans.',
    'Jelajahi Kategori': 'Explore Categories',
    'Pilihan Untukmu': 'Picks for You',
    'Karya keramik favorit dari pengrajin lokal.':
        'Favorite ceramic crafts from local artisans.',
    'Tidak ada produk yang cocok.': 'No matching products found.',

    // ── Products Screen & Product Detail ────────────────────────────────────
    'Produk Keramik': 'Ceramic Products',
    'Cari produk atau studio...': 'Search products or studios...',
    'Katalog Produk': 'Product Catalog',
    'Detail Produk': 'Product Details',
    'Deskripsi Produk': 'Product Description',
    'Ulasan Pembeli': 'Customer Reviews',
    'Produk Terkait': 'Related Products',
    'Tambah ke Keranjang': 'Add to Cart',
    'Beli Sekarang': 'Buy Now',
    'Pilih Variasi': 'Select Variation',
    'Jumlah': 'Quantity',
    'Stok': 'Stock',
    'Tersedia': 'Available',
    'Habis': 'Out of Stock',
    'Harga:': 'Price:',
    'Total:': 'Total:',
    'Hot': 'Hot',

    // ── Stores Screen & Detail ──────────────────────────────────────────────
    'Temukan Toko': 'Find Stores',
    'Jelajahi studio pengrajin keramik Dinoyo.':
        'Explore Dinoyo ceramic artisan studios.',
    'Cari toko...': 'Search stores...',
    'Kunjungi Toko': 'Visit Store',
    'Buka': 'Open',
    'Tentang Toko': 'About Store',
    'Alamat': 'Address',
    'Jam Operasional': 'Opening Hours',
    'Ulasan': 'Reviews',

    // ── Workshop Screen ─────────────────────────────────────────────────────
    'Workshop Keramik': 'Ceramic Workshop',
    'Workshop Keramik Dinoyo': 'Dinoyo Ceramic Workshop',
    'Rasakan pengalaman membentuk tanah liat bersama pengrajin Dinoyo':
        'Feel the experience of shaping clay with Dinoyo artisans',
    'Pengalaman Workshop': 'Workshop Experience',
    'Contact Person': 'Contact Person',
    'Reservasi via WhatsApp': 'Reserve via WhatsApp',
    'Tidak dapat membuka WhatsApp': 'Unable to open WhatsApp',
    'Sesi 2 jam: pengenalan tanah liat, teknik dasar throwing/handbuilding, glazing intro, dan hasil karya bisa dibawa pulang setelah pembakaran (estimasi 7–14 hari). Cocok untuk pemula & komunitas.':
        '2-hour session: clay introduction, basic throwing/handbuilding techniques, glazing intro, and pieces can be taken home after firing (estimated 7–14 days). Suitable for beginners & communities.',

    // ── Profile Screen ──────────────────────────────────────────────────────
    'Data Diri': 'Personal Info',
    'Kelola Data Diri': 'Manage Personal Info',
    'Ubah Data Diri': 'Edit Personal Info',
    'Kelola informasi akun dan profil pengrajin Anda':
        'Manage your account and artisan profile information',
    'Sesuai KTP': 'As on ID Card',
    'Alamat Email': 'Email Address',
    'Nomor WhatsApp / Seluler': 'WhatsApp / Mobile Number',
    'Username profil dinoyocraft.id/@customer. Ubah 30 hari sekali.':
        'Profile username dinoyocraft.id/@customer. Change every 30 days.',
    'Verif': 'Verified',
    'Ubah': 'Edit',
    'Format JPG, PNG atau WEBP. Maksimal 5 MB.':
        'JPG, PNG or WEBP format. Maximum 5 MB.',
    'Pastikan data diri sesuai dengan identitas resmi untuk kemudahan verifikasi pesanan dan pengiriman keramik di Aplikasi DinoyoCraft.':
        'Ensure personal data matches official ID for easy order verification and ceramic shipping in DinoyoCraft App.',
    'Perubahan data diri disimpan.': 'Personal info changes saved.',
    'Batalkan': 'Cancel',
    'Riwayat Pesanan': 'Order History',
    '1 Pesanan': '1 Order',
    'Belum Bayar': 'Unpaid',
    'Menunggu Pembayaran': 'Waiting for Payment',
    'Batalkan Pesanan': 'Cancel Order',
    'Batalkan Pesanan?': 'Cancel Order?',
    'Pesanan #DNC-005 akan dibatalkan. Tindakan ini tidak dapat diurungkan.':
        'Order #DNC-005 will be canceled. This action cannot be undone.',
    'Pesanan #DNC-005 berhasil dibatalkan.':
        'Order #DNC-005 has been successfully canceled.',
    'Selesaikan pembayaran sebelum batas waktu berakhir\nagar pesanan tidak dibatalkan otomatis.':
        'Complete the payment before the deadline\nso the order is not automatically canceled.',
    'Dikemas': 'Packed',
    'Dikirim': 'Shipped',
    'Diterima': 'Delivered',
    'Dikemas Penjual': 'Packed by Seller',
    'Menyerahkan ke Pihak Jasa Kirim': 'Handing over to Courier',
    'Paket sedang dalam perjalanan untuk diserahkan\nke Pihak Jasa Kirim':
        'Package is on the way to be handed over to the courier',
    'Sedang Dikirim': 'In Transit',
    'Paket sedang dalam perjalanan menuju kota\nMalang (Hub Sukun)':
        'Package is in transit to Malang city (Hub Sukun)',
    'Lacak Resi': 'Track Package',
    'Pesanan Selesai': 'Order Completed',
    'Beri Ulasan': 'Write Review',
    'Lihat Ulasan': 'View Review',
    'Beli Lagi': 'Buy Again',
    'Semua Pesanan': 'All Orders',
    'Lihat Semua Pesanan': 'View All Orders',
    'Akun': 'Account',
    'Kelola informasi akun & profil': 'Manage account info & profile',
    'Alamat Pengiriman': 'Shipping Addresses',
    'Kelola alamat tujuan pesanan': 'Manage delivery address',
    'Pengaturan': 'Settings',
    'Notifikasi, bahasa & privasi': 'Notifications, language & privacy',
    'Bantuan': 'Help',
    'Temukan jawaban yang Anda butuhkan': 'Find the answers you need',
    'Jumlah: 1': 'Qty: 1',
    'Jumlah: 2': 'Qty: 2',
    'Total (1 Produk):': 'Total (1 Item):',
    'Total (2 Produk):': 'Total (2 Items):',
    'Keluar dari Akun': 'Log Out',
    'Mangkuk Keramik': 'Ceramic Bowl',
    'Cangkir Handmade Artisan': 'Handmade Artisan Cup',
    'Vas Keramik Minimalis': 'Minimalist Ceramic Vase',
    'Mangkuk Keramik Artisanal': 'Artisanal Ceramic Bowl',
    'Kembali ke Halaman Beranda': 'Back to Home Page',
    'Butuh Bantuan': 'Need Help',

    // ── Settings (Pengaturan Screen) ────────────────────────────────────────
    'Kelola Pengaturan': 'Manage Settings',
    'AKUN & KEAMANAN': 'ACCOUNT & SECURITY',
    'Keamanan Akun': 'Account Security',
    'Ubah Kata Sandi': 'Change Password',
    'Terakhir diubah 3 bulan lalu': 'Last changed 3 months ago',
    'Baru saja diubah': 'Just changed',
    'Kata Sandi Saat Ini': 'Current Password',
    'Kata Sandi Baru': 'New Password',
    'Konfirmasi Kata Sandi Baru': 'Confirm New Password',
    'Autentikasi 2 Langkah (2FA)': 'Two-Factor Authentication (2FA)',
    'Aktif via Email': 'Active via Email',
    'Tingkatkan keamanan akun via Email OTP':
        'Increase account security via Email OTP',
    'Perangkat Terhubung': 'Connected Devices',
    'perangkat aktif saat ini': 'devices currently active',
    '1 perangkat aktif saat ini': '1 device currently active',
    '2 perangkat aktif saat ini': '2 devices currently active',
    'Hapus Akun': 'Delete Account',
    'Nonaktifkan akun secara permanen': 'Permanently deactivate your account',
    'NOTIFIKASI': 'NOTIFICATIONS',
    'Status Pesanan & Pengiriman': 'Order & Shipping Status',
    'Notifikasi status pesanan dan pengiriman':
        'Notifications for order and shipping status',
    'Notifikasi via WhatsApp': 'WhatsApp Notifications',
    'Terima update pesanan melalui WhatsApp':
        'Receive order updates via WhatsApp',
    'PREFERENSI APLIKASI': 'APP PREFERENCES',
    'Bahasa Aplikasi': 'App Language',
    'Pilih Bahasa Aplikasi': 'Select App Language',
    'Bahasa tampilan menu & pemberitahuan':
        'Display language for menu & notifications',
    'Bahasa default sistem aplikasi': 'Default app system language',
    'Tema Tampilan': 'Display Theme',
    'Pilih Tema Tampilan': 'Select Display Theme',
    'Sesuaikan kenyamanan visual layar': 'Adjust visual screen comfort',
    'Terang (Light Mode)': 'Light Mode',
    'Gelap (Dark Mode)': 'Dark Mode',
    'Mengikuti Sistem': 'Follow System',
    'Ikuti Sistem': 'Follow System',
    'Bersihkan Cache': 'Clear Cache',
    'file sementara': 'temporary files',
    'Bersihkan file sementara aplikasi': 'Clear temporary app files',
    'PRIVASI & LEGALITAS': 'PRIVACY & LEGAL',
    'Kebijakan Privasi': 'Privacy Policy',
    'Syarat & Ketentuan': 'Terms & Conditions',
    'Syarat & Ketentuan Penggunaan': 'Terms & Conditions of Use',
    'Kebijakan Garansi': 'Warranty Policy',
    'Kebijakan Garansi Barang Pecah Belah':
        'Fragile Goods Warranty Policy',
    'Konfirmasi Keluar': 'Confirm Log Out',
    'Apakah Anda yakin ingin keluar dari akun ini?':
        'Are you sure you want to log out of this account?',
    'Sentra Keramik Dinoyo Malang • Jawa Timur':
        'Dinoyo Ceramic Center Malang • East Java',
    'Perangkat Saat Ini': 'Current Device',
    'Perangkat Lain': 'Other Devices',
    'Keluar dari Semua Perangkat Lain': 'Log Out of All Other Devices',

    // ── Cart & Checkout ─────────────────────────────────────────────────────
    'Keranjang': 'Cart',
    'Keranjang Belanja': 'Shopping Cart',
    'Produk yang Dibeli': 'Purchased Items',
    'Keranjangmu masih kosong': 'Your cart is empty',
    'Yuk, jelajahi produk keramik dan tambahkan ke keranjang.':
        'Let\'s explore ceramic products and add them to your cart.',
    'Yuk, jelajahi produk keramik dan tambahkan\nke keranjang.':
        'Let\'s explore ceramic products and add them to your cart.',
    'Pengiriman dan metode pembayaran dipilih pada halaman checkout.':
        'Shipping and payment methods are selected on the checkout page.',
    'Total Harga': 'Total Price',
    'Total Tagihan': 'Total Bill',
    'Metode Pembayaran': 'Payment Method',
    'Pilih Pengiriman': 'Select Shipping',
    'Hapus Produk?': 'Remove Item?',

    // ── Notifications ───────────────────────────────────────────────────────
    'Notifikasi': 'Notifications',
    '1 Baru': '1 New',
    '2 Baru': '2 New',
    '3 Baru': '3 New',
    'Transaksi & Pesanan': 'Transactions & Orders',
    'Info Akun': 'Account Info',
    'Tandai Semua Dibaca': 'Mark All as Read',
    'Belum ada notifikasi': 'No notifications yet',
    'DISKON PENGRAJIN': 'ARTISAN DISCOUNT',
    'WISATA KREATIF': 'CREATIVE TOUR',
    'PEMBAYARAN': 'PAYMENT',
    'STATUS PESANAN': 'ORDER STATUS',
    'KEAMANAN AKUN': 'ACCOUNT SECURITY',
    'Voucher Diskon Keramik 15%': '15% Ceramic Discount Voucher',
    'Salin Voucher': 'Copy Voucher',
    'Jadwal Workshop Pembuatan Keramik': 'Ceramic Workshop Schedule',
    'Kelas seni putar tanah liat akhir pekan ini di Studio Dinoyo dibuka. Kuota tersisa 3 orang!':
        'Pottery wheel class this weekend at Dinoyo Studio is open. Only 3 spots left!',
    'Lihat Detail Workshop': 'View Workshop Details',
    'Pembayaran Dikonfirmasi': 'Payment Confirmed',
    'Pembayaran via GoPay untuk pesanan Cangkir Speckle sebesar Rp70.000 telah berhasil diverifikasi.':
        'GoPay payment for Speckle Cup order of Rp70,000 has been successfully verified.',
    'Pesanan Sedang Dikemas': 'Order Being Packed',
    'Penjual Dinoyo Ceramic Studio sedang menyiapkan pesanan #DNC-001 milikmu.':
        'Dinoyo Ceramic Studio is preparing your order #DNC-001.',
    'Masuk dari Perangkat Baru': 'Sign-in from New Device',
    'Akun @customer terdeteksi masuk dari perangkat baru pada 12 Feb 2025.':
        'Account @customer was detected logging in from a new device on 12 Feb 2025.',

    // ── Chatbot ─────────────────────────────────────────────────────────────
    'ClayBot': 'ClayBot',
    'Asisten DinoyoCraft': 'DinoyoCraft Assistant',
    'Apa yang ingin kamu cari?': 'What would you like to search for?',
    'Cari produk': 'Find products',
    'Rekomendasi cangkir': 'Cup recommendations',
    'Cari toko': 'Find stores',
    'Info workshop': 'Workshop info',
    'Bantuan pesanan': 'Order help',
    'Tulis pesan untuk ClayBot...': 'Type a message for ClayBot...',
    'Ketik pesan...': 'Type a message...',
    'Halo! 👋\n\nSaya ClayBot, asisten DinoyoCraft. Saya siap membantu kamu menemukan produk keramik lokal, mencari studio toko, info jadwal workshop, hingga bantuan pesananmu.':
        'Hello! 👋\n\nI am ClayBot, your DinoyoCraft assistant. I am ready to help you discover local ceramics, find artisan studios, check workshop schedules, or assist with your orders.',
    'Ada produk keramik spesifik yang sedang ingin kamu cari hari ini?':
        'Is there a specific ceramic product you are looking for today?',
    'Chat dengan customer service langsung':
        'Chat directly with Customer Service',
    'Customer Service': 'Customer Service',
    'Tim DinoyoCraft • Siap membantu': 'DinoyoCraft Team • Ready to help',
    'Menghubungkan kamu ke Customer Service DinoyoCraft... Mohon tunggu sebentar ya.':
        'Connecting you to DinoyoCraft Customer Service... Please wait a moment.',

    // ── Onboarding & Splash ────────────────────────────────────────────────
    'Temukan Cerita di Balik Setiap ': 'Discover the Story Behind Every ',
    'Keramik!': 'Ceramics!',
    'Jelajahi karya lokal Dinoyo, temukan pengrajin pilihan, dan rasakan pengalaman kreatif di balik setiap tanah liat.':
        'Explore Dinoyo local crafts, discover curated artisans, and feel the creative experience behind every clay.',
    'Mulai Menjelajah': 'Start Exploring',
    'Karya Otentik Sentra Keramik Dinoyo':
        'Authentic Crafts of Dinoyo Ceramic Center',
    'Sentuh layar untuk melanjutkan': 'Tap screen to continue',

    // ── Auth ────────────────────────────────────────────────────────────────
    'Silahkan Login Terlebih Dahulu': 'Please Log In First',
    'Masuk ke Akun': 'Sign In to Account',
    'Masuk untuk melanjutkan ke DinoyoCraft.':
        'Log in to continue to DinoyoCraft.',
    'Daftar Akun': 'Create Account',
    'Daftar Akun Baru': 'Register New Account',
    'Buat akun untuk mulai menjelajahi DinoyoCraft.':
        'Create an account to start exploring DinoyoCraft.',
    'Nama Lengkap': 'Full Name',
    'Masukkan nama lengkap': 'Enter full name',
    'Username': 'Username',
    'Buat username kamu': 'Create your username',
    'Email': 'Email',
    'Masukkan email kamu': 'Enter your email',
    'Tanggal Lahir': 'Date of Birth',
    'Nomor WhatsApp': 'WhatsApp Number',
    'Kata Sandi': 'Password',
    'Password': 'Password',
    'Masukkan kata sandi': 'Enter password',
    'Masukkan password': 'Enter password',
    'Konfirmasi Kata Sandi': 'Confirm Password',
    'Konfirmasi Password': 'Confirm Password',
    'Ulangi kata sandi': 'Repeat password',
    'Ulangi password': 'Repeat password',
    'Lupa kata sandi?': 'Forgot password?',
    'Lupa password?': 'Forgot password?',
    'Masuk': 'Log In',
    'Daftar': 'Register',
    'atau': 'or',
    'atau daftar dengan': 'or register with',
    'atau masuk dengan': 'or log in with',
    'Sudah punya akun? Masuk': 'Already have an account? Log In',
    'Sudah punya akun?': 'Already have an account?',
    'Sudah punya akun? ': 'Already have an account? ',
    'Belum punya akun?': 'Don\'t have an account?',
    'Belum punya akun? ': 'Don\'t have an account? ',
    'Belum punya akun? Daftar': 'Don\'t have an account? Register',
    'Masuk dengan Google': 'Sign In with Google',
    'Daftar dengan Google': 'Sign Up with Google',
    'Ganti Akun Google': 'Change Google Account',
    'Pilih Akun Google': 'Select Google Account',
    'Lanjutkan pendaftaran ke DinoyoCraft':
        'Continue registration to DinoyoCraft',
    'Batal & Gunakan Pendaftaran Manual':
        'Cancel & Use Manual Registration',
    'Beralih ke pendaftaran manual (Email & Password)':
        'Switched to manual registration (Email & Password)',
    'Saya menyetujui ': 'I agree to ',
    ' dan ': ' and ',
    'Saya menyetujui Syarat & Ketentuan serta Kebijakan Privasi yang berlaku.':
        'I agree to the Terms & Conditions and Privacy Policy.',
    'Setujui syarat & ketentuan terlebih dahulu':
        'Please agree to the terms & conditions first',
    'Akun Google Terhubung': 'Google Account Connected',
    'Nama wajib diisi': 'Name is required',
    'Username wajib diisi': 'Username is required',
    'Email wajib diisi': 'Email is required',
    'Password wajib diisi': 'Password is required',
    'Email tidak valid': 'Invalid email',
    'Tanggal lahir wajib diisi': 'Date of birth is required',
    'WhatsApp wajib diisi': 'WhatsApp number is required',
    'Masukkan nomor WhatsApp (contoh: 0812xxxxxxxx)':
        'Enter WhatsApp number (e.g. 0812xxxxxxxx)',
    'Username digunakan untuk identitas profil kamu.':
        'Username is used for your profile identity.',
    'Email terhubung dari akun Google dan tidak dapat diubah.':
        'Email is linked to Google account and cannot be changed.',
    'Email otomatis sesuai akun Google dan tidak dapat diganti.':
        'Email is automatically set from Google and cannot be changed.',
    'Minimal 8 karakter': 'At least 8 characters',
    'Password minimal 8 karakter.': 'Password must be at least 8 characters.',
    'Kata sandi minimal 8 karakter': 'Password must be at least 8 characters',
    'Konfirmasi wajib diisi': 'Confirmation is required',
    'Password tidak cocok': 'Passwords do not match',
    'Konfirmasi kata sandi tidak cocok': 'Passwords do not match',
    'Kolom password tertutup karena pendaftaran terautentikasi langsung dengan akun Google.':
        'Password field is closed because registration is authenticated directly with Google.',

    // ── Feedback & Dialogs ──────────────────────────────────────────────────
    'Tekan sekali lagi untuk keluar': 'Press back again to exit',
    'Tekan lagi untuk keluar': 'Press back again to exit',
    'Saya Mengerti': 'I Understand',
    'Ubah Foto Profil': 'Change Profile Picture',
    'Pilih sumber foto baru untuk profilmu.':
        'Select a new photo source for your profile.',
    'Kamera': 'Camera',
    'Galeri': 'Gallery',
    'Jenis Kelamin': 'Gender',
    'Laki-laki': 'Male',
    'Perempuan': 'Female',

    // ── Kamera & Galeri (PhotoPickerService) ────────────────────────────────
    'Pilih Sumber Foto': 'Choose Photo Source',
    'Ambil foto baru menggunakan kamera.':
        'Take a new photo with your camera.',
    'Pilih foto yang sudah ada di galeri.':
        'Pick an existing photo from your gallery.',
    'Ukuran foto maksimal 5 MB. Pilih foto yang lebih kecil.':
        'Photo size is up to 5 MB. Please choose a smaller photo.',
    'Tidak dapat membuka Kamera. Periksa izin kamera lalu coba lagi.':
        'Unable to open the camera. Check the camera permission and try again.',
    'Tidak dapat membuka Galeri. Periksa izin penyimpanan lalu coba lagi.':
        'Unable to open the gallery. Check the storage permission and try again.',
    'Kamera tidak tersedia di perangkat ini. Membuka galeri foto...':
        'Camera is unavailable on this device. Opening photo gallery...',
    'Foto profil berhasil diperbarui.':
        'Profile photo successfully updated.',
    'Preview Foto': 'Photo Preview',
    'Foto Profil': 'Profile Photo',
    'Ubah foto profil melalui menu Kelola Data Diri':
        'Change profile picture via Manage Personal Data menu',
    'Gagal memuat gambar': 'Failed to load image',
    'Foto Ulasan': 'Review Photo',
    'Tambahkan Foto Produk': 'Add Product Photos',

    // ── Hapus Akun ──────────────────────────────────────────────────────────
    'Hapus Akun?': 'Delete Account?',
    'Akun DinoyoCraft kamu akan dihapus secara permanen. Tindakan ini tidak dapat dibatalkan.':
        'Your DinoyoCraft account will be permanently deleted. This action cannot be undone.',
    'Permintaan penghapusan akun terkirim (demo).':
        'Account deletion request submitted (demo).',
    'Beri tahu kami alasan kamu (Opsional)':
        'Tell us your reason (Optional)',
    'Masukan kamu sangat berharga untuk kemajuan perajin keramik lokal Dinoyo.':
        'Your feedback is very valuable for the progress of local Dinoyo ceramic artisans.',
    'Sudah jarang membeli keramik': 'Rarely buy ceramics anymore',
    'Ingin membuat akun baru': 'Want to create a new account',
    'Kekhawatiran privasi & keamanan data':
        'Privacy & data security concerns',
    'Lainnya': 'Other',
    'Masukkan Kata Sandi untuk Konfirmasi':
        'Enter Password to Confirm',
    'Masukkan kata sandi akunmu': 'Enter your account password',
    'Verifikasi keamanan untuk memastikan ini benar-benar pemilik akun.':
        'Security verification to confirm you are truly the account owner.',
    'Hapus Akun Secara Permanen': 'Permanently Delete Account',
    'Apakah kamu yakin ingin menghapus akun?':
        'Are you sure you want to delete your account?',
    'Tindakan ini bersifat ': 'This action is ',
    'permanen dan tidak dapat dibatalkan':
        'permanent and cannot be undone',
    '. Seluruh data profil, riwayat kurasi produk keramik, serta poin DinoyoCraft kamu akan dihapus selamanya.':
        '. All profile data, ceramic curation history, and DinoyoCraft points will be permanently deleted.',
    'Saya mengerti konsekuensi penghapusan akun DinoyoCraft ini dan menyatakan bahwa keputusan ini bersifat final.':
        'I understand the consequences of deleting this DinoyoCraft account and declare that this decision is final.',

    // ── Alamat ──────────────────────────────────────────────────────────────
    'Kelola Alamat': 'Manage Addresses',
    'Alamat Pengiriman Terdaftar': 'Registered Delivery Addresses',
    'dari 5 alamat': 'of 5 addresses',
    'Belum Ada Alamat Tersimpan': 'No Saved Addresses',
    'Tambahkan alamat pengiriman untuk memudahkan proses pembelian tembikar dan keramik Dinoyo.':
        'Add a delivery address to make purchasing Dinoyo pottery and ceramics easier.',
    'Tambah Alamat Baru': 'Add New Address',
    'Maksimal 5 alamat tersimpan untuk kemudahan checkout.':
        'Up to 5 saved addresses for convenient checkout.',
    'Utama': 'Primary',
    'Jadikan Utama': 'Set as Primary',
    'Jadikan Alamat Utama': 'Set as Primary Address',
    'Ubah Alamat': 'Edit Address',
    'Salin Alamat': 'Copy Address',
    'Hapus Alamat': 'Delete Address',
    'Hapus Alamat?': 'Delete Address?',
    'Catatan untuk kurir:': 'Courier note:',
    'Titik Peta\nTerverifikasi': 'Map Pin\nVerified',
    'Atur Titik\nPeta GPS': 'Set GPS\nMap Pin',
    'Titik Peta Terverifikasi': 'Verified Map Pin',
    'Koordinat GPS Terhubung': 'GPS Coordinates Connected',
    'Ubah Alamat Pengiriman': 'Edit Shipping Address',
    'Pastikan rincian alamat tepat untuk kurir keramik':
        'Ensure address details are accurate for ceramic courier',
    'LABEL ALAMAT': 'ADDRESS LABEL',
    'Rumah': 'Home',
    'Kantor': 'Office',
    'Apartemen': 'Apartment',
    'Studio': 'Studio',
    'NAMA PENERIMA': 'RECIPIENT NAME',
    'Masukkan nama lengkap penerima': 'Enter recipient full name',
    'NOMOR TELEPON / WHATSAPP': 'PHONE NUMBER / WHATSAPP',
    'ALAMAT LENGKAP': 'FULL ADDRESS',
    'Nama jalan, nomor rumah, RT/RW, kelurahan, kecamatan, kota & kode pos':
        'Street name, house number, RT/RW, subdistrict, district, city & postal code',
    'CATATAN UNTUK KURIR (OPSIONAL)': 'COURIER NOTE (OPTIONAL)',
    'cth: Pagar hitam depan studio keramik, titip satpam':
        'e.g.: Black gate in front of ceramic studio, leave with guard',
    'Verifikasi Titik Peta GPS': 'Verify GPS Map Pin',
    'Mempermudah kurir melacak alamat akurat':
        'Makes it easier for couriers to locate accurately',
    'Alamat prioritas saat checkout belanjaan':
        'Priority address during shopping checkout',
    'Simpan Alamat Baru': 'Save New Address',

    // ── Product Details & Variations ────────────────────────────────────────
    '128 Ulasan': '128 Reviews',
    '128 ulasan': '128 reviews',
    'Terjual 340+': '340+ Sold',
    'Spesifikasi Detail': 'Detailed Specifications',
    'Bahan Utama': 'Main Material',
    'Tanah Liat Dinoyo (Stoneware)': 'Dinoyo Clay (Stoneware)',
    'Finishing': 'Finishing',
    'Matte Glaze Alami': 'Natural Matte Glaze',
    'Dimensi Produk': 'Product Dimensions',
    'Berat Bersih': 'Net Weight',
    'Garansi Kemasan Aman Dinoyo': 'Dinoyo Safe Packaging Warranty',
    'Setiap keramik dibalut triple bubble wrap & kotak kardus tebal untuk memastikan produk sampai utuh.':
        'Each ceramic is wrapped in triple bubble wrap & thick carton box to ensure intact delivery.',
    '98% pembeli merekomendasikan produk ini':
        '98% of buyers recommend this product',
    'Membantu': 'Helpful',
    'Apakah ulasan ini bermanfaat?': 'Was this review helpful?',
    'Salin Ulasan': 'Copy Review',
    'Laporkan Ulasan': 'Report Review',
    'Beli Langsung': 'Buy Directly',
    'PILIHAN WARNA / GLAZE': 'COLOR / GLAZE SELECTION',
    'JUMLAH PRODUK': 'PRODUCT QUANTITY',
    'Subtotal Estimasi:': 'Estimated Subtotal:',
    'Kampung Keramik Dinoyo': 'Dinoyo Ceramic Village',

    // ── Checkout ────────────────────────────────────────────────────────────
    'Pilih Alamat Pengiriman': 'Select Delivery Address',
    'Ringkasan Belanja': 'Order Summary',
    'Ringkasan Pembayaran': 'Payment Summary',
    'Subtotal Produk': 'Item Subtotal',
    'Metode Pengiriman': 'Shipping Method',
    'Catatan untuk Penjual (Opsional)': 'Note for Seller (Optional)',
    'Reguler': 'Regular',
    'Hemat': 'Economy',
    'Express': 'Express',
    'Estimasi 2–4 hari kerja': 'Estimated 2–4 business days',
    'Estimasi 4–7 hari kerja': 'Estimated 4–7 business days',
    'Estimasi 1–2 hari kerja (Prioritas)':
        'Estimated 1–2 business days (Priority)',
    'Opsi Pengiriman': 'Shipping Option',
    'Catatan Pesanan': 'Order Notes',
    'Bayar Sekarang': 'Pay Now',
    'Rincian Pembayaran': 'Payment Details',
    'Biaya Pengiriman': 'Shipping Fee',
    'Biaya Layanan': 'Service Fee',
    'Total Pembayaran': 'Total Payment',
    'Pembayaran berhasil': 'Payment successful',
    'Kembali ke Beranda': 'Back to Home',

    // ── Chat Room ────────────────────────────────────────────────────────────
    'Lihat Profil Toko': 'View Store Profile',
    'Asisten Toko (Bot)': 'Store Assistant (Bot)',
    'Asisten Toko Siaga': 'Store Assistant Ready',
    'Penjual Online': 'Seller Online',
    'Chat dengan Penjual': 'Chat with Seller',
    'Chat Penjual': 'Chat Seller',
    'Chat dengan Penjual Langsung': 'Chat with Seller Directly',
    'Menghubungkan ke Pemilik Toko... Mohon tunggu sebentar ya.':
        'Connecting to the Store Owner... Please wait a moment.',
    'Beralih ke Asisten Bot': 'Switch to Bot Assistant',
    'Penjual Toko': 'Store Seller',
    'Hapus Percakapan': 'Clear Conversation',
    'Laporkan Percakapan': 'Report Conversation',
    'Terima kasih, laporanmu kami terima.':
        'Thank you, your report has been received.',
    'Kirim Foto': 'Send Photo',
    'Foto Terkirim': 'Sent Photo',
    'Foto dari Toko': 'Store Photo',
    'Foto ChatBot': 'ChatBot Photo',
    'Pilih foto dari galeri contoh (demo).':
        'Choose a photo from demo gallery.',
    'Hari ini, 14:10': 'Today, 14:10',
    'Hari ini': 'Today',

    // ── Toko, Review & Bantuan ───────────────────────────────────────────────
    'Profil Toko': 'Store Profile',
    'Chat Toko': 'Store Chat',
    'Cari produk di toko ini...': 'Search products in this store...',
    'Katalog': 'Catalog',
    'Produk tidak ditemukan': 'No products found',
    'Menampilkan': 'Showing',
    'Ulasan Toko': 'Store Reviews',
    'Ulasan Pelanggan': 'Customer Reviews',
    'Terverifikasi': 'Verified',
    '98% pembeli merekomendasikan produk studio ini':
        '98% of buyers recommend this studio\'s products',
    'Beri Ulasan Produk': 'Write Product Review',
    'Kirim Ulasan': 'Submit Review',
    'Butuh Bantuan?': 'Need Help?',
    'Temukan jawaban cepat atau hubungi tim kami.':
        'Find quick answers or contact our team.',
    'Cari pertanyaan...': 'Search questions...',
    'Kontak Customer Service': 'Contact Customer Service',
    'ClayBot Asisten': 'ClayBot Assistant',
    'Bintang': 'Star',
    'Ulasan disalin': 'Review copied',
    'Terima kasih, laporan ulasan dikirim.':
        'Thank you, review report submitted.',
    'Perbesar': 'Enlarge',
    'Perbesar Foto': 'Enlarge Photo',
    'Foto Produk': 'Product Photo',

    // ── Pelaporan Produk ─────────────────────────────────────────────────────
    'Laporkan Produk': 'Report Product',
    'Pilih Alasan Pelaporan': 'Select Reason for Reporting',
    'Beri tahu kami masalah apa yang Anda temukan pada produk ini untuk membantu menjaga kualitas dan keamanan komunitas DinoyoCraft.':
        'Tell us what issue you found with this product to help maintain the quality and safety of the DinoyoCraft community.',
    'Gambar tidak sesuai produk asli': 'Image does not match actual product',
    'Deskripsi atau spesifikasi tidak akurat':
        'Description or specifications are inaccurate',
    'Produk tiruan atau pelanggaran hak cipta':
        'Counterfeit product or copyright violation',
    'Harga tidak wajar atau indikasi penipuan':
        'Unreasonable price or suspicious activity',
    'Produk rusak, cacat, atau kualitas buruk':
        'Damaged, defective, or poor quality product',
    'Tuliskan alasan pelaporan Anda': 'Write your reason for reporting',
    'Tuliskan alasan pelaporan Anda secara rinci...':
        'Describe your reason for reporting in detail...',
    'Harap tuliskan alasan pelaporan': 'Please write your reason for reporting',
    'Pilih salah satu alasan pelaporan': 'Please select a reason for reporting',
    'Kirim Laporan': 'Submit Report',
    'Laporan berhasil dikirim. Terima kasih telah membantu menjaga komunitas DinoyoCraft.':
        'Report submitted successfully. Thank you for helping keep the DinoyoCraft community safe.',

    // ── Pelaporan Ulasan ─────────────────────────────────────────────────────
    'Beri tahu kami masalah apa yang Anda temukan pada ulasan ini untuk membantu menjaga ulasan tetap relevan, sopan, dan terpercaya.':
        'Tell us what issue you found with this review to help keep reviews relevant, polite, and trustworthy.',
    'Ulasan mengandung kata kasar atau menyerang':
        'Review contains offensive or abusive words',
    'Ulasan palsu & tidak relevan': 'Fake & irrelevant review',
    'Spam, penipuan, atau iklan promosi': 'Spam, scam, or promotional ads',
    'Mengandung informasi pribadi atau sensitif':
        'Contains personal or sensitive information',
    'Foto ulasan tidak pantas atau menyesatkan':
        'Review photo is inappropriate or misleading',
    'Tuliskan alasan pelaporan ulasan secara rinci...':
        'Describe your reason for reporting this review in detail...',
    'Terima kasih, laporan ulasan berhasil dikirim.':
        'Thank you, the review report has been successfully submitted.',

    // ── Pelaporan Toko ───────────────────────────────────────────────────────
    'Laporkan Toko': 'Report Store',
    'Bagikan Toko': 'Share Store',
    'Tautan profil toko disalin ke clipboard':
        'Store profile link copied to clipboard',
    'Beri tahu kami masalah apa yang Anda temukan pada toko ini untuk membantu menjaga persaingan sehat dan keamanan berbelanja di DinoyoCraft.':
        'Tell us what issue you found with this store to help maintain fair competition and safe shopping at DinoyoCraft.',
    'Melanggar ketentuan harga (price dumping)':
        'Price dumping policy violation',
    'Foto produk menggunakan gambar curian':
        'Product photos use stolen images',
    'Toko terindikasi penipuan atau pesanan fiktif':
        'Store suspected of fraud or fictitious orders',
    'Menjual produk tiruan atau pelanggaran hak cipta':
        'Selling counterfeit products or copyright violation',
    'Penyalahgunaan data pribadi pembeli':
        'Misuse of buyer personal data',
    'Tuliskan alasan pelaporan toko secara rinci...':
        'Describe your reason for reporting this store in detail...',
    'Terima kasih, laporan toko berhasil dikirim dan akan segera ditinjau oleh tim DinoyoCraft.':
        'Thank you, your store report has been submitted and will be reviewed by the DinoyoCraft team.',
  };

  /// Cache lowercase untuk pencarian cepat case-insensitive
  static final Map<String, String> _lowerDict = {
    for (final entry in _dict.entries)
      entry.key.trim().toLowerCase(): entry.value,
  };
}

/// Extension agar mempermudah pemanggilan 'Teks'.tr di sembarang widget
extension AppTextExtension on String {
  String get tr => AppText.tr(this);
}
