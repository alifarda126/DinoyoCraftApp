import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Utilitas untuk menjalankan animasi parabola "terlempar ke keranjang"
/// saat produk ditambahkan ke keranjang belanja.
class CartFlyAnimation {
  /// Daftar target ikon keranjang aktif yang ter-mount di layar
  static final Set<BuildContext> _activeTargets = <BuildContext>{};

  /// Opsional override key jika dibutuhkan
  static GlobalKey? cartKey;

  /// ValueNotifier untuk memicu animasi pantulan (bounce/pulse) pada ikon keranjang saat produk mendarat
  static final ValueNotifier<int> cartBounceTrigger = ValueNotifier<int>(0);

  /// Jalankan animasi produk terlempar ke keranjang
  static void run(
    BuildContext context, {
    required String imagePath,
    Offset? startPosition,
    Offset? targetPosition,
    VoidCallback? onComplete,
  }) {
    // Ambil root overlay agar animasi berjalan mulus di atas seluruh layar dan modal yang sedang ditutup
    final navigator = Navigator.maybeOf(context, rootNavigator: true) ??
        Navigator.maybeOf(context);
    final overlayState = navigator?.overlay ?? Overlay.maybeOf(context);
    if (overlayState == null) {
      onComplete?.call();
      return;
    }

    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;

    // Start position: bila tidak diberikan, default ke posisi thumbnail modal (kiri bawah)
    final start = startPosition ??
        Offset(screenSize.width * 0.25, screenSize.height * 0.65);

    // Target position: prioritaskan targetPosition, lalu target aktif ter-mount, fallback ke kanan atas
    Offset end;
    if (targetPosition != null) {
      end = targetPosition;
    } else {
      RenderBox? activeBox;
      // Cek manual override cartKey bila ada
      if (cartKey?.currentContext != null && cartKey!.currentContext!.mounted) {
        final box = cartKey!.currentContext!.findRenderObject() as RenderBox?;
        if (box != null && box.hasSize && box.attached) {
          activeBox = box;
        }
      }
      // Bila belum, cari dari target aktif (layar teratas)
      if (activeBox == null) {
        for (final ctx in _activeTargets.toList().reversed) {
          if (ctx.mounted) {
            final box = ctx.findRenderObject() as RenderBox?;
            if (box != null && box.hasSize && box.attached) {
              activeBox = box;
              break;
            }
          }
        }
      }

      if (activeBox != null) {
        end = activeBox.localToGlobal(
          Offset(activeBox.size.width / 2, activeBox.size.height / 2),
        );
      } else {
        // Fallback default: pojok kanan atas tempat ikon keranjang biasa berada di header
        end = Offset(screenSize.width - 58, mediaQuery.padding.top + 28);
      }
    }

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => _FlyingProductWidget(
        imagePath: imagePath,
        start: start,
        end: end,
        onFinished: () {
          entry.remove();
          // Memicu pantulan ikon keranjang
          cartBounceTrigger.value++;
          onComplete?.call();
        },
      ),
    );

    overlayState.insert(entry);
  }
}

class _FlyingProductWidget extends StatefulWidget {
  const _FlyingProductWidget({
    required this.imagePath,
    required this.start,
    required this.end,
    required this.onFinished,
  });

  final String imagePath;
  final Offset start;
  final Offset end;
  final VoidCallback onFinished;

  @override
  State<_FlyingProductWidget> createState() => _FlyingProductWidgetState();
}

class _FlyingProductWidgetState extends State<_FlyingProductWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _curvedAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _curvedAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onFinished();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p0 = widget.start;
    final p2 = widget.end;

    // Titik puncak lemparan:
    // P1 dibuat lebih tinggi (y lebih kecil) agar melengkung ke atas seperti dilempar ke udara
    final minY = math.min(p0.dy, p2.dy);
    final apexY = math.max(16.0, minY - 90.0);
    // x1 sedikit condong ke arah target
    final apexX = p0.dx + (p2.dx - p0.dx) * 0.25;
    final p1 = Offset(apexX, apexY);

    return AnimatedBuilder(
      animation: _curvedAnim,
      builder: (context, child) {
        final t = _curvedAnim.value;

        // Quadratic Bezier: B(t) = (1-t)^2 * P0 + 2(1-t)t * P1 + t^2 * P2
        final oneMinusT = 1.0 - t;
        final currentX = oneMinusT * oneMinusT * p0.dx +
            2 * oneMinusT * t * p1.dx +
            t * t * p2.dx;
        final currentY = oneMinusT * oneMinusT * p0.dy +
            2 * oneMinusT * t * p1.dy +
            t * t * p2.dy;

        // Skala:
        // t in [0.0, 0.25]: tumbuh sedikit 1.0 -> 1.18 (efek melompat/terlempar mendekat)
        // t in [0.25, 0.70]: 1.18 -> 0.85 (melayang di udara)
        // t in [0.70, 1.00]: 0.85 -> 0.18 (menyusut masuk ke keranjang)
        double scale;
        if (t < 0.25) {
          scale = 1.0 + (t / 0.25) * 0.18;
        } else if (t < 0.70) {
          final subT = (t - 0.25) / 0.45;
          scale = 1.18 - subT * 0.33;
        } else {
          final subT = (t - 0.70) / 0.30;
          scale = 0.85 - subT * 0.67;
        }

        // Rotasi organik: lembut berputar saat melayang di udara
        final rotation = math.sin(t * math.pi) * 0.35;

        // Opacity: penuh sampai 85%, lalu memudar cepat saat masuk
        final opacity =
            t < 0.85 ? 1.0 : (1.0 - (t - 0.85) / 0.15).clamp(0.0, 1.0);

        const baseSize = 64.0;

        return Positioned(
          left: currentX - (baseSize / 2),
          top: currentY - (baseSize / 2),
          child: IgnorePointer(
            child: Opacity(
              opacity: opacity,
              child: Transform.rotate(
                angle: rotation,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: baseSize,
                    height: baseSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white, width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.30),
                          blurRadius: 14,
                          spreadRadius: 2,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13.5),
                      child: Image.asset(
                        widget.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: const Color(0xFFE0E0E0),
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Widget pembungkus tombol keranjang yang akan memantul (bounce/pulse kenyal)
/// ketika ada produk yang berhasil masuk ke keranjang.
class CartBounceTarget extends StatefulWidget {
  const CartBounceTarget({super.key, required this.child});

  final Widget child;

  @override
  State<CartBounceTarget> createState() => _CartBounceTargetState();
}

class _CartBounceTargetState extends State<CartBounceTarget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );

    // Animasi kenyal: 1.0 -> 1.35 -> 0.88 -> 1.08 -> 1.0
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.35)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.35, end: 0.88)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.88, end: 1.08)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.08, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 20,
      ),
    ]).animate(_bounceController);

    CartFlyAnimation.cartBounceTrigger.addListener(_onTriggerBounce);
    CartFlyAnimation._activeTargets.add(context);
  }

  void _onTriggerBounce() {
    if (mounted) {
      _bounceController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    CartFlyAnimation._activeTargets.remove(context);
    CartFlyAnimation.cartBounceTrigger.removeListener(_onTriggerBounce);
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.child,
    );
  }
}
