import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_settings.dart';
import '../../core/theme/app_colors.dart';

/// Halaman Verifikasi OTP — disesuaikan dengan desain Verifikasi_Daftar_Akun.png.
class OtpScreen extends StatefulWidget {
const   OtpScreen({super.key, this.from = 'register', this.email});

  final String from;

  /// Email tujuan kode. Jika null, ditampilkan contoh "m●●●●●@email.com".
  final String? email;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const String _illustration = 'assets/images/Icon_verifikasi_OTP.png';
  static const int _resendDelay = 60; // detik

  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focus = List.generate(6, (_) => FocusNode());

  Timer? _timer;
  int _seconds = _resendDelay;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focus) {
      f.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _seconds = _resendDelay);
    _timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_seconds <= 1) {
        t.cancel();
        setState(() => _seconds = 0);
      } else {
        setState(() => _seconds--);
      }
    });
  }

  String get _timerText {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get _maskedEmail {
    final e = widget.email;
    if (e == null || !e.contains('@')) return 'm●●●●●@email.com';
    final parts = e.split('@');
    final first = parts.first.isEmpty ? '' : parts.first[0];
    return '$first●●●●●@${parts.last}';
  }

  bool get _complete => _controllers.every((c) => c.text.trim().isNotEmpty);

  void _continue() {
    if (!_complete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lengkapi 6 digit kode verifikasi')),
      );
      return;
    }
    if (widget.from == 'login') {
      // Verifikasi 2FA berhasil — login berikutnya tidak minta OTP lagi.
      AppSettings.instance.consumeOtpRequirement();
      context.go('/home');
    } else if (widget.from == 'forgot') {
      context.go('/login');
    } else {
      context.go('/home');
    }
  }

  void _resend() {
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kode baru telah dikirim (mock)')),
    );
  }

  void _back() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  // ═══ Header: ← Kembali ........ (?) ═════════════════════════════════════
  PreferredSizeWidget _buildHeader() {
    return AppBar(
      backgroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 20,
      title: GestureDetector(
        onTap: _back,
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back_rounded, size: 22, color: AppColors.ink),
            SizedBox(width: 10),
            Text(
              'Kembali',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => context.push('/help'),
          icon: Icon(
            Icons.help_outline_rounded,
            size: 22,
            color: AppColors.textMuted,
          ),
        ),
        SizedBox(width: 12),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: AppColors.border),
      ),
    );
  }

  // ═══ Kotak OTP: 40x52, border hitam tebal, bayangan lembut ══════════════
  Widget _otpBox(int i) {
    return Container(
      width: 40,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: TextField(
          controller: _controllers[i],
          focusNode: _focus[i],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          cursorColor: AppColors.ink,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
          decoration: InputDecoration(
            isDense: true,
            counterText: '',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (v) {
            if (v.isNotEmpty && i < 5) {
              _focus[i + 1].requestFocus();
            } else if (v.isEmpty && i > 0) {
              _focus[i - 1].requestFocus();
            }
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isForgot = widget.from == 'forgot';
    final isLogin = widget.from == 'login';
    final grayStyle = GoogleFonts.plusJakartaSans(
      fontSize: 12,
      color: AppColors.textSecondary,
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildHeader(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 56, 26, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Ilustrasi ──
              Center(
                child: Image.asset(
                  _illustration,
                  height: 140,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 20),

              // ── Judul + deskripsi ──
              Text(
                isLogin
                    ? 'Verifikasi Keamanan'
                    : isForgot
                        ? 'Verifikasi Lupa Password'
                        : 'Verifikasi Akun',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  color: AppColors.ink,
                ),
              ),
              SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    height: 1.7,
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    TextSpan(
                      text: 'Masukkan kode verifikasi 6 digit yang telah kami\n'
                          'kirimkan ke email ',
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(
                          Icons.mail_outline_rounded,
                          size: 14,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: _maskedEmail,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        height: 1.7,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),

              // ── 6 kotak OTP ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < 6; i++) ...[
                    if (i > 0) SizedBox(width: 10),
                    _otpBox(i),
                  ],
                ],
              ),
              SizedBox(height: 26),

              // ── Hitung mundur kirim ulang ──
              Text(
                'Belum menerima kode?',
                textAlign: TextAlign.center,
                style: grayStyle,
              ),
              SizedBox(height: 6),
              if (_seconds > 0)
                Text.rich(
                  TextSpan(
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.ink,
                    ),
                    children: [
                      TextSpan(text: 'Kirim ulang kode dalam '),
                      TextSpan(
                        text: _timerText,
                        style: GoogleFonts.robotoMono(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                )
              else
                GestureDetector(
                  onTap: _resend,
                  behavior: HitTestBehavior.opaque,
                  child: Text(
                    'Kirim ulang kode',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.ink,
                    ),
                  ),
                ),
              SizedBox(height: 25),

              // ── Tombol Konfirmasi ──
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _continue,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.black,
                    foregroundColor: AppColors.white,
                    shape: StadiumBorder(),
                    elevation: 0,
                  ),
                  child: Text(
                    'Konfirmasi',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // ── Salah memasukkan email? ──
              Text(
                'Salah memasukkan email?',
                textAlign: TextAlign.center,
                style: grayStyle,
              ),
              SizedBox(height: 6),
              Center(
                child: GestureDetector(
                  onTap: _back,
                  behavior: HitTestBehavior.opaque,
                  child: Text(
                    isForgot ? 'Ubah email' : 'Ubah data pendaftaran',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.ink,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}