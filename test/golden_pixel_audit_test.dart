// Audit piksel golden: pastikan latar tiap PNG sesuai mode yang dimaksud.
// Light = didominasi putih (0xFFFFFFFF); Dark = didominasi gelap.
// Jalankan: flutter test test/golden_pixel_audit_test.dart
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

Future<Map<int, int>> _histogram(File file) async {
  final bytes = await file.readAsBytes();
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  final data =
      await frame.image.toByteData(format: ui.ImageByteFormat.rawStraightRgba);
  final px = data!.buffer.asUint32List(); // ABGR little-endian per piksel
  final counts = <int, int>{};
  for (final p in px) {
    counts[p] = (counts[p] ?? 0) + 1;
  }
  frame.image.dispose();
  codec.dispose();
  return counts;
}

String _hex(int abgr) {
  final r = abgr & 0xFF;
  final g = (abgr >> 8) & 0xFF;
  final b = (abgr >> 16) & 0xFF;
  return r == g && g == b
      ? r.toRadixString(16)
      : '${r.toRadixString(16)}${g.toRadixString(16)}${b.toRadixString(16)}';
}

void main() {
  test('audit piksel golden terang & gelap', () async {
    final dir = Directory('test/goldens');
    if (!dir.existsSync()) {
      // Golden belum digenerate — audit opsional.
      // Generate: GOLDEN=1 flutter test --update-goldens test/theme_screens_golden_test.dart
      return;
    }
    final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith(".png")).map((f) => f.path).toList()
      ..sort();
    final buf = StringBuffer();
    for (final path in files) {
      final name = path.split(Platform.pathSeparator).last;
      final Map<int, int> h;
      try {
        h = await _histogram(File(path));
      } catch (e) {
        buf.writeln('$name => GAGAL DECODE: $e');
        continue;
      }
      final top = (h.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value)))
          .take(5)
          .map((e) => '#${_hex(e.key)} ${(e.value * 100 / (h.values.reduce((a, b) => a + b))).toStringAsFixed(1)}%')
          .join(' | ');
      buf.writeln('$name => $top');
    }
    // Cetak ke file agar mudah dibaca dari shell.
    File('test/goldens/_pixel_audit.txt').writeAsStringSync(buf.toString());
    debugPrint(buf.toString());
  }, timeout: const Timeout(Duration(seconds: 240)));
}
