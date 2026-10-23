import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_settings.dart';
import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_back_scope.dart';
import '../../core/widgets/dc_text_field.dart';

/// Halaman Lupa Password — disesuaikan dengan desain Lupa_Password.png.
class ForgotPasswordScreen extends StatefulWidget {
const   ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  static const String _illustration = AppAssets.iconLupaPassword;

  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _back() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/login');
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _email.text.trim();
      AppSettings.instance.lastAuthEmail = email;
      final uri = Uri(
        path: '/verify-otp',
        queryParameters: {
          'from': 'forgot',
          if (email.isNotEmpty) 'email': email,
        },
      );
      context.push(uri.toString());
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

  @override
  Widget build(BuildContext context) {
    return AppBackScope(
      onBack: _back,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: _buildHeader(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── Ilustrasi ──
                        Center(
                          child: Image.asset(
                            _illustration,
                            height: 190,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 14),

                        // ── Judul ──
                        Text(
                          'Lupa Password?',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            color: AppColors.ink,
                          ),
                        ),
                        SizedBox(height: 10),

                        // ── Deskripsi ──
                        Text(
                          'Masukkan alamat email yang terdaftar pada akun '
                          'DinoyoCraft Anda untuk menerima kode verifikasi OTP.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            height: 1.6,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 24),

                        // ── Field email ──
                        DcTextField(
                          label: 'Email',
                          hint: 'Masukkan email kamu',
                          controller: _email,
                          leadingIconPath: AppAssets.iconEmail,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Email wajib diisi'
                              : null,
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Pastikan email aktif untuk menerima 6 digit kode OTP.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                        SizedBox(height: 14),

                        // ── Tombol Kirim Kode Verifikasi ──
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
                                'Kirim Kode Verifikasi',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 18),

                        // ── Pemisah "atau" ──
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                height: 1,
                                thickness: 1,
                                color: AppColors.border,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'atau',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                height: 1,
                                thickness: 1,
                                color: AppColors.border,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 18),

                        // ── Tombol Masuk Sekarang (outline) ──
                        SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () => context.go('/login'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.ink,
                              backgroundColor: AppColors.surface,
                              shape: StadiumBorder(),
                              side: BorderSide(
                                color: AppColors.border,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'Masuk Sekarang',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                        ),

                        Spacer(),
                        SizedBox(height: 32),

                        // ── Butuh Bantuan? Customer Service ──
                        Center(
                          child: GestureDetector(
                            onTap: () => context.push('/help'),
                            behavior: HitTestBehavior.opaque,
                            child: Text.rich(
                              TextSpan(
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                                children: [
                                  TextSpan(text: 'Butuh Bantuan? '),
                                  TextSpan(
                                    text: 'Customer Service',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
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
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}
}