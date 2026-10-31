import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_text.dart';
import '../theme/app_colors.dart';
import 'dc_button.dart';

/// State tampilan ketika tidak ada koneksi internet (No Internet State).
class DcNoInternetState extends StatelessWidget {
  const DcNoInternetState({
    super.key,
    this.onRetry,
    this.title,
    this.subtitle,
  });

  final VoidCallback? onRetry;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A1E1E) : const Color(0xFFFEE2E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 40,
                color: Color(0xFFDC2626),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              (title ?? 'Tidak Ada Koneksi Internet').tr,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              (subtitle ?? 'Periksa koneksi Wi-Fi atau data seluler Anda lalu coba lagi.').tr,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                height: 1.4,
                color: AppColors.textSecondary,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: 140,
                child: DcButton(
                  label: 'Coba Lagi'.tr,
                  onPressed: onRetry,
                  height: 44,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// State tampilan ketika terjadi kendala pada server (Server Error State).
class DcServerErrorState extends StatelessWidget {
  const DcServerErrorState({
    super.key,
    this.onRetry,
    this.title,
    this.subtitle,
  });

  final VoidCallback? onRetry;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2E2218) : const Color(0xFFFEF3C7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 40,
                color: Color(0xFFD97706),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              (title ?? 'Terjadi Kendala Server').tr,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              (subtitle ?? 'Server kami sedang mengalami gangguan sementara. Silakan coba beberapa saat lagi.').tr,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                height: 1.4,
                color: AppColors.textSecondary,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: 140,
                child: DcButton(
                  label: 'Muat Ulang'.tr,
                  onPressed: onRetry,
                  height: 44,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
