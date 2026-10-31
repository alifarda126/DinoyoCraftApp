import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_text.dart';

/// Service singleton untuk memantau status koneksi internet pengguna secara real-time.
class ConnectivityService {
  ConnectivityService._internal();
  static final ConnectivityService instance = ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// ValueNotifier status online/offline agar UI dapat bereaksi secara instan.
  final ValueNotifier<bool> isOnlineNotifier = ValueNotifier<bool>(true);

  bool get isOnline => isOnlineNotifier.value;

  /// Inisialisasi pemantauan koneksi internet.
  Future<void> initialize() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateStatus(results);

      _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
    } catch (e) {
      debugPrint('[ConnectivityService] Inisialisasi offline detector (safe fallback): $e');
    }
  }

  void _updateStatus(List<ConnectivityResult> results) {
    // Online bila ada salah satu koneksi (wifi, mobile, ethernet, vpn)
    final online = results.any((r) =>
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.ethernet ||
        r == ConnectivityResult.vpn);

    if (isOnlineNotifier.value != online) {
      isOnlineNotifier.value = online;
      debugPrint('[ConnectivityService] Status koneksi berubah: ${online ? "ONLINE" : "OFFLINE"}');
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}

/// Banner status koneksi otomatis premium bergaya YouTube / Shopee:
/// - Saat internet putus: 🔴 "Tidak ada koneksi internet" turun dari atas dan tetap tampil.
/// - Saat internet balik: 🟢 "Koneksi tersambung kembali" berubah hijau lalu otomatis hilang setelah 2.5 detik.
class OfflineBannerWrapper extends StatefulWidget {
  const OfflineBannerWrapper({super.key, required this.child});

  final Widget child;

  @override
  State<OfflineBannerWrapper> createState() => _OfflineBannerWrapperState();
}

class _OfflineBannerWrapperState extends State<OfflineBannerWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  Timer? _dismissTimer;
  bool _wasOffline = false;
  _BannerType _bannerType = _BannerType.hidden;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    // Periksa status awal
    if (!ConnectivityService.instance.isOnline) {
      _wasOffline = true;
      _bannerType = _BannerType.offline;
      _animController.value = 1.0;
    }

    ConnectivityService.instance.isOnlineNotifier.addListener(_onConnectivityChanged);
  }

  @override
  void dispose() {
    ConnectivityService.instance.isOnlineNotifier.removeListener(_onConnectivityChanged);
    _dismissTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _onConnectivityChanged() {
    final isOnline = ConnectivityService.instance.isOnline;
    _dismissTimer?.cancel();

    if (!isOnline) {
      _wasOffline = true;
      setState(() {
        _bannerType = _BannerType.offline;
      });
      _animController.forward();
    } else if (_wasOffline) {
      setState(() {
        _bannerType = _BannerType.reconnected;
      });
      _animController.forward();

      // Hilang otomatis setelah 2.5 detik (YouTube/Shopee UX)
      _dismissTimer = Timer(const Duration(milliseconds: 2500), () {
        if (!mounted) return;
        _animController.reverse().then((_) {
          if (mounted) {
            setState(() {
              _bannerType = _BannerType.hidden;
              _wasOffline = false;
            });
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_bannerType != _BannerType.hidden)
          Positioned(
            top: MediaQuery.paddingOf(context).top + 8,
            left: 16,
            right: 16,
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: _bannerType == _BannerType.offline
                          ? const Color(0xFFDC2626) // 🔴 Merah
                          : const Color(0xFF16A34A), // 🟢 Hijau
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _bannerType == _BannerType.offline
                              ? Icons.wifi_off_rounded
                              : Icons.check_circle_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _bannerType == _BannerType.offline
                                ? 'Tidak ada koneksi internet'.tr
                                : 'Koneksi tersambung kembali'.tr,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

enum _BannerType {
  hidden,
  offline,
  reconnected,
}

