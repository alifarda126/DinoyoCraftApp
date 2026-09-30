import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../assets.dart';
import '../theme/app_colors.dart';

class DcAppHeader extends StatelessWidget {
  const DcAppHeader({super.key, this.showActions = true});

  final bool showActions;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 16, 8),
        child: Row(
          children: [
            Image.asset(AppAssets.logoBlack, width: 36, height: 36),
            const SizedBox(width: 10),
            Text(
              'DinoyoCraft',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
            const Spacer(),
            if (showActions) ...[
              _IconBtn(
                asset: AppAssets.iconSearch,
                onTap: () => context.go('/products'),
              ),
              const SizedBox(width: 4),
              _IconBtn(
                asset: AppAssets.iconProfile,
                onTap: () => context.push('/profile'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.asset, required this.onTap});

  final String asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SvgPicture.asset(
          asset,
          width: 22,
          height: 22,
          colorFilter: const ColorFilter.mode(AppColors.ink, BlendMode.srcIn),
        ),
      ),
    );
  }
}
