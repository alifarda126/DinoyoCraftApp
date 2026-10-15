import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';

/// Halaman Daftar — disesuaikan 1:1 dengan desain Daftar.png.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const Color _checkBorder = Color(0xFFBDBDBD);
  static const Color _checkFill = Color(0xFFF4F4F4);

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Setujui syarat & ketentuan terlebih dahulu'),
        ),
      );
      return;
    }
    context.push('/verify-otp?from=register');
  }

  void _back() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  void _showTermsDialog() {
    _showLegalDialog(
      title: 'Syarat & Ketentuan',
      content:
          'Dengan mendaftar dan menggunakan DinoyoCraft, kamu menyetujui '
          'untuk: (1) menyediakan data yang akurat dan terkini, (2) menggunakan '
          'akun hanya untuk transaksi yang sah, (3) tidak menyalahgunakan '
          'platform untuk aktivitas yang melanggar hukum, serta (4) mematuhi '
          'kebijakan pembayaran dan pengembalian yang berlaku pada setiap '
          'studio pengrajin.',
    );
  }

  void _showPrivacyDialog() {
    _showLegalDialog(
      title: 'Kebijakan Privasi',
      content:
          'Kami menghargai privasimu. Data pribadi yang kamu berikan hanya '
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
            child: const Text('Saya Mengerti'),
          ),
        ],
      ),
    );
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
            const Icon(Icons.arrow_back_rounded, size: 22, color: AppColors.ink),
            const SizedBox(width: 10),
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
          icon: const Icon(
            Icons.help_outline_rounded,
            size: 22,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(width: 12),
      ],
      bottom: const PreferredSize(
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
        const SizedBox(height: 6),
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
            fillColor: AppColors.white,
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
            prefixIconConstraints: const BoxConstraints(minWidth: 0),
            suffixIcon: suffix,
            suffixIconConstraints: const BoxConstraints(minWidth: 0),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            enabledBorder: border(AppColors.ink),
            focusedBorder: border(AppColors.ink),
            errorBorder: border(const Color(0xFFD32F2F)),
            focusedErrorBorder: border(const Color(0xFFD32F2F)),
          ),
        ),
        if (helper != null) ...[
          const SizedBox(height: 6),
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
            ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
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
      backgroundColor: AppColors.white,
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
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Daftar Akun',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Buat akun untuk mulai menjelajahi DinoyoCraft.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 44),

                      // ── Form ──
                      _field(
                        label: 'Nama Lengkap',
                        hint: 'Masukkan nama lengkap',
                        controller: _name,
                        icon: Icons.person_outline_rounded,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Nama wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _field(
                        label: 'Username',
                        hint: 'Buat username kamu',
                        controller: _username,
                        icon: Icons.alternate_email_rounded,
                        helper: 'Username digunakan untuk identitas profil kamu.',
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Username wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _field(
                        label: 'Email',
                        hint: 'Masukkan email kamu',
                        controller: _email,
                        icon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Email wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _field(
                        label: 'Tanggal Lahir',
                        hint: 'mm/dd/yyyy',
                        hintColor: AppColors.ink,
                        controller: _birth,
                        icon: Icons.calendar_today_outlined,
                        readOnly: true,
                        onTap: _pickDate,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Tanggal lahir wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _field(
                        label: 'Nomor WhatsApp',
                        hint: 'Masukkan nomor WhatsApp (contoh: 0812xxxxxxxx)',
                        controller: _wa,
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'WhatsApp wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _field(
                        label: 'Password',
                        hint: 'Minimal 8 karakter',
                        controller: _password,
                        icon: Icons.lock_outline_rounded,
                        obscureText: _obscure,
                        helper: 'Password minimal 8 karakter.',
                        suffix: _eye(
                          obscured: _obscure,
                          onTap: () => setState(() => _obscure = !_obscure),
                        ),
                        validator: (v) => (v == null || v.length < 8)
                            ? 'Minimal 8 karakter'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _field(
                        label: 'Konfirmasi Password',
                        hint: 'Ulangi password',
                        controller: _confirm,
                        icon: Icons.lock_outline_rounded,
                        obscureText: _obscureConfirm,
                        textInputAction: TextInputAction.done,
                        suffix: _eye(
                          obscured: _obscureConfirm,
                          onTap: () =>
                              setState(() => _obscureConfirm = !_obscureConfirm),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Konfirmasi wajib diisi';
                          }
                          if (v != _password.text) return 'Password tidak cocok';
                          return null;
                        },
                      ),
                      const SizedBox(height: 22),

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
                                  const TextSpan(text: 'Saya menyetujui '),
                                  TextSpan(
                                    text: 'Syarat & Ketentuan',
                                    style: linkStyle,
                                    recognizer: _termsLinkTap,
                                  ),
                                  const TextSpan(text: ' dan '),
                                  TextSpan(
                                    text: 'Kebijakan Privasi',
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

                      // Tombol Daftar menempel di dasar layar.
                      const Spacer(),
                      const SizedBox(height: 28),
                      SizedBox(
                        height: 52,
                        child: FilledButton(
                          onPressed: _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.black,
                            foregroundColor: AppColors.white,
                            shape: const StadiumBorder(),
                            elevation: 0,
                          ),
                          child: Text(
                            'Daftar',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
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