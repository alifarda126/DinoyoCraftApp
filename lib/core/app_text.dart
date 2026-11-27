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

    // 5. Fallback pola dinamis (interpolasi angka / kode pesanan / nama)
    final dynamicTranslated = _translateDynamic(trimmed);
    if (dynamicTranslated != null) {
      final startIdx = text.indexOf(trimmed);
      final leading = text.substring(0, startIdx);
      final trailing = text.substring(startIdx + trimmed.length);
      return '$leading$dynamicTranslated$trailing';
    }

    return text;
  }

  static String? _translateDynamic(String s) {
    RegExpMatch? m;

    if ((m = RegExp(r'^(\d+)\s+Baru$').firstMatch(s)) != null) {
      return '${m![1]} New';
    }
    if ((m = RegExp(r'^(\d+)\s+Pesanan$').firstMatch(s)) != null) {
      final n = m![1]!;
      return n == '1' ? '1 Order' : '$n Orders';
    }
    if ((m = RegExp(r'^(\d+)\s+Penjual Terpilih$').firstMatch(s)) != null) {
      final n = m![1]!;
      return n == '1' ? '1 Selected Seller' : '$n Selected Sellers';
    }
    if ((m = RegExp(r'^\+\s*(\d+)\s+produk lainnya$').firstMatch(s)) != null) {
      final n = m![1]!;
      return '+ $n more ${n == '1' ? 'item' : 'items'}';
    }
    if ((m = RegExp(r'^Jumlah:\s*(\d+)(x?)$').firstMatch(s)) != null) {
      return 'Qty: ${m![1]}${m[2]}';
    }
    if ((m = RegExp(r'^Total\s*\((\d+)\s+Produk\):?$').firstMatch(s)) != null) {
      final n = m![1]!;
      final colon = s.endsWith(':') ? ':' : '';
      return 'Total ($n ${n == '1' ? 'Item' : 'Items'})$colon';
    }
    if ((m = RegExp(r'^Rincian Pesanan\s*\((\d+)\s+Barang\)$').firstMatch(s)) !=
        null) {
      final n = m![1]!;
      return 'Order Details ($n ${n == '1' ? 'Item' : 'Items'})';
    }
    if ((m = RegExp(r'^Varian:\s*(.+)$').firstMatch(s)) != null) {
      return 'Variant: ${m![1]}';
    }
    if ((m = RegExp(r'^Variasi:\s*(.+)$').firstMatch(s)) != null) {
      return 'Variation: ${m![1]}';
    }
    if ((m = RegExp(r'^Resi:\s*(.+)$').firstMatch(s)) != null) {
      return 'Tracking No: ${m![1]}';
    }
    if ((m = RegExp(r'^Pengiriman:\s*(.+)$').firstMatch(s)) != null) {
      return 'Shipping: ${m![1]}';
    }
    if ((m = RegExp(r'^Batas akhir:\s*(.+)$').firstMatch(s)) != null) {
      return 'Deadline: ${m![1]}';
    }
    if ((m = RegExp(r'^Buka Aplikasi\s+(.+)$').firstMatch(s)) != null) {
      return 'Open ${m![1]} App';
    }
    if ((m = RegExp(
          r'^Buka aplikasi\s+(.+),\s*pilih menu Scan QR lalu arahkan atau unggah QRIS di atas\.$',
        ).firstMatch(s)) !=
        null) {
      return 'Open ${m![1]} app, select Scan QR, then scan or upload the QRIS code above.';
    }
    if ((m = RegExp(r'^Nomor VA\s+(.+)\s+berhasil disalin!$').firstMatch(s)) !=
        null) {
      return '${m![1]} VA number copied!';
    }
    if ((m = RegExp(
          r'^Tautan aplikasi\s+(.+)\s+belum tersedia\. Gunakan QR atau coba muat ulang\.$',
        ).firstMatch(s)) !=
        null) {
      return '${m![1]} app link is unavailable. Please use QR or reload.';
    }
    if ((m = RegExp(
          r'^Tekan tombol di atas untuk langsung diarahkan ke aplikasi\s+(.+)\s+dan konfirmasikan pembayaran sebelum batas waktu berakhir\.$',
        ).firstMatch(s)) !=
        null) {
      return 'Tap the button above to open ${m![1]} directly and confirm payment before the deadline.';
    }
    if ((m = RegExp(
          r'^Tidak dapat membuka aplikasi\s+(.+)\s+di perangkat ini\. Pindai QR atau gunakan Simulator Midtrans Sandbox\.$',
        ).firstMatch(s)) !=
        null) {
      return 'Unable to open ${m![1]} on this device. Scan the QR code or use the Midtrans Sandbox Simulator.';
    }
    if ((m = RegExp(
          r'^Pesanan #(.+) akan dibatalkan\. Tindakan ini tidak dapat diurungkan\.$',
        ).firstMatch(s)) !=
        null) {
      return 'Order #${m![1]} will be canceled. This action cannot be undone.';
    }
    if ((m = RegExp(r'^Pesanan #(.+) berhasil dibatalkan\.$').firstMatch(s)) !=
        null) {
      return 'Order #${m![1]} has been canceled.';
    }
    if ((m = RegExp(
          r'^Pesanan #(.+) selesai! Dana diteruskan ke penjual\.$',
        ).firstMatch(s)) !=
        null) {
      return 'Order #${m![1]} completed! Funds have been released to the seller.';
    }
    if ((m = RegExp(
          r'^Pastikan produk pesanan #(.+) sudah diterima dengan baik\. Setelah dikonfirmasi, pesanan selesai dan dana masuk ke saldo aktif penjual\.$',
        ).firstMatch(s)) !=
        null) {
      return 'Make sure order #${m![1]} has been received in good condition. Once confirmed, the order is completed and funds are released to the seller.';
    }
    String trProd(String raw) => raw.replaceAllMapped(
          RegExp(r'\(\+(\d+)\s+produk lainnya\)'),
          (pm) => '(+${pm[1]} more ${pm[1] == '1' ? 'item' : 'items'})',
        );

    if ((m = RegExp(
          r'^Pembayaran untuk "(.+)" telah (?:berhasil )?dikonfirmasi\.\s*(.*)$',
        ).firstMatch(s)) !=
        null) {
      return 'Payment for "${trProd(m![1]!)}" has been confirmed. The seller will process your order shortly.';
    }
    if ((m = RegExp(
          r'^Pesanan "(.+)" di toko (.+) berhasil dibuat\. Silakan selesaikan pembayaran\.$',
        ).firstMatch(s)) !=
        null) {
      return 'Order "${trProd(m![1]!)}" at ${m[2]} has been placed. Please complete your payment.';
    }
    if ((m = RegExp(
          r'^Pesanan "(.+)" sedang dikemas(?: dengan rapi)? oleh pengrajin\.(?:\s*Mohon tunggu hingga pesanan dikirim\.)?$',
        ).firstMatch(s)) !=
        null) {
      return 'Order "${trProd(m![1]!)}" is being carefully packed by the artisan.';
    }
    if ((m = RegExp(
          r'^Pesanan "(.+)" telah dikirim! No\. Resi:\s*(.+)$',
        ).firstMatch(s)) !=
        null) {
      return 'Order "${trProd(m![1]!)}" has been shipped! Tracking No: ${m[2]}';
    }
    if ((m = RegExp(
          r'^Pesanan "(.+)" telah dikirim oleh pengrajin!$',
        ).firstMatch(s)) !=
        null) {
      return 'Order "${trProd(m![1]!)}" has been shipped by the artisan!';
    }
    if ((m = RegExp(
          r'^Pesanan "(.+)" telah diterima dan selesai\.\s*(.*)$',
        ).firstMatch(s)) !=
        null) {
      return 'Order "${trProd(m![1]!)}" has been received and completed. Don\'t forget to leave a review!';
    }
    if ((m = RegExp(r'^Pesanan "(.+)" telah dibatalkan\.$').firstMatch(s)) !=
        null) {
      return 'Order "${trProd(m![1]!)}" has been canceled.';
    }
    if ((m = RegExp(
          r'^Pesanan "(.+)"(?:\s*\(Rp\s*[^)]+\))?\s+dibatalkan otomatis\.\s*(.*)$',
        ).firstMatch(s)) !=
        null) {
      return 'Order "${trProd(m![1]!)}" was automatically canceled. Please place a new order if you are still interested.';
    }
    if ((m = RegExp(
          r'^Akun Anda baru saja masuk pada perangkat (.+)\. Jika ini bukan Anda, segera ubah kata sandi di Pengaturan\.$',
        ).firstMatch(s)) !=
        null) {
      return 'Your account just signed in on ${m![1]}. If this wasn\'t you, please change your password in Settings immediately.';
    }
    if ((m = RegExp(
          r'^Pembayaran pesanan #(.+) telah (?:berhasil )?dikonfirmasi\.\s*(.*)$',
        ).firstMatch(s)) !=
        null) {
      return 'Payment for order #${m![1]} has been confirmed. The seller will process your order shortly.';
    }
    if ((m = RegExp(
          r'^Pesanan #(.+) sedang dikemas oleh pengrajin\. Mohon tunggu hingga pesanan dikirim\.$',
        ).firstMatch(s)) !=
        null) {
      return 'Order #${m![1]} is being packed by the artisan. Please wait until it is shipped.';
    }
    if ((m = RegExp(
          r'^Pesanan #(.+) telah dikirim! No\. Resi:\s*(.+)$',
        ).firstMatch(s)) !=
        null) {
      return 'Order #${m![1]} has been shipped! Tracking No: ${m[2]}';
    }
    if ((m = RegExp(
          r'^Pesanan #(.+) sedang dalam perjalanan menuju alamat Anda\.$',
        ).firstMatch(s)) !=
        null) {
      return 'Order #${m![1]} is on its way to your address.';
    }
    if ((m = RegExp(
          r'^Pesanan #(.+) telah diterima dan selesai\. Terima kasih telah berbelanja di DinoyoCraft!$',
        ).firstMatch(s)) !=
        null) {
      return 'Order #${m![1]} has been received and completed. Thank you for shopping at DinoyoCraft!';
    }
    if ((m = RegExp(
          r'^Mohon maaf, pesanan #(.+) telah dibatalkan\.$',
        ).firstMatch(s)) !=
        null) {
      return 'Sorry, order #${m![1]} has been canceled.';
    }
    if ((m = RegExp(r'^Update Status Pesanan #(.+)$').firstMatch(s)) != null) {
      return 'Order #${m![1]} Status Update';
    }
    if ((m = RegExp(
          r'^Status pesanan #(.+) diperbarui menjadi\s+(.+)\.$',
        ).firstMatch(s)) !=
        null) {
      return 'Order #${m![1]} status updated to ${m[2]}.';
    }
    if ((m = RegExp(r'^Pesan Baru dari\s+(.+)$').firstMatch(s)) != null) {
      return 'New Message from ${m![1]}';
    }
    if ((m = RegExp(r'^Mulai obrolan dengan\s+(.+)$').firstMatch(s)) != null) {
      return 'Start a chat with ${m![1]}';
    }
    if ((m = RegExp(r'^Terakhir dilihat\s+(.+)$').firstMatch(s)) != null) {
      return 'Last seen ${m![1]}';
    }
    if ((m = RegExp(r'^Terakhir diubah\s+(\d+)\s+hari lalu$').firstMatch(s)) !=
        null) {
      final n = m![1]!;
      return 'Last changed $n ${n == '1' ? 'day' : 'days'} ago';
    }
    if ((m = RegExp(r'^Terakhir diubah\s+(\d+)\s+bulan lalu$').firstMatch(s)) !=
        null) {
      final n = m![1]!;
      return 'Last changed $n ${n == '1' ? 'month' : 'months'} ago';
    }
    if ((m = RegExp(r'^(\d+)\s+menit lalu$').firstMatch(s)) != null) {
      return '${m![1]}m ago';
    }
    if ((m = RegExp(r'^(\d+)\s+jam lalu$').firstMatch(s)) != null) {
      return '${m![1]}h ago';
    }
    if ((m = RegExp(r'^(\d+)\s+hari lalu$').firstMatch(s)) != null) {
      return '${m![1]}d ago';
    }
    if ((m = RegExp(
          r'^Belum ada ulasan dengan bintang\s+(\d+)$',
        ).firstMatch(s)) !=
        null) {
      return 'No ${m![1]}-star reviews yet';
    }
    if ((m = RegExp(r'^Ulasan oleh\s+(.+)$').firstMatch(s)) != null) {
      return 'Review by ${m![1]}';
    }
    if ((m = RegExp(
          r'^Username profil dinoyocraft\.my\.id/@(.+)$',
        ).firstMatch(s)) !=
        null) {
      return 'Profile username dinoyocraft.my.id/@${m![1]}';
    }
    if ((m = RegExp(
          r'^Alamat "(.+)" berhasil disalin ke clipboard\.$',
        ).firstMatch(s)) !=
        null) {
      return 'Address "${m![1]}" copied to clipboard.';
    }
    if ((m = RegExp(r'^Alamat "(.+)" berhasil diperbarui\.$').firstMatch(s)) !=
        null) {
      return 'Address "${m![1]}" updated successfully.';
    }
    if ((m = RegExp(r'^Alamat "(.+)" berhasil ditambahkan\.$').firstMatch(s)) !=
        null) {
      return 'Address "${m![1]}" added successfully.';
    }
    if ((m = RegExp(r'^Alamat "(.+)" dijadikan alamat utama\.$').firstMatch(s)) !=
        null) {
      return 'Address "${m![1]}" set as primary address.';
    }
    if ((m = RegExp(
          r'^Sesi "(.+)" akan dicabut dan perangkat tersebut otomatis ter-logout dari akun Anda\.$',
        ).firstMatch(s)) !=
        null) {
      return 'Session "${m![1]}" will be revoked and that device will be logged out automatically.';
    }
    if ((m = RegExp(
          r'^Untuk mengonfirmasi penonaktifan Autentikasi 2 Langkah, kami akan mengirimkan kode verifikasi OTP ke email terdaftar Anda \((.+)\)\.$',
        ).firstMatch(s)) !=
        null) {
      return 'To confirm disabling Two-Factor Authentication, we will send an OTP verification code to your registered email (${m![1]}).';
    }
    if ((m = RegExp(
          r'^Akun Anda login melalui Google\. Ketik persis alamat email \((.+)\) untuk konfirmasi keamanan\.$',
        ).firstMatch(s)) !=
        null) {
      return 'Your account signed in via Google. Type your exact email address (${m![1]}) to confirm.';
    }
    if ((m = RegExp(
          r'^Anda masih memiliki (\d+) pesanan aktif yang sedang berjalan\..*$',
        ).firstMatch(s)) !=
        null) {
      final n = m![1]!;
      return 'You still have $n active ${n == '1' ? 'order' : 'orders'} in progress. Please complete or cancel them before requesting account deletion.';
    }
    if ((m = RegExp(
          r'^Apakah kamu yakin ingin menghapus "(.+)" dari keranjang\?$',
        ).firstMatch(s)) !=
        null) {
      return 'Are you sure you want to remove "${m![1]}" from your cart?';
    }
    if ((m = RegExp(r'^"(.+)" dihapus dari keranjang$').firstMatch(s)) !=
        null) {
      return '"${m![1]}" removed from cart';
    }
    if ((m = RegExp(
          r'^Stok tersisa (\d+) buah untuk varian ini$',
        ).firstMatch(s)) !=
        null) {
      return '${m![1]} left in stock for this variant';
    }
    if ((m = RegExp(r'^Stok tersisa (\d+) buah$').firstMatch(s)) != null) {
      return '${m![1]} left in stock';
    }
    if ((m = RegExp(r'^Kampung Wisata Keramik Dinoyo,\s*(.+)$').firstMatch(s)) !=
        null) {
      return 'Dinoyo Ceramic Tourism Village, ${m![1]}';
    }

    // Scripted chat bot & store replies with dynamic store/product/order names
    if ((m = RegExp(
          r'^(.+) melayani pembuatan keramik custom \(desain motif, glasir khusus, ukiran nama/logo\)\. Silakan chat langsung dengan penjual untuk berkonsultasi detailnya ya! 🏺$',
        ).firstMatch(s)) !=
        null) {
      return '${m![1]} accepts custom ceramic orders (patterns, custom glazes, name/logo engravings). Chat directly with the seller to consult on details! 🏺';
    }
    if ((m = RegExp(
          r'^Halo Kak! Selamat datang di (.+)\. Saya Asisten Bot Toko siap membantu pertanyaan seputar produk keramik atau pengiriman sebelum terhubung dengan Penjual! 😊$',
        ).firstMatch(s)) !=
        null) {
      return 'Hello! Welcome to ${m![1]}. I am the Store Bot Assistant, ready to help with ceramic product or shipping questions before connecting you with the Seller! 😊';
    }
    if ((m = RegExp(
          r'^Halo Kak! Produk keramik di (.+) sebagian besar ready stock dan siap dikirim\..*$',
        ).firstMatch(s)) !=
        null) {
      return 'Hello! Most ceramic products at ${m![1]} are in stock and ready to ship. Each piece is crafted from Dinoyo clay with high-temperature firing. Need specific variant stock info? Chat directly with the seller below! 👍';
    }
    if ((m = RegExp(
          r'^Halo Kak! Saya Mas Dinoyo dari (.+)\. Maaf tadi masih mengecek pembakaran di workshop\. Ada yang bisa saya bantu secara langsung terkait produk atau pesanan Kakak\? 😊$',
        ).firstMatch(s)) !=
        null) {
      return 'Hello! I am the artisan from ${m![1]}. Sorry, I was checking the kiln at the workshop earlier. How can I assist you directly with our products or your order? 😊';
    }
    if ((m = RegExp(
          r'^Halo Kak! Informasi pesanan (.+) \((.+)\) sudah saya catat\..*$',
        ).firstMatch(s)) !=
        null) {
      return 'Hello! I have noted order ${m![1]} (${m[2]}). Please share your question or issue, or tap the button below to connect directly with Customer Service.';
    }
    if ((m = RegExp(
          r'^Halo Kak! Informasi pesanan (.+) \((.+)\) sudah saya terima\..*$',
        ).firstMatch(s)) !=
        null) {
      return 'Hello! I have received the details for order ${m![1]} (${m[2]}). The Bot Assistant can help check shipping/packaging info, or tap Chat Seller below to speak directly with the store.';
    }
    if ((m = RegExp(
          r'^Halo Kak! Terima kasih sudah membagikan info (.+)\. Ada kendala atau pertanyaan terkait produk ini.*$',
        ).firstMatch(s)) !=
        null) {
      return 'Hello! Thank you for sharing ${m![1]}. Do you have any questions or issues regarding this product before connecting to Customer Service?';
    }
    if ((m = RegExp(
          r'^Halo Kak! Terima kasih sudah menanyakan (.+)\. Karya keramik ini ready stock.*$',
        ).firstMatch(s)) !=
        null) {
      return 'Hello! Thank you for asking about ${m![1]}. This ceramic piece is handcrafted by Dinoyo artisans. Need glaze color options or packaging details? Tap below to chat directly with the seller! 😊';
    }

    // Error prefixes ("Gagal ...: $msg")
    const errorPrefixes = <String, String>{
      'Gagal login dengan Google: ': 'Google sign-in failed: ',
      'Gagal membatalkan pesanan: ': 'Failed to cancel order: ',
      'Gagal memilih akun Google: ': 'Failed to select Google account: ',
      'Gagal mengirim ulang OTP: ': 'Failed to resend OTP: ',
      'Gagal mengonfirmasi pesanan: ': 'Failed to confirm order: ',
      'Gagal mengubah kata sandi: ': 'Failed to change password: ',
      'Gagal menyelesaikan pesanan: ': 'Failed to complete order: ',
      'Gagal menyimpan: ': 'Failed to save: ',
      'Gagal verifikasi OTP: ': 'OTP verification failed: ',
      'Gagal mengirim OTP: ': 'Failed to send OTP: ',
      'Gagal mencabut sesi: ': 'Failed to revoke session: ',
      'Gagal menyimpan alamat: ': 'Failed to save address: ',
      'Gagal menghapus alamat: ': 'Failed to delete address: ',
      'Gagal mengubah alamat utama: ': 'Failed to update primary address: ',
    };
    for (final entry in errorPrefixes.entries) {
      if (s.startsWith(entry.key)) {
        final rest = s.substring(entry.key.length);
        return '${entry.value}${_dict[rest] ?? rest}';
      }
    }

    return null;
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
    'Username profil dinoyocraft.my.id/@customer. Ubah 30 hari sekali.':
        'Profile username dinoyocraft.my.id/@customer. Change every 30 days.',
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
    'Pusat Bantuan': 'Help Center',
    'Asisten Toko (Bot)': 'Store Assistant (Bot)',
    'Asisten CS (Bot)': 'CS Assistant (Bot)',
    'Asisten Toko Siaga': 'Store Assistant Ready',
    'Asisten Toko Siaga • Dibalas otomatis':
        'Store Assistant Ready • Auto-replied',
    'Asisten CS Siaga • Dibalas otomatis':
        'CS Assistant Ready • Auto-replied',
    'Terhubung langsung dengan Penjual': 'Connected directly to Seller',
    'Terhubung langsung dengan Customer Service':
        'Connected directly to Customer Service',
    'Asisten Bot siap membantu sebelum ke Penjual':
        'Bot Assistant is ready to help before Seller',
    'Asisten Bot CS siap membantu sebelum ke CS':
        'CS Bot Assistant is ready to help before CS',
    'Asisten Bot toko siap menjawab saat toko sibuk':
        'Store Bot Assistant is ready when store is busy',
    'Chat dengan Customer Service': 'Chat with Customer Service',
    'Chat CS': 'Chat CS',
    'Terhubung kembali langsung dengan Customer Service.':
        'Reconnected directly with Customer Service.',
    'Menghubungkan ke Customer Service... Mohon tunggu sebentar ya.':
        'Connecting to Customer Service... Please wait a moment.',
    'Asisten Bot Toko aktif kembali. Silakan tanyakan seputar produk atau toko! 🤖':
        'Store Bot Assistant is back online. Feel free to ask about products or the store! 🤖',
    'Asisten Bot CS aktif kembali. Silakan tanyakan seputar pesanan, pembayaran, atau akun! 🤖':
        'CS Bot Assistant is back online. Feel free to ask about orders, payments, or your account! 🤖',
    'Foto dari Customer Service': 'Photo from Customer Service',
    'Penjual Online': 'Seller Online',
    'Chat dengan Penjual': 'Chat with Seller',
    'Chat Penjual': 'Chat Seller',
    'Chat dengan Penjual Langsung': 'Chat with Seller Directly',
    'Terhubung kembali langsung dengan Penjual.':
        'Reconnected directly with the Seller.',
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

    // ── Tambahan Lengkap Seluruh Modul Aplikasi (Orders, Payment, Auth, Workshop, Settings, Legal, FAQ, Chat) ──
    '(estimasi 7–14 hari). Cocok untuk pemula, keluarga & komunitas.':
        '(estimated 7–14 days). Suitable for beginners, families & communities.',
    'Sesi 2 jam: pengenalan tanah liat, teknik dasar throwing/handbuilding, glazing intro, dan hasil karya bisa dibawa pulang setelah pembakaran (estimasi 7–14 hari). Cocok untuk pemula, keluarga & komunitas.':
        '2-hour session: clay introduction, basic throwing/handbuilding techniques, glazing intro, and pieces can be taken home after firing (estimated 7–14 days). Suitable for beginners, families & communities.',
    'Jadwal Operasional Workshop': 'Workshop Operating Hours',
    'Kampung Wisata Keramik Dinoyo': 'Dinoyo Ceramic Tourism Village',
    'Contact Person & Lokasi': 'Contact Person & Location',
    'Buka di Google Maps': 'Open in Google Maps',

    // Kategori Produk Backend & Umum
    'Keramik': 'Ceramics',
    'Keramik Dekoratif': 'Decorative Ceramics',
    'Peralatan Makan': 'Tableware',
    'Pot Tanaman': 'Plant Pots',
    'Vas': 'Vases',
    'Cangkir': 'Cups',
    'Piring': 'Plates',
    'Mangkuk': 'Bowls',
    'Teko': 'Teapots',
    'Guci': 'Urns & Jars',
    'Suvenir': 'Souvenirs',
    'Hiasan': 'Ornaments',
    'Patung': 'Figurines',
    'Kategori': 'Category',
    'Standar': 'Standard',
    'Varian Standar': 'Standard Variant',
    'Pelanggan': 'Customer',
    'Toko Keramik': 'Ceramic Store',
    'Produk Pesanan': 'Ordered Item',
    'Stok Habis': 'Out of Stock',
    'Stok produk habis': 'Product out of stock',
    'Stok Pengrajin: ': 'Artisan Stock: ',
    'Belum ada deskripsi produk dari pengrajin.':
        'No product description from the artisan yet.',
    'Belum ada ulasan pembeli untuk produk ini.':
        'No customer reviews for this product yet.',

    // Pesanan, Pelacakan & Riwayat Transaksi (Profile & Tracking Sheet)
    'Dibayar': 'Paid',
    'Dibatalkan': 'Canceled',
    'Pesanan Dibatalkan': 'Order Canceled',
    'Pesanan Diterima': 'Order Received',
    'Pesanan Diterima & Selesai': 'Order Received & Completed',
    'Pesanan Dibuat': 'Order Placed',
    'Pembayaran Diterima': 'Payment Received',
    'Pembayaran Berhasil': 'Payment Successful',
    'Pesanan Sedang Dikirim': 'Order Shipped',
    'Sedang Dikemas Penjual': 'Being Packed by Seller',
    'Dibayar • Menunggu Dikemas': 'Paid • Waiting to Pack',
    'Dibayar • Perlu Dikemas': 'Paid • Ready to Pack',
    'Pesanan Aktif': 'Active Order',
    'Konfirmasi Pembayaran': 'Payment Confirmation',
    'Produk Dikemas': 'Items Packed',
    'Pesanan Dikirim': 'Order Shipped',
    'Detail Pesanan': 'Order Details',
    'Lacak Pesanan': 'Track Order',
    'Hubungi Penjual': 'Contact Seller',
    'Hubungi Penjual Terkait Pesanan Ini':
        'Contact Seller About This Order',
    'Penjual sedang menyiapkan pesanan Anda.':
        'The seller is preparing your order.',
    'Paket sedang dalam perjalanan menuju alamat Anda.':
        'Your package is on the way to your address.',
    'Pesanan telah diterima. Terima kasih telah berbelanja!':
        'Order has been received. Thank you for shopping!',
    'Selesaikan pembayaran agar pesanan\nsegera diproses penjual.':
        'Complete payment so the seller\ncan process your order right away.',
    'Pesanan berhasil dibatalkan.': 'Order canceled successfully.',
    'Pesanan ini telah dibatalkan dan tidak diproses.':
        'This order has been canceled and was not processed.',
    'Belum ada pesanan di sini': 'No orders here yet',
    'Yuk jelajahi keramik buatan pengrajin Dinoyo!':
        'Let\'s explore handcrafted ceramics by Dinoyo artisans!',
    'Total Tagihan:': 'Total Bill:',
    'Total': 'Total',
    'Subtotal': 'Subtotal',
    'Checkout': 'Checkout',
    'Konfirmasi Pesanan Diterima?': 'Confirm Order Received?',
    'Pastikan produk sudah diterima dengan baik. Setelah dikonfirmasi, pesanan selesai dan dana masuk ke saldo aktif penjual.':
        'Make sure your items have arrived in good condition. Once confirmed, the order is completed and funds are released to the seller.',
    'Belum': 'Not Yet',
    'Ya, Pesanan Diterima': 'Yes, Order Received',
    'Cek posisi paket di situs kurir:':
        'Track package on courier website:',
    'CekResi (auto)': 'CekResi (auto)',
    'Live': 'Live',
    'Resi:': 'Tracking No:',
    'Nomor resi disalin': 'Tracking number copied',
    'Resi tersalin — tempel di situs kurir bila kolomnya masih kosong':
        'Tracking number copied — paste it on the courier page if blank',
    'Ringkasan Paket': 'Package Summary',
    'Tidak dapat membuka browser': 'Unable to open browser',

    // Catatan Timeline Backend
    'Pesanan dibuat oleh pembeli': 'Order placed by buyer',
    'Pembayaran berhasil dikonfirmasi': 'Payment confirmed',
    'Pesanan sedang dikemas oleh pengrajin':
        'Order is being packed by the artisan',
    'Pesanan diserahkan ke kurir ekspedisi':
        'Order handed over to shipping courier',
    'Pesanan diterima oleh pembeli': 'Order received by buyer',

    // Checkout & Pembayaran Midtrans
    'Pembayaran': 'Payment',
    'Pembayaran Berhasil!': 'Payment Successful!',
    'PILIHAN METODE PEMBAYARAN': 'PAYMENT METHOD OPTIONS',
    'PILIH BANK VIRTUAL ACCOUNT': 'SELECT VIRTUAL ACCOUNT BANK',
    'PILIH DOMPET DIGITAL (E-WALLET)': 'SELECT E-WALLET',
    'Selesaikan pembayaran dalam': 'Complete payment within',
    'Waktu Pembayaran Habis': 'Payment Time Expired',
    'Batas waktu pembayaran sudah kedaluwarsa.':
        'Payment time limit has expired.',
    'Tagihan telah kedaluwarsa dan stok produk telah dikembalikan.':
        'The invoice has expired and product stock has been restored.',
    'Keluar dari Pembayaran?': 'Leave Payment?',
    'Anda bisa menyimpan pesanan untuk dibayar nanti sebelum batas waktu berakhir, atau membatalkan pesanan sekarang.':
        'You can save this order to pay later before the deadline, or cancel the order now.',
    'Bayar Nanti': 'Pay Later',
    'Bayar Nanti / Batalkan': 'Pay Later / Cancel',
    'Lanjut Bayar': 'Continue Payment',
    'Belanja Lagi': 'Shop Again',
    'Lihat Status Pesanan': 'View Order Status',
    'Status Pesanan': 'Order Status',
    'No. Pesanan': 'Order No.',
    'Total Dibayar': 'Total Paid',
    'Instan': 'Instant',
    'Verifikasi Otomatis': 'Auto Verification',
    'Cek Status Pembayaran': 'Check Payment Status',
    'Memeriksa Pembayaran...': 'Checking Payment...',
    'Menghubungkan ke Midtrans Sandbox': 'Connecting to Midtrans Sandbox',
    'Bayar QRIS (Sandbox)': 'Pay QRIS (Sandbox)',
    'Buka Aplikasi': 'Open App',
    'Cara Bayar Lewat Aplikasi': 'How to Pay via App',
    'Salin': 'Copy',
    'Salin / Panduan QR': 'Copy / QR Guide',
    'Kode QR belum tersedia': 'QR code not available yet',
    'Kode Perusahaan (Biller Code)': 'Company Code (Biller Code)',
    'Kode Pembayaran (Bill Key)': 'Payment Code (Bill Key)',
    'Bill Key Mandiri berhasil disalin!': 'Mandiri Bill Key copied!',
    'Kode Perusahaan Mandiri disalin!': 'Mandiri Biller Code copied!',
    'Nominal total pembayaran disalin!': 'Total payment amount copied!',
    'Nomor pesanan disalin!': 'Order number copied!',
    'Payload QRIS disalin! Anda juga bisa screenshot QR di atas.':
        'QRIS payload copied! You can also screenshot the QR code above.',
    'Silakan screenshot gambar QR di atas untuk diunggah dari galeri.':
        'Please screenshot the QR image above to upload from your gallery.',
    'Pindai QR menggunakan aplikasi m-Banking atau e-Wallet apapun (BCA, Mandiri, BRI, GoPay, OVO, ShopeePay, DANA)':
        'Scan QR using any m-Banking or e-Wallet app (BCA, Mandiri, BRI, GoPay, OVO, ShopeePay, DANA)',
    'Screenshot QRIS di atas lalu pindai atau unggah gambar QR lewat menu Scan di aplikasi berikut:':
        'Screenshot the QRIS code above, then scan or upload it via the Scan menu in these apps:',
    'Untuk pembayaran via OVO atau DANA, silakan gunakan tab QRIS Instant di atas.':
        'For payment via OVO or DANA, please use the QRIS Instant tab above.',
    'Mode Sandbox: tekan tombol di atas untuk langsung diarahkan ke pembayaran Midtrans tanpa salin nomor VA secara manual.':
        'Sandbox Mode: tap the button above to proceed directly to Midtrans payment without copying the VA number manually.',
    'Mode pratinjau tanpa pesanan nyata. Buat pesanan dari Keranjang untuk menguji Midtrans Sandbox.':
        'Preview mode without a live order. Create an order from Cart to test Midtrans Sandbox.',
    'Pembayaran belum terkonfirmasi. Selesaikan transaksi di kanal pembayaran lalu cek kembali.':
        'Payment is not confirmed yet. Complete the transaction in your payment app and check again.',
    'Pembayaran telah dibatalkan atau gagal.':
        'Payment was canceled or failed.',
    'Gagal memuat data pembayaran.': 'Failed to load payment details.',
    'Terima kasih! Pesanan Anda telah diverifikasi otomatis dan diteruskan ke pengrajin untuk segera dikemas.':
        'Thank you! Your order has been automatically verified and forwarded to the artisan for packing.',
    'Transaksi dibatalkan. Anda dapat membuat pesanan baru kapan saja.':
        'Transaction canceled. You can place a new order anytime.',
    'Pembayaran Nasional': 'National Standard Payment',
    'Sentra Kerajinan Keramik Dinoyo Malang':
        'Dinoyo Ceramic Craft Center Malang',
    'Belum ada alamat pengiriman tersimpan': 'No saved delivery address yet',
    'Tambah Alamat Pengiriman': 'Add Delivery Address',
    'Tambahkan alamat pengiriman terlebih dahulu.':
        'Please add a delivery address first.',
    'Tambahkan alamat penerima agar pengrajin dapat mengirimkan pesanan keramik Anda.':
        'Add a recipient address so the artisan can ship your ceramic order.',
    'Alamat baru berhasil disimpan': 'New address saved successfully',
    'Alamat wajib diisi': 'Address is required',
    'Nomor telepon wajib diisi': 'Phone number is required',
    'Nomor telepon tidak valid': 'Invalid phone number',
    'Nama penerima tidak boleh kosong.': 'Recipient name cannot be empty.',
    'Nomor telepon minimal 9 digit.':
        'Phone number must be at least 9 digits.',
    'Alamat lengkap minimal 5 karakter.':
        'Full address must be at least 5 characters.',
    'Maksimal 5 alamat tersimpan. Hapus atau ubah alamat yang ada.':
        'Maximum 5 addresses saved. Delete or edit an existing address.',
    'Contoh: Tolong bungkus dengan bubble wrap tebal dan kardus aman.':
        'Example: Please wrap with extra bubble wrap and sturdy box.',
    'Tidak ada produk': 'No items',
    'Pilih produk untuk melanjutkan checkout.':
        'Select items to proceed to checkout.',
    'Tambahkan produk dari halaman Keranjang.':
        'Add items from the Cart page.',

    // Share Sheet, Gallery Picker & Connection Gate
    'Bagikan': 'Share',
    'Bagikan melalui': 'Share via',
    'Bagikan langsung ke WhatsApp, Instagram, atau aplikasi lain':
        'Share directly to WhatsApp, Instagram, or other apps',
    'Salin Link': 'Copy Link',
    'Salin tautan ke papan klip perangkat': 'Copy link to device clipboard',
    'Tautan berhasil disalin ke clipboard': 'Link copied to clipboard',
    'Izin Akses Galeri Diperlukan': 'Gallery Permission Required',
    'Berikan izin akses agar aplikasi dapat memuat foto langsung dari galeri HP Anda.':
        'Grant gallery permission so the app can load photos directly from your device.',
    'Buka Pengaturan Izin': 'Open Permission Settings',
    'Pilih Folder Galeri': 'Select Gallery Album',
    'Galeri Sistem': 'System Gallery',
    'Tidak ada foto ditemukan di galeri ini.':
        'No photos found in this album.',
    'Gagal memuat file foto asli dari galeri.':
        'Failed to load original photo file from gallery.',
    'Coba Lagi': 'Try Again',
    'Muat Ulang': 'Reload',
    'Tidak Ada Koneksi Internet': 'No Internet Connection',
    'Tidak ada koneksi internet': 'No internet connection',
    'Koneksi tersambung kembali': 'Back online',
    'Koneksi internetmu terputus. Periksa Wi-Fi atau kuota datamu, lalu coba lagi.':
        'Your internet connection is offline. Check your Wi-Fi or mobile data and try again.',
    'Pastikan Wi-Fi atau data seluler aktif':
        'Make sure Wi-Fi or mobile data is turned on',
    'Coba pindah ke area dengan sinyal lebih kuat':
        'Try moving to an area with a stronger signal',
    'Aktifkan mode pesawat lalu matikan kembali':
        'Turn Airplane Mode on and off again',
    'Halaman akan terbuka otomatis saat koneksi kembali.':
        'This page will reopen automatically once back online.',
    'Server Tidak Dapat Dihubungi': 'Server Unreachable',
    'Internetmu normal, tetapi server DinoyoCraft sedang tidak dapat dijangkau. Kemungkinan sedang dalam pemeliharaan.':
        'Your internet is working, but the DinoyoCraft server is currently unreachable or under maintenance.',
    'Tunggu beberapa saat lalu coba lagi':
        'Wait a moment and try again',
    'Pastikan server backend sedang berjalan':
        'Make sure the backend server is running',
    'Data pesananmu tetap aman dan tersinkron otomatis':
        'Your order data stays safe and syncs automatically',
    'Kami memeriksa koneksi ke server secara berkala...':
        'Checking connection to the server periodically...',

    // Auth, OTP, Forgot Password & New Password
    'KARYA OTENTIK SENTRA KERAMIK DINOYO':
        'AUTHENTIC CRAFTS OF DINOYO CERAMIC CENTER',
    'Lupa Password?': 'Forgot Password?',
    'Masukkan alamat email yang terdaftar pada akun DinoyoCraft Anda untuk menerima kode verifikasi OTP.':
        'Enter the email address registered to your DinoyoCraft account to receive an OTP verification code.',
    'Pastikan email aktif untuk menerima 6 digit kode OTP.':
        'Make sure your email is active to receive the 6-digit OTP code.',
    'Kirim Kode Verifikasi': 'Send Verification Code',
    'Masuk Sekarang': 'Log In Now',
    'Gagal mengirim kode OTP': 'Failed to send OTP code',
    'Kode OTP telah dikirim ke email kamu':
        'OTP code has been sent to your email',
    'Kode OTP baru telah dikirim ke email kamu':
        'A new OTP code has been sent to your email',
    'Kode OTP baru telah dikirim ke email terdaftar Anda':
        'A new OTP code has been sent to your registered email',
    'Kode OTP login baru telah dikirim ke email Anda':
        'A new login OTP code has been sent to your email',
    'Kode OTP verifikasi masuk telah dikirim ke email Anda.':
        'Login verification OTP code has been sent to your email.',
    'Kode OTP salah': 'Invalid OTP code',
    'Kode OTP salah.': 'Invalid OTP code.',
    'Kode OTP terverifikasi. Silakan buat kata sandi baru.':
        'OTP verified. Please create a new password.',
    'Lengkapi 6 digit kode verifikasi':
        'Please complete the 6-digit verification code',
    'Aktivasi 2FA': 'Enable 2FA',
    'Nonaktifkan 2FA': 'Disable 2FA',
    'Nonaktifkan 2FA?': 'Disable 2FA?',
    'Kirim OTP & Nonaktifkan': 'Send OTP & Disable',
    'Verifikasi Keamanan': 'Security Verification',
    'Verifikasi Lupa Password': 'Password Reset Verification',
    'Verifikasi Akun': 'Account Verification',
    'Masukkan kode verifikasi 6 digit yang telah kami kirimkan ke email untuk mengaktifkan 2FA:':
        'Enter the 6-digit verification code sent to your email to enable 2FA:',
    'Masukkan kode verifikasi 6 digit yang telah kami kirimkan ke email untuk konfirmasi nonaktifkan 2FA:':
        'Enter the 6-digit verification code sent to your email to disable 2FA:',
    'Masukkan kode verifikasi 6 digit yang telah kami\nkirimkan ke email':
        'Enter the 6-digit verification code we\nsent to',
    'email terdaftar Anda': 'your registered email',
    'Belum menerima kode?': 'Didn\'t receive the code?',
    'Kirim ulang kode dalam': 'Resend code in',
    'Kirim ulang kode': 'Resend code',
    'Konfirmasi': 'Confirm',
    'Verifikasi & Aktifkan': 'Verify & Enable',
    'Konfirmasi Nonaktifkan': 'Confirm Disable',
    'Batalkan Verifikasi': 'Cancel Verification',
    'Salah memasukkan email?': 'Entered the wrong email?',
    'Ubah email': 'Change email',
    'Ubah data pendaftaran': 'Edit registration info',
    'Autentikasi 2 Langkah via Email berhasil diaktifkan.':
        'Email Two-Factor Authentication enabled successfully.',
    'Autentikasi 2 Langkah (2FA) berhasil dinonaktifkan.':
        'Two-Factor Authentication (2FA) disabled successfully.',
    'Verifikasi berhasil! Selamat datang kembali.':
        'Verification successful! Welcome back.',
    'Pendaftaran berhasil!': 'Registration successful!',
    'Pendaftaran berhasil! Selamat datang di DinoyoCraft.':
        'Registration successful! Welcome to DinoyoCraft.',
    'Pendaftaran gagal': 'Registration failed',
    'Login dengan Google berhasil!': 'Signed in with Google!',
    'Login gagal': 'Sign-in failed',
    'Login gagal: token tidak diterima dari server':
        'Sign-in failed: no token received from server',
    'Akun Google belum terdaftar. Mengalihkan ke pendaftaran...':
        'Google account not registered yet. Redirecting to sign up...',
    'Minimal 3 karakter': 'At least 3 characters',
    'Username minimal 3 karakter': 'Username must be at least 3 characters',
    'Hanya boleh huruf, angka, dan underscore (_)':
        'Only letters, numbers, and underscores (_) allowed',
    'Username hanya boleh huruf, angka, dan underscore (_)':
        'Username may only contain letters, numbers, and underscores (_)',
    'huruf kecil, angka, underscore': 'lowercase, numbers, underscore',
    '✓ Username tersedia': '✓ Username available',
    'Username sudah digunakan': 'Username is already taken',
    'Username tidak tersedia atau format tidak valid.':
        'Username is unavailable or invalid format.',
    'Mengecek...': 'Checking...',
    'Tidak Tersedia': 'Unavailable',
    'Buat Kata Sandi Baru': 'Create New Password',
    'Masukkan kata sandi saat ini terlebih dahulu, lalu buat kata sandi baru yang kuat untuk akun Anda.':
        'Enter your current password first, then create a strong new password for your account.',
    'Buat kata sandi baru yang kuat dan mudah diingat untuk mengamankan akun DinoyoCraft Anda.':
        'Create a strong, memorable new password to secure your DinoyoCraft account.',
    'Masukkan kata sandi saat ini': 'Enter current password',
    'Kata sandi saat ini wajib diisi': 'Current password is required',
    'Masukkan kata sandi baru': 'Enter new password',
    'Kata sandi wajib diisi': 'Password is required',
    'Ulangi kata sandi baru': 'Repeat new password',
    'Konfirmasi kata sandi wajib diisi': 'Password confirmation is required',
    'KRITERIA KATA SANDI:': 'PASSWORD CRITERIA:',
    'Terpenuhi': 'Met',
    'Belum Terpenuhi': 'Not Met Yet',
    'Mengandung huruf besar dan angka':
        'Contains an uppercase letter and a number',
    'Cocok dengan konfirmasi kata sandi': 'Matches password confirmation',
    'Harap penuhi kriteria kata sandi': 'Please meet all password criteria',
    'Simpan Kata Sandi Baru': 'Save New Password',
    'Kata sandi berhasil diperbarui!': 'Password updated successfully!',
    'Kata sandi berhasil diubah. Silakan masuk kembali.':
        'Password changed successfully. Please log in again.',
    'Butuh bantuan lebih lanjut?': 'Need further assistance?',
    'Hubungi kami': 'Contact us',

    // Profile, Data Diri, Pengaturan & Hapus Akun
    'Kelola informasi akun dan profil pelanggan Anda':
        'Manage your account and customer profile information',
    'Foto profil dipilih. Tekan Simpan Perubahan untuk mengunggah ke akun.':
        'Profile photo selected. Tap Save Changes to upload to your account.',
    'Akun Google • Ketuk untuk buat kata sandi':
        'Google Account • Tap to create password',
    'Perbarui kata sandi keamanan akun Anda':
        'Update your account security password',
    'Terakhir diubah hari ini': 'Last changed today',
    'Terakhir diubah kemarin': 'Last changed yesterday',
    'International English localization':
        'International English localization',
    'Tampilan terang bersih khas keramik Dinoyo':
        'Clean light appearance inspired by Dinoyo ceramics',
    'Nuansa gelap nyaman untuk penggunaan malam hari':
        'Comfortable dark appearance for nighttime use',
    'Menyesuaikan mode tampilan sistem perangkat Anda':
        'Matches your device system display mode',
    'Kelola perangkat yang aktif mengakses akun Anda':
        'Manage devices currently signed in to your account',
    'PERANGKAT SAAT INI': 'CURRENT DEVICE',
    'Aktif Saat Ini': 'Active Now',
    'PERANGKAT LAIN YANG TERHUBUNG': 'OTHER CONNECTED DEVICES',
    'Perangkat ini terdaftar sebagai sesi utama Anda. Anda dapat mencabut token sesi di perangkat lain kapan saja.':
        'This device is registered as your primary session. You can revoke other device sessions anytime.',
    'Hapus Sesi Perangkat?': 'Remove Device Session?',
    'Hapus & Logout': 'Remove & Log Out',
    'Keluar': 'Log Out',
    'Keluar Semua': 'Log Out All',
    'Keluar dari Semua Perangkat Lain?': 'Log Out of All Other Devices?',
    'Semua sesi perangkat lain yang terhubung akan dicabut dan seluruh perangkat tersebut otomatis ter-logout.':
        'All connected sessions on other devices will be revoked and logged out automatically.',
    'Berhasil keluar dari semua perangkat lain. Semua perangkat tersebut otomatis logout.':
        'Successfully logged out of all other devices.',
    'Seluruh sesi di perangkat lain berhasil dikeluarkan.':
        'All sessions on other devices have been logged out.',
    'Bersihkan Cache?': 'Clear Cache?',
    'Cache aplikasi sudah bersih (0 B).': 'App cache is already clean (0 B).',
    'Keluar dari Akun?': 'Log Out of Account?',
    'Anda harus login kembali untuk mengakses keranjang dan riwayat transaksi kerajinan keramik Anda.':
        'You will need to sign in again to access your cart and ceramic order history.',
    'Anda telah berhasil keluar dari akun.':
        'You have logged out successfully.',
    'Notifikasi pesanan & pengiriman diaktifkan.':
        'Order & shipping notifications enabled.',
    'Notifikasi pesanan & pengiriman dinonaktifkan.':
        'Order & shipping notifications disabled.',
    'Notifikasi via WhatsApp diaktifkan.':
        'WhatsApp notifications enabled.',
    'Notifikasi via WhatsApp dinonaktifkan.':
        'WhatsApp notifications disabled.',
    'Ajukan Penghapusan Akun': 'Request Account Deletion',
    'Ajukan Hapus Akun?': 'Request Account Deletion?',
    'Kirim Pengajuan': 'Submit Request',
    'Mengirim Pengajuan...': 'Submitting Request...',
    'Memproses...': 'Processing...',
    'Menunggu Peninjauan Admin': 'Awaiting Admin Review',
    'Tim Admin DinoyoCraft sedang meninjau permohonan penghapusan akun Anda. Selama belum diproses, Anda masih dapat membatalkan pengajuan ini.':
        'The DinoyoCraft Admin team is reviewing your account deletion request. While pending, you can still cancel this request.',
    'Alasan yang diajukan:': 'Submitted reason:',
    'Batalkan Pengajuan Hapus Akun': 'Cancel Account Deletion Request',
    'Pengajuan penghapusan akun berhasil dikirim ke Admin.':
        'Account deletion request submitted to Admin.',
    'Pengajuan penghapusan akun berhasil dibatalkan.':
        'Account deletion request canceled.',
    'Permohonan penghapusan akun Anda akan dikirim ke tim Admin DinoyoCraft untuk ditinjau. Jika disetujui, akun akan dinonaktifkan secara permanen.':
        'Your account deletion request will be sent to the DinoyoCraft Admin team for review. Once approved, your account will be permanently deactivated.',
    'Pilih alasan penghapusan akun': 'Please select a reason for deletion',
    'Tuliskan alasan lainnya...': 'Write your reason...',
    'Ketik Email Akun untuk Konfirmasi': 'Type Account Email to Confirm',
    'Ketik alamat email akun Google Anda':
        'Type your Google account email address',
    'permanen setelah disetujui Admin': 'permanent once approved by Admin',
    '. Seluruh akses akun, data profil, serta riwayat belanja DinoyoCraft kamu akan dinonaktifkan.':
        '. All account access, profile data, and DinoyoCraft shopping history will be deactivated.',
    'Penghapusan Akun Disetujui': 'Account Deletion Approved',
    'Pengajuan penghapusan akun DinoyoCraft Anda telah disetujui oleh Admin.':
        'Your DinoyoCraft account deletion request has been approved by Admin.',

    // Reviews, Notifications, Chat & ClayBot
    'Baru saja': 'Just now',
    'Kemarin': 'Yesterday',
    'Ulasan Produk': 'Product Reviews',
    'ulasan': 'reviews',
    'pembeli merekomendasikan produk studio ini':
        'of buyers recommend this studio\'s products',
    'Jadilah pembeli pertama yang memberikan ulasan':
        'Be the first buyer to leave a review',
    'Belum ada ulasan untuk ditampilkan': 'No reviews to display yet',
    'Pembeli memberikan penilaian bintang tanpa komentar tertulis.':
        'Buyer left a star rating without a written comment.',
    'Ulasan berhasil dikirim. Terima kasih!':
        'Review submitted successfully. Thank you!',
    'Mengirim Ulasan...': 'Submitting Review...',
    'Mengirim...': 'Submitting...',
    'Gagal mengirim ulasan. Periksa koneksi Anda.':
        'Failed to submit review. Check your connection.',
    'Gagal mengirim laporan. Periksa koneksi Anda.':
        'Failed to submit report. Check your connection.',
    'ID produk tidak ditemukan pada pesanan ini.':
        'Product ID was not found on this order.',
    'Pilih hal yang paling kamu sukai:': 'Pick what you liked the most:',
    'Pesan Toko': 'Store Messages',
    'Promo & Voucher': 'Promos & Vouchers',
    'INFO KEAMANAN': 'SECURITY INFO',
    'PEMBERITAHUAN': 'NOTIFICATION',
    'PESAN TOKO': 'STORE MESSAGE',
    'PESANAN & PENGIRIMAN': 'ORDER & SHIPPING',
    'PROMO SPESIAL': 'SPECIAL PROMO',
    'Notifikasi transaksi dan info akun akan muncul di sini.':
        'Transaction notifications and account updates will appear here.',
    'Belum ada percakapan dengan toko.': 'No conversations with stores yet.',
    'Customer Service Resmi': 'Official Customer Service',
    'Pengrajin Dinoyo': 'Dinoyo Artisan',
    'Pengrajin DinoyoCraft': 'DinoyoCraft Artisan',
    'Online • Siap melayani': 'Online • Ready to help',
    'Offline': 'Offline',
    'Hapus Preview Pesanan': 'Remove Order Preview',
    'Percakapan berhasil dihapus.': 'Conversation cleared.',
    'Mascot Tembikar DinoyoCraft': 'DinoyoCraft Pottery Mascot',
    'Si Clay Keramik (8 Stiker)': 'Si Clay Ceramics (8 Stickers)',
    'Stiker Si Clay': 'Si Clay Sticker',
    'Stiker ChatBot': 'ChatBot Sticker',
    'Ketuk untuk kirim': 'Tap to send',
    'Terima Kasih': 'Thank You',
    'Ada Diskon?': 'Any Discount?',
    'Kirim Foto Produk': 'Send Product Photo',
    'Tulis pesan kamu...': 'Write your message...',
    'ClayBot sedang mengetik...': 'ClayBot is typing...',
    'ClayBot memiliki batasan tertentu, cerdaslah dalam bertanya...':
        'ClayBot may make mistakes, ask thoughtfully...',
    'Terima kasih Kak, foto produknya sudah kami terima! Tim Customer Service sedang memeriksanya.':
        'Thank you, we have received the product photo! Our Customer Service team is reviewing it.',
    'Untuk terhubung langsung dengan Customer Service DinoyoCraft secara realtime, silakan masuk ke akun kamu terlebih dahulu ya 😊':
        'To connect directly with DinoyoCraft Customer Service in real time, please log in to your account first 😊',
    'Maaf, layanan Live Chat CS sedang tidak terjangkau saat ini. Silakan hubungi csdinoyocraft@gmail.com atau coba sesaat lagi ya.':
        'Sorry, Live Chat CS is currently unreachable. Please contact csdinoyocraft@gmail.com or try again shortly.',
    'Layanan Live Chat CS sedang sibuk. Coba lagi sesaat.':
        'Live Chat CS is currently busy. Please try again shortly.',
    'Live Chat Customer Service': 'Live Chat Customer Service',
    'Menghubungkan CS...': 'Connecting to CS...',
    'Email: csdinoyocraft@gmail.com\nWhatsApp: +62 812-3456-7890\nJam operasional: 09.00–18.00 WIB':
        'Email: csdinoyocraft@gmail.com\nWhatsApp: +62 812-3456-7890\nOperating hours: 09:00–18:00 WIB',
    'Halo Kak! Saya Asisten Bot Customer Service DinoyoCraft. Sebelum terhubung ke tim CS, ada yang bisa saya bantu seputar pesanan, pembayaran, akun, atau pengiriman? 😊':
        'Hello! I am the DinoyoCraft Customer Service Bot Assistant. Before connecting to our CS team, how can I help with your order, payment, account, or shipping? 😊',
    'Halo Kak! Saya Asisten Bot Customer Service DinoyoCraft. Saya siap membantu pertanyaan seputar produk keramik, pesanan (#DNC/ORD), pembayaran Midtrans, pemulihan akun (csdinoyocraft@gmail.com), dan workshop. Jika butuh tim CS langsung, klik tombol di bawah ya!':
        'Hello! I am the DinoyoCraft Customer Service Bot Assistant. I can help with ceramic products, orders (#DNC/ORD), Midtrans payments, account recovery (csdinoyocraft@gmail.com), and workshops. Tap below if you need our live CS team!',
    'Halo Kak! Saya tim Customer Service DinoyoCraft. Ada kendala atau pertanyaan yang bisa saya bantu secara langsung? 😊':
        'Hello! I am from the DinoyoCraft Customer Service team. How can I assist you directly today? 😊',
    'Halo Kak! Pesanmu sudah kami terima. Penjual saat ini sedang di workshop keramik. Saya sebagai Asisten Bot Toko siap membantu menjawab pertanyaan seputar keramik. Jika butuh respons langsung dari pemilik toko, silakan tekan tombol di bawah ya! 🙏':
        'Hello! We received your message. The seller is currently at the ceramic workshop. As the Store Bot Assistant, I can help answer ceramic questions, or tap the button below for a direct reply from the store owner! 🙏',
    'Baik Kak, pertanyaan Kakak sudah saya catat langsung. Kualitas tembikar dan keramik Dinoyo kami utamakan selalu. Jika ingin memesan, silakan langsung checkout atau kabari saya jika butuh varian custom ya! 🙌':
        'Got it! I have noted your question. We always prioritize authentic Dinoyo ceramic quality. Feel free to checkout directly or let me know if you need a custom variant! 🙌',
    'Foto lampiran berhasil kami terima kak! Silakan jelaskan kendala atau kebutuhanmu, atau klik Chat dengan Customer Service di bawah untuk bantuan langsung dari tim CS. 📸':
        'Attachment photo received! Please describe your issue or request, or tap Chat with Customer Service below for direct help from our CS team. 📸',
    'Foto referensi berhasil kami terima kak! Ada model keramik serupa yang ingin ditanyakan ketersediaannya? Asisten bot siap membantu, atau hubungi penjual langsung jika butuh custom keramik! 📸🏺':
        'Reference photo received! Would you like to check availability for a similar ceramic design? Our bot assistant can help, or contact the seller directly for custom ceramics! 📸🏺',
    'Harga di etalase kami merupakan harga pengrajin lokal tangan pertama. Untuk pemesanan grosir atau souvenir acara dalam jumlah banyak, Kakak bisa nego langsung dengan penjual lewat tombol di bawah! 🏷️':
        'Our catalog prices are direct first-hand artisan prices. For wholesale or bulk event souvenir orders, you can negotiate directly with the seller via the button below! 🏷️',
    'Untuk pengiriman luar kota, toko kami menggunakan proteksi ekstra: bubble wrap tebal berlapis dan rangka kayu pelindung. Kami juga memberikan garansi ganti baru jika produk retak di perjalanan! 📦🛡️':
        'For intercity shipping, our store uses extra protection: multi-layer thick bubble wrap and wooden crate framing, backed by a full replacement warranty if damaged in transit! 📦🛡️',
    'Terima kasih stikernya kak! Ada yang bisa kami bantu mengenai pesanan atau koleksi keramik DinoyoCraft hari ini? 🎨✨':
        'Thanks for the sticker! How can we help with your order or DinoyoCraft ceramic collection today? 🎨✨',

    // FAQ (Help Screen)
    'Bagaimana cara memesan produk?': 'How do I order a product?',
    'Pilih produk dari Beranda atau tab Produk, tap tombol +, lalu lanjutkan ke Checkout untuk menyelesaikan pembayaran.':
        'Choose a product from Home or the Products tab, tap +, then proceed to Checkout to complete your payment.',
    'Apakah bisa pickup di toko?': 'Can I pick up my order at the store?',
    'Ya. Pilih opsi ambil di toko pada checkout jika tersedia, atau hubungi studio terkait melalui ClayBot.':
        'Yes. Choose the store pickup option at checkout if available, or contact the studio via ClayBot or Store Chat.',
    'Berapa lama pengiriman ke luar kota?':
        'How long does intercity shipping take?',
    'Estimasi 2–5 hari kerja tergantung kurir (Regular/Hemat/Express) dan destinasi pengiriman.':
        'Estimated 2–5 business days depending on the courier service (Regular/Economy/Express) and destination.',
    'Apakah produk bisa dikustom?': 'Can ceramic products be customized?',
    'Beberapa studio menerima custom order. Hubungi ClayBot atau WhatsApp studio untuk konfirmasi desain dan estimasi harga.':
        'Several studios accept custom orders. Chat with the store or ClayBot to confirm your design and price estimate.',
    'Bagaimana cara reservasi workshop?': 'How do I book a pottery workshop?',
    'Buka tab Workshop, baca detail pengalaman, lalu tap Reservasi via WhatsApp untuk menjadwalkan sesi.':
        'Open the Workshop tab, review the session details, and tap Reserve via WhatsApp to schedule your visit.',
    'Metode pembayaran apa saja yang tersedia?':
        'What payment methods are supported?',
    'DinoyoCraft mendukung pembayaran via Midtrans Sandbox: QRIS, Virtual Account (BCA, Mandiri, BRI, BNI, Permata), serta E-Wallet (GoPay & ShopeePay).':
        'DinoyoCraft supports payments via Midtrans: QRIS, Virtual Accounts (BCA, Mandiri, BRI, BNI, Permata), and E-Wallets (GoPay & ShopeePay).',

    // Legal Sheets (Kebijakan Privasi, Syarat & Ketentuan, Garansi)
    'Terakhir diperbarui: 1 Oktober 2026': 'Last updated: October 1, 2026',
    'Komitmen Perlindungan Privasi': 'Privacy Protection Commitment',
    'DinoyoCraft berkomitmen menjaga dan menghormati privasi seluruh pengguna, pembeli, serta mitra perajin keramik di kawasan Dinoyo Malang. Data Anda dikelola secara aman sesuai peraturan perlindungan data yang berlaku di Indonesia.':
        'DinoyoCraft is committed to protecting and respecting the privacy of all users, buyers, and ceramic artisan partners in Dinoyo, Malang. Your data is securely managed in accordance with applicable Indonesian data protection regulations.',
    'Data yang Dikumpulkan': 'Data We Collect',
    'Kami mengumpulkan informasi yang Anda berikan secara sukarela, seperti nama lengkap, nomor WhatsApp, alamat tujuan pengiriman pesanan tembikar, serta riwayat interaksi dan transaksi pesanan.':
        'We collect information you voluntarily provide, such as full name, WhatsApp number, pottery shipping addresses, and order interaction and transaction history.',
    'Penggunaan Informasi': 'Use of Information',
    'Data Anda digunakan secara eksklusif untuk memproses pesanan kerajinan keramik, koordinasi kurir ekspedisi dengan packing aman, pembaruan nomor resi, serta layanan pelanggan.':
        'Your data is used exclusively to process ceramic orders, coordinate safe-packaged courier deliveries, update tracking numbers, and provide customer support.',
    'Keamanan Transaksi & Akun': 'Transaction & Account Security',
    'Semua kata sandi dienkripsi dengan standar hash industri. Kami tidak pernah membagikan atau menjual data pribadi Anda kepada pihak ketiga manapun untuk kepentingan komersial.':
        'All passwords are encrypted using industry-standard hashing. We never sell or share your personal data with third parties for commercial purposes.',
    'Hak Pengguna': 'User Rights',
    'Anda berhak memperbarui data diri, mengatur preferensi notifikasi, atau meminta penutupan dan penghapusan akun kapan saja melalui menu Kelola Pengaturan.':
        'You have the right to update personal information, configure notification preferences, or request account deletion anytime via Manage Settings.',
    'Ketentuan berbelanja & bertransaksi di DinoyoCraft':
        'Shopping & transaction terms on DinoyoCraft',
    'Ketentuan Akun': 'Account Terms',
    'Pengguna wajib memberikan informasi yang akurat saat membuat akun dan bertanggung jawab penuh menjaga kerahasiaan kata sandi serta aktivitas yang terjadi pada akun tersebut.':
        'Users must provide accurate information when creating an account and are fully responsible for maintaining password confidentiality and account activity.',
    'Pemesanan & Pembayaran': 'Ordering & Payment',
    'Seluruh harga tertera dalam mata uang Rupiah (IDR). Pesanan akan diproses oleh pengrajin Dinoyo setelah pembayaran terverifikasi secara resmi melalui metode transfer atau e-wallet yang tersedia.':
        'All prices are listed in Indonesian Rupiah (IDR). Orders are processed by Dinoyo artisans once payment is officially verified via available transfer, QRIS, or e-wallet methods.',
    'Karakteristik Produk Keramik Hand-made':
        'Handcrafted Ceramic Characteristics',
    'Produk keramik Dinoyo merupakan karya seni kerajinan tangan. Sedikit perbedaan dalam corak glasir, dimensi (toleransi 1-2 cm), atau tekstur adalah ciri khas keaslian tembikar lokal dan bukan cacat produksi.':
        'Dinoyo ceramics are handcrafted works of art. Slight variations in glaze pattern, dimensions (1–2 cm tolerance), or texture reflect authentic local pottery craftsmanship rather than manufacturing defects.',
    'Pengiriman & Pembatalan': 'Shipping & Cancellation',
    'Setiap produk dikemas menggunakan standar pengemasan barang pecah belah. Pembatalan pesanan hanya dapat disetujui jika toko perajin belum memulai proses produksi khusus atau pengemasan paket.':
        'Every item is packed using fragile-goods protection standards. Order cancellations can only be approved before the artisan begins custom production or package packing.',
    'Hak Kekayaan Intelektual': 'Intellectual Property Rights',
    'Seluruh foto katalog, logo, identitas merek, dan desain karya kerajinan keramik di platform ini dilindungi oleh hak kekayaan intelektual milik perajin sentra keramik Dinoyo.':
        'All catalog photos, logos, brand identities, and ceramic craft designs on this platform are protected intellectual property of Dinoyo ceramic artisans.',
    'Garansi Barang Pecah Belah': 'Fragile Goods Warranty',
    '100% Proteksi Pengiriman Keramik DinoyoCraft':
        '100% DinoyoCraft Ceramic Shipping Protection',
    'Pusat Bantuan & Klaim': 'Help & Warranty Claims Center',
    'Jaminan Proteksi 100% Tanpa Risiko': '100% Risk-Free Protection Guarantee',
    'Kami memahami kerentanan barang tembikar dan keramik. Setiap pesanan kerajinan di DinoyoCraft dilindungi garansi penggantian penuh jika terjadi kerusakan atau pecah selama proses pengantaran ekspedisi.':
        'We understand the delicate nature of pottery and ceramics. Every DinoyoCraft order is backed by a full replacement warranty in case of breakage during courier delivery.',
    'Syarat Wajib Video Unboxing': 'Mandatory Unboxing Video Requirement',
    'Untuk memvalidasi klaim asuransi ekspedisi, pembeli wajib merekam video unboxing secara utuh tanpa jeda (no pause/no edit) sejak paket masih tersegel rapi hingga isi barang diperiksa.':
        'To validate shipping insurance claims, buyers must record an uninterrupted, unedited unboxing video starting from the sealed package until the item is inspected.',
    'Batas Waktu Pengajuan Klaim': 'Claim Submission Window',
    'Permohonan klaim garansi harus diajukan maksimal 1 x 24 jam setelah status resi menunjukkan paket telah berhasil diterima oleh penerima.':
        'Warranty claims must be submitted within 24 hours after the tracking status shows the package was delivered.',
    'Pilihan Solusi Penggantian': 'Replacement & Refund Options',
    'Pembeli dapat memilih antara: (a) Pengiriman unit keramik baru secara gratis tanpa biaya ongkir tambahan, ATAU (b) Pengembalian dana penuh (100% refund) sesuai nominal pesanan.':
        'Buyers may choose between: (a) Free replacement unit shipped at no extra shipping cost, OR (b) A full 100% refund of the order amount.',
    'Autentikasi 2 Langkah (2FA) Aktif':
        'Two-Factor Authentication (2FA) Enabled',
    'Autentikasi 2 Langkah (2FA) Dinonaktifkan':
        'Two-Factor Authentication (2FA) Disabled',
    'Keamanan akun DinoyoCraft Anda kini dilindungi verifikasi OTP Email setiap kali masuk.':
        'Your DinoyoCraft account is now protected with Email OTP verification on every sign-in.',
    'Verifikasi 2 langkah (2FA) pada akun DinoyoCraft Anda telah dimatikan.':
        'Two-factor authentication (2FA) on your DinoyoCraft account has been turned off.',
    'Login Perangkat Baru Terdeteksi': 'New Device Sign-In Detected',
    'Login Akun Baru di Perangkat Ini': 'New Account Sign-In on This Device',
    'baru saja masuk pada perangkat ini.': 'just signed in on this device.',
    'Peringatan Keamanan Akun': 'Account Security Alert',
    'Terdapat pembaruan keamanan pada akun DinoyoCraft Anda.':
        'There is a security update on your DinoyoCraft account.',
    'Login terdeteksi': 'Sign-in detected',
    'Baru saja masuk': 'Just signed in',
    'Pembaruan Status Pesanan': 'Order Status Update',
    'Pesanan Anda': 'Your Order',
    'Email ini belum terdaftar sebagai akun Customer di aplikasi DinoyoCraft. Silakan daftar terlebih dahulu.':
        'This email is not registered as a Customer account on the DinoyoCraft app. Please sign up first.',
    'Akun Google ini belum terdaftar sebagai Customer di aplikasi DinoyoCraft. Silakan daftar terlebih dahulu.':
        'This Google account is not registered as a Customer on the DinoyoCraft app. Please sign up first.',
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
