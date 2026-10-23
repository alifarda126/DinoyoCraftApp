import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_text.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_back_scope.dart';
import '../../data/mock_data.dart';

/// Menampilkan modal notifikasi sesuai desain Figma (Notif.dart)
/// Menggunakan useRootNavigator: true agar berada di atas navbar dan FAB
Future<void> showNotificationsModal(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Color(0x73000000),
    builder: (context) => NotificationsModalSheet(),
  );
}

class NotificationsScreen extends StatelessWidget {
const   NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackScope(
      fallbackRoute: '/home',
      child: Scaffold(
        backgroundColor: Color(0x73000000),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/home');
                    }
                  },
                  child: const SizedBox.expand(),
                ),
              ),
              NotificationsModalSheet(isFullPageFallback: true),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationsModalSheet extends StatefulWidget {
const   NotificationsModalSheet({super.key, this.isFullPageFallback = false});

  final bool isFullPageFallback;

  @override
  State<NotificationsModalSheet> createState() =>
      _NotificationsModalSheetState();
}

class _NotificationsModalSheetState extends State<NotificationsModalSheet> {
  String _selectedFilter = 'Semua';

  // ID notifikasi yang sudah dibaca (disinkronkan dengan MockData)
  Set<String> get _readIds => MockData.readNotificationIds;
  int get _unreadCount =>
      {'1', '2'}.difference(_readIds).length;

  void _markAsRead(String id) {
    setState(() {
      MockData.markNotificationAsRead(id);
    });
  }

  static const Color _black = Color(0xFF000000);
  Color get _textDark => AppColors.ink;
  Color get _textGray => AppColors.textSecondary;
  Color get _textDesc => AppColors.textSecondary;
  Color get _cardBgUnread => AppColors.surfaceSubtle;
  Color get _cardBgRead => AppColors.surface;
  Color get _borderRead => AppColors.divider;
  Color get _chipInactiveBg => AppColors.surfaceSubtle;
  Color get _chipInactiveBorder => AppColors.borderAlt;
  Color get _handleBarColor => AppColors.borderAlt;
  Color get _cardBorderUnread =>
      AppColors.isDark ? Colors.white.withValues(alpha: 0.3) : _black;
  Color get _unreadDotColor =>
      AppColors.isDark ? Colors.white : _black;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenH = mediaQuery.size.height;
    final bottomPad = mediaQuery.padding.bottom;

    // Tinggi tetap (fixed) konsisten seperti tampilan awal:
    // Muat pas sekitar 3 kartu notifikasi pertama dan tidak menyusut/turun saat filter ditekan.
    final modalH = (screenH * 0.64).clamp(510.0, 600.0) + bottomPad;

    return Container(
      height: modalH,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 40,
            offset: Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Handle Bar ───────────────────────────────────────────────
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 14, bottom: 16),
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
                color: _handleBarColor,
              ),
            ),
          ),

          // ── Header: Judul + Badge + Tombol Close (X) ─────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Notifikasi'.tr,
                      style: GoogleFonts.plusJakartaSans(
                        color: _textDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (_unreadCount > 0) ...[
                      SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9999),
                          color: _black,
                          border: AppColors.isDark
                              ? Border.all(
                                  color: Colors.white.withValues(alpha: 0.35),
                                  width: 1,
                                )
                              : null,
                        ),
                        child: Text(
                          '$_unreadCount Baru'.tr,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceSubtle,
                      border: Border.all(
                        color: AppColors.border,
                        width: 0.8,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: _textDark,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // ── Filter Chips: Semua, Transaksi & Pesanan, Info Akun ───────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildFilterChip('Semua'),
                SizedBox(width: 8),
                _buildFilterChip('Transaksi & Pesanan'),
                SizedBox(width: 8),
                _buildFilterChip('Info Akun'),
              ],
            ),
          ),

          SizedBox(height: 16),

          // ── Daftar Kartu Notifikasi (Expanded + Scrollable) ───────────
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + bottomPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kartu 1: Voucher Diskon
                  if (_shouldShow('Transaksi & Pesanan')) ...[
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _markAsRead('1'),
                      child: _buildVoucherCard(context),
                    ),
                    SizedBox(height: 12),
                  ],

                  // Kartu 2: Jadwal Workshop
                  if (_shouldShow('Info Akun')) ...[
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (!_readIds.contains('2')) {
                          _markAsRead('2');
                        } else {
                          _openNotificationTarget('2', '/workshop');
                        }
                      },
                      child: _buildWorkshopCard(context),
                    ),
                    SizedBox(height: 12),
                  ],

                  // Kartu 3: Pembayaran Dikonfirmasi
                  if (_shouldShow('Transaksi & Pesanan')) ...[
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _openNotificationTarget('3', '/profile'),
                      child: _buildPaymentCard(),
                    ),
                    SizedBox(height: 12),
                  ],

                  // Kartu 4: Status Pesanan Dikemas (terlihat saat discroll)
                  if (_shouldShow('Transaksi & Pesanan')) ...[
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _openNotificationTarget('4', '/profile'),
                      child: _buildOrderPackedCard(),
                    ),
                    SizedBox(height: 12),
                  ],

                  // Kartu 5: Info Keamanan Akun (terlihat saat discroll)
                  if (_shouldShow('Info Akun')) ...[
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _openNotificationTarget('5', '/settings'),
                      child: _buildAccountSecurityCard(),
                    ),
                    SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShow(String category) {
    if (_selectedFilter == 'Semua') return true;
    return _selectedFilter == category;
  }

  /// Tandai kartu sudah dibaca, tutup modal, lalu buka halaman terkait.
  void _openNotificationTarget(String readId, String route) {
    final router = GoRouter.of(context);
    _markAsRead(readId);
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    // Rute shell branch harus memakai .go() agar StatefulNavigationShell
    // berpindah branch dan navbar ikut beralih ke tab yang sesuai (mis. Profil).
    const shellBranches = {
      '/home',
      '/products',
      '/stores',
      '/workshop',
      '/profile',
    };

    if (shellBranches.contains(route)) {
      router.go(route);
    } else {
      router.push(route);
    }
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9999),
          color: isSelected ? _black : _chipInactiveBg,
          border: Border.all(
            color: isSelected
                ? (AppColors.isDark
                    ? Colors.white.withValues(alpha: 0.35)
                    : _black)
                : _chipInactiveBorder,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : const Color(0x1A000000),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label.tr,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : _textDark,
          ),
        ),
      ),
    );
  }

  // ── Kartu 1: Voucher Diskon Keramik 15% ──────────────────────────────────
  Widget _buildVoucherCard(BuildContext context) {
    final isUnread = !_readIds.contains('1');

    return Container(
      decoration: BoxDecoration(
        color: isUnread ? _cardBgUnread : _cardBgRead,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnread ? _cardBorderUnread : _borderRead,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(
              Icons.local_offer_outlined,
              size: 20,
              color: _textDark,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'DISKON PENGRAJIN'.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          color: _textGray,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          AppText.isEnglish ? '2 hours ago' : '2 jam lalu',
                          style: GoogleFonts.plusJakartaSans(
                            color: _textGray,
                            fontSize: 12,
                          ),
                        ),
                        if (isUnread) ...[
                          SizedBox(width: 7),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _unreadDotColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 3),
                Text(
                  'Voucher Diskon Keramik 15%'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    color: _textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: AppText.isEnglish ? 'Use code ' : 'Gunakan kode ',
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.borderAlt,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                            color: AppColors.isDark
                                ? const Color(0xFF2E2E2E)
                                : AppColors.divider,
                          ),
                          child: Text(
                            'DINOYOKARYA',
                            style: GoogleFonts.plusJakartaSans(
                              color: _textDark,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                      TextSpan(
                        text: AppText.isEnglish
                            ? ' for discounts on pottery made by Dinoyo artisans.'
                            : ' untuk potongan belanja produk tembikar buatan pengrajin Dinoyo.',
                      ),
                    ],
                  ),
                  style: GoogleFonts.plusJakartaSans(
                    color: _textDesc,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: 'DINOYOKARYA'),
                    );
                    _markAsRead('1');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppText.isEnglish
                              ? 'Voucher code DINOYOKARYA successfully copied!'
                              : 'Kode voucher DINOYOKARYA berhasil disalin!',
                          style: GoogleFonts.plusJakartaSans(),
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Salin Voucher'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          color: _textDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.copy_rounded,
                        size: 13,
                        color: _textDark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Kartu 2: Jadwal Workshop Pembuatan Keramik ──────────────────────────
  Widget _buildWorkshopCard(BuildContext context) {
    final isUnread = !_readIds.contains('2');

    return Container(
      decoration: BoxDecoration(
        color: isUnread ? _cardBgUnread : _cardBgRead,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnread ? _cardBorderUnread : _borderRead,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(
              Icons.calendar_today_outlined,
              size: 20,
              color: _textDark,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'WISATA KREATIF'.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          color: _textGray,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Row(
                      children: [
                        Text(
                          AppText.isEnglish ? 'Yesterday, 14:20' : 'Kemarin, 14:20',
                          style: GoogleFonts.plusJakartaSans(
                            color: _textGray,
                            fontSize: 12,
                          ),
                        ),
                        if (isUnread) ...[
                          SizedBox(width: 7),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _unreadDotColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 3),
                Text(
                  'Jadwal Workshop Pembuatan Keramik'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    color: _textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Kelas seni putar tanah liat akhir pekan ini di Studio Dinoyo dibuka. Kuota tersisa 3 orang!'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    color: _textDesc,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: () => _openNotificationTarget('2', '/workshop'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          'Lihat Detail Workshop'.tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            color: _textDark,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: _textDark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Kartu 3: Pembayaran Dikonfirmasi ────────────────────────────────────
  Widget _buildPaymentCard() {
    return Container(
      decoration: BoxDecoration(
        color: _cardBgRead,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _borderRead,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Icon(
              Icons.check_circle_outline_rounded,
              size: 22,
              color: _textGray,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PEMBAYARAN'.tr,
                      style: GoogleFonts.plusJakartaSans(
                        color: _textGray,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      AppText.isEnglish ? '2 days ago' : '2 hari lalu',
                      style: GoogleFonts.plusJakartaSans(
                        color: _textGray,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3),
                Text(
                  'Pembayaran Dikonfirmasi'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    color: _textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Pembayaran via GoPay untuk pesanan Cangkir Speckle sebesar Rp70.000 telah berhasil diverifikasi.'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    color: _textDesc,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Kartu 4: Status Pesanan Dikemas ──────────────────────────────────────
  Widget _buildOrderPackedCard() {
    return Container(
      decoration: BoxDecoration(
        color: _cardBgRead,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _borderRead,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Icon(
              Icons.local_shipping_outlined,
              size: 22,
              color: _textGray,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'STATUS PESANAN'.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          color: _textGray,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      AppText.isEnglish ? '3 days ago' : '3 hari lalu',
                      style: GoogleFonts.plusJakartaSans(
                        color: _textGray,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3),
                Text(
                  'Pesanan Sedang Dikemas'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    color: _textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Penjual Dinoyo Ceramic Studio sedang menyiapkan pesanan #DNC-001 milikmu.'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    color: _textDesc,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Kartu 5: Info Keamanan Akun ──────────────────────────────────────────
  Widget _buildAccountSecurityCard() {
    return Container(
      decoration: BoxDecoration(
        color: _cardBgRead,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _borderRead,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Icon(
              Icons.shield_outlined,
              size: 22,
              color: _textGray,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'KEAMANAN AKUN'.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          color: _textGray,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      AppText.isEnglish ? '5 days ago' : '5 hari lalu',
                      style: GoogleFonts.plusJakartaSans(
                        color: _textGray,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3),
                Text(
                  'Masuk dari Perangkat Baru'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    color: _textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Akun @customer terdeteksi masuk dari perangkat baru pada 12 Feb 2025.'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    color: _textDesc,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
