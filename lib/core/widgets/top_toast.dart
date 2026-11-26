import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_text.dart';

/// Jenis tampilan notifikasi popup atas.
enum TopToastType { success, info, error }

class _TopToastItem {
  const _TopToastItem({
    required this.id,
    required this.message,
    required this.type,
    required this.duration,
  });

  final int id;
  final String message;
  final TopToastType type;
  final Duration duration;
}

/// Controller global agar notifikasi popup dari atas ([TopToastHost]) bisa
/// dipanggil dari mana saja (termasuk saat berpindah rute / pop) dengan
/// kontras warna terjamin di Light Mode maupun Dark Mode.
abstract final class AppTopToast {
  static final StreamController<_TopToastItem> _controller =
      StreamController<_TopToastItem>.broadcast();
  static int _seq = 0;

  static Stream<_TopToastItem> get _stream => _controller.stream;

  static void show(
    String message, {
    TopToastType type = TopToastType.info,
    Duration duration = const Duration(milliseconds: 3200),
  }) {
    final trimmed = message.trim();
    if (trimmed.isEmpty) return;
    _controller.add(
      _TopToastItem(
        id: ++_seq,
        message: AppText.tr(trimmed),
        type: type,
        duration: duration,
      ),
    );
  }

  static void success(
    String message, {
    Duration duration = const Duration(milliseconds: 3200),
  }) =>
      show(message, type: TopToastType.success, duration: duration);

  static void info(
    String message, {
    Duration duration = const Duration(milliseconds: 3200),
  }) =>
      show(message, type: TopToastType.info, duration: duration);

  static void error(
    String message, {
    Duration duration = const Duration(milliseconds: 3500),
  }) =>
      show(message, type: TopToastType.error, duration: duration);
}

/// Host overlay tingkat root yang menampilkan popup toast di bagian atas layar
/// (aman dari keyboard, aman saat perpindahan rute, dan terbaca jelas di mode gelap).
class TopToastHost extends StatefulWidget {
  const TopToastHost({super.key, required this.child});

  final Widget child;

  @override
  State<TopToastHost> createState() => _TopToastHostState();
}

class _TopToastHostState extends State<TopToastHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  StreamSubscription<_TopToastItem>? _sub;
  Timer? _dismissTimer;
  _TopToastItem? _current;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      reverseDuration: const Duration(milliseconds: 220),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _sub = AppTopToast._stream.listen(_present);
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _sub?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _present(_TopToastItem item) {
    if (!mounted) return;
    _dismissTimer?.cancel();
    setState(() {
      _current = item;
    });
    _animController.forward(from: 0);
    _dismissTimer = Timer(item.duration, _dismiss);
  }

  void _dismiss() {
    if (!mounted) return;
    _dismissTimer?.cancel();
    _animController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _current = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = _current;
    final topPadding = MediaQuery.paddingOf(context).top;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        widget.child,
        if (item != null)
          Positioned(
            top: topPadding + 10,
            left: 16,
            right: 16,
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Dismissible(
                  key: ValueKey('top_toast_${item.id}'),
                  direction: DismissDirection.up,
                  onDismissed: (_) {
                    _dismissTimer?.cancel();
                    setState(() => _current = null);
                  },
                  child: _TopToastCard(
                    item: item,
                    isDark: isDark,
                    onClose: _dismiss,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _TopToastCard extends StatelessWidget {
  const _TopToastCard({
    required this.item,
    required this.isDark,
    required this.onClose,
  });

  final _TopToastItem item;
  final bool isDark;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color border;
    final Color fg;
    final Color iconColor;
    final IconData icon;

    switch (item.type) {
      case TopToastType.error:
        bg = isDark ? const Color(0xFF7F1D1D) : const Color(0xFF991B1B);
        border = isDark
            ? const Color(0xFFF87171).withValues(alpha: 0.45)
            : const Color(0xFFDC2626);
        fg = isDark ? const Color(0xFFFFF1F2) : const Color(0xFFFFFFFF);
        iconColor = isDark ? const Color(0xFFFCA5A5) : const Color(0xFFFECACA);
        icon = Icons.error_outline_rounded;
      case TopToastType.success:
        bg = isDark ? const Color(0xFF242428) : const Color(0xFF18181B);
        border = isDark
            ? Colors.white.withValues(alpha: 0.22)
            : Colors.black.withValues(alpha: 0.08);
        fg = isDark ? const Color(0xFFF5F5F5) : const Color(0xFFFFFFFF);
        iconColor = const Color(0xFF4ADE80);
        icon = Icons.check_circle_rounded;
      case TopToastType.info:
        bg = isDark ? const Color(0xFF242428) : const Color(0xFF18181B);
        border = isDark
            ? Colors.white.withValues(alpha: 0.22)
            : Colors.black.withValues(alpha: 0.08);
        fg = isDark ? const Color(0xFFF5F5F5) : const Color(0xFFFFFFFF);
        iconColor = isDark ? const Color(0xFF4ADE80) : const Color(0xFF93C5FD);
        icon = Icons.mark_email_read_rounded;
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: 1.1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.18),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item.message,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                  color: fg,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onClose,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: fg.withValues(alpha: 0.72),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
