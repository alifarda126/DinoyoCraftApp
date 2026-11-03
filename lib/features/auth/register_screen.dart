import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_settings.dart';
import '../../core/app_text.dart';
import '../../core/assets.dart';
import '../../core/network/api_client.dart';
import '../../core/services/auth_session.dart';
import '../../core/services/fcm_service.dart';
import '../../core/services/google_auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_back_scope.dart';

/// Halaman Daftar — disesuaikan 1:1 dengan desain Daftar.png.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    this.initialEmail,
    this.initialName,
    this.initialGoogleId,
    this.initialAvatarUrl,
    this.initialIdToken,
    this.isGoogleAuth = false,
  });

  final String? initialEmail;
  final String? initialName;
  final String? initialGoogleId;
  final String? initialAvatarUrl;
  final String? initialIdToken;
  final bool isGoogleAuth;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Color get _checkBorder => AppColors.border;
  Color get _checkFill => AppColors.surfaceSubtle;

  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _birth = TextEditingController();
  final _wa = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _terms = false;
  bool _obscure = true;
  bool _obscureConfirm = true;
  DateTime? _birthDate;
  bool _isGoogleAuth = false;
  bool _isLoading = false;
  String? _googleId;
  String? _avatarUrl;
  String? _idToken;

  Timer? _usernameDebounce;
  bool _isCheckingUsername = false;
  bool? _isUsernameAvailable;
  String? _usernameError;

  void _onUsernameChanged(String value) {
    _usernameDebounce?.cancel();
    final trimmed = value.trim().toLowerCase();

    if (trimmed.isEmpty) {
      setState(() {
        _isCheckingUsername = false;
        _isUsernameAvailable = null;
        _usernameError = null;
      });
      return;
    }

    if (trimmed.length < 3) {
      setState(() {
        _isCheckingUsername = false;
        _isUsernameAvailable = false;
        _usernameError = 'Minimal 3 karakter'.tr;
      });
      return;
    }

    final validRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!validRegex.hasMatch(trimmed)) {
      setState(() {
        _isCheckingUsername = false;
        _isUsernameAvailable = false;
        _usernameError = 'Hanya boleh huruf, angka, dan underscore (_)'.tr;
      });
      return;
    }

    setState(() {
      _isCheckingUsername = true;
      _isUsernameAvailable = null;
      _usernameError = null;
    });

    _usernameDebounce = Timer(const Duration(milliseconds: 400), () async {
      try {
        final res = await ApiClient.get(
          '/auth/check-username?username=${Uri.encodeComponent(trimmed)}',
        );
        if (!mounted || _username.text.trim().toLowerCase() != trimmed) return;
        final available = res['available'] == true;
        setState(() {
          _isCheckingUsername = false;
          _isUsernameAvailable = available;
          _usernameError = available
              ? null
              : (res['message']?.toString() ?? 'Username sudah digunakan'.tr);
        });
      } catch (e) {
        if (!mounted || _username.text.trim().toLowerCase() != trimmed) return;
        setState(() {
          _isCheckingUsername = false;
          _isUsernameAvailable = null;
          _usernameError = null;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.isGoogleAuth || (widget.initialEmail != null && widget.initialEmail!.isNotEmpty)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _applyGoogleAccount(
          name: widget.initialName ?? 'Pengguna Google',
          email: widget.initialEmail ?? '',
          googleId: widget.initialGoogleId,
          avatarUrl: widget.initialAvatarUrl,
          idToken: widget.initialIdToken,
        );
      });
    }
  }

  late final TapGestureRecognizer _termsLinkTap = TapGestureRecognizer()
    ..onTap = _showTermsDialog;
  late final TapGestureRecognizer _privacyLinkTap = TapGestureRecognizer()
    ..onTap = _showPrivacyDialog;

  @override
  void dispose() {
    _usernameDebounce?.cancel();
    _termsLinkTap.dispose();
    _privacyLinkTap.dispose();
    _name.dispose();
    _username.dispose();
    _email.dispose();
    _birth.dispose();
    _wa.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 18),
      firstDate: DateTime(1950),
      lastDate: now,
    );
    if (picked != null) {
      if (!mounted) return;
      setState(() {
        _birthDate = picked;
        final d = picked.day.toString().padLeft(2, '0');
        final m = picked.month.toString().padLeft(2, '0');
        // Format mm/dd/yyyy sesuai placeholder di desain.
        _birth.text = '$m/$d/${picked.year}';
      });
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_terms) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text('Setujui syarat & ketentuan terlebih dahulu'.tr),
        ),
      );
      return;
    }
    ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();

    final name = _name.text.trim();
    final username = _username.text.trim();
    final email = _email.text.trim();
    final password = _password.text;
    final phone = _wa.text.trim();

    setState(() => _isLoading = true);

    try {
      final Map<String, dynamic> response;
      if (_isGoogleAuth) {
        response = await ApiClient.post('/auth/register-customer', {
          'name': name.isNotEmpty ? name : 'Pengguna Google',
          'username': username,
          'email': email,
          'phone': phone,
          'isGoogleAuth': true,
          if (_googleId != null) 'google_id': _googleId,
          if (_avatarUrl != null) 'avatar_url': _avatarUrl,
          if (_idToken != null) 'credential': _idToken,
        });
      } else {
        response = await ApiClient.post('/auth/register-customer', {
          'name': name,
          'username': username,
          'email': email,
          'password': password,
          'phone': phone,
        });
      }

      if (response['success'] == true) {
        if (!_isGoogleAuth && (response['requires_otp'] == true || response['data']?['requires_otp'] == true)) {
          // Pendaftaran manual: Arahkan ke halaman Verifikasi OTP
          if (mounted) {
            ScaffoldMessenger.maybeOf(context)?.showSnackBar(
              SnackBar(
                content: Text(response['message']?.toString() ?? 'Kode OTP telah dikirim ke email kamu'.tr),
                backgroundColor: AppColors.ink,
              ),
            );
          }
          AppSettings.instance.lastAuthEmail = email;
          if (!mounted) return;
          context.push(
            '/verify-otp',
            extra: {
              'from': 'register',
              'email': email,
              'expectedCode': response['data']?['otp']?.toString(),
              'registrationData': {
                'name': name,
                'username': username,
                'email': email,
                'password': password,
                'phone': phone,
              },
            },
          );
          return;
        }

        final data = response['data'] as Map<String, dynamic>?;
        final token = data?['token'] as String? ?? '';
        if (token.isNotEmpty) {
          await AuthSession.signIn(
            token: token,
            refreshToken: data?['refresh_token']?.toString(),
            user: data,
          );
          unawaited(FcmService.instance.syncTokenWithBackend());
        }

        if (mounted) {
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(
            SnackBar(content: Text('Pendaftaran berhasil!'.tr)),
          );
        }
        if (!mounted) return;
        AppSettings.instance.lastAuthEmail = email;
        context.go('/home');
      } else {
        if (mounted) {
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(
            SnackBar(content: Text(response['message']?.toString() ?? 'Pendaftaran gagal')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final errMsg = e.toString().replaceFirst('Exception: ', '');
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(content: Text(errMsg)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _onGoogleRegisterTap() async {
    try {
      final googleData = await GoogleAuthService.getGoogleAccountForRegistration();
      if (googleData != null) {
        _applyGoogleAccount(
          name: googleData['name'] as String? ?? 'Pengguna Google',
          email: googleData['email'] as String? ?? '',
          googleId: googleData['googleId'] as String?,
          avatarUrl: googleData['avatarUrl'] as String?,
          idToken: googleData['idToken'] as String?,
        );
      }
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text('Gagal memilih akun Google: $msg'.tr),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _applyGoogleAccount({
    required String name,
    required String email,
    String? googleId,
    String? avatarUrl,
    String? idToken,
  }) {
    if (!mounted) return;
    setState(() {
      _isGoogleAuth = true;
      _googleId = googleId;
      _avatarUrl = avatarUrl;
      _idToken = idToken;
      _name.text = name;
      final rawUser =
          email.split('@').first.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
      _username.text = rawUser.isNotEmpty ? rawUser : 'user';
      _onUsernameChanged(_username.text);
      _email.text = email;
      _password.clear();
      _confirm.clear();
    });
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.hideCurrentSnackBar();
    messenger?.showSnackBar(
      SnackBar(
        content: Text(
          AppText.isEnglish
              ? 'Connected to Google account: $email'
              : 'Terhubung dengan akun Google: $email',
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Batal'.tr,
          textColor: Colors.amberAccent,
          onPressed: () {
            if (mounted) {
              _resetGoogleAuth();
            }
          },
        ),
      ),
    );
  }

  void _resetGoogleAuth() {
    if (!mounted) return;
    setState(() {
      _isGoogleAuth = false;
      _email.clear();
    });
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.hideCurrentSnackBar();
    messenger?.showSnackBar(
      SnackBar(
        content: Text('Beralih ke pendaftaran manual (Email & Password)'.tr),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _back() {
    ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  void _showTermsDialog() {
    _showLegalDialog(
      title: 'Syarat & Ketentuan'.tr,
      content: AppText.isEnglish
          ? 'By registering and using DinoyoCraft, you agree to: (1) provide accurate and up-to-date information, (2) use your account only for legitimate transactions, (3) not misuse the platform for unlawful activities, and (4) comply with payment and return policies of each artisan studio.'
          : 'Dengan mendaftar dan menggunakan DinoyoCraft, kamu menyetujui '
              'untuk: (1) menyediakan data yang akurat dan terkini, (2) menggunakan '
              'akun hanya untuk transaksi yang sah, (3) tidak menyalahgunakan '
              'platform untuk aktivitas yang melanggar hukum, serta (4) mematuhi '
              'kebijakan pembayaran dan pengembalian yang berlaku pada setiap '
              'studio pengrajin.',
    );
  }

  void _showPrivacyDialog() {
    _showLegalDialog(
      title: 'Kebijakan Privasi'.tr,
      content: AppText.isEnglish
          ? 'We respect your privacy. Your personal information is solely used to process orders, provide customer support, and improve our services. We do not sell or share data with third parties without your consent unless required by law.'
          : 'Kami menghargai privasimu. Data pribadi yang kamu berikan hanya '
              'digunakan untuk memproses pesanan, memberikan dukungan pelanggan, '
              'dan meningkatkan layanan. Kami tidak menjual atau membagikan data '
              'kepada pihak ketiga tanpa persetujuanmu, kecuali diwajibkan oleh '
              'hukum.',
    );
  }

  void _showLegalDialog({
    required String title,
    required String content,
  }) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        content: Text(
          content,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text('Saya Mengerti'.tr),
          ),
        ],
      ),
    );
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

  // ═══ Field input (label di atas, border hitam, radius 16) ═══════════════
  Widget _field({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    required String? Function(String?) validator,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    TextInputAction textInputAction = TextInputAction.next,
    bool obscureText = false,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffix,
    Color? hintColor,
    String? helper,
    Color? helperColor,
    Color? fillColor,
    void Function(String)? onChanged,
  }) {
    OutlineInputBorder border(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: c, width: 1),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.ink,
          ),
        ),
        SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppColors.ink,
          ),
          cursorColor: AppColors.ink,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: fillColor ?? AppColors.surface,
            hintText: hint,
            hintMaxLines: 1,
            hintStyle: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: hintColor ?? AppColors.textMuted,
            ).copyWith(overflow: TextOverflow.clip),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 12),
              child: Icon(icon, size: 18, color: AppColors.textSecondary),
            ),
            prefixIconConstraints: BoxConstraints(minWidth: 0),
            suffixIcon: suffix,
            suffixIconConstraints: BoxConstraints(minWidth: 0),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            enabledBorder: border(AppColors.ink),
            focusedBorder: border(AppColors.ink),
            errorBorder: border(AppColors.danger),
            focusedErrorBorder: border(AppColors.danger),
          ),
        ),
        if (helper != null) ...[
          SizedBox(height: 6),
          Text(
            helper,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: helperColor ?? AppColors.textSecondary,
              fontWeight: helperColor != null ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ],
    );
  }

  Widget _eye({required bool obscured, required VoidCallback onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 16),
        child: Icon(
          obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: 20,
          color: AppColors.ink,
        ),
      ),
    );
  }

  Widget _checkbox() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _terms = !_terms),
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: _terms ? AppColors.black : _checkFill,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: _terms ? AppColors.black : _checkBorder),
        ),
        child: _terms
            ? Icon(Icons.check_rounded, size: 14, color: Colors.white)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final linkStyle = GoogleFonts.plusJakartaSans(
      fontSize: 12,
      color: AppColors.ink,
      decoration: TextDecoration.underline,
      decorationColor: AppColors.ink,
    );

    return AppBackScope(
      onBack: _back,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: _buildHeader(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 42, 25, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Logo + judul ──
                      Center(
                        child: Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: AppColors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            AppAssets.logoBlack,
                            color: Colors.white,
                            colorBlendMode: BlendMode.srcIn,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Daftar Akun'.tr,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Buat akun untuk mulai menjelajahi DinoyoCraft.'.tr,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      if (_isGoogleAuth) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSubtle,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                AppAssets.iconGoogle,
                                width: 22,
                                height: 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Akun Google Terhubung'.tr,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                    Text(
                                      _email.text,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                key: const Key('cancel_google_btn'),
                                onPressed: _resetGoogleAuth,
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Batal'.tr,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.danger,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ] else ...[
                        const SizedBox(height: 44),
                      ],

                      // ── Form ──
                      _field(
                        label: 'Nama Lengkap'.tr,
                        hint: 'Masukkan nama lengkap'.tr,
                        controller: _name,
                        icon: Icons.person_outline_rounded,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Nama wajib diisi'.tr
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _field(
                        label: 'Username'.tr,
                        hint: 'huruf kecil, angka, underscore'.tr,
                        controller: _username,
                        icon: Icons.alternate_email_rounded,
                        onChanged: _onUsernameChanged,
                        inputFormatters: [
                          // Wajib huruf kecil: kapital otomatis diubah,
                          // karakter lain selain [a-z0-9_] ditolak.
                          FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9_]')),
                          TextInputFormatter.withFunction(
                            (oldValue, newValue) =>
                                newValue.copyWith(text: newValue.text.toLowerCase()),
                          ),
                        ],
                        helper: _usernameError != null
                            ? _usernameError!
                            : (_isUsernameAvailable == true
                                ? '✓ Username tersedia'.tr
                                : 'Username digunakan untuk identitas profil kamu.'.tr),
                        helperColor: _usernameError != null
                            ? Colors.red
                            : (_isUsernameAvailable == true
                                ? AppColors.ink
                                : AppColors.textSecondary),
                        suffix: Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: _isCheckingUsername
                              ? SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.ink),
                                  ),
                                )
                              : (_isUsernameAvailable == true
                                  ? Icon(
                                      Icons.check_circle_rounded,
                                      color: AppColors.ink,
                                      size: 22,
                                    )
                                  : (_isUsernameAvailable == false
                                      ? Icon(
                                          Icons.cancel_rounded,
                                          color: AppColors.ink,
                                          size: 22,
                                        )
                                      : null)),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Username wajib diisi'.tr;
                          }
                          if (v.trim().length < 3) {
                            return 'Username minimal 3 karakter'.tr;
                          }
                          if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(v.trim())) {
                            return 'Username hanya boleh huruf, angka, dan underscore (_)'.tr;
                          }
                          if (_isUsernameAvailable == false) {
                            return 'Username sudah digunakan'.tr;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _field(
                        label: 'Email'.tr,
                        hint: 'Masukkan email kamu'.tr,
                        controller: _email,
                        icon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        readOnly: _isGoogleAuth,
                        fillColor:
                            _isGoogleAuth ? AppColors.surfaceSubtle : null,
                        suffix: _isGoogleAuth
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 14),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      AppAssets.iconGoogle,
                                      width: 16,
                                      height: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Icon(
                                      Icons.lock_outline_rounded,
                                      size: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                  ],
                                ),
                              )
                            : null,
                        helper: _isGoogleAuth
                            ? 'Email terhubung dari akun Google dan tidak dapat diubah.'.tr
                            : null,
                        onTap: _isGoogleAuth
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Email otomatis sesuai akun Google dan tidak dapat diganti.'.tr,
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            : null,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Email wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _field(
                        label: 'Tanggal Lahir'.tr,
                        hint: 'mm/dd/yyyy',
                        hintColor: AppColors.ink,
                        controller: _birth,
                        icon: Icons.calendar_today_outlined,
                        readOnly: true,
                        onTap: _pickDate,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Tanggal lahir wajib diisi'.tr
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _field(
                        label: 'Nomor WhatsApp'.tr,
                        hint: 'Masukkan nomor WhatsApp (contoh: 0812xxxxxxxx)'.tr,
                        controller: _wa,
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'WhatsApp wajib diisi'.tr
                            : null,
                      ),
                      const SizedBox(height: 16),
                      if (!_isGoogleAuth) ...[
                        _field(
                          label: 'Password'.tr,
                          hint: 'Minimal 8 karakter'.tr,
                          controller: _password,
                          icon: Icons.lock_outline_rounded,
                          obscureText: _obscure,
                          helper: 'Password minimal 8 karakter.'.tr,
                          suffix: _eye(
                            obscured: _obscure,
                            onTap: () => setState(() => _obscure = !_obscure),
                          ),
                          validator: (v) => (v == null || v.length < 8)
                              ? 'Minimal 8 karakter'.tr
                              : null,
                        ),
                        const SizedBox(height: 16),
                        _field(
                          label: 'Konfirmasi Password'.tr,
                          hint: 'Ulangi password'.tr,
                          controller: _confirm,
                          icon: Icons.lock_outline_rounded,
                          obscureText: _obscureConfirm,
                          textInputAction: TextInputAction.done,
                          suffix: _eye(
                            obscured: _obscureConfirm,
                            onTap: () => setState(
                                () => _obscureConfirm = !_obscureConfirm),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Konfirmasi wajib diisi'.tr;
                            }
                            if (v != _password.text) {
                              return 'Password tidak cocok'.tr;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSubtle,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.verified_user_outlined,
                                size: 20,
                                color: AppColors.ink,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Kolom password tertutup karena pendaftaran terautentikasi langsung dengan akun Google.'.tr,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      const SizedBox(height: 6),

                      // ── Syarat & ketentuan ──
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 1),
                            child: _checkbox(),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  height: 1.5,
                                  color: AppColors.textSecondary,
                                ),
                                children: [
                                  TextSpan(text: 'Saya menyetujui '.tr),
                                  TextSpan(
                                    text: 'Syarat & Ketentuan'.tr,
                                    style: linkStyle,
                                    recognizer: _termsLinkTap,
                                  ),
                                  TextSpan(text: ' dan '.tr),
                                  TextSpan(
                                    text: 'Kebijakan Privasi'.tr,
                                    style: linkStyle,
                                    recognizer: _privacyLinkTap,
                                  ),
                                  const TextSpan(text: '.'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Tombol Daftar
                      const Spacer(),
                      const SizedBox(height: 28),
                      SizedBox(
                        height: 52,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: AppColors.darkButtonShadow,
                          ),
                          child: FilledButton(
                            onPressed: _isLoading ? null : _submit,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.black,
                              foregroundColor: AppColors.white,
                              shape: AppColors.stadiumButtonShape,
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                              'Daftar'.tr,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── ——— atau ——— ──
                      Row(
                        children: [
                          Expanded(
                            child: Divider(height: 1, color: AppColors.border),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'atau'.tr,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(height: 1, color: AppColors.border),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // ── Daftar dengan Google ──
                      SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: _onGoogleRegisterTap,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.surface,
                            side: BorderSide(color: AppColors.border),
                            shape: const StadiumBorder(),
                            foregroundColor: AppColors.ink,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AppAssets.iconGoogle,
                                width: 18,
                                height: 18,
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  _isGoogleAuth
                                      ? 'Ganti Akun Google'.tr
                                      : 'Daftar dengan Google'.tr,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_isGoogleAuth) ...[
                        const SizedBox(height: 10),
                        Center(
                          child: TextButton.icon(
                            onPressed: _resetGoogleAuth,
                            icon: Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            label: Text(
                              'Batal & Gunakan Pendaftaran Manual'.tr,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),

                      // ── Sudah punya akun? Masuk ──
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.maybeOf(context)
                                ?.hideCurrentSnackBar();
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/login');
                            }
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text.rich(
                              TextSpan(
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                                children: [
                                  TextSpan(text: 'Sudah punya akun? '.tr),
                                  TextSpan(
                                    text: 'Masuk'.tr,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.ink,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppColors.ink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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