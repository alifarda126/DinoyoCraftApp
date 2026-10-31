import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../assets.dart';
import '../../data/mock_data.dart';
import '../../features/cart/cart_screen.dart';
import '../../features/notification/notifications_screen.dart';
import '../theme/app_colors.dart';
import 'cart_fly_animation.dart';

class DcAppHeader extends StatelessWidget {
  const DcAppHeader({
    super.key,
    this.showActions = true,
    this.showBorder = false,
  });

  final bool showActions;
  final bool showBorder;

  /// Faktor skala responsif berbasis lebar layar logis (dp).
  ///
  /// Di ponsel sempit (< 600dp), metrik diskalakan proporsional (0.88–1.20)
  /// agar tampilan pas di segala ukuran hp.
  static double widthScale(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return (width / 360.0).clamp(0.88, 1.20);
  }

  /// True bila perangkat berlayar lebar (tablet, iPad, foldable unfolded).
  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 600;

  /// Tinggi area konten header (tanpa status bar) — dipakai
  /// [SliverPinnedDcHeader] dan konsumen lain (edgeOffset RefreshIndicator).
  static double contentHeight(BuildContext context) {
    if (isTablet(context)) {
      return 56.0;
    }
    return 48.0 * widthScale(context);
  }

  /// Tinggi total header = status bar + konten.
  static double totalHeight(BuildContext context) =>
      MediaQuery.paddingOf(context).top + contentHeight(context);

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark || AppColors.isDark;
    final logoAsset = isDark ? AppAssets.logoWhite : AppAssets.logoBlack;
    final tablet = isTablet(context);
    final s = widthScale(context);

    // Pada tablet/iPad, padding horizontal mengikuti margin konten halaman (20dp).
    // Padding kiri 16dp mengompensasi whitespace bawaan aset logo tembikar
    // sehingga visual logo sejajar sempurna di garis 20dp.
    final hPadding = tablet
        ? const EdgeInsets.fromLTRB(16, 6, 20, 6)
        : EdgeInsets.fromLTRB(12 * s, 4 * s, 16 * s, 4 * s);

    final logoSize = tablet ? 42.0 : 36.0 * s;
    final logoTextGap = tablet ? 10.0 : 8.0 * s;
    final titleFontSize = tablet ? 21.0 : 18.0 * s;
    final actionGap = tablet ? 12.0 : 8.0 * s;

    Widget content = SafeArea(
      bottom: false,
      child: Padding(
        padding: hPadding,
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(logoAsset, width: logoSize, height: logoSize),
                  SizedBox(width: logoTextGap),
                  Flexible(
                    child: Text(
                      'DinoyoCraft',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showActions) ...[
              ValueListenableBuilder<int>(
                valueListenable: MockData.unreadNotificationsNotifier,
                builder: (context, count, _) => _IconBtn(
                  asset: AppAssets.iconNotification,
                  iconSize: tablet ? 21 : 19,
                  badge: count > 0 ? '$count' : null,
                  badgeTop: -2,
                  badgeRight: -2,
                  onTap: () => showNotificationsModal(context),
                ),
              ),
              SizedBox(width: actionGap),
              ValueListenableBuilder<int>(
                valueListenable: MockData.cartCountNotifier,
                builder: (context, cartCount, _) => CartBounceTarget(
                  child: _IconBtn(
                    asset: AppAssets.iconCart,
                    iconSize: tablet ? 21 : 19,
                    badge: cartCount > 0 ? '$cartCount' : null,
                    badgeTop: -2,
                    badgeRight: -3,
                    onTap: () => showCartModal(context),
                  ),
                ),
              ),
              SizedBox(width: actionGap),
              ValueListenableBuilder<int>(
                valueListenable: MockData.unreadChatNotifier,
                builder: (context, chatCount, _) => _IconBtn(
                  asset: AppAssets.iconChat,
                  iconSize: tablet ? 21 : 19,
                  badge: chatCount > 0 ? '$chatCount' : null,
                  badgeTop: -2,
                  badgeRight: -2,
                  onTap: () => context.push('/messages'),
                ),
              ),
            ],
          ],
        ),
      ),
    );

    if (showBorder) {
      content = Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            bottom: BorderSide(color: AppColors.divider),
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
    this.iconSize = 19,
    this.badge,
    this.badgeTop = -2.0,
    this.badgeRight = -3.0,
  });

  final String asset;
  final VoidCallback onTap;
  final double iconSize;
  final String? badge;
  final double badgeTop;
  final double badgeRight;

  @override
  Widget build(BuildContext context) {
    final tablet = DcAppHeader.isTablet(context);
    final s = DcAppHeader.widthScale(context);

    final btnSize = tablet ? 38.0 : 30.0 * s;
    final iSize = tablet ? iconSize : iconSize * s;
    final bTop = tablet ? badgeTop : badgeTop * s;
    final bRight = tablet ? badgeRight : badgeRight * s;
    final bMinWidth = tablet ? 16.0 : 14.0 * s;
    final bFontSize = tablet ? 9.5 : 8.0 * s;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(btnSize / 2),
      child: SizedBox(
        width: btnSize,
        height: btnSize,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: SvgPicture.asset(
                asset,
                width: iSize,
                height: iSize,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(
                  AppColors.ink,
                  BlendMode.srcIn,
                ),
              ),
            ),
            if (badge != null && badge!.isNotEmpty)
              Positioned(
                top: bTop,
                right: bRight,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: tablet ? 4.0 : 3.5 * s,
                  ),
                  constraints: BoxConstraints(
                    minWidth: bMinWidth,
                    minHeight: bMinWidth,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.ink,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.surface, width: 1.0),
                  ),
                  child: Text(
                    badge!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: bFontSize,
                      fontWeight: FontWeight.w700,
                      color: AppColors.surface,
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
  const SliverPinnedDcHeader({super.key, this.showActions = true});

  final bool showActions;

  @override
  Widget build(BuildContext context) {
    // Ambil topPad di sini (ada context) lalu teruskan ke delegate.
    // Tinggi konten ikut skala lebar layar agar konsisten dengan DcAppHeader.
    final topPad = MediaQuery.paddingOf(context).top;
    return SliverPersistentHeader(
      pinned: true,
      delegate: _DcHeaderDelegate(
        showActions: showActions,
        topPad: topPad,
        contentH: DcAppHeader.contentHeight(context),
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
        color: AppColors.surface,
        child: Container(
          // Garis batas tipis agar jelas di mana akhir header.
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.divider),
            ),
          ),
          child: DcAppHeader(showActions: showActions),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_DcHeaderDelegate old) =>
      // Selalu rebuild: delegat membaca token warna (AppColors) saat build.
      // False akan mempertahankan child lama saat tema berganti — header
      // jadi tidak ikut terang/gelap.
      true;
}
