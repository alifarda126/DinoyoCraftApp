import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_text.dart';
import '../theme/app_colors.dart';
import 'dc_button.dart';

/// State tampilan ketika data kosong (Empty State).
class DcEmptyState extends StatelessWidget {
  const DcEmptyState({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  final String? title;
  final String? subtitle;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
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
                color: AppColors.surfaceSubtle,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.inbox_rounded,
                size: 40,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              (title ?? 'Belum Ada Data').tr,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!.tr,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  height: 1.4,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: 160,
                child: DcButton(
                  label: actionLabel!.tr,
                  onPressed: onAction,
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
