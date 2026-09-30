import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

class DcButton extends StatelessWidget {
  const DcButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.trailingIconPath,
    this.trailingIcon,
    this.backgroundColor = AppColors.black,
    this.foregroundColor = AppColors.white,
    this.height = 52,
    this.outlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final String? trailingIconPath;
  final IconData? trailingIcon;
  final Color backgroundColor;
  final Color foregroundColor;
  final double height;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: outlined ? AppColors.ink : foregroundColor,
          ),
        ),
        if (trailingIconPath != null) ...[
          const SizedBox(width: 8),
          SvgPicture.asset(
            trailingIconPath!,
            width: 18,
            height: 18,
            colorFilter: ColorFilter.mode(
              outlined ? AppColors.ink : foregroundColor,
              BlendMode.srcIn,
            ),
          ),
        ] else if (trailingIcon != null) ...[
          const SizedBox(width: 8),
          Icon(
            trailingIcon,
            size: 18,
            color: outlined ? AppColors.ink : foregroundColor,
          ),
        ],
      ],
    );

    if (outlined) {
      return SizedBox(
        width: double.infinity,
        height: height,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.border),
            shape: const StadiumBorder(),
            backgroundColor: AppColors.white,
          ),
          child: child,
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: AppColors.textMuted,
          elevation: 0,
          shape: const StadiumBorder(),
        ),
        child: child,
      ),
    );
  }
}
