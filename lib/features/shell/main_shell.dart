import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/dc_bottom_nav.dart';
import '../../features/chatbot/chatbot_screen.dart';
import '../../core/assets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // Posisi FAB — null = belum dihitung, akan di-init saat build pertama
  Offset? _fabPos;
  bool _posInitialized = false;

  // Ukuran FAB
  static const double _fabSize = 56.0;
  // Gap dari tepi
  static const double _edgePad = 16.0;

  @override
  Widget build(BuildContext context) {
    final index = widget.navigationShell.currentIndex;
    final showFab = index != 4;

    final mq = MediaQuery.of(context);
    final screenW = mq.size.width;
    final screenH = mq.size.height;

    // Batas atas: di bawah status bar + header (~88px)
    final topBound = mq.padding.top + 72.0;
    // Batas bawah: di atas navbar (navbar height ≈ 76 + bottomPad ~28 + overflowTop 20)
    final navbarH = 76.0 + mq.padding.bottom.clamp(8.0, 28.0);
    final bottomBound = screenH - navbarH - _fabSize - _edgePad;

    // Posisi default: kanan bawah tepat di atas navbar
    if (!_posInitialized && screenW > 0 && screenH > 0) {
      _fabPos = Offset(
        screenW - _fabSize - _edgePad,
        bottomBound,
      );
      _posInitialized = true;
    }

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // ── konten halaman ──────────────────────────────────────────────
          widget.navigationShell,

          // ── draggable FAB ───────────────────────────────────────────────
          if (showFab && _fabPos != null)
            Positioned(
              left: _fabPos!.dx,
              top: _fabPos!.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    double nx = _fabPos!.dx + details.delta.dx;
                    double ny = _fabPos!.dy + details.delta.dy;
                    nx = nx.clamp(_edgePad, screenW - _fabSize - _edgePad);
                    ny = ny.clamp(topBound, bottomBound);
                    _fabPos = Offset(nx, ny);
                  });
                },
                onPanEnd: (_) {
                  // Snap ke sisi kiri atau kanan yang terdekat
                  final center = _fabPos!.dx + _fabSize / 2;
                  final snapX = center < screenW / 2
                      ? _edgePad                          // kiri
                      : screenW - _fabSize - _edgePad;    // kanan
                  setState(() {
                    _fabPos = Offset(snapX, _fabPos!.dy);
                  });
                },
                onTap: () => showClayBotPopup(context),
                child: _DraggableFabButton(),
              ),
            ),
        ],
      ),
      bottomNavigationBar: DcBottomNav(
        currentIndex: index,
        onTap: (i) => widget.navigationShell.goBranch(
          i,
          initialLocation: i == widget.navigationShell.currentIndex,
        ),
      ),
    );
  }
}

// ─── FAB button widget ────────────────────────────────────────────────────────
class _DraggableFabButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            AppAssets.iconChat,
            width: 24,
            height: 24,
            colorFilter:
                const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
