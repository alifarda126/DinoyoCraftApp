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
          SizedBox(width: 8),
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
          SizedBox(width: 8),
          Icon(
            trailingIcon,
            size: 18,
            color: outlined ? AppColors.ink : foregroundColor,
          ),
        ],
      ],
    );

    final isDark =
        Theme.of(context).brightness == Brightness.dark || AppColors.isDark;
    final isDarkButton = isDark &&
        !outlined &&
        (backgroundColor == AppColors.black ||
            backgroundColor == Colors.black ||
            backgroundColor.computeLuminance() < 0.1);

    if (outlined) {
      return SizedBox(
        width: double.infinity,
        height: height,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.border),
            shape: const StadiumBorder(),
            backgroundColor: AppColors.surface,
          ),
          child: child,
        ),
      );
    }

    final buttonWidget = SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: AppColors.textMuted,
          elevation: 0,
          side: isDarkButton
              ? BorderSide(
                  color: Colors.white.withValues(alpha: 0.35),
                  width: 1.2,
                )
              : null,
          shape: isDarkButton
              ? StadiumBorder(
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                )
              : const StadiumBorder(),
        ),
        child: child,
      ),
    );

    if (isDarkButton) {
      return Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.12),
              blurRadius: 10,
              spreadRadius: 0.5,
            ),
          ],
        ),
        child: buttonWidget,
      );
    }

    return buttonWidget;
  }
}

