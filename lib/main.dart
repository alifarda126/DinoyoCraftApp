import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';

import 'core/app_settings.dart';
import 'core/network/api_client.dart';
import 'core/storage/local_storage.dart';
import 'core/router/app_router.dart';
import 'core/services/app_info_service.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/fcm_service.dart';
import 'core/services/pusher_service.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/fcm_notification_banner.dart';
import 'core/widgets/connection_gate.dart';
import 'core/widgets/keyboard_dismiss_wrapper.dart';
import 'core/widgets/top_toast.dart';
import 'data/mock_data.dart';

Future<void> _initFirebaseAndPushServices() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    FlutterError.onError = (errorDetails) {
      if (Firebase.apps.isNotEmpty) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      }
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      if (Firebase.apps.isNotEmpty) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      }
      return true;
    };
  } catch (e) {
    debugPrint('[Crashlytics] Safe initialization fallback: $e');
  }
  await FcmService.instance.initialize();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  final cachedRole = LocalStorage.getUser()?['role']?.toString().trim();
  if (LocalStorage.isLoggedIn &&
      cachedRole != null &&
      cachedRole.isNotEmpty &&
      cachedRole != 'pengunjung') {
    await LocalStorage.clearAuth();
  }
  await ApiClient.init();
  await AppSettings.instance.loadSavedPreferences();
  unawaited(MockData.fetchPublicData());
  if (!kIsWeb) {
    AppSettings.instance.syncCacheSize();
  }

  // Render UI pertama secepat mungkin agar layar logo statis (bagi user yg sudah login)
  // langsung tampil tanpa tertahan layar hitam selama inisialisasi Firebase.
  unawaited(_initFirebaseAndPushServices());
  unawaited(ConnectivityService.instance.initialize());
  MockData.hookConnectivity(ConnectivityService.instance.isOnlineNotifier);
  unawaited(AppInfoService.instance.initialize());
  unawaited(PusherService.instance.init());
  runApp(const DinoyoCraftApp());
}

class DinoyoCraftApp extends StatefulWidget {
  const DinoyoCraftApp({super.key});

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

            // Status bar & navigation bar ikut mode tema â€” tanpa ini ikon
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
            // berubah â€” state navigator (route, input, scroll) tetap utuh
            // karena reparenting GlobalKey milik go_router.
            return KeyboardDismissWrapper(
              child: KeyedSubtree(
                key: ValueKey((isDark, settings.locale)),
                child: OfflineBannerWrapper(
                  child: ConnectionGate(
                    child: TopToastHost(
                      child: FcmNotificationHost(
                        child: child ?? const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
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
