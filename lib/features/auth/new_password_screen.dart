import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_back_scope.dart';
import '../../core/widgets/dc_text_field.dart';

/// Halaman Buat Kata Sandi Baru
class NewPasswordScreen extends StatefulWidget {
const   NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  static const String _illustration = AppAssets.iconLupaPassword;

  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _isMinLength = false;
  bool _hasUpperAndNumber = false;
  bool _isMatch = false;

  @override
  void initState() {
    super.initState();
    _password.addListener(_validateCriteria);
    _confirmPassword.addListener(_validateCriteria);
  }

  @override
  void dispose() {
    _password.removeListener(_validateCriteria);
    _confirmPassword.removeListener(_validateCriteria);
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _validateCriteria() {
    final pass = _password.text;
    final confirm = _confirmPassword.text;
    
    setState(() {
      _isMinLength = pass.length >= 8;
      _hasUpperAndNumber = pass.contains(RegExp(r'[A-Z]')) && pass.contains(RegExp(r'[0-9]'));
      _isMatch = pass.isNotEmpty && pass == confirm;
    });
  }

  bool get _isCriteriaMet => _isMinLength && _hasUpperAndNumber && _isMatch;

  void _back() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/login');
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_isCriteriaMet) {
        // Berhasil, kembali ke login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kata sandi berhasil diubah')),
        );
        if (context.canPop()) {
          context.pop(true);
        } else {
          context.go('/login');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Harap penuhi kriteria kata sandi')),
        );
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

  Widget _buildCriterion(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isMet ? AppColors.successText : AppColors.border,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: isMet ? AppColors.ink : AppColors.textSecondary,
              ),
            ),
          ),
        ],
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
                            height: 156,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 14),

                        // ── Judul ──
                        Text(
                          'Buat Kata Sandi Baru',
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
                          'Buat kata sandi baru yang kuat dan mudah diingat '
                          'untuk mengamankan akun DinoyoCraft Anda.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            height: 1.6,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 24),

                        // ── Field Kata Sandi Baru ──
                        DcTextField(
                          label: 'Kata Sandi Baru',
                          hint: 'Masukkan kata sandi baru',
                          controller: _password,
                          leadingIconPath: AppAssets.iconLock,
                          obscureText: true,
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Kata sandi wajib diisi'
                              : null,
                        ),
                        SizedBox(height: 16),
                        
                        // ── Field Konfirmasi Kata Sandi ──
                        DcTextField(
                          label: 'Konfirmasi Kata Sandi Baru',
                          hint: 'Ulangi kata sandi baru',
                          controller: _confirmPassword,
                          leadingIconPath: AppAssets.iconLock,
                          obscureText: true,
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Konfirmasi kata sandi wajib diisi'
                              : null,
                        ),
                        SizedBox(height: 20),

                        // ── Kriteria Kata Sandi ──
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.surface,
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'KRITERIA KATA SANDI:',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    _isCriteriaMet ? 'Terpenuhi' : 'Belum Terpenuhi',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: _isCriteriaMet ? AppColors.successText : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              _buildCriterion('Minimal 8 karakter', _isMinLength),
                              _buildCriterion('Mengandung huruf besar dan angka', _hasUpperAndNumber),
                              _buildCriterion('Cocok dengan konfirmasi kata sandi', _isMatch),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),

                        // ── Tombol Simpan ──
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
                                'Simpan Kata Sandi Baru',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        Spacer(),
                        SizedBox(height: 32),

                        // ── Butuh Bantuan? ──
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Butuh bantuan lebih lanjut?',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              SizedBox(height: 4),
                              GestureDetector(
                                onTap: () => context.push('/help'),
                                behavior: HitTestBehavior.opaque,
                                child: Text(
                                  'Hubungi kami',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.ink,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.ink,
                                  ),
                                ),
                              ),
                            ],
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
