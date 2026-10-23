import 'package:dinoyocraftmobile/features/profile/data_diri_screen.dart';
import 'package:dinoyocraftmobile/features/review/write_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Regresi keyboard: bar aksi di dasar layar (Simpan/Batalkan, Kirim Ulasan)
  // sebelumnya berada di dalam body Scaffold sehingga ikut naik ke ATAS
  // keyboard saat field difokuskan. Perilaku yang benar — sama seperti bottom
  // nav di halaman pencarian produk/toko — bar tetap di dasar layar dan
  // TERTUTUP keyboard.
  testWidgets(
      'DataDiriScreen: bar Simpan Perubahan tertutup keyboard saat field difokuskan',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: DataDiriScreen()));

    // Fokuskan field nama lalu buka keyboard (simulasi inset 400px).
    await tester.tap(find.byType(TextField).first);
    tester.view.viewInsets = const FakeViewPadding(bottom: 400);
    await tester.pump();
    await tester.pump();

    // Jika bar naik ke atas keyboard, bottom teks ≈ 1200 (1600 - 400).
    // Jika benar (tertutup keyboard), tetap menempel di dasar layar.
    final barBottom = tester.getRect(find.text('Simpan Perubahan')).bottom;
    expect(barBottom, greaterThan(1250));

    tester.view.viewInsets = FakeViewPadding.zero;
    await tester.pumpAndSettle();

    // Keyboard tertutup: bar kembali terlihat normal di dasar layar.
    expect(find.text('Simpan Perubahan'), findsOneWidget);
    expect(find.text('Batalkan'), findsOneWidget);
  });

  testWidgets(
      'WriteReviewScreen: bar Kirim Ulasan tertutup keyboard saat menulis ulasan',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: WriteReviewScreen()));

    // Buka keyboard.
    tester.view.viewInsets = const FakeViewPadding(bottom: 400);
    await tester.pump();
    await tester.pump();

    final barBottom = tester.getRect(find.text('Kirim Ulasan')).bottom;
    expect(barBottom, greaterThan(1250));
  });
}
