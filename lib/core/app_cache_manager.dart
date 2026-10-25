import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:path_provider/path_provider.dart';

/// Pengelola cache nyata aplikasi DinoyoCraft.
/// Membaca ukuran fisik direktori temporary/cache sistem dan menghapusnya
/// langsung dari disk agar pengguna tidak perlu pergi ke menu Info Aplikasi perangkat.
abstract final class AppCacheManager {
  /// Direktori override khusus untuk testing jika diperlukan.
  @visibleForTesting
  static Directory? testCacheDirectoryOverride;

  /// Mendapatkan direktori cache aplikasi:
  /// - Pada Android/iOS: direktori temporary / cache sandbox aplikasi.
  /// - Pada Desktop/Lainnya: subdirektori khusus 'dinoyocraftmobile_cache' agar terisolasi.
  /// - Fallback: subdirektori di systemTemp jika platform channel tidak tersedia.
  static Future<Directory> getAppCacheDir() async {
    if (testCacheDirectoryOverride != null) {
      return testCacheDirectoryOverride!;
    }
    try {
      final tempDir = await getTemporaryDirectory();
      if (Platform.isAndroid || Platform.isIOS) {
        return tempDir;
      }
      final appDir = Directory('${tempDir.path}/dinoyocraftmobile_cache');
      if (!appDir.existsSync()) {
        appDir.createSync(recursive: true);
      }
      return appDir;
    } catch (_) {
      final fallbackDir =
          Directory('${Directory.systemTemp.path}/dinoyocraftmobile_cache');
      if (!fallbackDir.existsSync()) {
        fallbackDir.createSync(recursive: true);
      }
      return fallbackDir;
    }
  }

  /// Menghitung total ukuran cache nyata (dalam bytes) dari direktori
  /// temporary / cache sistem dan external cache (Android).
  static Future<int> getRealCacheBytes() async {
    int totalBytes = 0;
    final visited = <String>{};

    void sumDirectory(Directory dir) {
      if (!visited.add(dir.path)) return;
      try {
        if (dir.existsSync()) {
          for (final entity
              in dir.listSync(recursive: true, followLinks: false)) {
            if (entity is File) {
              try {
                totalBytes += entity.lengthSync();
              } catch (_) {}
            }
          }
        }
      } catch (_) {}
    }

    try {
      final cacheDir = await getAppCacheDir();
      sumDirectory(cacheDir);

      if (testCacheDirectoryOverride == null && Platform.isAndroid) {
        try {
          final codeCache = Directory('${cacheDir.parent.path}/code_cache');
          sumDirectory(codeCache);
        } catch (_) {}

        try {
          final extDirs = await getExternalCacheDirectories();
          if (extDirs != null) {
            for (final dir in extDirs) {
              sumDirectory(dir);
            }
          }
        } catch (_) {}
      }
    } catch (_) {}

    return totalBytes;
  }

  /// Menghapus seluruh file cache secara langsung dari sistem perangkat,
  /// serta membersihkan in-memory decoded image cache Flutter.
  static Future<int> clearRealCache() async {
    int bytesDeleted = 0;

    // 1. Bersihkan memory image cache Flutter
    try {
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
    } catch (_) {}

    final visited = <String>{};

    void wipeDirectory(Directory dir) {
      if (!visited.add(dir.path)) return;
      try {
        if (dir.existsSync()) {
          final entities = dir.listSync(recursive: false, followLinks: false);
          for (final entity in entities) {
            try {
              if (entity is File) {
                bytesDeleted += entity.lengthSync();
                entity.deleteSync();
              } else if (entity is Directory) {
                bytesDeleted += _dirSizeSync(entity);
                entity.deleteSync(recursive: true);
              }
            } catch (_) {}
          }
        }
      } catch (_) {}
    }

    try {
      final cacheDir = await getAppCacheDir();
      wipeDirectory(cacheDir);

      if (testCacheDirectoryOverride == null && Platform.isAndroid) {
        try {
          final codeCache = Directory('${cacheDir.parent.path}/code_cache');
          wipeDirectory(codeCache);
        } catch (_) {}

        try {
          final extDirs = await getExternalCacheDirectories();
          if (extDirs != null) {
            for (final dir in extDirs) {
              wipeDirectory(dir);
            }
          }
        } catch (_) {}
      }
    } catch (_) {}

    return bytesDeleted;
  }

  static int _dirSizeSync(Directory dir) {
    int bytes = 0;
    try {
      for (final entity in dir.listSync(recursive: true, followLinks: false)) {
        if (entity is File) {
          try {
            bytes += entity.lengthSync();
          } catch (_) {}
        }
      }
    } catch (_) {}
    return bytes;
  }
}
