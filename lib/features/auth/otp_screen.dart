import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_settings.dart';
import '../../core/app_text.dart';
import '../../core/network/api_client.dart';
import '../../core/assets.dart';
import '../../core/services/auth_session.dart';
import '../../core/services/fcm_service.dart';
import '../../core/storage/local_storage.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_back_scope.dart';
import '../../core/widgets/top_toast.dart';

/// Halaman Verifikasi OTP — terintegrasi penuh ke Backend SMTP untuk:
/// registrasi pelanggan, login 2FA, lupa kata sandi, serta aktivasi/penonaktifan 2FA.
class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    this.from = 'register',
    this.email,
    this.expectedCode,
    this.registrationData,
  });

  final String from;
  final String? email;
  final String? expectedCode;
  final Map<String, dynamic>? registrationData;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const String _illustration = AppAssets.iconVerifikasiOtp;
  static const int _resendDelay = 60; // detik

  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focus = List.generate(6, (_) => FocusNode());

  Timer? _timer;
  int _seconds = _resendDelay;
  bool _isLoading = false;

  bool get _isEnable2fa =>
      widget.from == 'enable_2fa' || widget.from == '2fa-setup';
  bool get _isDisable2fa =>
      widget.from == 'disable_2fa' || widget.from == '2fa-disable';
  bool get _is2fa => _isEnable2fa || _isDisable2fa;

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
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
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

  String get _resolvedTargetEmail {
    final candidates = [
      widget.email,
      AuthSession.user?['email']?.toString(),
      AppSettings.instance.lastAuthEmail,
      widget.registrationData?['email']?.toString(),
    ];
    for (final c in candidates) {
      final clean = c?.trim() ?? '';
      if (clean.isNotEmpty && clean.contains('@')) return clean;
    }
    return '';
  }

  String get _maskedEmail {
    final raw = _resolvedTargetEmail;
    if (raw.isEmpty || !raw.contains('@')) {
      return 'email terdaftar Anda'.tr;
    }
    final e = raw.toLowerCase();
    final parts = e.split('@');
    final name = parts.first;
    final domain = parts.sublist(1).join('@');
    if (name.length <= 2) {
      return '${name.isEmpty ? '*' : name[0]}***@$domain';
    }
    return '${name.substring(0, 2)}●●●●●@$domain';
  }

  bool get _complete => _controllers.every((c) => c.text.trim().isNotEmpty);

  Future<void> _continue() async {
    if (!_complete) {
      AppTopToast.error('Lengkapi 6 digit kode verifikasi'.tr);
      return;
    }

    final enteredCode = _controllers.map((c) => c.text.trim()).join();

    if (_is2fa) {
      setState(() => _isLoading = true);
      try {
        final action = _isEnable2fa ? 'enable' : 'disable';
        final response = await ApiClient.post('/auth/2fa/verify-otp', {
          'action': action,
          'otp': enteredCode,
        });
        if (response['success'] == true) {
          final enabled = _isEnable2fa;
          if (AuthSession.user != null) {
            await LocalStorage.saveUser({
              ...AuthSession.user!,
              'two_factor_enabled': enabled,
            });
          }
          if (!mounted) return;
          setState(() => _isLoading = false);

          final router = GoRouter.of(context);
          if (router.canPop()) {
            router.pop(true);
          } else {
            router.go('/settings');
          }

          AppSettings.instance.setTwoFactor(enabled);
          AppTopToast.success(
            enabled
                ? 'Autentikasi 2 Langkah via Email berhasil diaktifkan.'.tr
                : 'Autentikasi 2 Langkah (2FA) berhasil dinonaktifkan.'.tr,
          );

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (router.routerDelegate.currentConfiguration.uri.path ==
                '/verify-otp') {
              router.go('/settings');
            }
          });
          return;
        } else {
          if (mounted) {
            AppTopToast.error(
              response['message']?.toString() ?? 'Kode OTP salah.'.tr,
            );
          }
        }
      } catch (e) {
        if (mounted) {
          final msg = e.toString().replaceFirst('Exception: ', '');
          AppTopToast.error(msg);
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
      return;
    }

    if (widget.from == 'login') {
      setState(() => _isLoading = true);
      try {
        final response = await ApiClient.post('/auth/verify-login-otp', {
          'email': _resolvedTargetEmail,
          'otp': enteredCode,
        });
        if (response['success'] == true) {
          final data = response['data'] as Map<String, dynamic>?;
          final token = data?['token']?.toString() ?? '';
          if (token.isNotEmpty) {
            await AuthSession.signIn(
              token: token,
              refreshToken: data?['refresh_token']?.toString(),
              user: data,
            );
            unawaited(FcmService.instance.syncTokenWithBackend());
          }
          AppSettings.instance.consumeOtpRequirement();
          if (mounted) {
            AppTopToast.success(
              'Verifikasi berhasil! Selamat datang kembali.'.tr,
            );
            context.go('/home');
          }
        } else {
          if (mounted) {
            AppTopToast.error(
              response['message']?.toString() ?? 'Kode OTP salah'.tr,
            );
          }
        }
      } catch (e) {
        if (mounted) {
          final msg = e.toString().replaceFirst('Exception: ', '');
          AppTopToast.error(msg);
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else if (widget.from == 'forgot') {
      setState(() => _isLoading = true);
      try {
        final targetEmail = (widget.email?.trim().isNotEmpty ?? false)
            ? widget.email!.trim()
            : AppSettings.instance.lastAuthEmail ?? '';
        final response = await ApiClient.post('/auth/verify-otp', {
          'email': targetEmail,
          'otp': enteredCode,
        });

        if (response['success'] == true) {
          if (mounted) {
            AppTopToast.success(
              'Kode OTP terverifikasi. Silakan buat kata sandi baru.'.tr,
            );
            context.go(
              '/new-password',
              extra: {'email': targetEmail, 'otp': enteredCode},
            );
          }
        } else {
          if (mounted) {
            AppTopToast.error(
              response['message']?.toString() ?? 'Kode OTP salah'.tr,
            );
          }
        }
      } catch (e) {
        if (mounted) {
          final msg = e.toString().replaceFirst('Exception: ', '');
          AppTopToast.error('Gagal verifikasi OTP: $msg'.tr);
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } else {
      // Verifikasi pendaftaran manual pengunjung ke server backend
      setState(() => _isLoading = true);
      try {
        final targetEmail = (widget.email?.trim().isNotEmpty ?? false)
            ? widget.email!.trim()
            : widget.registrationData?['email']?.toString() ?? '';

        final payload = <String, dynamic>{
          'email': targetEmail,
          'otp': enteredCode,
          if (widget.registrationData != null) ...widget.registrationData!,
        };

        final response = await ApiClient.post(
          '/auth/verify-register-otp',
          payload,
        );

        if (response['success'] == true) {
          // Auto-login: simpan token + data user dari backend, langsung ke Home.
          final data = response['data'];
          if (data is Map<String, dynamic> &&
              (data['token'] ?? '').toString().isNotEmpty) {
            await AuthSession.signIn(
              token: data['token'].toString(),
              refreshToken: data['refresh_token']?.toString(),
              user: data,
            );
            unawaited(FcmService.instance.syncTokenWithBackend());
          }
          if (mounted) {
            AppTopToast.success(
              response['message']?.toString() ??
                  'Pendaftaran berhasil! Selamat datang di DinoyoCraft.'.tr,
            );
            context.go('/home');
          }
        } else {
          if (mounted) {
            AppTopToast.error(
              response['message']?.toString() ?? 'Kode OTP salah'.tr,
            );
          }
        }
      } catch (e) {
        if (mounted) {
          final msg = e.toString().replaceFirst('Exception: ', '');
          AppTopToast.error('Gagal verifikasi OTP: $msg'.tr);
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _resend() async {
    _startTimer();
    for (final c in _controllers) {
      c.clear();
    }
    if (_focus.isNotEmpty) {
      _focus[0].requestFocus();
    }

    if (_is2fa) {
      try {
        final action = _isEnable2fa ? 'enable' : 'disable';
        final response = await ApiClient.post('/auth/2fa/request-otp', {
          'action': action,
        });
        if (mounted) {
          AppTopToast.info(
            response['message']?.toString() ??
                'Kode OTP baru telah dikirim ke email terdaftar Anda'.tr,
          );
        }
      } catch (e) {
        if (mounted) {
          final msg = e.toString().replaceFirst('Exception: ', '');
          AppTopToast.error('Gagal mengirim ulang OTP: $msg'.tr);
        }
      }
    } else if (widget.from == 'login') {
      try {
        final response = await ApiClient.post('/auth/resend-login-otp', {
          'email': _resolvedTargetEmail,
        });
        if (mounted) {
          AppTopToast.info(
            response['message']?.toString() ??
                'Kode OTP login baru telah dikirim ke email Anda'.tr,
          );
        }
      } catch (e) {
        if (mounted) {
          final msg = e.toString().replaceFirst('Exception: ', '');
          AppTopToast.error('Gagal mengirim ulang OTP: $msg'.tr);
        }
      }
    } else if (widget.from == 'register') {
      try {
        final targetEmail = _resolvedTargetEmail;

        final response = await ApiClient.post('/auth/resend-register-otp', {
          'email': targetEmail,
          'name': widget.registrationData?['name'] ?? 'Pengguna',
        });

        if (mounted) {
          AppTopToast.info(
            response['message']?.toString() ??
                'Kode OTP baru telah dikirim ke email kamu'.tr,
          );
        }
      } catch (e) {
        if (mounted) {
          final msg = e.toString().replaceFirst('Exception: ', '');
          AppTopToast.error('Gagal mengirim ulang OTP: $msg'.tr);
        }
      }
    } else if (widget.from == 'forgot') {
      try {
        final targetEmail = _resolvedTargetEmail;

        final response = await ApiClient.post('/auth/forgot-password', {
          'email': targetEmail,
        });

        if (mounted) {
          AppTopToast.info(
            response['message']?.toString() ??
                'Kode OTP baru telah dikirim ke email kamu'.tr,
          );
        }
      } catch (e) {
        if (mounted) {
          final msg = e.toString().replaceFirst('Exception: ', '');
          AppTopToast.error('Gagal mengirim ulang OTP: $msg'.tr);
        }
      }
    }
  }

  void _back() {
    if (context.canPop()) {
      context.pop(false);
    } else {
      if (_is2fa) {
        context.go('/settings');
      } else if (widget.from == 'login') {
        context.go('/login');
      } else if (widget.from == 'forgot') {
        context.go('/forgot-password');
      } else {
        context.go('/register');
      }
    }
  }

  // ═══ Header: ← Kembali ........ (?) ═════════════════════════════════════
  PreferredSizeWidget _buildHeader() {
    return AppBar(
      backgroundColor: AppColors.surface,
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
              'Kembali'.tr,
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.ink, width: 2),
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
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
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

    return AppBackScope(
      onBack: _back,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: _buildHeader(),
        body: SafeArea(
          maintainBottomViewPadding: true,
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
                  _isEnable2fa
                      ? 'Aktivasi 2FA'.tr
                      : _isDisable2fa
                      ? 'Nonaktifkan 2FA'.tr
                      : isLogin
                      ? 'Verifikasi Keamanan'.tr
                      : isForgot
                      ? 'Verifikasi Lupa Password'.tr
                      : 'Verifikasi Akun'.tr,
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
                        text: _isEnable2fa
                            ? '${'Masukkan kode verifikasi 6 digit yang telah kami kirimkan ke email untuk mengaktifkan 2FA:'.tr}\n'
                            : _isDisable2fa
                            ? '${'Masukkan kode verifikasi 6 digit yang telah kami kirimkan ke email untuk konfirmasi nonaktifkan 2FA:'.tr}\n'
                            : '${'Masukkan kode verifikasi 6 digit yang telah kami\nkirimkan ke email'.tr} ',
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
                  'Belum menerima kode?'.tr,
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
                        TextSpan(text: '${'Kirim ulang kode dalam'.tr} '),
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
                      'Kirim ulang kode'.tr,
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
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: AppColors.darkButtonShadow,
                    ),
                    child: FilledButton(
                      onPressed: _isLoading ? null : _continue,
                      style: FilledButton.styleFrom(
                        backgroundColor: _isDisable2fa
                            ? AppColors.danger
                            : AppColors.black,
                        foregroundColor: AppColors.white,
                        shape: AppColors.stadiumButtonShape,
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _isEnable2fa
                                  ? 'Verifikasi & Aktifkan'.tr
                                  : _isDisable2fa
                                  ? 'Konfirmasi Nonaktifkan'.tr
                                  : 'Konfirmasi'.tr,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // ── Batal / Salah memasukkan email? ──
                if (_is2fa) ...[
                  Center(
                    child: GestureDetector(
                      onTap: _back,
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        'Batalkan Verifikasi'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Text(
                    'Salah memasukkan email?'.tr,
                    textAlign: TextAlign.center,
                    style: grayStyle,
                  ),
                  SizedBox(height: 6),
                  Center(
                    child: GestureDetector(
                      onTap: _back,
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        isForgot
                            ? 'Ubah email'.tr
                            : 'Ubah data pendaftaran'.tr,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
