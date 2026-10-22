import 'package:dinoyocraftmobile/core/router/app_router.dart';
import 'package:dinoyocraftmobile/features/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Halaman register: tombol Google, auto-fill, email locked, password tertutup',
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

    // Navigasi ke halaman register
    appRouter.go('/register');
    await tester.pumpAndSettle();
    expect(find.byType(RegisterScreen), findsOneWidget);

    // Scroll ke bawah sampai tombol "Daftar dengan Google" terlihat
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
    await tester.pumpAndSettle();

    // Verifikasi tombol "Daftar dengan Google" dan divider "atau" ada
    expect(find.text('atau'), findsOneWidget);
    final googleBtn = find.text('Daftar dengan Google');
    expect(googleBtn, findsOneWidget);

    // Klik tombol "Daftar dengan Google"
    await tester.tap(googleBtn);
    await tester.pumpAndSettle();

    // Bottom sheet akun Google muncul
    expect(find.text('Pilih Akun Google'), findsOneWidget);
    expect(find.text('Alif Farda'), findsOneWidget);
    expect(find.text('aliffarda@gmail.com'), findsOneWidget);

    // Pilih akun Alif Farda
    await tester.tap(find.text('Alif Farda'));
    await tester.pumpAndSettle();

    // Scroll kembali ke atas untuk mengecek semua field
    await tester.drag(find.byType(CustomScrollView), const Offset(0, 500));
    await tester.pumpAndSettle();

    // 1. Password & Konfirmasi Password otomatis TERTUTUP (tidak ada di layar)
    expect(find.text('Password'), findsNothing);
    expect(find.text('Konfirmasi Password'), findsNothing);
    expect(find.textContaining('Kolom password tertutup'), findsOneWidget);

    // 2. Email otomatis terisi dan readOnly (tidak bisa diganti)
    expect(find.text('aliffarda@gmail.com'), findsAtLeastNWidgets(1));
    final emailTextField = tester.widget<TextField>(
      find.descendant(
        of: find.widgetWithText(TextFormField, 'aliffarda@gmail.com'),
        matching: find.byType(TextField),
      ),
    );
    expect(emailTextField.readOnly, isTrue,
        reason: 'Email harus readOnly saat menggunakan akun Google');

    // 3. Nama & Username otomatis terisi dan TETAP BISA DI-EDIT
    final nameField = find.widgetWithText(TextFormField, 'Alif Farda');
    expect(nameField, findsOneWidget);
    final nameTextField = tester.widget<TextField>(
      find.descendant(of: nameField, matching: find.byType(TextField)),
    );
    expect(nameTextField.readOnly, isFalse,
        reason: 'Nama lengkap harus tetap bisa diedit');

    // Coba edit Nama
    await tester.enterText(nameField, 'Alif Farda Pratama');
    await tester.pumpAndSettle();
    expect(find.text('Alif Farda Pratama'), findsOneWidget);

    // Coba edit Username
    final userField = find.widgetWithText(TextFormField, 'aliffarda');
    expect(userField, findsOneWidget);
    final userTextField = tester.widget<TextField>(
      find.descendant(of: userField, matching: find.byType(TextField)),
    );
    expect(userTextField.readOnly, isFalse,
        reason: 'Username harus tetap bisa diedit');
    await tester.enterText(userField, 'aliffarda_edited');
    await tester.pumpAndSettle();
    expect(find.text('aliffarda_edited'), findsOneWidget);
  });

  testWidgets('Membatalkan pendaftaran Google mengembalikan kolom password dan membuka email',
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

    appRouter.go('/register');
    await tester.pumpAndSettle();

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
    await tester.pumpAndSettle();

    // Pilih Google
    final googleBtn = find.text('Daftar dengan Google');
    await tester.tap(googleBtn);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Alif Farda'));
    await tester.pumpAndSettle();

    // Scroll ke atas dan verifikasi kolom password tertutup
    await tester.drag(find.byType(CustomScrollView), const Offset(0, 500));
    await tester.pumpAndSettle();
    expect(find.text('Password'), findsNothing);
    expect(find.text('Konfirmasi Password'), findsNothing);

    // Klik tombol "Batal" pada banner atas
    final cancelBtn = find.byKey(const Key('cancel_google_btn'));
    expect(cancelBtn, findsOneWidget);
    await tester.tap(cancelBtn);
    await tester.pumpAndSettle();

    // Verifikasi kolom password kembali terbuka
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Konfirmasi Password'), findsOneWidget);
  });

  testWidgets('SnackBar action tidak memanggil setState setelah screen di-dispose',
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

    appRouter.go('/register');
    await tester.pumpAndSettle();

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
    await tester.pumpAndSettle();

    // Pilih Google
    final googleBtn = find.text('Daftar dengan Google');
    await tester.tap(googleBtn);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Alif Farda'));
    await tester.pumpAndSettle();

    // Navigasi keluar dari RegisterScreen (misal kembali ke Onboarding)
    appRouter.go('/');
    await tester.pumpAndSettle();
    expect(find.byType(RegisterScreen), findsNothing);

    // Jika ada SnackBarAction tersisa, menekannya tidak boleh melempar error
    final snackBarAction = find.text('Batalkan');
    if (snackBarAction.evaluate().isNotEmpty) {
      await tester.tap(snackBarAction);
      await tester.pumpAndSettle();
    }
  });
}
