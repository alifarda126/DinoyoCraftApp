import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/assets.dart';
import '../../core/services/fcm_service.dart';

/// Layar pembuka statis (tanpa animasi) khusus pengguna yang sudah login
/// saat membuka kembali aplikasi dari cold-start (gaya Instagram).
class AppLaunchSplashScreen extends StatefulWidget {
  const AppLaunchSplashScreen({super.key});

  /// Menandai apakah splash pembuka sudah pernah tampil pada sesi proses ini.
  static bool hasShownInitialSplash = false;

  @override
  State<AppLaunchSplashScreen> createState() => _AppLaunchSplashScreenState();
}

class _AppLaunchSplashScreenState extends State<AppLaunchSplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    AppLaunchSplashScreen.hasShownInitialSplash = true;

    // Jika aplikasi dibuka melalui ketukan push notifikasi, langsung arahkan
    // tanpa menunggu durasi splash penuh.
    if (FcmService.instance.hasPendingInitialRoute) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _finishSplash());
      return;
    }

    _timer = Timer(const Duration(milliseconds: 950), _finishSplash);
  }

  void _finishSplash() {
    if (!mounted) return;
    context.go('/home');
    // Jika ada deep-link notifikasi cold-start yang tertunda, jalankan segera setelah /home aktif.
    FcmService.instance.flushPendingInitialRoute();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFF121212),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: Center(
          child: Image.asset(
            AppAssets.logoWhite,
            width: 96,
            height: 96,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
