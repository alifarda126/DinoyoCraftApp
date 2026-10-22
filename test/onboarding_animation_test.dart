import 'package:dinoyocraftmobile/core/app_settings.dart';
import 'package:dinoyocraftmobile/core/theme/app_colors.dart';
import 'package:dinoyocraftmobile/core/theme/app_theme.dart';
import 'package:dinoyocraftmobile/features/auth/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    AppColors.isDark = false;
  });

  testWidgets('Elemen teks, logo header, dan tombol onboarding tampil dengan animasi masuk',
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

    // Langsung merender halaman onboarding tanpa splash
    expect(find.byKey(const Key('app_splash_overlay')), findsNothing);
    expect(find.text('DinoyoCraft'), findsOneWidget);
    expect(find.textContaining('Temukan Cerita di Balik Setiap'), findsOneWidget);
    expect(find.text('Mulai Menjelajah'), findsOneWidget);
    expect(find.textContaining('Daftar'), findsOneWidget);

    // Jalankan seluruh durasi animasi bertahap (1100ms)
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('Mulai Menjelajah'), findsOneWidget);
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

    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('Mulai Menjelajah'), findsOneWidget);
    expect(find.textContaining('Temukan Cerita di Balik Setiap'), findsOneWidget);
  });
}
