import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_text.dart';
import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';
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
    this.showEntranceAnimation = true,
  });

  /// Jika false, langsung tampilkan halaman onboarding tanpa animasi masuk logo
  final bool showEntranceAnimation;

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

    if (!widget.showEntranceAnimation) {
      _introFinished = true;
    }

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {
          _introFinished = true;
        });
      }
    });

    if (widget.showEntranceAnimation) {
      _animController.forward();
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
    // Jika animasi pengantar telah selesai, tampilkan Onboarding standar
    if (_introFinished) {
      return _buildSettledOnboarding(context);
    }

    return LayoutBuilder(
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
                // ── Layer 1: Halaman Onboarding Lengkap (Fade in saat transisi logo) ──
                AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) {
                    final onboardingFade = CurvedAnimation(
                      parent: _animController,
                      curve: const Interval(0.66, 0.90, curve: Curves.easeIn),
                    ).value;

                    return Opacity(
                      opacity: onboardingFade,
                      child: child,
                    );
                  },
                  child: _buildSettledOnboarding(context, hideBadgeLogo: true),
                ),

                // ── Layer 2: Intro Canvas & Partikel/Aura Cahaya ──
                AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) {
                    final canvasFade = 1.0 -
                        CurvedAnimation(
                          parent: _animController,
                          curve:
                              const Interval(0.66, 0.90, curve: Curves.easeOut),
                        ).value;

                    return Opacity(
                      opacity: canvasFade,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment(0, -0.1),
                            radius: 1.1,
                            colors: [
                              Color(0xFF241C1A),
                              Color(0xFF141212),
                              Color(0xFF0D0C0C),
                            ],
                            stops: [0.0, 0.6, 1.0],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // ── Layer 3: Teks Identitas Merek di Tengah (Phase 2) ──
                AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) {
                    final textFadeIn = CurvedAnimation(
                      parent: _animController,
                      curve: const Interval(0.42, 0.55, curve: Curves.easeOut),
                    ).value;

                    final textFadeOut = 1.0 -
                        CurvedAnimation(
                          parent: _animController,
                          curve:
                              const Interval(0.62, 0.72, curve: Curves.easeIn),
                        ).value;

                    final opacity = (textFadeIn * textFadeOut).clamp(0.0, 1.0);
                    final slideY = (1.0 - textFadeIn) * 16.0;

                    return Positioned(
                      top: startY + startSize + 20.0 + slideY,
                      left: 0,
                      right: 0,
                      child: Opacity(
                        opacity: opacity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'DinoyoCraft',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'KARYA OTENTIK SENTRA KERAMIK DINOYO',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFB5A49D),
                                letterSpacing: 1.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // ── Layer 4: Pecahan Logo & Logo Terbang Menuju Badge ──
                AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) {
                    // Phase 1: Pecahan Meluncur Masuk (0.00 - 0.36)
                    final inProgress = CurvedAnimation(
                      parent: _animController,
                      curve: const Interval(0.00, 0.36,
                          curve: Curves.easeOutCubic),
                    ).value;

                    // Snap bounce saat menyatu di detik 0.36 - 0.48
                    final bounceProgress = CurvedAnimation(
                      parent: _animController,
                      curve: const Interval(0.36, 0.48,
                          curve: Curves.easeOutBack),
                    ).value;
                    final bounceScale =
                        1.0 + (0.08 * (1.0 - (bounceProgress - 0.5).abs() * 2));

                    // Kilatan garis sambungan emas saat menyatu (0.35 - 0.46)
                    final flashProgress = CurvedAnimation(
                      parent: _animController,
                      curve: const Interval(0.35, 0.46, curve: Curves.easeInOut),
                    ).value;
                    final flashOpacity =
                        (flashProgress <= 0.5
                                ? flashProgress * 2
                                : (1.0 - flashProgress) * 2)
                            .clamp(0.0, 1.0);

                    // Phase 3: Terbang meluncur ke wadah badge (0.66 - 0.90)
                    final flightProgress = CurvedAnimation(
                      parent: _animController,
                      curve: const Interval(0.66, 0.90,
                          curve: Curves.easeInOutCubicEmphasized),
                    ).value;

                    final currentX =
                        ui.lerpDouble(startX, targetX, flightProgress)!;
                    final currentY =
                        ui.lerpDouble(startY, targetY, flightProgress)!;
                    final currentSize =
                        ui.lerpDouble(startSize, targetSize, flightProgress)!;

                    // Offset masing-masing pecahan
                    final topOffset = Offset(
                      0,
                      ui.lerpDouble(-90.0, 0.0, inProgress)!,
                    );
                    final topRotate =
                        ui.lerpDouble(-0.08, 0.0, inProgress)!;

                    final handOffset = Offset(
                      ui.lerpDouble(-90.0, 0.0, inProgress)!,
                      ui.lerpDouble(60.0, 0.0, inProgress)!,
                    );
                    final handRotate =
                        ui.lerpDouble(0.08, 0.0, inProgress)!;

                    final leafOffset = Offset(
                      ui.lerpDouble(90.0, 0.0, inProgress)!,
                      ui.lerpDouble(60.0, 0.0, inProgress)!,
                    );
                    final leafRotate =
                        ui.lerpDouble(-0.10, 0.0, inProgress)!;

                    return Positioned(
                      left: currentX,
                      top: currentY,
                      width: currentSize,
                      height: currentSize,
                      child: Transform.scale(
                        scale: flightProgress > 0.0 ? 1.0 : bounceScale,
                        child: Stack(
                          key: const Key('logo_motion_intro'),
                          fit: StackFit.expand,
                          children: [
                            // Efek pendar kilau emas saat kepingan menyatu (Kintsugi Golden Glow)
                            if (flashOpacity > 0.0 && flightProgress == 0.0)
                              Positioned.fill(
                                child: Opacity(
                                  opacity: flashOpacity * 0.75,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          Color(0xFFFFD580),
                                          Color(0x80D4AF37),
                                          Colors.transparent,
                                        ],
                                        stops: [0.0, 0.5, 1.0],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            // Bagian 1: Atas (Leher/Bibir Vas)
                            Transform.translate(
                              offset: topOffset,
                              child: Transform.rotate(
                                angle: topRotate,
                                child: Opacity(
                                  opacity: inProgress.clamp(0.0, 1.0),
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
                            ),

                            // Bagian 2: Kiri Bawah (Tangan Pengrajin)
                            Transform.translate(
                              offset: handOffset,
                              child: Transform.rotate(
                                angle: handRotate,
                                child: Opacity(
                                  opacity: inProgress.clamp(0.0, 1.0),
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
                            ),

                            // Bagian 3: Kanan Bawah (Daun Keramik)
                            Transform.translate(
                              offset: leafOffset,
                              child: Transform.rotate(
                                angle: leafRotate,
                                child: Opacity(
                                  opacity: inProgress.clamp(0.0, 1.0),
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
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // ── Tombol Lewati (Skip) di Pojok Kanan Atas ──
                Positioned(
                  top: topPadding + 14,
                  right: 20,
                  child: AnimatedBuilder(
                    animation: _animController,
                    builder: (context, child) {
                      final fade = 1.0 -
                          CurvedAnimation(
                            parent: _animController,
                            curve: const Interval(0.66, 0.85,
                                curve: Curves.easeOut),
                          ).value;
                      if (fade <= 0.0) return const SizedBox.shrink();

                      return Opacity(
                        opacity: fade,
                        child: child,
                      );
                    },
                    child: GestureDetector(
                      key: const Key('logo_intro_skip_btn'),
                      onTap: _skipIntro,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          'Lewati',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
