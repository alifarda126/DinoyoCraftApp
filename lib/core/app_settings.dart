import 'package:flutter/material.dart';

import 'app_cache_manager.dart';
import 'theme/app_colors.dart';

/// Mode tema aplikasi.
enum AppThemeMode { system, light, dark }

/// Sesi perangkat lain yang terhubung ke akun.
class DeviceSession {
const   DeviceSession({
    required this.name,
    required this.location,
    required this.lastActive,
  });

  final String name;
  final String location;
  final String lastActive;
}

/// State aplikasi global — tema, bahasa, 2FA, perangkat, dan cache.
/// Singleton sederhana (demo tanpa backend); setiap perubahan memberi
/// notify agar MaterialApp & halaman pengaturan ikut membangun ulang.
class AppSettings extends ChangeNotifier {
  AppSettings._();

  static final AppSettings instance = AppSettings._();

  /// Default terang: tampilan utama memakai light mode; pengguna tetap
  /// bisa memilih gelap/ikuti sistem dari Kelola Pengaturan.
  AppThemeMode themeMode = AppThemeMode.light;

  /// 'id' | 'en'
  String locale = 'id';

  /// Autentikasi dua langkah (kode OTP via email saat login berikutnya).
  bool twoFactorEnabled = false;

  /// True setelah logout / keluar dari perangkat — login berikutnya
  /// (jika 2FA aktif) harus melewati verifikasi OTP.
  bool requireOtpNextLogin = false;

  /// Email terakhir yang didaftarkan atau dimasukkan saat autentikasi.
  String? lastAuthEmail;

  /// Simulasi ukuran cache (±26 MB); 0 setelah dibersihkan.
  int cacheBytes = 26214400;

  /// Perangkat lain yang sedang terhubung (selain perangkat ini).
  final List<DeviceSession> otherDevices = [
    DeviceSession(
      name: 'Chrome • Windows 11',
      location: 'Malang, Indonesia',
      lastActive: 'Aktif 2 jam lalu',
    ),
    DeviceSession(
      name: 'Safari • iPhone 14',
      location: 'Surabaya, Indonesia',
      lastActive: 'Terakhir aktif 3 hari lalu',
    ),
  ];

  bool get hasOtherDevices => otherDevices.isNotEmpty;

  String get cacheLabel => _formatBytes(cacheBytes);

  void setThemeMode(AppThemeMode mode) {
    themeMode = mode;
    // Selaraskan token warna saat interaksi dilakukan. Untuk mode sistem,
    // nilai final tetap disinkronkan oleh MaterialApp setelah tema dipilih.
    if (mode != AppThemeMode.system) {
      AppColors.isDark = mode == AppThemeMode.dark;
    }
    notifyListeners();
  }

  void setLocale(String code) {
    locale = code;
    notifyListeners();
  }

  void setTwoFactor(bool value) {
    twoFactorEnabled = value;
    notifyListeners();
  }

  /// Dipanggil aksi logout / keluar perangkat agar login berikutnya
  /// diminta kode OTP (bila 2FA aktif).
  void markLoggedOut() {
    requireOtpNextLogin = true;
  }

  /// Dipanggil setelah OTP login berhasil diverifikasi.
  void consumeOtpRequirement() {
    requireOtpNextLogin = false;
  }

  void removeOtherDevice(int index) {
    otherDevices.removeAt(index);
    notifyListeners();
  }

  void removeAllOtherDevices() {
    otherDevices.clear();
    notifyListeners();
  }

  /// Sinkronkan ukuran cache nyata langsung dari penyimpanan perangkat.
  Future<void> syncCacheSize() async {
    try {
      final real = await AppCacheManager.getRealCacheBytes();
      cacheBytes = real;
      notifyListeners();
    } catch (_) {
      // Pada lingkungan widget test atau tanpa platform channel
    }
  }

  /// Hapus seluruh file cache fisik langsung dari disk perangkat dan memory.
  Future<int> clearCache() async {
    int cleared = cacheBytes;
    try {
      final bytes = await AppCacheManager.clearRealCache();
      if (bytes > 0) cleared = bytes;
      cacheBytes = await AppCacheManager.getRealCacheBytes();
    } catch (_) {
      cacheBytes = 0;
    }
    notifyListeners();
    return cleared;
  }

  /// Paksa rebuild root (dipakai observer kecerahan sistem).
  void refresh() {
    notifyListeners();
  }

  static String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const units = ['B', 'KB', 'MB', 'GB'];
    var value = bytes.toDouble();
    var unit = 0;
    while (value >= 1024 && unit < units.length - 1) {
      value /= 1024;
      unit++;
    }
    final text = value >= 100
        ? value.round().toString()
        : value.toStringAsFixed(1);
    return '$text ${units[unit]}';
  }
}
