import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_text.dart';
import '../theme/app_colors.dart';

/// Scope untuk halaman yang MEMILIKI tombol kembali (seperti auth screens, detail screens, dll).
/// Saat pengguna menggunakan gestur kembali bawaan HP (Android back gesture / back button),
/// aplikasi TIDAK akan langsung keluar, melainkan menjalankan aksi kembali yang sesuai
/// ([onBack] atau pop ke route sebelumnya, atau fallback ke [fallbackRoute]).
class AppBackScope extends StatelessWidget {
  const AppBackScope({
    super.key,
    required this.child,
    this.onBack,
    this.fallbackRoute,
  });

  final Widget child;

  /// Aksi kustom saat tombol/gestur kembali ditekan.
  /// Jika null, default memanggil `context.pop()` jika `context.canPop() == true`,
  /// atau `context.go(fallbackRoute ?? '/home')` jika tidak bisa pop.
  final VoidCallback? onBack;

  /// Rute tujuan jika stack navigasi kosong dan tidak bisa di-pop.
  final String? fallbackRoute;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (onBack != null) {
          onBack!();
        } else if (context.canPop()) {
          context.pop();
        } else if (fallbackRoute != null) {
          context.go(fallbackRoute!);
        } else {
          context.go('/home');
        }
      },
      child: child,
    );
  }
}

/// Scope untuk tampilan yang TIDAK MEMILIKI tombol kembali (seperti MainShell root tabs, Onboarding).
/// Saat pengguna menggunakan gestur kembali bawaan HP:
/// - Tekanan ke-1: Menampilkan pop-up toast floating "Tekan sekali lagi untuk keluar".
/// - Tekanan ke-2 (dalam interval 2 detik): Aplikasi keluar (SystemNavigator.pop).
class DoubleBackExitScope extends StatefulWidget {
  const DoubleBackExitScope({
    super.key,
    required this.child,
    this.bottomOffset = 96.0,
    this.exitDuration = const Duration(seconds: 2),
    this.message,
    this.onExit,
  });

  final Widget child;

  /// Jarak vertikal toast dari batas bawah layar (misalnya di atas navbar).
  final double bottomOffset;

  /// Interval waktu maksimal antara gestur pertama dan kedua untuk keluar.
  final Duration exitDuration;

  /// Pesan yang ditampilkan di toast (default: 'Tekan sekali lagi untuk keluar').
  final String? message;

  /// Callback kustom saat benar-benar keluar (default: SystemNavigator.pop).
  /// Berguna untuk testing.
  final VoidCallback? onExit;

  @override
  State<DoubleBackExitScope> createState() => _DoubleBackExitScopeState();
}

class _DoubleBackExitScopeState extends State<DoubleBackExitScope>
    with SingleTickerProviderStateMixin {
  DateTime? _lastBackPressTime;
  OverlayEntry? _toastEntry;
  Timer? _dismissTimer;
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(_fadeAnimation);
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _removeToastEntry();
    _animController.dispose();
    super.dispose();
  }

  void _removeToastEntry() {
    _toastEntry?.remove();
    _toastEntry = null;
  }

  void _handleBack() {
    final now = DateTime.now();
    if (_lastBackPressTime != null &&
        now.difference(_lastBackPressTime!) <= widget.exitDuration) {
      // Tekanan ke-2 dalam rentang waktu: keluar aplikasi
      _dismissTimer?.cancel();
      _removeToastEntry();
      _lastBackPressTime = null;
      if (widget.onExit != null) {
        widget.onExit!();
      } else {
        SystemNavigator.pop();
      }
      return;
    }

    _lastBackPressTime = now;
    _showToast();
  }

  void _showToast() {
    _dismissTimer?.cancel();
    _removeToastEntry();

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    final displayMessage = widget.message ??
        (AppText.isEnglish
            ? 'Press back again to exit'
            : 'Tekan sekali lagi untuk keluar'.tr);

    _toastEntry = OverlayEntry(
      builder: (context) {
        final isDark = AppColors.isDark;
        return Positioned(
          left: 20,
          right: 20,
          bottom: widget.bottomOffset,
          child: IgnorePointer(
            ignoring: true,
            child: Material(
              type: MaterialType.transparency,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xF02A2A2E)
                            : const Color(0xE81C1C1E),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Colors.white.withValues(
                            alpha: isDark ? 0.16 : 0.12,
                          ),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? 0.45 : 0.28,
                            ),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 16,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              displayMessage,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_toastEntry!);
    _animController.forward(from: 0.0);

    _dismissTimer = Timer(widget.exitDuration, () async {
      if (!mounted) return;
      try {
        await _animController.reverse();
      } catch (_) {}
      _removeToastEntry();
      _lastBackPressTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: widget.child,
    );
  }
}
