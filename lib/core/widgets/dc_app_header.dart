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
        padding: const EdgeInsets.fromLTRB(20, 4, 16, 4),
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
                iconSize: 32, // viewBox 40×40 → perlu lebih besar agar visual sama
                onTap: () => context.go('/products'),
              ),
              const SizedBox(width: 4),
              _IconBtn(
                asset: AppAssets.iconProfile,
                iconSize: 26,
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
  const _IconBtn({
    required this.asset,
    required this.onTap,
    this.iconSize = 26,
  });

  final String asset;
  final VoidCallback onTap;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: SvgPicture.asset(
          asset,
          width: iconSize,
          height: iconSize,
          fit: BoxFit.contain,
          colorFilter: const ColorFilter.mode(AppColors.ink, BlendMode.srcIn),
        ),
      ),
    );
  }
}

// ─── Pinned sliver header — pakai ini di CustomScrollView ────────────────────
class SliverPinnedDcHeader extends StatelessWidget {
  const SliverPinnedDcHeader({super.key, this.showActions = true});

  final bool showActions;

  static const double _contentH = 48.0;

  @override
  Widget build(BuildContext context) {
    // Ambil topPad di sini (ada context) lalu teruskan ke delegate
    final topPad = MediaQuery.paddingOf(context).top;
    return SliverPersistentHeader(
      pinned: true,
      delegate: _DcHeaderDelegate(
        showActions: showActions,
        topPad: topPad,
        contentH: _contentH,
      ),
    );
  }
}

class _DcHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _DcHeaderDelegate({
    required this.topPad,
    required this.contentH,
    this.showActions = true,
  });

  final double topPad;
  final double contentH;
  final bool showActions;

  // maxExtent HARUS menyertakan topPad agar header tidak terpotong
  @override
  double get maxExtent => topPad + contentH;
  @override
  double get minExtent => topPad + contentH;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white, // solid white → konten scroll tidak tembus
      child: DcAppHeader(showActions: showActions),
    );
  }

  @override
  bool shouldRebuild(_DcHeaderDelegate old) =>
      old.showActions != showActions ||
      old.topPad != topPad ||
      old.contentH != contentH;
}
