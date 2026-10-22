// Regresi alur pendaftaran: verifikasi OTP setelah daftar HARUS
// mendarat di halaman Login, bukan langsung ke dalam aplikasi.
import 'package:dinoyocraftmobile/core/router/app_router.dart';
import 'package:dinoyocraftmobile/features/auth/login_screen.dart';
import 'package:dinoyocraftmobile/features/home/home_screen.dart';
import 'package:dinoyocraftmobile/features/auth/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('selesai verifikasi OTP pendaftaran → halaman Login',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      ),
    );
    await tester.pumpAndSettle();

    // Buka halaman verifikasi OTP untuk alur pendaftaran.
    appRouter.go('/verify-otp?from=register');
    await tester.pumpAndSettle();
    expect(find.byType(OtpScreen), findsOneWidget);

    // Isi 6 digit kode OTP.
    final boxes = find.byType(TextField);
    expect(boxes, findsNWidgets(6));
    for (var i = 0; i < 6; i++) {
      await tester.enterText(boxes.at(i), '${i + 1}');
    }

    // Tekan Konfirmasi.
    await tester.tap(find.text('Konfirmasi'));
    await tester.pumpAndSettle();

    // Harus berakhir di Login — BUKAN langsung masuk aplikasi.
    expect(find.byType(LoginScreen), findsOneWidget,
        reason: 'setelah daftar, pengguna diarahkan ke halaman Login');
    expect(find.byType(HomeScreen), findsNothing,
        reason: 'tidak boleh langsung masuk ke dalam aplikasi');
  });

  testWidgets('verifikasi OTP lupa password → kembali ke halaman Login',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      ),
    );
    await tester.pumpAndSettle();

    appRouter.go('/verify-otp?from=forgot');
    await tester.pumpAndSettle();
    expect(find.byType(OtpScreen), findsOneWidget);

    final boxes = find.byType(TextField);
    for (var i = 0; i < 6; i++) {
      await tester.enterText(boxes.at(i), '9');
    }
    await tester.tap(find.text('Konfirmasi'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);
  });

  testWidgets('email pada verifikasi OTP sesuai dengan email yang didaftarkan',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      ),
    );
    await tester.pumpAndSettle();

    // Buka verifikasi OTP dengan email pendaftaran
    appRouter.go('/verify-otp?from=register&email=alifarda@gmail.com');
    await tester.pumpAndSettle();

    expect(find.byType(OtpScreen), findsOneWidget);
    // Verifikasi teks email yang ditampilkan sesuai (awalan a, domain @gmail.com)
    expect(find.textContaining('a●●●●●@gmail.com'), findsOneWidget);
  });
}
