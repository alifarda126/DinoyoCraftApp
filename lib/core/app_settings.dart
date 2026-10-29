import 'package:flutter/material.dart';

import 'app_cache_manager.dart';
import 'app_device_manager.dart';
import 'app_theme_persistence.dart';
import 'theme/app_colors.dart';

/// Mode tema aplikasi.
enum AppThemeMode { system, light, dark }

/// Sesi perangkat yang terhubung ke akun.
class DeviceSession {
  DeviceSession({
    this.id = 'session',
    required this.name,
    required this.location,
    required this.lastActive,
    this.details = '',
    this.icon = Icons.devices_rounded,
    this.isCurrent = false,
    this.isRevoked = false,
  });

  final String id;
  final String name;
  final String location;
  final String lastActive;
  final String details;
  final IconData icon;
  final bool isCurrent;
  bool isRevoked;
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

  /// Perangkat saat ini yang sedang menjalankan aplikasi (sinkron dengan info nyata).
  DeviceSession currentDevice = DeviceSession(
    id: 'current_device',
    name: 'Smartphone Ini',
    location: 'Malang, Indonesia',
    lastActive: 'Aktif saat ini',
    details: 'DinoyoCraft App v1.0.0',
    icon: Icons.phone_android_rounded,
    isCurrent: true,
  );

  /// Perangkat lain yang sedang terhubung (selain perangkat ini).
  final List<DeviceSession> otherDevices = [
    DeviceSession(
      id: 'session_win_chrome',
      name: 'Chrome di Windows 11',
      location: 'Surabaya, Indonesia',
      lastActive: 'Aktif 2 jam lalu',
      details: 'Chrome Browser v122',
      icon: Icons.laptop_chromebook_rounded,
    ),
    DeviceSession(
      id: 'session_ios_safari',
      name: 'Safari di iPhone 14 Pro',
      location: 'Malang, Indonesia',
      lastActive: 'Terakhir aktif 3 hari lalu',
      details: 'Safari Mobile • iOS 17',
      icon: Icons.phone_iphone_rounded,
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
    // Simpan pilihan tema agar tetap bertahan saat aplikasi dibuka kembali.
    AppThemePersistence.saveThemeMode(mode);
  }

  /// Memuat preferensi tema yang tersimpan di disk jika pengguna pernah mengubahnya.
  /// Bila belum pernah diubah, nilai awal bawaan tetap AppThemeMode.light.
  Future<void> loadSavedPreferences() async {
    try {
      final saved = await AppThemePersistence.getSavedThemeMode();
      if (saved != null) {
        themeMode = saved;
        if (saved != AppThemeMode.system) {
          AppColors.isDark = saved == AppThemeMode.dark;
        }
        notifyListeners();
      }
    } catch (_) {
      // Abaikan bila di environment widget test
    }
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

  /// Sinkronkan info perangkat saat ini langsung dari hardware / OS nyata.
  Future<void> syncCurrentDevice() async {
    try {
      final real = await AppDeviceManager.getRealCurrentDevice();
      currentDevice = DeviceSession(
        id: real.id,
        name: real.name,
        location: 'Malang, Indonesia',
        lastActive: 'Aktif saat ini',
        details: real.details,
        icon: real.icon,
        isCurrent: true,
      );
      notifyListeners();
    } catch (_) {
      // Abaikan pada testing environment
    }
  }

  /// Menghapus sesi perangkat lain berdasarkan index.
  /// Sesi perangkat tersebut dicabut (revoked), dan otomatis ter-logout.
  DeviceSession? removeOtherDevice(int index) {
    if (index >= 0 && index < otherDevices.length) {
      final removed = otherDevices.removeAt(index);
      removed.isRevoked = true;
      notifyListeners();
      return removed;
    }
    return null;
  }

  /// Menghapus seluruh sesi perangkat lain.
  /// Seluruh perangkat lain otomatis ter-logout dari akun.
  void removeAllOtherDevices() {
    for (final dev in otherDevices) {
      dev.isRevoked = true;
    }
    otherDevices.clear();
    notifyListeners();
  }

  /// Menghapus / mengeluarkan sesi perangkat ini.
  /// Perangkat ini otomatis ter-logout dari akun dan status requireOtpNextLogin diatur.
  void logoutCurrentDevice() {
    currentDevice.isRevoked = true;
    markLoggedOut();
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
