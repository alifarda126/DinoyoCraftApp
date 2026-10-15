import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';

/// Halaman Login — disesuaikan 1:1 dengan desain Login.png.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.go('/home');
    }
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
    TextInputAction? textInputAction,
    bool obscureText = false,
    Widget? suffix,
    ValueChanged<String>? onFieldSubmitted,
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
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
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
            hintStyle: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 12),
              child: Icon(icon, size: 20, color: AppColors.ink),
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.fromLTRB(26, 20, 26, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Logo + nama ──
                      Center(
                        child: Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: AppColors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          // Logo ditint putih di atas tile hitam (sesuai desain).
                          child: Image.asset(
                            AppAssets.logoBlack,
                            color: Colors.white,
                            colorBlendMode: BlendMode.srcIn,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Center(
                        child: Text(
                          'DinoyoCraft',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // ── Judul ──
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Silahkan Login Terlebih Dahulu',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Masuk untuk melanjutkan ke DinoyoCraft.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // ── Form ──
                      _field(
                        label: 'Email',
                        hint: 'Masukkan email kamu',
                        controller: _email,
                        icon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Email wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _field(
                        label: 'Password',
                        hint: 'Masukkan password',
                        controller: _password,
                        icon: Icons.lock_outline_rounded,
                        obscureText: _obscure,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Password wajib diisi'
                            : null,
                        suffix: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => setState(() => _obscure = !_obscure),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 16),
                            child: Icon(
                              _obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () => context.push('/forgot-password'),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Lupa password?',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // ── Tombol Masuk ──
                      SizedBox(
                        height: 48,
                        child: FilledButton(
                          onPressed: _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.black,
                            foregroundColor: AppColors.white,
                            shape: const StadiumBorder(),
                            elevation: 0,
                          ),
                          child: Text(
                            'Masuk',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── ——— atau ——— ──
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(height: 1, color: AppColors.border),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'atau',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(height: 1, color: AppColors.border),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // ── Masuk dengan Google ──
                      SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => context.go('/home'),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            side: const BorderSide(color: AppColors.border),
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
                              Text(
                                'Masuk dengan Google',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.ink,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Dorong "Belum punya akun?" ke dasar layar.
                      const Spacer(),
                      const SizedBox(height: 24),
                      Center(
                        child: GestureDetector(
                          onTap: () => context.push('/register'),
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
                                  const TextSpan(text: 'Belum punya akun? '),
                                  TextSpan(
                                    text: 'Daftar',
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