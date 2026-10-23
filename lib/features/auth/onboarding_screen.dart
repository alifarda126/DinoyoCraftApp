import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_text.dart';
import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_back_scope.dart';
import '../../core/widgets/dc_button.dart';

/// Clipper untuk Bagian 1 (Atas): Leher, bibir, dan bahu atas vas keramik.
class LogoTopPartClipper extends CustomClipper<Path> {
  const LogoTopPartClipper();

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(w, 0);
    path.lineTo(w, h * 0.38);
    // Boundary B: Garis potong sisi kanan menuju titik temu tengah
    path.quadraticBezierTo(w * 0.75, h * 0.42, w * 0.60, h * 0.48);
    path.lineTo(w * 0.51, h * 0.53);
    // Boundary A: Garis potong sisi kiri dari tengah ke tepi kiri
    path.quadraticBezierTo(w * 0.35, h * 0.46, w * 0.20, h * 0.40);
    path.lineTo(0, h * 0.36);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Clipper untuk Bagian 2 (Kiri Bawah): Siluet tangan pengrajin dan jemari.
class LogoHandPartClipper extends CustomClipper<Path> {
  const LogoHandPartClipper();

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();
    path.moveTo(0, h * 0.36);
    // Boundary A: Mengikuti garis potong kiri menuju titik temu tengah
    path.lineTo(w * 0.20, h * 0.40);
    path.quadraticBezierTo(w * 0.35, h * 0.46, w * 0.51, h * 0.53);
    // Boundary C: Garis pemisah tengah ke bawah antara tangan dan daun
    path.quadraticBezierTo(w * 0.53, h * 0.68, w * 0.58, h * 0.82);
    path.lineTo(w * 0.60, h);
    path.lineTo(0, h);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Clipper untuk Bagian 3 (Kanan Bawah): Siluet helai daun / lekukan keramik.
class LogoLeafPartClipper extends CustomClipper<Path> {
  const LogoLeafPartClipper();

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();
    path.moveTo(w * 0.51, h * 0.53);
    // Boundary B: Mengikuti garis potong kanan menuju tepi kanan
    path.lineTo(w * 0.60, h * 0.48);
    path.quadraticBezierTo(w * 0.75, h * 0.42, w, h * 0.38);
    path.lineTo(w, h);
    path.lineTo(w * 0.60, h);
    // Boundary C: Menelusuri kembali batas bawah ke titik temu tengah
    path.lineTo(w * 0.58, h * 0.82);
    path.quadraticBezierTo(w * 0.53, h * 0.68, w * 0.51, h * 0.53);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    this.showEntranceAnimation,
  });

  /// Status apakah animasi masuk logo pernah dijalankan di sesi aplikasi ini.
  /// Setelah dijalankan pertama kali, animasi tidak akan diputar ulang saat logout / kembali.
  static bool hasPlayedEntranceAnimation = false;

  /// Jika null, default membaca !hasPlayedEntranceAnimation (hanya jalan pertama kali saat aplikasi dibuka).
  final bool? showEntranceAnimation;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  bool _introFinished = false;

  @override
  void initState() {
    super.initState();

    final shouldPlay = widget.showEntranceAnimation ??
        !OnboardingScreen.hasPlayedEntranceAnimation;

    if (!shouldPlay) {
      _introFinished = true;
    } else {
      OnboardingScreen.hasPlayedEntranceAnimation = true;
    }

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5500),
    );

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {
          _introFinished = true;
        });
      }
    });

    if (shouldPlay) {
      // Stopwatch animasi JANGAN dimulai saat initState. Saat cold start, frame
      // pertama butuh waktu lama untuk dirender (decode aset, shader compile),
      // sehingga jika controller sudah berjalan, seluruh fase awal (Decon-
      // struction) terlewat sebelum frame pertama tampil di layar. Mulai tik
      // hanya SETELAH frame pertama selesai dibangun agar fase 1 terlihat penuh.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_introFinished) {
          _animController.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _skipIntro() {
    if (_introFinished) return;
    _animController.stop();
    setState(() {
      _introFinished = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget content;
    // Jika animasi pengantar telah selesai, tampilkan Onboarding standar
    if (_introFinished) {
      content = _buildSettledOnboarding(context);
    } else {
      content = LayoutBuilder(
        builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final topPadding = MediaQuery.of(context).padding.top;

        // Koordinat target di wadah badge logo header kiri atas:
        // SafeArea padding: left: 24, top: topPadding + 16
        // Wadah container 44x44 dengan padding 6 -> logo di dalamnya berukuran 32x32
        const targetSize = 32.0;
        const targetX = 24.0 + 6.0;
        final targetY = topPadding + 16.0 + 6.0;

        // Posisi awal di tengah layar
        const startSize = 110.0;
        final startX = (screenWidth - startSize) / 2;
        final startY = (screenHeight - startSize) / 2 - 32.0;

        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          body: GestureDetector(
            onTap: _skipIntro,
            behavior: HitTestBehavior.opaque,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ── Layer 1: Halaman Onboarding Lengkap (Fade in saat transisi Phase 4) ──
                AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) {
                    final onboardingFade = CurvedAnimation(
                      parent: _animController,
                      curve: const Interval(0.727, 0.960, curve: Curves.easeIn),
                    ).value;

                    return Opacity(
                      opacity: onboardingFade,
                      child: child,
                    );
                  },
                  child: _buildSettledOnboarding(context, hideBadgeLogo: true),
                ),

                // ── Layer 2: Intro Canvas Hitam Polos ──
                AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) {
                    final canvasFade = 1.0 -
                        CurvedAnimation(
                          parent: _animController,
                          curve: const Interval(0.727, 0.960,
                              curve: Curves.easeOut),
                        ).value;

                    return Opacity(
                      opacity: canvasFade,
                      child: Container(
                        color: const Color(0xFF121212),
                      ),
                    );
                  },
                ),

                // ── Layer 3: Teks Identitas Merek di Tengah (Phase 3: Identity Full Brand Lockup) ──
                AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) {
                    // DinoyoCraft muncul setelah kepingan menyatu
                    final titleFadeIn = CurvedAnimation(
                      parent: _animController,
                      curve: const Interval(0.220, 0.350, curve: Curves.easeOut),
                    ).value;

                    // Tagline muncul bertahap (in sequence)
                    final subtitleFadeIn = CurvedAnimation(
                      parent: _animController,
                      curve: const Interval(0.455, 0.580, curve: Curves.easeOut),
                    ).value;

                    final textFadeOut = 1.0 -
                        CurvedAnimation(
                          parent: _animController,
                          curve: const Interval(0.690, 0.730, curve: Curves.easeIn),
                        ).value;

                    final titleOpacity = (titleFadeIn * textFadeOut).clamp(0.0, 1.0);
                    final subOpacity = (subtitleFadeIn * textFadeOut).clamp(0.0, 1.0);
                    final slideY = (1.0 - titleFadeIn) * 8.0;

                    return Positioned(
                      top: startY + startSize - 12.0 + slideY,
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Opacity(
                            opacity: titleOpacity,
                            child: Text(
                              'DinoyoCraft',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Opacity(
                            opacity: subOpacity,
                            child: Text(
                              'KARYA OTENTIK SENTRA KERAMIK DINOYO',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFB5A49D),
                                letterSpacing: 1.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // ── Layer 4: 4-Fase Storyboard Logo Intro Animation ──
                AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) {
                    final animVal = _animController.value;

                    // (1) Phase 1: Deconstruction — Logo Pieces Inward [0.0s - 1.2s] (0.00 - 0.218)
                    // Kepingan meluncur masuk dari luar layar (outside frame boundaries) menuju pusat
                    final inProgress = CurvedAnimation(
                      parent: _animController,
                      curve: const Interval(0.00, 0.218,
                          curve: Curves.easeOutCubic),
                    ).value;

                    // (2) Phase 2: Convergence — Magnetic Snap & Glow [1.2s - 2.5s] (0.218 - 0.455)
                    final snapBounceProgress = CurvedAnimation(
                      parent: _animController,
                      curve: const Interval(0.218, 0.290,
                          curve: Curves.easeOutBack),
                    ).value;
                    final snapScale =
                        1.0 + (0.06 * (1.0 - (snapBounceProgress - 0.5).abs() * 2));

                    // Golden fusion glow radiates from the seams at the moment of completion
                    double flashOpacity = 0.0;
                    if (animVal >= 0.218 && animVal <= 0.455) {
                      final rel = (animVal - 0.218) / (0.455 - 0.218);
                      if (rel < 0.15) {
                        flashOpacity = rel / 0.15;
                      } else if (rel < 0.65) {
                        flashOpacity = 1.0;
                      } else {
                        flashOpacity = (1.0 - rel) / 0.35;
                      }
                    }

                    // (3) Phase 3: Identity — The logo pulses slightly [2.5s - 4.0s] (0.455 - 0.727)
                    double pulseScale = 1.0;
                    if (animVal >= 0.455 && animVal <= 0.700) {
                      final p = (animVal - 0.455) / (0.700 - 0.455);
                      pulseScale = 1.0 + 0.035 * math.sin(p * math.pi * 2);
                    }

                    // (4) Phase 4: Application — Move to App Badge [4.0s - 5.5s] (0.727 - 0.960)
                    // Graceful curved motion path into the top-left corner glass icon badge
                    final flightProgress = CurvedAnimation(
                      parent: _animController,
                      curve: const Interval(0.727, 0.960,
                          curve: Curves.easeInOutCubicEmphasized),
                    ).value;

                    final currentX =
                        ui.lerpDouble(startX, targetX, flightProgress)!;
                    // Jalur lengkung anggun (curved motion path)
                    final curveArc = math.sin(flightProgress * math.pi) * 32.0;
                    final currentY =
                        ui.lerpDouble(startY, targetY, flightProgress)! - curveArc;
                    final currentSize =
                        ui.lerpDouble(startSize, targetSize, flightProgress)!;

                    // Offset masing-masing pecahan dari LUAR BINGKAI logo
                    // (outside frame boundaries) — bukan luar layar. Sesuai
                    // storyboard, kepingan harus terlihat mengapung masuk ke
                    // pusat sejak frame pertama fase Deconstruction.
                    // Bagian 1: Atas (Leher/Bibir Vas) datang dari atas bingkai
                    final topOffset = Offset(
                      ui.lerpDouble(startSize * 0.14, 0.0, inProgress)!,
                      ui.lerpDouble(-startSize * 1.35, 0.0, inProgress)!,
                    );
                    final topRotate =
                        ui.lerpDouble(-0.25, 0.0, inProgress)!;

                    // Bagian 2: Kiri Bawah (Tangan Pengrajin) dari kiri bingkai
                    final handOffset = Offset(
                      ui.lerpDouble(-startSize * 1.25, 0.0, inProgress)!,
                      ui.lerpDouble(startSize * 0.62, 0.0, inProgress)!,
                    );
                    final handRotate =
                        ui.lerpDouble(0.28, 0.0, inProgress)!;

                    // Bagian 3: Kanan Bawah (Daun Keramik) dari kanan bingkai
                    final leafOffset = Offset(
                      ui.lerpDouble(startSize * 1.25, 0.0, inProgress)!,
                      ui.lerpDouble(startSize * 0.66, 0.0, inProgress)!,
                    );
                    final leafRotate =
                        ui.lerpDouble(-0.30, 0.0, inProgress)!;

                    final combinedScale = flightProgress > 0.0
                        ? 1.0
                        : (snapScale * pulseScale);

                    return Positioned(
                      left: currentX,
                      top: currentY,
                      width: currentSize,
                      height: currentSize,
                      child: Transform.scale(
                        scale: combinedScale,
                        child: Stack(
                          key: const Key('logo_motion_intro'),
                          clipBehavior: Clip.none,
                          fit: StackFit.expand,
                          children: [
                            // ── Efek Pendar Kilau Emas Kintsugi (Convergence Golden Fusion Glow) ──
                            if (flashOpacity > 0.0 && flightProgress == 0.0) ...[
                              Positioned(
                                left: -45,
                                top: -45,
                                width: startSize + 90,
                                height: startSize + 90,
                                child: Opacity(
                                  opacity:
                                      (flashOpacity * 0.85).clamp(0.0, 1.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          Color(0xFFFFE8A3),
                                          Color(0xFFFFD580),
                                          Color(0x77D4AF37),
                                          Colors.transparent,
                                        ],
                                        stops: [0.0, 0.35, 0.65, 1.0],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],

                            // Bagian 1: Atas (Leher/Bibir Vas) — tampil penuh,
                            // tidak diperlukan fade agar fase 1 langsung terlihat
                            Transform.translate(
                              offset: topOffset,
                              child: Transform.rotate(
                                angle: topRotate,
                                child: ClipPath(
                                  key: const Key('logo_piece_top'),
                                  clipper: const LogoTopPartClipper(),
                                  child: Image.asset(
                                    AppAssets.logoWhite,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),

                            // Bagian 2: Kiri Bawah (Tangan Pengrajin)
                            Transform.translate(
                              offset: handOffset,
                              child: Transform.rotate(
                                angle: handRotate,
                                child: ClipPath(
                                  key: const Key('logo_piece_hand'),
                                  clipper: const LogoHandPartClipper(),
                                  child: Image.asset(
                                    AppAssets.logoWhite,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),

                            // Bagian 3: Kanan Bawah (Daun Keramik)
                            Transform.translate(
                              offset: leafOffset,
                              child: Transform.rotate(
                                angle: leafRotate,
                                child: ClipPath(
                                  key: const Key('logo_piece_leaf'),
                                  clipper: const LogoLeafPartClipper(),
                                  child: Image.asset(
                                    AppAssets.logoWhite,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  return DoubleBackExitScope(
    bottomOffset: 40,
    child: content,
  );
}

  /// Membangun tampilan utama Onboarding setelah animasi masuk logo selesai
  Widget _buildSettledOnboarding(BuildContext context,
      {bool hideBadgeLogo = false}) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Gambar Latar dengan Penyesuaian Visual ──
          Image.asset(
            AppAssets.onboardingBg,
            fit: BoxFit.cover,
            alignment: const Alignment(0, -0.2),
          ),

          // ── Gradient Overlay ──
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.45),
                  Colors.black.withValues(alpha: 0.05),
                  Colors.transparent,
                  AppColors.bg.withValues(alpha: 0.82),
                  AppColors.bg,
                ],
                stops: const [0, 0.22, 0.48, 0.7, 1],
              ),
            ),
          ),

          // ── Elemen Teks dan Tombol Onboarding ──
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Brand Badge
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.white.withValues(alpha: 0.35),
                          ),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: hideBadgeLogo
                            ? const SizedBox.shrink()
                            : Image.asset(
                                AppAssets.logoWhite,
                                fit: BoxFit.contain,
                              ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'DinoyoCraft',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Heading Title
                  Text.rich(
                    TextSpan(
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        height: 1.18,
                        letterSpacing: -0.6,
                        color: AppColors.ink,
                      ),
                      children: [
                        TextSpan(text: 'Temukan Cerita di Balik Setiap '.tr),
                        TextSpan(
                          text: 'Keramik!'.tr,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.italic,
                            height: 1.18,
                            letterSpacing: -0.6,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Subtitle Description
                  Text(
                    'Jelajahi karya lokal Dinoyo, temukan pengrajin pilihan, '
                            'dan rasakan pengalaman kreatif di balik setiap tanah liat.'
                        .tr,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      height: 1.55,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Tombol "Mulai Menjelajah"
                  DcButton(
                    label: 'Mulai Menjelajah'.tr,
                    trailingIconPath: AppAssets.arrowRight,
                    onPressed: () => context.go('/login'),
                  ),

                  const SizedBox(height: 18),

                  // Link "Belum punya akun? Daftar"
                  Center(
                    child: GestureDetector(
                      onTap: () => context.go('/register'),
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text.rich(
                          TextSpan(
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                            children: [
                              TextSpan(text: 'Belum punya akun? '.tr),
                              TextSpan(
                                text: 'Daftar'.tr,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.ink,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shared back app bar for auth screens.
class AuthBackHeader extends StatelessWidget implements PreferredSizeWidget {
  const AuthBackHeader({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: onBack ??
            () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
        icon: SvgPicture.asset(
          AppAssets.iconBack,
          width: 22,
          height: 22,
          colorFilter: ColorFilter.mode(AppColors.ink, BlendMode.srcIn),
        ),
      ),
    );
  }
}
