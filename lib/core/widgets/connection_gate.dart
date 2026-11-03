import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_text.dart';
import '../network/api_client.dart';
import '../network/server_status.dart';
import '../services/connectivity_service.dart';
import '../theme/app_colors.dart';

/// Gerbang layar penuh ala e-commerce profesional (Shopee/Tokopedia):
///
/// - Internet putus          -> halaman "Tidak Ada Koneksi Internet",
///                              kembali OTOMATIS begitu online.
/// - Online tapi server mati -> halaman "Server Tidak Dapat Dihubungi"
///                              dengan ping otomatis + tombol Coba Lagi.
///
/// Dipasang di atas seluruh aplikasi (MaterialApp.builder) sehingga
/// TIDAK ADA layar yang menampilkan error jaringan mentah lagi.
class ConnectionGate extends StatelessWidget {
  const ConnectionGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        ConnectivityService.instance.isOnlineNotifier,
        ServerStatus.reachable,
      ]),
      builder: (context, _) {
        final online = ConnectivityService.instance.isOnline;
        final serverUp = ServerStatus.isReachable;

        if (!online) return const NoInternetPage();
        if (!serverUp) return const ServerUnavailablePage();
        return child;
      },
    );
  }
}

/// ══════════════════════════════════════════════════════════════════════
/// Halaman: TIDAK ADA KETERANGAN INTERNET
/// ══════════════════════════════════════════════════════════════════════
class NoInternetPage extends StatefulWidget {
  const NoInternetPage({super.key});

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  bool _checking = false;

  Future<void> _retry() async {
    if (_checking) return;
    setState(() => _checking = true);
    // Paksa ping server; bila internet sudah kembali, ApiClient akan
    // menandai ServerStatus up dan ConnectionGate membuka aplikasi.
    try {
      await ApiClient.get('/products/public?page=1&limit=1');
      ServerStatus.markUp();
    } catch (_) {
      // Masih offline — halaman tetap, pengguna dapat mencoba lagi.
    }
    if (mounted) setState(() => _checking = false);
  }

  @override
  Widget build(BuildContext context) {
    return _GateScaffold(
      icon: Icons.wifi_off_rounded,
      iconColor: AppColors.textMuted,
      title: 'Tidak Ada Koneksi Internet'.tr,
      subtitle:
          'Koneksi internetmu terputus. Periksa Wi-Fi atau kuota datamu, lalu coba lagi.'
              .tr,
      tips: [
        'Pastikan Wi-Fi atau data seluler aktif'.tr,
        'Coba pindah ke area dengan sinyal lebih kuat'.tr,
        'Aktifkan mode pesawat lalu matikan kembali'.tr,
      ],
      onRetry: _retry,
      checking: _checking,
      footnote: 'Halaman akan terbuka otomatis saat koneksi kembali.'.tr,
    );
  }
}

/// ══════════════════════════════════════════════════════════════════════
/// Halaman: SERVER TIDAK DAPAT DIHUBUNGI
/// ══════════════════════════════════════════════════════════════════════
class ServerUnavailablePage extends StatefulWidget {
  const ServerUnavailablePage({super.key});

  @override
  State<ServerUnavailablePage> createState() => _ServerUnavailablePageState();
}

class _ServerUnavailablePageState extends State<ServerUnavailablePage> {
  bool _checking = false;
  Timer? _autoPing;

  @override
  void initState() {
    super.initState();
    // Ping otomatis tiap 10 detik: begitu server hidup, aplikasi terbuka
    // sendiri tanpa user perlu menekan apa pun.
    _autoPing = Timer.periodic(const Duration(seconds: 10), (_) => _retry(silent: true));
  }

  @override
  void dispose() {
    _autoPing?.cancel();
    super.dispose();
  }

  Future<void> _retry({bool silent = false}) async {
    if (_checking) return;
    if (!silent && mounted) setState(() => _checking = true);
    try {
      await ApiClient.get('/products/public?page=1&limit=1');
      ServerStatus.markUp(); // respons diterima -> server hidup
    } catch (_) {
      // Tetap gagal — tunggu siklus berikutnya.
    }
    if (mounted && !silent) setState(() => _checking = false);
  }

  @override
  Widget build(BuildContext context) {
    return _GateScaffold(
      icon: Icons.cloud_off_rounded,
      iconColor: AppColors.textMuted,
      title: 'Server Tidak Dapat Dihubungi'.tr,
      subtitle:
          'Internetmu normal, tetapi server DinoyoCraft sedang tidak dapat dijangkau. Kemungkinan sedang dalam pemeliharaan.'
              .tr,
      tips: [
        'Tunggu beberapa saat lalu coba lagi'.tr,
        'Pastikan server backend sedang berjalan'.tr,
        'Data pesananmu tetap aman dan tersinkron otomatis'.tr,
      ],
      onRetry: () => _retry(),
      checking: _checking,
      footnote: 'Kami memeriksa koneksi ke server secara berkala...'.tr,
    );
  }
}

/// ══════════════════════════════════════════════════════════════════════
/// Kerangka visual bersama kedua halaman
/// ══════════════════════════════════════════════════════════════════════
class _GateScaffold extends StatelessWidget {
  const _GateScaffold({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.tips,
    required this.onRetry,
    required this.checking,
    required this.footnote,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final List<String> tips;
  final VoidCallback onRetry;
  final bool checking;
  final String footnote;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ilustrasi lingkaran lembut
                Container(
                  width: 132,
                  height: 132,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceSubtle,
                    border: Border.all(color: AppColors.border, width: 1.5),
                  ),
                  child: Icon(icon, size: 64, color: iconColor),
                ),
                const SizedBox(height: 28),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    height: 1.55,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 22),

                // Tips bergaya kartu
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final tip in tips) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check_circle_outline_rounded,
                                size: 15, color: AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                tip,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  height: 1.45,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (tip != tips.last) const SizedBox(height: 10),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 26),

                // Tombol Coba Lagi
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: checking ? null : onRetry,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.black,
                      foregroundColor: AppColors.white,
                      shape: const StadiumBorder(),
                      elevation: 0,
                    ),
                    child: checking
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.refresh_rounded, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Coba Lagi'.tr,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  footnote,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
