import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Wrapper global untuk otomatis menutup keyboard saat pengguna mengetuk (tap)
/// area di luar kolom teks (misalnya background, label, atau area di atas keyboard).
///
/// Fitur UX Sesuai Permintaan:
/// 1. Bisa di-scroll (hold/drag) langsung tanpa keyboard menutup kembali.
/// 2. Berpindah langsung saat menekan kolom teks lain di bawahnya tanpa keyboard buka-tutup
///    (menghilangkan animasi loop naik-turun pada form/sheet).
/// 3. Hanya saat mengetuk/menekan area (selain kolom teks) "bukan scroll", keyboard
///    otomatis tertutup secara halus.
class KeyboardDismissWrapper extends StatefulWidget {
  const KeyboardDismissWrapper({super.key, required this.child});

  final Widget child;

  @override
  State<KeyboardDismissWrapper> createState() => _KeyboardDismissWrapperState();
}

class _KeyboardDismissWrapperState extends State<KeyboardDismissWrapper> {
  Offset? _pointerDownPosition;
  int? _pointerDownTime;
  int? _pointerId;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (event) {
        _pointerId = event.pointer;
        _pointerDownPosition = event.position;
        _pointerDownTime = DateTime.now().millisecondsSinceEpoch;
      },
      onPointerUp: (event) {
        if (_pointerId != event.pointer) return;
        final downPos = _pointerDownPosition;
        final downTime = _pointerDownTime;
        _pointerDownPosition = null;
        _pointerDownTime = null;
        _pointerId = null;

        if (downPos == null || downTime == null) return;

        // Jika jarak pergerakan melebihi threshold (> 18dp),
        // ini adalah gesture scroll / drag / hold, BUKAN tap biasa.
        // Scroll / drag TIDAK boleh menutup keyboard agar pengguna leluasa menggeser form.
        final distance = (event.position - downPos).distance;
        if (distance > 18.0) return;

        // Jika durasi terlalu lama (> 500ms), ini hold/long press, bukan tap cepat
        final elapsed = DateTime.now().millisecondsSinceEpoch - downTime;
        if (elapsed > 500) return;

        // Cek apakah ada input aktif (keyboard sedang terbuka)
        final currentFocus = FocusManager.instance.primaryFocus;
        if (currentFocus == null || !currentFocus.hasFocus) return;

        // Cek apakah area yang diketuk adalah textfield (baik input yang sedang aktif maupun input lainnya)
        if (_isPointerOnTextField(event.position)) {
          // Mengetuk kolom teks lain: jangan unfocus agar keyboard tidak buka-tutup
          return;
        }

        // Pengguna mengetuk area kosong / non-input: tutup keyboard
        currentFocus.unfocus();
      },
      onPointerCancel: (_) {
        _pointerDownPosition = null;
        _pointerDownTime = null;
        _pointerId = null;
      },
      child: widget.child,
    );
  }

  bool _isPointerOnTextField(Offset globalPosition) {
    try {
      final result = BoxHitTestResult();
      WidgetsBinding.instance.hitTestInView(
        result,
        globalPosition,
        View.of(context).viewId,
      );
      for (final entry in result.path) {
        final target = entry.target;
        if (target is RenderEditable) {
          return true;
        }
        if (target is RenderObject) {
          RenderObject? current = target.parent;
          int depth = 0;
          while (current != null && depth < 10) {
            if (current is RenderEditable) return true;
            current = current.parent;
            depth++;
          }
        }
      }
    } catch (_) {}
    return false;
  }
}
