import 'package:flutter/material.dart';

import 'app_cache_manager.dart';
import 'app_device_manager.dart';
import 'app_theme_persistence.dart';
import 'network/api_client.dart';
import 'storage/local_storage.dart';
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

  /// Preferensi notifikasi pesanan & WhatsApp yang tersimpan di penyimpanan lokal.
  bool orderNotification = true;
  bool whatsAppNotification = true;

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

  /// Perangkat lain yang terhubung. Server belum menyimpan sesi
  /// per-perangkat, jadi daftar ini KOSONG (tanpa data mock) — hanya
  /// perangkat saat ini yang ditampilkan.
  final List<DeviceSession> otherDevices = [];

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
      }
      final savedLocale = LocalStorage.getLocale();
      if (savedLocale == 'id' || savedLocale == 'en') {
        locale = savedLocale!;
      }
      orderNotification = LocalStorage.getOrderNotification();
      whatsAppNotification = LocalStorage.getWhatsAppNotification();
      final user = LocalStorage.getUser();
      if (user != null) {
        final raw2fa = user['two_factor_enabled'];
        twoFactorEnabled = raw2fa == true || raw2fa == 1 || raw2fa == '1';
      }
      notifyListeners();
    } catch (_) {
      // Abaikan bila di environment widget test
    }
  }

  void setLocale(String code) {
    locale = code;
    LocalStorage.savePreferences(locale: code);
    notifyListeners();
  }

  void setOrderNotification(bool value) {
    orderNotification = value;
    LocalStorage.savePreferences(orderNotification: value);
    notifyListeners();
  }

  void setWhatsAppNotification(bool value) {
    whatsAppNotification = value;
    LocalStorage.savePreferences(whatsAppNotification: value);
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

  /// Sinkronkan info perangkat saat ini langsung dari hardware / OS nyata
  /// serta muat daftar perangkat lain yang pernah login pada akun ini dari backend.
  Future<void> syncCurrentDevice() async {
    try {
      final real = await AppDeviceManager.getRealCurrentDevice();
      ApiClient.deviceId = real.id;
      ApiClient.deviceName = real.name;
      currentDevice = DeviceSession(
        id: real.id,
        name: real.name,
        location: 'Malang, Indonesia',
        lastActive: 'Aktif saat ini',
        details: real.details,
        icon: real.icon,
        isCurrent: true,
      );

      if (LocalStorage.isLoggedIn) {
        try {
          final res = await ApiClient.get('/auth/devices');
          if (res['success'] == true && res['data'] is List) {
            final rows = (res['data'] as List).whereType<Map>();
            final fetchedOthers = <DeviceSession>[];
            for (final row in rows) {
              final id = row['id']?.toString() ?? '';
              final isCur = row['is_current'] == true || id == real.id;
              if (isCur) continue;
              final name = row['name']?.toString() ?? 'Perangkat Terhubung';
              final ip = row['ip_address']?.toString() ?? '-';
              final lowerName = name.toLowerCase();
              final icon = lowerName.contains('browser') ||
                      lowerName.contains('windows') ||
                      lowerName.contains('mac')
                  ? Icons.computer_rounded
                  : Icons.phone_android_rounded;
              fetchedOthers.add(
                DeviceSession(
                  id: id,
                  name: name,
                  location: ip != '-' ? 'IP $ip' : 'Indonesia',
                  lastActive: 'Login terdeteksi',
                  details: name,
                  icon: icon,
                  isCurrent: false,
                ),
              );
            }
            otherDevices
              ..clear()
              ..addAll(fetchedOthers);
          }
        } catch (_) {}
      }
      notifyListeners();
    } catch (_) {
      // Abaikan pada testing environment
    }
  }

  /// Mencatat perangkat lain secara instan dari event realtime keamanan.
  void recordOtherDeviceLogin({
    required String id,
    required String name,
    String? ipAddress,
  }) {
    if (id.isEmpty || id == currentDevice.id) return;
    otherDevices.removeWhere((d) => d.id == id);
    otherDevices.insert(
      0,
      DeviceSession(
        id: id,
        name: name.isNotEmpty ? name : 'Perangkat Baru',
        location: (ipAddress != null && ipAddress.isNotEmpty && ipAddress != '-')
            ? 'IP $ipAddress'
            : 'Indonesia',
        lastActive: 'Baru saja masuk',
        details: name,
        icon: name.toLowerCase().contains('browser')
            ? Icons.computer_rounded
            : Icons.phone_android_rounded,
        isCurrent: false,
      ),
    );
    notifyListeners();
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
