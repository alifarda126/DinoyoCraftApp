import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/dc_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppAssets.onboardingBg,
            fit: BoxFit.cover,
            alignment: const Alignment(0, -0.2),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.45),
                  Colors.black.withValues(alpha: 0.05),
                  Colors.transparent,
                  AppColors.white.withValues(alpha: 0.82),
                  AppColors.white,
                ],
                stops: const [0, 0.22, 0.48, 0.7, 1],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const Spacer(),
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
                        const TextSpan(text: 'Temukan Cerita di Balik Setiap '),
                        TextSpan(
                          text: 'Keramik!',
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
                  Text(
                    'Jelajahi karya lokal Dinoyo, temukan pengrajin pilihan, '
                    'dan rasakan pengalaman kreatif di balik setiap tanah liat.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      height: 1.55,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  DcButton(
                    label: 'Mulai Menjelajah',
                    trailingIconPath: AppAssets.arrowRight,
                    onPressed: () => context.go('/login'),
                  ),
                  const SizedBox(height: 18),
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
                              const TextSpan(text: 'Belum punya akun? '),
                              TextSpan(
                                text: 'Daftar',
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
          colorFilter: const ColorFilter.mode(AppColors.ink, BlendMode.srcIn),
        ),
      ),
    );
  }
}
