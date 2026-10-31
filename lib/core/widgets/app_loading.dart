import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_text.dart';
import '../theme/app_colors.dart';

/// Loading state widget serbaguna untuk halaman atau komponen data.
class DcLoadingState extends StatelessWidget {
  const DcLoadingState({
    super.key,
    this.message,
    this.size = 36.0,
  });

  final String? message;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.ink),
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!.tr,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
