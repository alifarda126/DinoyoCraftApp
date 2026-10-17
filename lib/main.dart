import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/app_settings.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Pastikan konten tidak menembus status bar
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
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

        // Sinkronkan flag warna global SEBELUM subtree dibangun.
        final platformDark =
            View.of(context).platformDispatcher.platformBrightness ==
                Brightness.dark;
        AppColors.isDark = switch (settings.themeMode) {
          AppThemeMode.light => false,
          AppThemeMode.dark => true,
          AppThemeMode.system => platformDark,
        };
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
