import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/app_settings.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/keyboard_dismiss_wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppSettings.instance.syncCacheSize();
  runApp(DinoyoCraftApp());
}

class DinoyoCraftApp extends StatefulWidget {
const   DinoyoCraftApp({super.key});

  @override
  State<DinoyoCraftApp> createState() => _DinoyoCraftAppState();
}

class _DinoyoCraftAppState extends State<DinoyoCraftApp> {
  @override
  void initState() {
    super.initState();
    // Reaksi terhadap perubahan tema sistem saat mode "Ikuti Sistem".
    WidgetsBinding.instance.addObserver(systemThemeObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(systemThemeObserver);
    super.dispose();
  }

  final systemThemeObserver = _SystemThemeObserver();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppSettings.instance,
      builder: (context, _) {
        final settings = AppSettings.instance;

        // ThemeMode menentukan tema Material. Token warna kustom disinkronkan
        // kembali di builder MaterialApp dari brightness yang benar-benar aktif.
        final themeMode = switch (settings.themeMode) {
          AppThemeMode.light => ThemeMode.light,
          AppThemeMode.dark => ThemeMode.dark,
          AppThemeMode.system => ThemeMode.system,
        };
        // Bahasa UI dikendalikan AppText (tak butuh delegates ARB).

        return MaterialApp.router(
          title: 'DinoyoCraft',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          routerConfig: appRouter,
          builder: (context, child) {
            // Gunakan brightness dari Theme di dalam MaterialApp, bukan status
            // lama sebelum perpindahan mode selesai dibangun.
            final isDark = Theme.of(context).brightness == Brightness.dark;
            AppColors.isDark = isDark;

            // Status bar & navigation bar ikut mode tema — tanpa ini ikon
            // status bar gelap tak terlihat di mode gelap.
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness:
                    isDark ? Brightness.light : Brightness.dark,
                statusBarBrightness:
                    isDark ? Brightness.dark : Brightness.light,
                systemNavigationBarColor:
                    isDark ? const Color(0xFF121212) : Colors.white,
                systemNavigationBarIconBrightness:
                    isDark ? Brightness.light : Brightness.dark,
              ),
            );

            // Layar membaca token warna (AppColors) saat build. Pergantian
            // tema/bahasa tidak otomatis membangun ulang subtree di bawah
            // Router, sehingga warna lama terpakai sampai hot reload. Key
            // di bawah memaksa seluruh subtree dibangun ulang SAAT mode
            // berubah — state navigator (route, input, scroll) tetap utuh
            // karena reparenting GlobalKey milik go_router.
            return KeyboardDismissWrapper(
              child: KeyedSubtree(
                key: ObjectKey((isDark, settings.locale)),
                child: child ?? const SizedBox.shrink(),
              ),
            );
          },
        );
      },
    );
  }
}

/// Memaksa rebuild saat kecerahan sistem berubah (mode Ikuti Sistem).
class _SystemThemeObserver extends WidgetsBindingObserver {
  @override
  void didChangePlatformBrightness() {
    AppSettings.instance.refresh();
  }
}
