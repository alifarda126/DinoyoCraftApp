// Verifikasi runtime: mengganti tema dari Pengaturan harus langsung
// mem-propagasi ke seluruh layar TANPA hot reload.
import 'package:dinoyocraftmobile/core/app_settings.dart';
import 'package:dinoyocraftmobile/core/assets.dart';
import 'package:dinoyocraftmobile/core/router/app_router.dart';
import 'package:dinoyocraftmobile/core/theme/app_colors.dart';
import 'package:dinoyocraftmobile/features/auth/login_screen.dart';
import 'package:dinoyocraftmobile/features/profile/data_diri_screen.dart';
import 'package:dinoyocraftmobile/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ganti tema ke gelap saat runtime langsung mewarnai ulang layar',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
    AppSettings.instance.setThemeMode(AppThemeMode.light);

    await tester.pumpWidget(const app.DinoyoCraftApp());
    await tester.pumpAndSettle();

    // Buka Login langsung lewat router (route '/').
    final ctx0 = tester.element(find.byType(Navigator).first);
    Navigator.of(ctx0, rootNavigator: true).push(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
    );
    await tester.pumpAndSettle();

    Color scaffoldBg() =>
        tester.widget<Scaffold>(find.byType(Scaffold).first).backgroundColor ??
        const Color(0xDEADBEEF);
    Color labelColor() => tester
        .widget<Text>(find.text('Email'))
        .style
        ?.color ??
        const Color(0xDEADBEEF);

    expect(AppColors.isDark, isFalse, reason: 'awal: mode terang');
    expect(scaffoldBg(), const Color(0xFFFFFFFF));
    expect(labelColor(), const Color(0xFF1A1A1A));

    // Ganti tema persis seperti aksi modal Pengaturan.
    AppSettings.instance.setThemeMode(AppThemeMode.dark);
    await tester.pumpAndSettle();

    expect(AppColors.isDark, isTrue,
        reason: 'flag token tersinkron setelah ganti tema');
    expect(scaffoldBg(), const Color(0xFF121212),
        reason: 'latar Scaffold harus langsung gelap tanpa hot reload');
    expect(labelColor(), const Color(0xFFF5F5F5),
        reason: 'teks bertema harus langsung berwarna terang tanpa hot reload');

    // Kembali ke terang — pastikan reversibel.
    AppSettings.instance.setThemeMode(AppThemeMode.light);
    await tester.pumpAndSettle();
    expect(scaffoldBg(), const Color(0xFFFFFFFF));
    expect(labelColor(), const Color(0xFF1A1A1A));
  });

  testWidgets('ganti tema runtime juga mewarnai ulang cabang tab (workshop) & header',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 4800);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
    AppSettings.instance.setThemeMode(AppThemeMode.light);

    await tester.pumpWidget(const app.DinoyoCraftApp());
    await tester.pumpAndSettle();
    appRouter.go('/workshop');
    await tester.pumpAndSettle();

    Color titleColor() => tester
            .widget<Text>(find.text('Workshop Keramik'))
            .style
            ?.color ??
        const Color(0xDEADBEEF);

    expect(titleColor(), const Color(0xFF1A1A1A),
        reason: 'awal terang: judul memakai ink terang');

    AppSettings.instance.setThemeMode(AppThemeMode.dark);
    await tester.pumpAndSettle();

    expect(titleColor(), const Color(0xFFF5F5F5),
        reason:
            'cabang shell (workshop) harus langsung ikut gelap tanpa hot reload');

    // Reversibel.
    AppSettings.instance.setThemeMode(AppThemeMode.light);
    await tester.pumpAndSettle();
    expect(titleColor(), const Color(0xFF1A1A1A));
  });

  testWidgets('mode Ikuti Sistem: brightness sistem berubah saat runtime langsung mewarnai ulang',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
    tester.binding.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    AppSettings.instance.setThemeMode(AppThemeMode.system);

    await tester.pumpWidget(const app.DinoyoCraftApp());
    await tester.pumpAndSettle();

    final navCtx = tester.element(find.byType(Navigator).first);
    Navigator.of(navCtx, rootNavigator: true).push(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
    );
    await tester.pumpAndSettle();

    Color scaffoldBg() =>
        tester.widget<Scaffold>(find.byType(Scaffold).first).backgroundColor ??
        const Color(0xDEADBEEF);

    expect(AppColors.isDark, isFalse, reason: 'awal: sistem terang');

    // Sistem berganti gelap — observer harus memicu pewarnaan ulang.
    tester.binding.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpAndSettle();

    expect(AppColors.isDark, isTrue,
        reason: 'mode sistem: flag harus ikut brightness sistem');
    expect(scaffoldBg(), const Color(0xFF121212),
        reason: 'mode sistem: latar harus langsung gelap tanpa hot reload');
  });

  testWidgets('header logo berganti ke logoWhite saat mode gelap',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
    AppSettings.instance.setThemeMode(AppThemeMode.light);

    await tester.pumpWidget(const app.DinoyoCraftApp());
    await tester.pumpAndSettle();
    appRouter.go('/home');
    await tester.pumpAndSettle();

    // Mode terang: logo harus hitam
    expect(find.image(const AssetImage(AppAssets.logoBlack)), findsOneWidget);
    expect(find.image(const AssetImage(AppAssets.logoWhite)), findsNothing);

    // Ganti ke mode gelap
    AppSettings.instance.setThemeMode(AppThemeMode.dark);
    await tester.pumpAndSettle();

    // Mode gelap: logo harus putih
    expect(find.image(const AssetImage(AppAssets.logoWhite)), findsOneWidget);
    expect(find.image(const AssetImage(AppAssets.logoBlack)), findsNothing);

    // Kembalikan ke terang
    AppSettings.instance.setThemeMode(AppThemeMode.light);
    await tester.pumpAndSettle();
    expect(find.image(const AssetImage(AppAssets.logoBlack)), findsOneWidget);
    expect(find.image(const AssetImage(AppAssets.logoWhite)), findsNothing);
  });

  testWidgets(
      'floating chat button memiliki stroke putih dan shadow putih tipis saat mode gelap',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
    AppSettings.instance.setThemeMode(AppThemeMode.light);

    await tester.pumpWidget(const app.DinoyoCraftApp());
    await tester.pumpAndSettle();
    appRouter.go('/home');
    await tester.pumpAndSettle();

    Finder findFabContainer() => find.byWidgetPredicate((widget) {
          if (widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).shape == BoxShape.circle) {
            final box = widget.decoration as BoxDecoration;
            return box.color == Colors.black &&
                widget.constraints?.maxWidth == 56;
          }
          return false;
        });

    expect(findFabContainer(), findsOneWidget);

    BoxDecoration fabDeco() =>
        tester.widget<Container>(findFabContainer()).decoration as BoxDecoration;

    // Mode terang: hanya shadow bayangan dasar
    expect(fabDeco().boxShadow!.length, 1);

    // Ganti ke mode gelap
    AppSettings.instance.setThemeMode(AppThemeMode.dark);
    await tester.pumpAndSettle();

    // Mode gelap: border stroke putih terlihat jelas & ada shadow putih tipis
    final darkDeco = fabDeco();
    expect(darkDeco.border, isNotNull);
    expect(darkDeco.border!.top.color, Colors.white.withValues(alpha: 0.35));
    expect(darkDeco.boxShadow!.length, 2);
    expect(darkDeco.boxShadow!.first.color, Colors.white.withValues(alpha: 0.15));

    // Kembalikan ke terang
    AppSettings.instance.setThemeMode(AppThemeMode.light);
    await tester.pumpAndSettle();
    expect(fabDeco().boxShadow!.length, 1);
  });

  testWidgets(
      'icon container Hapus Akun di Pengaturan langsung ikut berubah saat ganti tema',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
    AppSettings.instance.setThemeMode(AppThemeMode.light);

    await tester.pumpWidget(const app.DinoyoCraftApp());
    await tester.pumpAndSettle();
    appRouter.go('/settings');
    await tester.pumpAndSettle();

    Finder findHapusAkunIconBox() => find.ancestor(
          of: find.byIcon(Icons.delete_outline_rounded),
          matching: find.byType(Container),
        ).first;

    BoxDecoration boxDeco() =>
        tester.widget<Container>(findHapusAkunIconBox()).decoration as BoxDecoration;

    // Mode terang: container berlatar terang (0xFFF5F5F5)
    expect(boxDeco().color, const Color(0xFFF5F5F5));

    // Ganti ke mode gelap
    AppSettings.instance.setThemeMode(AppThemeMode.dark);
    await tester.pumpAndSettle();

    // Mode gelap: container harus langsung ikut gelap (0xFF2A2A2A)
    expect(boxDeco().color, const Color(0xFF2A2A2A));

    // Kembalikan ke terang
    AppSettings.instance.setThemeMode(AppThemeMode.light);
    await tester.pumpAndSettle();
    expect(boxDeco().color, const Color(0xFFF5F5F5));
  });

  testWidgets(
      'tombol bawaan hitam (DcButton / ClayBot Asisten) memiliki stroke dan shadow putih tipis saat mode gelap',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 4800);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
    AppSettings.instance.setThemeMode(AppThemeMode.light);

    await tester.pumpWidget(const app.DinoyoCraftApp());
    await tester.pumpAndSettle();
    appRouter.go('/help');
    await tester.pumpAndSettle();

    final buttonFinder = find.widgetWithText(ElevatedButton, 'ClayBot Asisten');
    expect(buttonFinder, findsOneWidget);

    ElevatedButton getButton() => tester.widget<ElevatedButton>(buttonFinder);

    // Mode terang: tidak ada stroke putih
    final lightStyle = getButton().style!;
    expect(lightStyle.side?.resolve({}), isNull);

    // Ganti ke mode gelap
    AppSettings.instance.setThemeMode(AppThemeMode.dark);
    await tester.pumpAndSettle();

    final darkStyle = getButton().style!;
    final side = darkStyle.side?.resolve({});
    expect(side, isNotNull);
    expect(side!.color, Colors.white.withValues(alpha: 0.35));
    expect(side.width, 1.2);

    // Shadow putih tipis pada container pembungkus
    final containerFinder = find
        .ancestor(
          of: buttonFinder,
          matching: find.byType(Container),
        )
        .first;
    final containerDeco =
        tester.widget<Container>(containerFinder).decoration as BoxDecoration?;
    expect(containerDeco?.boxShadow, isNotNull);
    expect(containerDeco!.boxShadow!.first.color,
        Colors.white.withValues(alpha: 0.12));

    // Kembalikan ke terang
    AppSettings.instance.setThemeMode(AppThemeMode.light);
    await tester.pumpAndSettle();
    expect(getButton().style!.side?.resolve({}), isNull);
  });

  testWidgets(
      'teks link dan kode voucher di modal Notifikasi berwarna kontras (ink) saat mode gelap',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
    AppSettings.instance.setThemeMode(AppThemeMode.dark);

    await tester.pumpWidget(const app.DinoyoCraftApp());
    await tester.pumpAndSettle();
    appRouter.go('/notifications');
    await tester.pumpAndSettle();

    final salinTextFinder = find.text('Salin Voucher');
    expect(salinTextFinder, findsOneWidget);
    final salinTextColor = tester.widget<Text>(salinTextFinder).style?.color;
    expect(salinTextColor, const Color(0xFFF5F5F5));

    final codeTextFinder = find.text('DINOYOKARYA');
    expect(codeTextFinder, findsOneWidget);
    final codeTextColor = tester.widget<Text>(codeTextFinder).style?.color;
    expect(codeTextColor, const Color(0xFFF5F5F5));

    final workshopTextFinder = find.text('Lihat Detail Workshop');
    expect(workshopTextFinder, findsOneWidget);
    final workshopTextColor =
        tester.widget<Text>(workshopTextFinder).style?.color;
    expect(workshopTextColor, const Color(0xFFF5F5F5));

    // Kembalikan ke mode terang
    AppSettings.instance.setThemeMode(AppThemeMode.light);
    await tester.pumpAndSettle();
    final lightSalinTextColor =
        tester.widget<Text>(salinTextFinder).style?.color;
    expect(lightSalinTextColor, const Color(0xFF1A1A1A));
  });

  testWidgets(
      'opsi tema yang dipilih di modal Tema Tampilan memiliki border, icon, dan checkmark putih saat mode gelap',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
    AppSettings.instance.setThemeMode(AppThemeMode.dark);

    await tester.pumpWidget(const app.DinoyoCraftApp());
    await tester.pumpAndSettle();
    appRouter.go('/settings');
    await tester.pumpAndSettle();

    // Scroll ke tile Tema Tampilan lalu tap untuk membuka modal bottom sheet
    final themeTileFinder = find.text('Tema Tampilan');
    await tester.ensureVisible(themeTileFinder);
    await tester.pumpAndSettle();
    await tester.tap(themeTileFinder);
    await tester.pumpAndSettle();

    expect(find.text('Pilih Tema Tampilan'), findsOneWidget);

    // Opsi Gelap (Dark Mode) adalah mode yang sedang dipilih
    final checkIconFinder = find.byIcon(Icons.check_circle_rounded);
    expect(checkIconFinder, findsOneWidget);
    final checkIcon = tester.widget<Icon>(checkIconFinder);
    // Di mode gelap, checkmark harus putih (Colors.white), bukan hitam!
    expect(checkIcon.color, Colors.white);

    // Ikon bulan pada opsi Gelap (Dark Mode) di dalam modal
    final moonIconFinder = find.byIcon(Icons.dark_mode_outlined).last;
    final moonIcon = tester.widget<Icon>(moonIconFinder);
    // Di mode gelap, ikon opsi yang dipilih harus putih (Colors.white), bukan hitam!
    expect(moonIcon.color, Colors.white);

    // Kembalikan ke mode terang
    AppSettings.instance.setThemeMode(AppThemeMode.light);
    await tester.pumpAndSettle();
  });

  testWidgets(
      'tombol gender di DataDiriScreen memiliki kontras tinggi saat dipilih di mode gelap',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.reset();
      AppSettings.instance.setThemeMode(AppThemeMode.light);
    });

    AppSettings.instance.setThemeMode(AppThemeMode.dark);
    await tester.pumpWidget(
      const MaterialApp(
        home: DataDiriScreen(),
      ),
    );
    await tester.pumpAndSettle();

    final maleFinder = find.text('Laki-laki');
    await tester.scrollUntilVisible(
      maleFinder,
      150,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    // Default: 'Laki-laki' terpilih (selected)
    // Di mode gelap, tombol terpilih harus berlatar putih dengan teks hitam
    final maleText = tester.widget<Text>(maleFinder);
    expect(maleText.style?.color, AppColors.black);

    // Tombol tidak terpilih 'Perempuan' harus berwarna textSecondary (abu-abu)
    final femaleFinder = find.text('Perempuan');
    final femaleText = tester.widget<Text>(femaleFinder);
    expect(femaleText.style?.color, AppColors.textSecondary);

    // Tap Perempuan
    await tester.tap(femaleFinder);
    await tester.pumpAndSettle();

    // Sekarang Perempuan yang terpilih (teks hitam) dan Laki-laki tidak terpilih (textSecondary)
    final femaleTextAfter = tester.widget<Text>(femaleFinder);
    expect(femaleTextAfter.style?.color, AppColors.black);
    final maleTextAfter = tester.widget<Text>(maleFinder);
    expect(maleTextAfter.style?.color, AppColors.textSecondary);
  });
}
