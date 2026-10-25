import 'dart:io';

import 'package:dinoyocraftmobile/core/app_cache_manager.dart';
import 'package:dinoyocraftmobile/core/app_settings.dart';
import 'package:dinoyocraftmobile/core/theme/app_colors.dart';
import 'package:dinoyocraftmobile/features/profile/pengaturan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempTestDir;

  setUp(() {
    tempTestDir = Directory.systemTemp.createTempSync('dc_cache_test_');
    AppCacheManager.testCacheDirectoryOverride = tempTestDir;
    AppColors.isDark = false;
    AppSettings.instance.setThemeMode(AppThemeMode.light);
  });

  tearDown(() {
    AppCacheManager.testCacheDirectoryOverride = null;
    try {
      if (tempTestDir.existsSync()) {
        tempTestDir.deleteSync(recursive: true);
      }
    } catch (_) {}
  });

  test('AppCacheManager membersihkan memory image cache dan menghapus file',
      () async {
    final cacheDir = await AppCacheManager.getAppCacheDir();
    final dummyFile = File('${cacheDir.path}/test_cached_image.jpg');
    dummyFile.writeAsBytesSync(List.filled(1024 * 50, 42)); // 50 KB

    expect(dummyFile.existsSync(), isTrue);
    expect(dummyFile.lengthSync(), equals(50 * 1024));

    // Ukuran cache terbaca 50 KB
    final size = await AppCacheManager.getRealCacheBytes();
    expect(size, equals(50 * 1024));

    // Bersihkan cache fisik
    await AppCacheManager.clearRealCache();

    // Pastikan file fisik terhapus dan sisa cache 0 B
    expect(dummyFile.existsSync(), isFalse);
    final sizeAfter = await AppCacheManager.getRealCacheBytes();
    expect(sizeAfter, equals(0));
  });

  testWidgets(
      'PengaturanScreen menampilkan cache asli dari disk dan menghapus file nyata saat ditekan',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    // 1. Buat file cache nyata sebesar 2 MB di direktori cache
    final cacheDir = await AppCacheManager.getAppCacheDir();
    final testFile = File('${cacheDir.path}/test_cache_blob.bin');
    testFile.writeAsBytesSync(List.filled(1024 * 1024 * 2, 7)); // 2 MB

    // Sinkronkan cacheBytes ke AppSettings
    await AppSettings.instance.syncCacheSize();
    expect(AppSettings.instance.cacheBytes, equals(1024 * 1024 * 2));
    expect(AppSettings.instance.cacheLabel, equals('2.0 MB'));

    // 2. Buka PengaturanScreen
    await tester.pumpWidget(
      const MaterialApp(
        home: PengaturanScreen(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Pastikan subtitle cache menampilkan ukuran cache nyata
    expect(find.textContaining('2.0 MB file sementara'), findsOneWidget);
    expect(find.text('Bersihkan'), findsWidgets);

    // 3. Tekan tile Bersihkan Cache
    final clearTileFinder = find.text('Bersihkan Cache').first;
    await tester.ensureVisible(clearTileFinder);
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(clearTileFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Dialog konfirmasi Bersihkan Cache muncul dengan ukuran asli
    expect(find.text('Bersihkan Cache?'), findsOneWidget);
    expect(find.textContaining('2.0 MB'), findsWidgets);

    // 4. Tekan tombol 'Bersihkan' di dalam dialog
    final confirmButtonFinder = find.widgetWithText(ElevatedButton, 'Bersihkan');
    expect(confirmButtonFinder, findsOneWidget);
    await tester.tap(confirmButtonFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    // 5. Pastikan file fisik benar-benar terhapus langsung dari disk
    expect(testFile.existsSync(), isFalse);

    // Dialog tertutup dan cache menjadi bersih (0 B)
    expect(find.text('Bersihkan Cache?'), findsNothing);
    expect(find.textContaining('0 B file sementara'), findsOneWidget);
    expect(find.text('Bersih'), findsWidgets);

    // 6. Jika ditekan kembali saat sudah bersih, tampilkan feedback bahwa cache sudah bersih
    await tester.tap(clearTileFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Cache aplikasi sudah bersih (0 B).'), findsOneWidget);
  });
}
