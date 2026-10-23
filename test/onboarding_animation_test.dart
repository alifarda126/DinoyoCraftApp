import 'package:dinoyocraftmobile/core/app_settings.dart';
import 'package:dinoyocraftmobile/core/theme/app_colors.dart';
import 'package:dinoyocraftmobile/core/theme/app_theme.dart';
import 'package:dinoyocraftmobile/features/auth/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    AppColors.isDark = false;
    OnboardingScreen.hasPlayedEntranceAnimation = false;
  });

  testWidgets(
      'Animasi masuk motion graphic logo: 3 pecahan bergerak dan menyatu, lalu berpindah ke badge onboarding',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const OnboardingScreen(),
      ),
    );

    // Frame awal: animasi intro berjalan dengan 3 kepingan logo sesuai goresan garis pemisah
    expect(find.byKey(const Key('logo_motion_intro')), findsOneWidget);
    expect(find.byKey(const Key('logo_piece_top')), findsOneWidget);
    expect(find.byKey(const Key('logo_piece_hand')), findsOneWidget);
    expect(find.byKey(const Key('logo_piece_leaf')), findsOneWidget);

    // Majukan ke detik saat kepingan menyatu dan brand reveal tampil di tengah (1300ms)
    await tester.pump(const Duration(milliseconds: 1300));
    expect(find.byKey(const Key('logo_motion_intro')), findsOneWidget);
    expect(find.text('DinoyoCraft'), findsAtLeast(1));

    // Selesaikan seluruh durasi animasi sampai transisi meluncur ke badge onboarding selesai
    await tester.pump(const Duration(milliseconds: 1400));
    await tester.pumpAndSettle();

    // Halaman onboarding utama tampil utuh dengan tombol yang dapat diklik
    expect(find.byKey(const Key('logo_motion_intro')), findsNothing);
    expect(find.text('DinoyoCraft'), findsOneWidget);
    expect(find.textContaining('Temukan Cerita di Balik Setiap'), findsOneWidget);
    expect(find.text('Mulai Menjelajah'), findsOneWidget);
    expect(find.textContaining('Daftar'), findsOneWidget);
  });

  testWidgets('Mengetuk layar saat animasi intro langsung mempercepat ke halaman onboarding',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const OnboardingScreen(),
      ),
    );

    expect(find.byKey(const Key('logo_motion_intro')), findsOneWidget);

    // Tap pada layar intro
    await tester.tap(
      find.byKey(const Key('logo_motion_intro')),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    // Langsung berada pada halaman onboarding
    expect(find.byKey(const Key('logo_motion_intro')), findsNothing);
    expect(find.text('Mulai Menjelajah'), findsOneWidget);
    expect(find.textContaining('Temukan Cerita di Balik Setiap'), findsOneWidget);
  });

  testWidgets(
      'Setelah animasi masuk pertama kali selesai, kunjungan berikutnya (misal logout) langsung ke onboarding tanpa animasi',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    // Simulasi bahwa animasi sudah pernah diputar saat pertama kali buka aplikasi
    OnboardingScreen.hasPlayedEntranceAnimation = true;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const OnboardingScreen(),
      ),
    );
    await tester.pump();

    // Langsung merender halaman onboarding tanpa intro
    expect(find.byKey(const Key('logo_motion_intro')), findsNothing);
    expect(find.text('Mulai Menjelajah'), findsOneWidget);
    expect(find.textContaining('Temukan Cerita di Balik Setiap'), findsOneWidget);
  });

  testWidgets(
      'OnboardingScreen dengan showEntranceAnimation: false langsung tampil tanpa intro',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const OnboardingScreen(showEntranceAnimation: false),
      ),
    );

    // Langsung merender halaman onboarding tanpa intro
    expect(find.byKey(const Key('logo_motion_intro')), findsNothing);
    expect(find.text('Mulai Menjelajah'), findsOneWidget);
    expect(find.textContaining('Temukan Cerita di Balik Setiap'), findsOneWidget);
  });

  testWidgets('Animasi onboarding berjalan mulus pada mode gelap',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    AppColors.isDark = true;
    AppSettings.instance.themeMode = AppThemeMode.dark;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: const OnboardingScreen(),
      ),
    );

    // Verifikasi intro di mode gelap
    expect(find.byKey(const Key('logo_motion_intro')), findsOneWidget);

    // Tunggu sampai animasi selesai
    await tester.pump(const Duration(milliseconds: 2700));
    await tester.pumpAndSettle();

    expect(find.text('Mulai Menjelajah'), findsOneWidget);
    expect(find.textContaining('Temukan Cerita di Balik Setiap'), findsOneWidget);
  });
}
