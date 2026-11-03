import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_text.dart';
import '../../core/network/api_client.dart';
import '../../core/services/auth_session.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_back_scope.dart';
import '../../core/models/fcm_notification_model.dart';
import '../../core/services/fcm_service.dart';

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

  // Notifikasi REAL dari backend (GET /notifications) + riwayat FCM.
  List<FcmNotificationModel> _serverNotifs = [];
  bool _notifLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    if (!AuthSession.isLoggedIn) {
      if (mounted) setState(() => _notifLoading = false);
      return;
    }
    try {
      final res = await ApiClient.get('/notifications');
      if (res['success'] == true && res['data'] is Map<String, dynamic>) {
        final data = res['data'] as Map<String, dynamic>;
        final rows = data['notifications'];
        if (rows is List) {
          _serverNotifs = rows
              .whereType<Map<String, dynamic>>()
              .map((row) => FcmNotificationModel.fromJson({
                    'id': row['id']?.toString(),
                    'title': row['title']?.toString(),
                    'body': row['message']?.toString(),
                    'category': row['type']?.toString(),
                    'is_read': row['is_read'] == 1 || row['is_read'] == true,
                    'created_at': row['created_at']?.toString(),
                  }))
              .toList();
        }
      }
    } catch (_) {
      // Offline / sesi berakhir: tampilkan riwayat FCM lokal saja.
    }
    if (mounted) setState(() => _notifLoading = false);
  }

  /// Gabungan notifikasi server + riwayat FCM perangkat (dedup by id).
  List<FcmNotificationModel> get _mergedNotifications {
    final serverIds = _serverNotifs.map((n) => n.id).toSet();
    final fcmOnly = FcmService.instance.notificationsHistory
        .where((n) => !serverIds.contains(n.id))
        .toList();
    return [..._serverNotifs, ...fcmOnly];
  }

  int get _unreadCount =>
      _mergedNotifications.where((n) => !n.isRead).length;

  void _markAsRead(String id) {
    setState(() {});
    // Tandai terbaca di server (fire-and-forget).
    if (AuthSession.isLoggedIn) {
      ApiClient.patch('/notifications/$id/read')
          .catchError((_) => <String, dynamic>{});
    }
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
            child: RefreshIndicator(
              onRefresh: () async {
                await _fetchNotifications();
              },
              color: _black,
              child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + bottomPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kartu notifikasi REAL: gabungan server (GET
                  // /notifications) + riwayat FCM perangkat ini.
                  if (_notifLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else ...[
                    for (final notif in _mergedNotifications)
                      if (_shouldShowCategory(notif.category)) ...[
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            notif.isRead = true;
                            _markAsRead(notif.id);
                            _openNotificationTarget(
                              notif.id,
                              notif.route ?? '/notifications',
                            );
                          },
                          child: _buildDynamicFcmCard(notif),
                        ),
                        const SizedBox(height: 12),
                      ],
                    if (_mergedNotifications.isEmpty)
                      _buildNotifEmpty(),
                  ],
                ],
              ),
            ),
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowCategory(FcmNotificationCategory cat) {
    if (_selectedFilter == 'Semua') return true;
    if (_selectedFilter == 'Transaksi & Pesanan') {
      return cat == FcmNotificationCategory.transaction ||
          cat == FcmNotificationCategory.promo;
    }
    if (_selectedFilter == 'Info Akun') {
      return cat == FcmNotificationCategory.account ||
          cat == FcmNotificationCategory.chat ||
          cat == FcmNotificationCategory.system;
    }
    return true;
  }

  Widget _buildDynamicFcmCard(FcmNotificationModel item) {
    final isUnread = !item.isRead;
    final (iconData, categoryLabel) = switch (item.category) {
      FcmNotificationCategory.transaction => (
          Icons.local_shipping_outlined,
          'PESANAN & PENGIRIMAN'.tr,
        ),
      FcmNotificationCategory.chat => (
          Icons.chat_bubble_outline_rounded,
          'PESAN TOKO'.tr,
        ),
      FcmNotificationCategory.promo => (
          Icons.local_offer_outlined,
          'PROMO SPESIAL'.tr,
        ),
      FcmNotificationCategory.account => (
          Icons.shield_outlined,
          'INFO KEAMANAN'.tr,
        ),
      FcmNotificationCategory.system => (
          Icons.notifications_outlined,
          'PEMBERITAHUAN'.tr,
        ),
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread ? _cardBgUnread : _cardBgRead,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnread ? _cardBorderUnread : _borderRead,
          width: isUnread ? 1.5 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isUnread ? AppColors.surface : _cardBgUnread,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(
              iconData,
              size: 20,
              color: _textDark,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        categoryLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          color: _textGray,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        Text(
                          item.timeLabel,
                          style: GoogleFonts.plusJakartaSans(
                            color: _textGray,
                            fontSize: 12,
                          ),
                        ),
                        if (isUnread) ...[
                          const SizedBox(width: 7),
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
                const SizedBox(height: 3),
                Text(
                  item.title,
                  style: GoogleFonts.plusJakartaSans(
                    color: _textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (item.body.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    item.body,
                    style: GoogleFonts.plusJakartaSans(
                      color: _textDesc,
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
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

  Widget _buildNotifEmpty() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: _cardBgRead,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderRead),
      ),
      child: Column(
        children: [
          Icon(Icons.notifications_off_outlined,
              size: 40, color: _textGray),
          const SizedBox(height: 10),
          Text(
            'Belum ada notifikasi'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Notifikasi transaksi dan info akun akan muncul di sini.'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: _textDesc,
            ),
          ),
        ],
      ),
    );
  }
}
