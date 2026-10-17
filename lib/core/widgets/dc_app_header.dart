import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../assets.dart';
import '../../data/mock_data.dart';
import '../../features/cart/cart_screen.dart';
import '../../features/notification/notifications_screen.dart';
import '../theme/app_colors.dart';

class DcAppHeader extends StatelessWidget {
const   DcAppHeader({
    super.key,
    this.showActions = true,
    this.showBorder = false,
  });

  final bool showActions;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    Widget content = SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 16, 4),
        child: Row(
          children: [
            Image.asset(AppAssets.logoBlack, width: 36, height: 36),
            SizedBox(width: 10),
            Text(
              'DinoyoCraft',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
            Spacer(),
            if (showActions) ...[
              _IconBtn(
                asset: AppAssets.iconNotification,
                iconSize: 22,
                showDot: true,
                dotTop: 4.0,
                dotRight: 7.0,
                dotSize: 7.5,
                onTap: () => showNotificationsModal(context),
              ),
              SizedBox(width: 10),
              _IconBtn(
                asset: AppAssets.iconCart,
                iconSize: 22,
                badge: '${MockData.mockCart.length}',
                onTap: () => showCartModal(context),
              ),
              SizedBox(width: 10),
              _IconBtn(
                asset: AppAssets.iconChat,
                // Ukuran 18.5 agar visual balance & optical weight sama persis
                // dengan icon lonceng notifikasi (18.3px) dan keranjang (18.9px)
                iconSize: 18.5,
                showDot: true,
                dotTop: 5.0,
                dotRight: 5.0,
                dotSize: 7.5,
                onTap: () => context.push('/messages'),
              ),
            ],
          ],
        ),
      ),
    );

    if (showBorder) {
      content = Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Color(0xFFEAEAEA)),
          ),
        ),
        child: content,
      );
    }

    return content;
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({
    required this.asset,
    required this.onTap,
    this.iconSize = 22,
    this.showDot = false,
    this.dotTop = 4.0,
    this.dotRight = 5.0,
    this.dotSize = 7.5,
    this.badge,
  });

  final String asset;
  final VoidCallback onTap;
  final double iconSize;
  final bool showDot;
  final double dotTop;
  final double dotRight;
  final double dotSize;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: SizedBox(
        width: 32,
        height: 32,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: SvgPicture.asset(
                asset,
                width: iconSize,
                height: iconSize,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(
                  AppColors.ink,
                  BlendMode.srcIn,
                ),
              ),
            ),
            if (showDot)
              Positioned(
                top: dotTop,
                right: dotRight,
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            if (badge != null)
              Positioned(
                top: -3,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  constraints: BoxConstraints(minWidth: 15),
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white, width: 1.2),
                  ),
                  child: Text(
                    badge!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Pinned sliver header — pakai ini di CustomScrollView ────────────────────
class SliverPinnedDcHeader extends StatelessWidget {
const   SliverPinnedDcHeader({super.key, this.showActions = true});

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
    // Tinggi child DIPAKSA sama dengan extent delegate. Bila child lebih
    // pendek, layoutExtent (48) melebihi paintExtent → SliverGeometry tidak
    // valid → seluruh viewport gagal layout dan layar jadi blank.
    return SizedBox(
      height: topPad + contentH,
      child: Material(
        color: Colors.white, // solid white → konten scroll tidak tembus
        child: Container(
          // Garis batas tipis agar jelas di mana akhir header.
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFFEAEAEA)),
            ),
          ),
          child: DcAppHeader(showActions: showActions),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_DcHeaderDelegate old) =>
      old.showActions != showActions ||
      old.topPad != topPad ||
      old.contentH != contentH;
}
