import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_text.dart';
import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/dc_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  /// Controller animasi masuk bertahap (staggered entrance) elemen-elemen Onboarding
  late final AnimationController _onboardingEntranceController;

  @override
  void initState() {
    super.initState();

    _onboardingEntranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    // Langsung putar animasi masuk elemen halaman onboarding
    _onboardingEntranceController.forward();
  }

  @override
  void dispose() {
    _onboardingEntranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Kurva staggered untuk setiap elemen Onboarding
    final bgScale = Tween<double>(begin: 1.08, end: 1.0).animate(
      CurvedAnimation(
        parent: _onboardingEntranceController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    final bgFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _onboardingEntranceController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    final headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.45),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _onboardingEntranceController,
        curve: const Interval(0.12, 0.60, curve: Curves.easeOutCubic),
      ),
    );

    final headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _onboardingEntranceController,
        curve: const Interval(0.12, 0.50, curve: Curves.easeOut),
      ),
    );

    final titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _onboardingEntranceController,
        curve: const Interval(0.25, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    final titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _onboardingEntranceController,
        curve: const Interval(0.25, 0.65, curve: Curves.easeOut),
      ),
    );

    final subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _onboardingEntranceController,
        curve: const Interval(0.40, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    final subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _onboardingEntranceController,
        curve: const Interval(0.40, 0.78, curve: Curves.easeOut),
      ),
    );

    final buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.40),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _onboardingEntranceController,
        curve: const Interval(0.55, 0.95, curve: Curves.easeOutBack),
      ),
    );

    final buttonScale = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _onboardingEntranceController,
        curve: const Interval(0.55, 0.95, curve: Curves.easeOutBack),
      ),
    );

    final buttonFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _onboardingEntranceController,
        curve: const Interval(0.55, 0.85, curve: Curves.easeOut),
      ),
    );

    final linkSlide = Tween<Offset>(
      begin: const Offset(0, 0.30),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _onboardingEntranceController,
        curve: const Interval(0.70, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    final linkFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _onboardingEntranceController,
        curve: const Interval(0.70, 0.95, curve: Curves.easeOut),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Gambar Latar dengan Animasi Zoom Out Halus ──
          AnimatedBuilder(
            animation: _onboardingEntranceController,
            builder: (context, child) {
              return Opacity(
                opacity: bgFade.value,
                child: Transform.scale(
                  scale: bgScale.value,
                  child: child,
                ),
              );
            },
            child: Image.asset(
              AppAssets.onboardingBg,
              fit: BoxFit.cover,
              alignment: const Alignment(0, -0.2),
            ),
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

          // ── Elemen Teks dan Tombol Onboarding dengan Animasi Masuk ──
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Brand Badge (Slide down + Fade in)
                  SlideTransition(
                    position: headerSlide,
                    child: FadeTransition(
                      opacity: headerFade,
                      child: Row(
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
                            child: Image.asset(
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
                    ),
                  ),

                  const Spacer(),

                  // Heading Title (Slide up + Fade in)
                  SlideTransition(
                    position: titleSlide,
                    child: FadeTransition(
                      opacity: titleFade,
                      child: Text.rich(
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
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Subtitle Description (Slide up + Fade in)
                  SlideTransition(
                    position: subtitleSlide,
                    child: FadeTransition(
                      opacity: subtitleFade,
                      child: Text(
                        'Jelajahi karya lokal Dinoyo, temukan pengrajin pilihan, '
                                'dan rasakan pengalaman kreatif di balik setiap tanah liat.'
                            .tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          height: 1.55,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Tombol "Mulai Menjelajah" (Slide up + Bounce Scale + Fade in)
                  SlideTransition(
                    position: buttonSlide,
                    child: ScaleTransition(
                      scale: buttonScale,
                      child: FadeTransition(
                        opacity: buttonFade,
                        child: DcButton(
                          label: 'Mulai Menjelajah'.tr,
                          trailingIconPath: AppAssets.arrowRight,
                          onPressed: () => context.go('/login'),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Link "Belum punya akun? Daftar" (Slide up + Fade in)
                  SlideTransition(
                    position: linkSlide,
                    child: FadeTransition(
                      opacity: linkFade,
                      child: Center(
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
