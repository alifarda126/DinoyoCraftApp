import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_settings.dart';
import '../../core/app_text.dart';
import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/app_info_service.dart';

class PengaturanScreen extends StatefulWidget {
  const PengaturanScreen({super.key});

  @override
  State<PengaturanScreen> createState() => _PengaturanScreenState();
}

class _PengaturanScreenState extends State<PengaturanScreen> {
  // ── State Pengaturan ───────────────────────────────────────────────────────
  static const String _userEmail = 'customer@gmail.com';
  static const String _maskedEmail = 'cus***@gmail.com';
  bool _orderNotification = true;
  bool _whatsAppNotification = true;
  bool _passwordRecentlyChanged = false;
  String get _lastPasswordChanged => _passwordRecentlyChanged
      ? 'Baru saja diubah'.tr
      : 'Terakhir diubah 3 bulan lalu'.tr;

  @override
  void initState() {
    super.initState();
    _settings.syncCacheSize();
    _settings.syncCurrentDevice();
  }

  /// Sumber kebenaran tema/bahasa/2FA/perangkat/cache ada di AppSettings
  /// agar seluruh aplikasi ikut berubah saat diubah dari sini.
  AppSettings get _settings => AppSettings.instance;

  String get _selectedTheme => switch (_settings.themeMode) {
        AppThemeMode.light => 'Terang (Light Mode)'.tr,
        AppThemeMode.dark => 'Gelap (Dark Mode)'.tr,
        AppThemeMode.system => 'Mengikuti Sistem'.tr,
      };

  String get _selectedLanguage =>
      _settings.locale == 'en' ? 'English' : 'Bahasa Indonesia';
  String get _selectedLanguageCode => _settings.locale == 'en' ? 'EN' : 'ID';

  String get _cacheSize => '${_settings.cacheLabel} ${'file sementara'.tr}';
  bool get _isCacheCleaned => _settings.cacheBytes <= 0;

  IconData get _currentThemeIcon => switch (_settings.themeMode) {
        AppThemeMode.light => Icons.light_mode_outlined,
        AppThemeMode.dark => Icons.dark_mode_outlined,
        AppThemeMode.system => Icons.brightness_auto_outlined,
      };

  void _showFeedback(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.black,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(
          message,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ── Helper Modal Bottom Sheet Wrapper ─────────────────────────────────────
  Future<T?> _showAppBottomSheet<T>({
    required Widget Function(BuildContext) builder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(0x73000000),
      builder: builder,
    );
  }

  // ── 1. Ubah Kata Sandi ────────────────────────────────────────────────────
  Future<void> _navigateToNewPassword() async {
    final res = await context.push<bool>('/new-password');
    if (res == true && mounted) {
      setState(() {
        _passwordRecentlyChanged = true;
      });
    }
  }


  // ── 2. Autentikasi 2 Langkah (2FA) ─────────────────────────────────────────
  Future<void> _toggleTwoFactor() async {
    if (_settings.twoFactorEnabled) {
      // Tampilkan dialog konfirmasi nonaktifkan
      final confirm = await showDialog<bool>(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            'Nonaktifkan 2FA?',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          content: Text(
            'Untuk mengonfirmasi penonaktifan Autentikasi 2 Langkah, kami akan mengirimkan kode verifikasi OTP ke email terdaftar Anda ($_maskedEmail).',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx, false),
              child: Text(
                'Batal',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogCtx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: AppColors.white,
                shape: StadiumBorder(),
                elevation: 0,
              ),
              child: Text(
                'Kirim OTP & Nonaktifkan',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      );

      if (confirm == true && mounted) {
        final uri = Uri(
          path: '/verify-otp',
          queryParameters: {
            'from': 'disable_2fa',
            'email': _userEmail,
          },
        );
        final res = await context.push<bool>(uri.toString());
        if (res == true && mounted) {
          setState(() {});
          _showFeedback('Autentikasi 2 Langkah (2FA) berhasil dinonaktifkan.');
        }
      }
    } else {
      // Buka bottom sheet untuk aktifkan via Email
      _showAppBottomSheet<void>(
        builder: (sheetContext) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.borderAlt,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.inputBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.mark_email_read_outlined,
                          color: AppColors.ink,
                          size: 22,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Aktifkan 2FA via Email',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.pop(sheetContext),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Untuk mengaktifkan Autentikasi 2 Langkah, DinoyoCraft akan mengirimkan kode verifikasi 6 digit ke alamat email terdaftar Anda.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.inputBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.borderAlt),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.email_outlined,
                            size: 20,
                            color: AppColors.ink,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email Terdaftar',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                _userEmail,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.successSurface,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Terverifikasi',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.successText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Pastikan Anda selalu memiliki akses ke kotak masuk email ini untuk menerima kode OTP masuk.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(sheetContext);
                        final uri = Uri(
                          path: '/verify-otp',
                          queryParameters: {
                            'from': 'enable_2fa',
                            'email': _userEmail,
                          },
                        );
                        final res = await context.push<bool>(uri.toString());
                        if (res == true && mounted) {
                          setState(() {});
                          _showFeedback(
                            'Autentikasi 2 Langkah via Email berhasil diaktifkan.',
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.black,
                        foregroundColor: AppColors.white,
                        shape: StadiumBorder(),
                        elevation: 0,
                      ),
                      child: Text(
                        'Kirim Kode OTP Verifikasi',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  // ── 3. Perangkat Terhubung ────────────────────────────────────────────────
  void _openConnectedDevicesModal() {
    _showAppBottomSheet<void>(
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final currentDev = _settings.currentDevice;
            final otherList = _settings.otherDevices;

            return Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: AppColors.borderAlt,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Perangkat Terhubung',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Kelola perangkat yang aktif mengakses akun Anda',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close_rounded, size: 20),
                            onPressed: () => Navigator.pop(sheetContext),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Section: Perangkat Ini
                      Text(
                        'PERANGKAT SAAT INI',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 8),

                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.inputBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.borderAlt),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceElevated,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                currentDev.icon,
                                size: 22,
                                color: AppColors.ink,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          currentDev.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.ink,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 7,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.successSurface,
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                        child: Text(
                                          'Aktif Saat Ini',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.successText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    '${currentDev.location} • ${currentDev.details}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () {
                                showDialog<void>(
                                  context: context,
                                  builder: (dlgCtx) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    title: Text(
                                      'Keluar dari Perangkat Ini?',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                    content: Text(
                                      'Sesi akun pada perangkat ini akan dihapus dan Anda akan otomatis keluar ke halaman masuk.',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        height: 1.5,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(dlgCtx),
                                        child: Text(
                                          'Batal',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(dlgCtx);
                                          Navigator.pop(sheetContext);
                                          _settings.logoutCurrentDevice();
                                          context.go('/login');
                                          _showFeedback(
                                            'Perangkat ini telah dihapus. Anda telah otomatis keluar dari akun.',
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.danger,
                                          foregroundColor: AppColors.white,
                                          shape: StadiumBorder(),
                                          elevation: 0,
                                        ),
                                        child: Text(
                                          'Keluar',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.danger,
                                side: BorderSide(color: AppColors.danger),
                                shape: StadiumBorder(),
                                minimumSize: Size(0, 32),
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                              ),
                              child: Text(
                                'Keluar',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      // Section: Perangkat Lain
                      Text(
                        'PERANGKAT LAIN YANG TERHUBUNG',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 8),

                      if (otherList.isNotEmpty) ...[
                        for (int i = 0; i < otherList.length; i++) ...[
                          if (i > 0) SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.borderAlt),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: AppColors.inputBg,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    otherList[i].icon,
                                    size: 22,
                                    color: AppColors.ink,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        otherList[i].name,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.ink,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        '${otherList[i].location} • ${otherList[i].lastActive}',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: () {
                                    final target = otherList[i];
                                    showDialog<void>(
                                      context: context,
                                      builder: (dlgCtx) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18),
                                        ),
                                        title: Text(
                                          'Hapus Sesi Perangkat?',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.ink,
                                          ),
                                        ),
                                        content: Text(
                                          'Sesi "${target.name}" akan dicabut dan perangkat tersebut otomatis ter-logout dari akun Anda.',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13,
                                            height: 1.5,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(dlgCtx),
                                            child: Text(
                                              'Batal',
                                              style: GoogleFonts.plusJakartaSans(
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(dlgCtx);
                                              final removed = _settings.removeOtherDevice(i);
                                              setSheetState(() {});
                                              setState(() {});
                                              _showFeedback(
                                                'Sesi "${removed?.name ?? target.name}" berhasil dihapus. Perangkat tersebut otomatis keluar dari akun.',
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.danger,
                                              foregroundColor: AppColors.white,
                                              shape: StadiumBorder(),
                                              elevation: 0,
                                            ),
                                            child: Text(
                                              'Hapus & Logout',
                                              style: GoogleFonts.plusJakartaSans(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.danger,
                                    side: BorderSide(color: AppColors.danger),
                                    shape: StadiumBorder(),
                                    minimumSize: Size(0, 32),
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                  child: Text(
                                    'Keluar',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                builder: (dlgCtx) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  title: Text(
                                    'Keluar dari Semua Perangkat Lain?',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                  content: Text(
                                    'Semua sesi perangkat lain yang terhubung akan dicabut dan seluruh perangkat tersebut otomatis ter-logout.',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      height: 1.5,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(dlgCtx),
                                      child: Text(
                                        'Batal',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(dlgCtx);
                                        _settings.removeAllOtherDevices();
                                        setSheetState(() {});
                                        setState(() {});
                                        Navigator.pop(sheetContext);
                                        _showFeedback(
                                          'Berhasil keluar dari semua perangkat lain. Semua perangkat tersebut otomatis logout.',
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.danger,
                                        foregroundColor: AppColors.white,
                                        shape: StadiumBorder(),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        'Keluar Semua',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: Icon(Icons.logout_rounded, size: 18),
                            label: Text(
                              'Keluar dari Semua Perangkat Lain',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.danger,
                              side: BorderSide(color: AppColors.danger),
                              shape: StadiumBorder(),
                            ),
                          ),
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSubtle,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.shield_outlined,
                                size: 22,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Hanya perangkat ini yang aktif mengakses akun Anda. Tidak ada sesi perangkat lain yang terhubung.',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    height: 1.4,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── 4. Bahasa Aplikasi ────────────────────────────────────────────────────
  void _openLanguageModal() {
    final languages = [
      {
        'name': 'Bahasa Indonesia',
        'code': 'ID',
        'desc': 'Bahasa default sistem aplikasi'.tr,
      },
      {
        'name': 'English',
        'code': 'EN',
        'desc': 'International English localization'.tr,
      },
    ];

    _showAppBottomSheet<void>(
      builder: (sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.borderAlt,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pilih Bahasa Aplikasi'.tr,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Bahasa tampilan menu & pemberitahuan'.tr,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.pop(sheetContext),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                for (final lang in languages) ...[
                  _buildRadioOptionTile(
                    icon: Icons.language_outlined,
                    title: lang['name']!,
                    subtitle: lang['desc'],
                    pillText: lang['code']!,
                    isSelected: _selectedLanguage == lang['name'],
                    onTap: () {
                      final isEn = lang['code'] == 'EN';
                      _settings.setLocale(isEn ? 'en' : 'id');
                      setState(() {});
                      Navigator.pop(sheetContext);
                      _showFeedback(
                        isEn
                            ? 'App language changed to English.'
                            : 'Bahasa aplikasi diubah ke Bahasa Indonesia.',
                      );
                    },
                  ),
                  SizedBox(height: 10),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // ── 5. Tema Tampilan ──────────────────────────────────────────────────────
  void _openThemeModal() {
    final themes = [
      {
        'name': 'Terang (Light Mode)',
        'icon': Icons.light_mode_outlined,
        'desc': 'Tampilan terang bersih khas keramik Dinoyo',
      },
      {
        'name': 'Gelap (Dark Mode)',
        'icon': Icons.dark_mode_outlined,
        'desc': 'Nuansa gelap nyaman untuk penggunaan malam hari',
      },
      {
        'name': 'Mengikuti Sistem',
        'icon': Icons.brightness_auto_outlined,
        'desc': 'Menyesuaikan mode tampilan sistem perangkat Anda',
      },
    ];

    _showAppBottomSheet<void>(
      builder: (sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.borderAlt,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pilih Tema Tampilan'.tr,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Sesuaikan kenyamanan visual layar'.tr,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.pop(sheetContext),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                for (final th in themes) ...[
                  _buildRadioOptionTile(
                    icon: th['icon'] as IconData,
                    title: (th['name'] as String).tr,
                    subtitle: (th['desc'] as String).tr,
                    isSelected: _settings.themeMode ==
                        (switch (th['name'] as String) {
                          'Gelap (Dark Mode)' => AppThemeMode.dark,
                          'Mengikuti Sistem' => AppThemeMode.system,
                          _ => AppThemeMode.light,
                        }),
                    onTap: () {
                      final mode = switch (th['name'] as String) {
                        'Gelap (Dark Mode)' => AppThemeMode.dark,
                        'Mengikuti Sistem' => AppThemeMode.system,
                        _ => AppThemeMode.light,
                      };
                      _settings.setThemeMode(mode);
                      setState(() {});
                      Navigator.pop(sheetContext);
                      _showFeedback(
                        AppText.isEnglish
                            ? 'Theme changed to ${(th['name'] as String).tr}.'
                            : 'Tema diubah ke ${th['name']}.',
                      );
                    },
                  ),
                  SizedBox(height: 10),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // ── 6. Bersihkan Cache ────────────────────────────────────────────────────
  void _clearCache() {
    if (_isCacheCleaned) {
      _showFeedback('Cache aplikasi sudah bersih (0 B).');
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Bersihkan Cache?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        content: Text(
          'File sementara sebesar ${_settings.cacheLabel} berupa pratinjau '
          'gambar keramik dan data offline akan dihapus. Ini tidak akan '
          'menghapus data akun Anda.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'Batal',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final cleared = _settings.cacheLabel;
              Navigator.pop(dialogCtx);
              await _settings.clearCache();
              if (mounted) {
                setState(() {});
                _showFeedback('Cache sebesar $cleared berhasil dibersihkan.');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.black,
              foregroundColor: AppColors.white,
              shape: StadiumBorder(),
              elevation: 0,
            ),
            child: Text(
              'Bersihkan',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 7. Kebijakan Privasi Modal ────────────────────────────────────────────
  void _openPrivacyPolicyModal() {
    _showLegalSheet(
      title: 'Kebijakan Privasi',
      subtitle: 'Terakhir diperbarui: 1 Oktober 2026',
      icon: Icons.privacy_tip_outlined,
      sections: [
        _LegalSection(
          number: '1',
          heading: 'Komitmen Perlindungan Privasi',
          body:
              'DinoyoCraft berkomitmen menjaga dan menghormati privasi seluruh pengguna, pembeli, serta mitra perajin keramik di kawasan Dinoyo Malang. Data Anda dikelola secara aman sesuai peraturan perlindungan data yang berlaku di Indonesia.',
        ),
        _LegalSection(
          number: '2',
          heading: 'Data yang Dikumpulkan',
          body:
              'Kami mengumpulkan informasi yang Anda berikan secara sukarela, seperti nama lengkap, nomor WhatsApp, alamat tujuan pengiriman pesanan tembikar, serta riwayat interaksi dan transaksi pesanan.',
        ),
        _LegalSection(
          number: '3',
          heading: 'Penggunaan Informasi',
          body:
              'Data Anda digunakan secara eksklusif untuk memproses pesanan kerajinan keramik, koordinasi kurir ekspedisi dengan packing aman, pembaruan nomor resi, serta layanan pelanggan.',
        ),
        _LegalSection(
          number: '4',
          heading: 'Keamanan Transaksi & Akun',
          body:
              'Semua kata sandi dienkripsi dengan standar hash industri. Kami tidak pernah membagikan atau menjual data pribadi Anda kepada pihak ketiga manapun untuk kepentingan komersial.',
        ),
        _LegalSection(
          number: '5',
          heading: 'Hak Pengguna',
          body:
              'Anda berhak memperbarui data diri, mengatur preferensi notifikasi, atau meminta penutupan dan penghapusan akun kapan saja melalui menu Kelola Pengaturan.',
        ),
      ],
    );
  }

  // ── 8. Syarat & Ketentuan Penggunaan ──────────────────────────────────────
  void _openTermsModal() {
    _showLegalSheet(
      title: 'Syarat & Ketentuan Penggunaan',
      subtitle: 'Ketentuan berbelanja & bertransaksi di DinoyoCraft',
      icon: Icons.description_outlined,
      sections: [
        _LegalSection(
          number: '1',
          heading: 'Ketentuan Akun',
          body:
              'Pengguna wajib memberikan informasi yang akurat saat membuat akun dan bertanggung jawab penuh menjaga kerahasiaan kata sandi serta aktivitas yang terjadi pada akun tersebut.',
        ),
        _LegalSection(
          number: '2',
          heading: 'Pemesanan & Pembayaran',
          body:
              'Seluruh harga tertera dalam mata uang Rupiah (IDR). Pesanan akan diproses oleh pengrajin Dinoyo setelah pembayaran terverifikasi secara resmi melalui metode transfer atau e-wallet yang tersedia.',
        ),
        _LegalSection(
          number: '3',
          heading: 'Karakteristik Produk Keramik Hand-made',
          body:
              'Produk keramik Dinoyo merupakan karya seni kerajinan tangan. Sedikit perbedaan dalam corak glasir, dimensi (toleransi 1-2 cm), atau tekstur adalah ciri khas keaslian tembikar lokal dan bukan cacat produksi.',
        ),
        _LegalSection(
          number: '4',
          heading: 'Pengiriman & Pembatalan',
          body:
              'Setiap produk dikemas menggunakan standar pengemasan barang pecah belah. Pembatalan pesanan hanya dapat disetujui jika toko perajin belum memulai proses produksi khusus atau pengemasan paket.',
        ),
        _LegalSection(
          number: '5',
          heading: 'Hak Kekayaan Intelektual',
          body:
              'Seluruh foto katalog, logo, identitas merek, dan desain karya kerajinan keramik di platform ini dilindungi oleh hak kekayaan intelektual milik perajin sentra keramik Dinoyo.',
        ),
      ],
    );
  }

  // ── 9. Kebijakan Garansi Barang Pecah Belah ────────────────────────────────
  void _openWarrantyModal() {
    _showLegalSheet(
      title: 'Garansi Barang Pecah Belah',
      subtitle: '100% Proteksi Pengiriman Keramik DinoyoCraft',
      icon: Icons.gavel_outlined,
      svgPath: AppAssets.iconGaransi,
      extraAction: OutlinedButton.icon(
        onPressed: () {
          Navigator.pop(context);
          context.push('/help');
        },
        icon: Icon(Icons.help_outline_rounded, size: 16),
        label: Text(
          'Pusat Bantuan & Klaim',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          side: BorderSide(color: AppColors.borderAlt),
          shape: StadiumBorder(),
          minimumSize: Size(double.infinity, 48),
        ),
      ),
      sections: [
        _LegalSection(
          number: '1',
          heading: 'Jaminan Proteksi 100% Tanpa Risiko',
          body:
              'Kami memahami kerentanan barang tembikar dan keramik. Setiap pesanan kerajinan di DinoyoCraft dilindungi garansi penggantian penuh jika terjadi kerusakan atau pecah selama proses pengantaran ekspedisi.',
        ),
        _LegalSection(
          number: '2',
          heading: 'Syarat Wajib Video Unboxing',
          body:
              'Untuk memvalidasi klaim asuransi ekspedisi, pembeli wajib merekam video unboxing secara utuh tanpa jeda (no pause/no edit) sejak paket masih tersegel rapi hingga isi barang diperiksa.',
        ),
        _LegalSection(
          number: '3',
          heading: 'Batas Waktu Pengajuan Klaim',
          body:
              'Permohonan klaim garansi harus diajukan maksimal 1 x 24 jam setelah status resi menunjukkan paket telah berhasil diterima oleh penerima.',
        ),
        _LegalSection(
          number: '4',
          heading: 'Pilihan Solusi Penggantian',
          body:
              'Pembeli dapat memilih antara: (a) Pengiriman unit keramik baru secara gratis tanpa biaya ongkir tambahan, ATAU (b) Pengembalian dana penuh (100% refund) sesuai nominal pesanan.',
        ),
      ],
    );
  }

  // Helper untuk sheet legal / informasi
  void _showLegalSheet({
    required String title,
    required String subtitle,
    required IconData icon,
    String? svgPath,
    required List<_LegalSection> sections,
    Widget? extraAction,
  }) {
    _showAppBottomSheet<void>(
      builder: (sheetContext) {
        return Container(
          height: MediaQuery.of(sheetContext).size.height * 0.82,
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 12, bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.borderAlt,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.inputBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: svgPath != null
                            ? Padding(
                                padding: const EdgeInsets.all(9),
                                child: SvgPicture.asset(
                                  svgPath,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.ink,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              )
                            : Icon(icon, size: 20, color: AppColors.ink),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                            Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.pop(sheetContext),
                      ),
                    ],
                  ),
                ),
                Divider(height: 20, color: AppColors.divider),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
                    physics: BouncingScrollPhysics(),
                    itemCount: sections.length,
                    separatorBuilder: (_, _) => SizedBox(height: 16),
                    itemBuilder: (context, i) {
                      final item = sections[i];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.inputBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.borderAlt),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    item.number,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    item.heading,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              item.body,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                height: 1.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: Column(
                    children: [
                      if (extraAction != null) ...[
                        extraAction,
                        SizedBox(height: 10),
                      ],
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(sheetContext),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.black,
                            foregroundColor: AppColors.white,
                            shape: StadiumBorder(),
                            elevation: 0,
                          ),
                          child: Text(
                            'Saya Mengerti',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── 10. Konfirmasi Keluar Akun ─────────────────────────────────────────────
  void _confirmLogout() {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Keluar dari Akun?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        content: Text(
          'Anda harus login kembali untuk mengakses keranjang dan riwayat transaksi kerajinan keramik Anda.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'Batal',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              // Logout dari perangkat ini → login berikutnya butuh OTP
              // (jika 2FA aktif).
              AppSettings.instance.markLoggedOut();
              context.go('/login');
              _showFeedback('Anda telah berhasil keluar dari akun.');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: AppColors.white,
              shape: StadiumBorder(),
              elevation: 0,
            ),
            child: Text(
              'Keluar',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helper Tile Radio Option ──────────────────────────────────────────────
  Widget _buildRadioOptionTile({
    required IconData icon,
    required String title,
    String? subtitle,
    String? pillText,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = AppColors.isDark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF2E2E33) : AppColors.surfaceSubtle)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? (isDark ? Colors.white : AppColors.black)
                : AppColors.borderAlt,
            width: isSelected ? 1.6 : 1,
          ),
          boxShadow: isSelected && isDark
              ? [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.12),
                    blurRadius: 10,
                    spreadRadius: 0.5,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark
                        ? Colors.white.withValues(alpha: 0.16)
                        : AppColors.black)
                    : AppColors.inputBg,
                borderRadius: BorderRadius.circular(10),
                border: isSelected && isDark
                    ? Border.all(
                        color: Colors.white.withValues(alpha: 0.35),
                        width: 1.2,
                      )
                    : null,
              ),
              child: Icon(
                icon,
                size: 19,
                color: isSelected
                    ? Colors.white
                    : AppColors.ink,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (pillText != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark
                          ? Colors.white.withValues(alpha: 0.16)
                          : AppColors.black)
                      : AppColors.inputBg,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isSelected
                        ? (isDark
                            ? Colors.white.withValues(alpha: 0.35)
                            : AppColors.black)
                        : AppColors.borderAlt,
                  ),
                ),
                child: Text(
                  pillText,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.ink,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: isSelected
                  ? (isDark ? Colors.white : AppColors.black)
                  : AppColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ── BUILD UTAMA ───────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _settings,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.bg,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
                    children: [
                      // 1. AKUN & KEAMANAN
                      _buildGroup(
                        'AKUN & KEAMANAN'.tr,
                        [
                          _SettingTile(
                            icon: Icons.lock_outline_rounded,
                            title: 'Ubah Kata Sandi'.tr,
                            subtitle: _lastPasswordChanged,
                            route: '/new-password',
                            onTap: _navigateToNewPassword,
                          ),
                          _SettingTile(
                            icon: Icons.verified_user_outlined,
                            title: 'Autentikasi 2 Langkah (2FA)'.tr,
                            subtitle: _settings.twoFactorEnabled
                                ? '${'Aktif via Email'.tr} ($_maskedEmail)'
                                : 'Tingkatkan keamanan akun via Email OTP'.tr,
                            onTap: _toggleTwoFactor,
                            trailing: Switch(
                              value: _settings.twoFactorEnabled,
                              activeThumbColor: AppColors.black,
                              onChanged: (_) => _toggleTwoFactor(),
                            ),
                          ),
                          _SettingTile(
                            icon: Icons.devices_outlined,
                            title: 'Perangkat Terhubung'.tr,
                            subtitle: _settings.hasOtherDevices
                                ? '${_settings.otherDevices.length + 1} '
                                    '${'perangkat aktif saat ini'.tr}'
                                : '1 perangkat aktif saat ini'.tr,
                            onTap: _openConnectedDevicesModal,
                          ),
                          _SettingTile(
                            icon: Icons.delete_outline_rounded,
                            title: 'Hapus Akun'.tr,
                            subtitle: 'Nonaktifkan akun secara permanen'.tr,
                            destructive: true,
                            route: '/hapus-akun',
                          ),
                        ],
                      ),
                  SizedBox(height: 18),

                  // 2. NOTIFIKASI
                  _buildGroup(
                    'NOTIFIKASI'.tr,
                    [
                      _SettingTile(
                        icon: Icons.local_shipping_outlined,
                        title: 'Status Pesanan & Pengiriman'.tr,
                        subtitle: 'Notifikasi status pesanan dan pengiriman'.tr,
                        onTap: () {
                          setState(
                            () => _orderNotification = !_orderNotification,
                          );
                          _showFeedback(
                            _orderNotification
                                ? 'Notifikasi pesanan & pengiriman diaktifkan.'
                                : 'Notifikasi pesanan & pengiriman dinonaktifkan.',
                          );
                        },
                        trailing: Switch(
                          value: _orderNotification,
                          activeThumbColor: AppColors.black,
                          onChanged: (v) {
                            setState(() => _orderNotification = v);
                            _showFeedback(
                              v
                                  ? 'Notifikasi pesanan & pengiriman diaktifkan.'
                                  : 'Notifikasi pesanan & pengiriman dinonaktifkan.',
                            );
                          },
                        ),
                      ),
                      _SettingTile(
                        icon: Icons.chat_bubble_outline_rounded,
                        title: 'Notifikasi via WhatsApp'.tr,
                        subtitle: 'Terima update pesanan melalui WhatsApp'.tr,
                        onTap: () {
                          setState(
                            () =>
                                _whatsAppNotification = !_whatsAppNotification,
                          );
                          _showFeedback(
                            _whatsAppNotification
                                ? 'Notifikasi via WhatsApp diaktifkan.'
                                : 'Notifikasi via WhatsApp dinonaktifkan.',
                          );
                        },
                        trailing: Switch(
                          value: _whatsAppNotification,
                          activeThumbColor: AppColors.black,
                          onChanged: (v) {
                            setState(() => _whatsAppNotification = v);
                            _showFeedback(
                              v
                                  ? 'Notifikasi via WhatsApp diaktifkan.'
                                  : 'Notifikasi via WhatsApp dinonaktifkan.',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18),

                  // 3. PREFERENSI APLIKASI
                  _buildGroup(
                    'PREFERENSI APLIKASI'.tr,
                    [
                      _SettingTile(
                        icon: Icons.language_outlined,
                        title: 'Bahasa Aplikasi'.tr,
                        subtitle: _selectedLanguage,
                        trailingPill: _selectedLanguageCode,
                        onTap: _openLanguageModal,
                      ),
                      _SettingTile(
                        icon: _currentThemeIcon,
                        title: 'Tema Tampilan'.tr,
                        subtitle: _selectedTheme,
                        onTap: _openThemeModal,
                      ),
                      _SettingTile(
                        icon: Icons.cleaning_services_outlined,
                        title: 'Bersihkan Cache'.tr,
                        subtitle: _cacheSize,
                        trailingPillAction: _isCacheCleaned
                            ? 'Bersih'.tr
                            : 'Bersihkan'.tr,
                        onPillAction: _clearCache,
                        onTap: _clearCache,
                      ),
                    ],
                  ),
                  SizedBox(height: 18),

                  // 4. PRIVASI & LEGALITAS
                  _buildGroup(
                    'PRIVASI & LEGALITAS'.tr,
                    [
                      _SettingTile(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Kebijakan Privasi'.tr,
                        onTap: _openPrivacyPolicyModal,
                      ),
                      _SettingTile(
                        icon: Icons.description_outlined,
                        title: 'Syarat & Ketentuan Penggunaan'.tr,
                        onTap: _openTermsModal,
                      ),
                      _SettingTile(
                        icon: Icons.gavel_outlined,
                        svgPath: AppAssets.iconGaransi,
                        title: 'Kebijakan Garansi Barang Pecah Belah'.tr,
                        onTap: _openWarrantyModal,
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // 5. Keluar dari Akun
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: _confirmLogout,
                      icon: Icon(
                        Icons.logout_rounded,
                        size: 20,
                        color: AppColors.danger,
                      ),
                      label: Text(
                        'Keluar dari Akun'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.danger,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppColors.danger,
                          width: 1.5,
                        ),
                        shape: StadiumBorder(),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        backgroundColor: AppColors.surface,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      AppInfoService.instance.versionLabel,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(height: 3),
                  Center(
                    child: Text(
                      'Sentra Keramik Dinoyo Malang • Jawa Timur'.tr,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 54,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/profile');
              }
            },
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 19),
          ),
          Expanded(
            child: Text(
              'Kelola Pengaturan'.tr,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
          SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildGroup(String heading, List<Widget> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderAlt),
          ),
          child: Column(
            children: [
              for (var i = 0; i < tiles.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 1,
                    indent: 60,
                    color: AppColors.divider,
                  ),
                tiles[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.icon,
    required this.title,
    this.svgPath,
    this.subtitle,
    this.trailing,
    this.trailingPill,
    this.trailingPillAction,
    this.onPillAction,
    this.destructive = false,
    this.route,
    this.onTap,
  });

  final IconData icon;
  final String? svgPath; // jika diisi, SVG ini menggantikan icon Material
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final String? trailingPill;
  final String? trailingPillAction;
  final VoidCallback? onPillAction;
  final bool destructive;
  final String? route;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark || AppColors.isDark;
    final titleColor = destructive ? _destructiveColor : AppColors.ink;

    final effectiveTap =
        onTap ?? (route != null ? () => context.push(route!) : null);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: effectiveTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2A2A) : AppColors.inputBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: svgPath != null
                  ? Padding(
                      padding: const EdgeInsets.all(9),
                      child: SvgPicture.asset(
                        svgPath!,
                        colorFilter: ColorFilter.mode(
                          destructive ? _destructiveColor : AppColors.ink,
                          BlendMode.srcIn,
                        ),
                      ),
                    )
                  : Icon(
                      icon,
                      size: 18,
                      color: destructive ? _destructiveColor : AppColors.ink,
                    ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        height: 1.4,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 8),
            if (trailing != null)
              trailing!
            else if (trailingPill != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.borderAlt),
                ),
                child: Text(
                  trailingPill!,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              )
            else if (trailingPillAction != null)
              InkWell(
                onTap: onPillAction ?? effectiveTap,
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.inputBg,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.borderAlt),
                  ),
                  child: Text(
                    trailingPillAction!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              )
            else
              Icon(
                Icons.chevron_right,
                size: 18,
                color: AppColors.textMuted,
              ),
          ],
        ),
      ),
    );
  }

  Color get _destructiveColor => AppColors.danger;
}

class _LegalSection {
  const _LegalSection({
    required this.number,
    required this.heading,
    required this.body,
  });

  final String number;
  final String heading;
  final String body;
}
