import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dinoyocraftmobile/features/help/help_screen.dart';

void main() {
  testWidgets('HelpScreen header menampilkan judul Bantuan dan tombol kembali', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HelpScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verifikasi judul Bantuan di header
    expect(find.text('Bantuan'), findsOneWidget);

    // Verifikasi tombol back icon ios new rounded
    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);

    // Verifikasi konten di bawahnya
    expect(find.text('Butuh Bantuan?'), findsOneWidget);
    expect(find.text('FAQ'), findsOneWidget);
  });
}
