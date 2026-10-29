import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'app_settings.dart';

/// Pengelola persistensi tema aplikasi DinoyoCraft.
/// Menyimpan preferensi tema (Light, Dark, System) ke penyimpanan permanen
/// agar tampilan tetap sesuai pilihan pengguna saat aplikasi dibuka kembali,
/// dengan nilai bawaan awal tetap Light Mode.
abstract final class AppThemePersistence {
  @visibleForTesting
  static Directory? testDirectoryOverride;

  static const String _fileName = 'app_theme_mode.cfg';

  static Future<File> _getFile() async {
    if (testDirectoryOverride != null) {
      return File('${testDirectoryOverride!.path}/$_fileName');
    }
    try {
      final docDir = await getApplicationDocumentsDirectory();
      return File('${docDir.path}/$_fileName');
    } catch (_) {
      try {
        final supportDir = await getApplicationSupportDirectory();
        return File('${supportDir.path}/$_fileName');
      } catch (_) {
        return File('${Directory.systemTemp.path}/dinoyocraft_$_fileName');
      }
    }
  }

  /// Membaca tema yang tersimpan di disk.
  /// Mengembalikan `null` jika pengguna belum pernah mengubah tema secara manual,
  /// sehingga aplikasi tetap mempertahankan nilai awal bawaan (Light Mode).
  static Future<AppThemeMode?> getSavedThemeMode() async {
    if (kIsWeb) return null;
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = (await file.readAsString()).trim().toLowerCase();
        return switch (content) {
          'dark' => AppThemeMode.dark,
          'system' => AppThemeMode.system,
          'light' => AppThemeMode.light,
          _ => null,
        };
      }
    } catch (_) {
      // Abaikan error pada sandbox/testing environment
    }
    return null;
  }

  /// Menyimpan preferensi tema pilihan pengguna secara persisten ke disk.
  static Future<void> saveThemeMode(AppThemeMode mode) async {
    if (kIsWeb) return;
    try {
      final file = await _getFile();
      final parent = file.parent;
      if (!parent.existsSync()) {
        parent.createSync(recursive: true);
      }
      await file.writeAsString(mode.name, flush: true);
    } catch (_) {
      // Abaikan bila storage sedang tidak dapat diakses
    }
  }
}

