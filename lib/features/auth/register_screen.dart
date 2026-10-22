import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_text.dart';
import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';

/// Halaman Daftar — disesuaikan 1:1 dengan desain Daftar.png.
class RegisterScreen extends StatefulWidget {
const   RegisterScreen({super.key});

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

  late final TapGestureRecognizer _termsLinkTap = TapGestureRecognizer()
    ..onTap = _showTermsDialog;
  late final TapGestureRecognizer _privacyLinkTap = TapGestureRecognizer()
    ..onTap = _showPrivacyDialog;

  @override
  void dispose() {
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

  void _submit() {
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
    if (_isGoogleAuth) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(
            AppText.isEnglish
                ? 'Registration successful! Welcome, ${_name.text.trim().isNotEmpty ? _name.text.trim() : "User"}.'
                : 'Pendaftaran berhasil! Selamat datang, ${_name.text.trim().isNotEmpty ? _name.text.trim() : "Pengguna"}.',
          ),
        ),
      );
      context.go('/home');
      return;
    }
    context.push('/verify-otp?from=register');
  }

  void _onGoogleRegisterTap() {
    _showGoogleAccountPicker();
  }

  void _showGoogleAccountPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Material(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.iconGoogle,
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pilih Akun Google'.tr,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                              ),
                            ),
                            Text(
                              'Lanjutkan pendaftaran ke DinoyoCraft'.tr,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        icon: Icon(Icons.close_rounded,
                            color: AppColors.textSecondary),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 8),
                  _googleAccountTile(
                    name: 'Alif Farda',
                    email: 'aliffarda@gmail.com',
                    initial: 'A',
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      _applyGoogleAccount(
                        name: 'Alif Farda',
                        email: 'aliffarda@gmail.com',
                      );
                    },
                  ),
                  _googleAccountTile(
                    name: 'Dinoyo Craft User',
                    email: 'dinoyocraft.user@gmail.com',
                    initial: 'D',
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      _applyGoogleAccount(
                        name: 'Dinoyo Craft User',
                        email: 'dinoyocraft.user@gmail.com',
                      );
                    },
                  ),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.surfaceSubtle,
                      child: Icon(Icons.person_add_alt_1_rounded,
                          size: 18, color: AppColors.ink),
                    ),
                    title: Text(
                      'Gunakan akun lain',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      _applyGoogleAccount(
                        name: 'Pengguna Google Baru',
                        email: 'user.google@gmail.com',
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _googleAccountTile({
    required String name,
    required String email,
    required String initial,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      onTap: onTap,
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: AppColors.black,
        child: Text(
          initial,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      title: Text(
        name,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
      subtitle: Text(
        email,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded,
          size: 20, color: AppColors.textMuted),
    );
  }

  void _applyGoogleAccount({required String name, required String email}) {
    if (!mounted) return;
    setState(() {
      _isGoogleAuth = true;
      _name.text = name;
      final rawUser =
          email.split('@').first.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
      _username.text = rawUser.isNotEmpty ? rawUser : 'user';
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
    TextInputType? keyboardType,
    TextInputAction textInputAction = TextInputAction.next,
    bool obscureText = false,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffix,
    Color? hintColor,
    String? helper,
    Color? fillColor,
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
              color: AppColors.textSecondary,
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

    return Scaffold(
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
                        hint: 'Buat username kamu'.tr,
                        controller: _username,
                        icon: Icons.alternate_email_rounded,
                        helper:
                            'Username digunakan untuk identitas profil kamu.'.tr,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Username wajib diisi'.tr
                            : null,
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
                            onPressed: _submit,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.black,
                              foregroundColor: AppColors.white,
                              shape: AppColors.stadiumButtonShape,
                              elevation: 0,
                            ),
                            child: Text(
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
    );
  }
}