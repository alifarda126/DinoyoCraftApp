import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/fcm_notification_model.dart';
import '../services/fcm_service.dart';
import '../theme/app_colors.dart';

/// Kartu desain notifikasi in-app untuk FCM.
/// Didesain modern bergaya floating heads-up banner dengan animasi slide-down.
class FcmNotificationBanner extends StatelessWidget {
  const FcmNotificationBanner({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  final FcmNotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark || AppColors.isDark;

    final (iconData, iconColor, iconBg) = switch (notification.category) {
      FcmNotificationCategory.transaction => (
          Icons.local_shipping_rounded,
          const Color(0xFFD97706),
          const Color(0xFFFEF3C7),
        ),
      FcmNotificationCategory.chat => (
          Icons.chat_bubble_rounded,
          const Color(0xFF2563EB),
          const Color(0xFFDBEAFE),
        ),
      FcmNotificationCategory.promo => (
          Icons.discount_rounded,
          const Color(0xFF7C3AED),
          const Color(0xFFEDE9FE),
        ),
      FcmNotificationCategory.account => (
          Icons.verified_user_rounded,
          const Color(0xFF059669),
          const Color(0xFFD1FAE5),
        ),
      FcmNotificationCategory.system => (
          Icons.notifications_active_rounded,
          const Color(0xFF4B5563),
          const Color(0xFFF3F4F6),
        ),
    };

    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.up,
      onDismissed: (_) => onDismiss(),
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.18)
                  : AppColors.borderAlt,
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.12),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon Kategori
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isDark ? iconColor.withValues(alpha: 0.2) : iconBg,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        iconData,
                        size: 20,
                        color: iconColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Isi Notifikasi (Judul, Kategori, Body)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              'DinoyoCraft',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              width: 3,
                              height: 3,
                              decoration: BoxDecoration(
                                color: AppColors.textSecondary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              notification.category.displayName,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: iconColor,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              notification.timeLabel,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          notification.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        if (notification.body.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            notification.body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              height: 1.35,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Tombol Tutup Banner
                  IconButton(
                    onPressed: onDismiss,
                    icon: Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                    splashRadius: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Host widget global untuk menampilkan banner notifikasi FCM
/// yang melayang dari atas layar secara otomatis.
class FcmNotificationHost extends StatefulWidget {
  const FcmNotificationHost({
    super.key,
    required this.child,
  });

  final Widget child;

  static void show(BuildContext context, FcmNotificationModel notification) {
    final state = context.findAncestorStateOfType<_FcmNotificationHostState>();
    state?.showNotification(notification);
  }

  @override
  State<FcmNotificationHost> createState() => _FcmNotificationHostState();
}

class _FcmNotificationHostState extends State<FcmNotificationHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  StreamSubscription? _fcmSub;
  Timer? _dismissTimer;
  FcmNotificationModel? _currentNotification;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
      reverseDuration: const Duration(milliseconds: 280),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeInCubic,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    // Dengarkan notifikasi masuk dari FCM service
    _fcmSub = FcmService.instance.notificationModelStream.listen((notif) {
      showNotification(notif);
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _fcmSub?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void showNotification(FcmNotificationModel notif) {
    if (!mounted) return;
    _dismissTimer?.cancel();
    setState(() {
      _currentNotification = notif;
    });

    _animController.forward(from: 0);

    // Auto dismiss setelah 4.5 detik jika tidak disentuh
    _dismissTimer = Timer(const Duration(milliseconds: 4500), () {
      dismissNotification();
    });
  }

  void dismissNotification() {
    if (!mounted) return;
    _dismissTimer?.cancel();
    _animController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _currentNotification = null;
        });
      }
    });
  }

  void _handleTap() {
    if (_currentNotification == null) return;
    final notif = _currentNotification!;
    dismissNotification();

    // Arahkan ke rute tujuan
    if (notif.route != null && notif.route!.isNotEmpty) {
      if (notif.category == FcmNotificationCategory.chat) {
        final storeName = notif.data['store_name']?.toString() ??
            'Dinoyo Ceramic Studio';
        final productId = notif.data['product_id']?.toString();
        final extraData = <String, dynamic>{
          'storeName': storeName,
        };
        if (productId != null) {
          extraData['productId'] = productId;
        }
        context.push(
          '/chat',
          extra: extraData,
        );
      } else {
        context.push(notif.route!);
      }
    } else {
      context.push('/notifications');
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return Stack(
      children: [
        widget.child,
        if (_currentNotification != null)
          Positioned(
            top: topPadding + 8,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: FcmNotificationBanner(
                  notification: _currentNotification!,
                  onTap: _handleTap,
                  onDismiss: dismissNotification,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
