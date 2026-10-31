import 'package:package_info_plus/package_info_plus.dart';

/// Service singleton untuk membaca metadata aplikasi (nama, versi, build number)
/// secara dinamis dari sistem operasi.
class AppInfoService {
  AppInfoService._internal();
  static final AppInfoService instance = AppInfoService._internal();

  String appName = 'DinoyoCraft';
  String version = '1.0.0';
  String buildNumber = '1';

  /// Inisialisasi metadata aplikasi dari platform.
  Future<void> initialize() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (info.appName.isNotEmpty) appName = info.appName;
      if (info.version.isNotEmpty) version = info.version;
      if (info.buildNumber.isNotEmpty) buildNumber = info.buildNumber;
    } catch (_) {
      // Safe fallback untuk environment pengujian
    }
  }

  /// Format label versi untuk ditampilkan di halaman Pengaturan.
  String get versionLabel => 'DinoyoCraft App v$version';
}

