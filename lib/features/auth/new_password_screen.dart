import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_settings.dart';
import '../../core/app_text.dart';
import '../../core/assets.dart';
import '../../core/network/api_client.dart';
import '../../core/services/auth_session.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_back_scope.dart';
import '../../core/widgets/dc_text_field.dart';
import '../../core/widgets/top_toast.dart';

/// Halaman Buat / Ubah Kata Sandi Baru (mendukung Lupa Sandi via OTP maupun Ubah Sandi dari Pengaturan)
class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key, this.email, this.otp});

  final String? email;
  final String? otp;

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  static const String _illustration = AppAssets.iconLupaPassword;

  final _formKey = GlobalKey<FormState>();
  final _currentPassword = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _isMinLength = false;
  bool _hasUpperAndNumber = false;
  bool _isMatch = false;
  bool _isLoading = false;

  bool get _isAuthenticatedChangePassword =>
      AuthSession.isLoggedIn &&
      (widget.otp == null || widget.otp!.trim().isEmpty);

  bool get _requiresCurrentPassword =>
      _isAuthenticatedChangePassword &&
      (AuthSession.user?['has_password'] != false);

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
    _currentPassword.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _validateCriteria() {
    final pass = _password.text;
    final confirm = _confirmPassword.text;

    setState(() {
      _isMinLength = pass.length >= 8;
      _hasUpperAndNumber =
          pass.contains(RegExp(r'[A-Z]')) && pass.contains(RegExp(r'[0-9]'));
      _isMatch = pass.isNotEmpty && pass == confirm;
    });
  }

  bool get _isCriteriaMet => _isMinLength && _hasUpperAndNumber && _isMatch;

  void _back() {
    if (context.canPop()) {
      context.pop(false);
    } else {
      context.go(_isAuthenticatedChangePassword ? '/settings' : '/login');
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_isCriteriaMet) {
        setState(() => _isLoading = true);
        try {
          if (_isAuthenticatedChangePassword) {
            final response = await ApiClient.put('/auth/change-password', {
              if (_requiresCurrentPassword)
                'currentPassword': _currentPassword.text,
              'newPassword': _password.text,
            });
            if (AuthSession.user != null) {
              await AuthSession.updateUser({
                ...AuthSession.user!,
                'password_changed_at':
                    response['data']?['password_changed_at'] ??
                    DateTime.now().toIso8601String(),
                'has_password': true,
              }, notify: false);
            }
            if (mounted) {
              if (context.canPop()) {
                context.pop(true);
              } else {
                context.go('/settings');
              }
              AppTopToast.success(
                response['message']?.toString() ??
                    'Kata sandi berhasil diperbarui!'.tr,
              );
            }
            return;
          }

          final targetEmail = (widget.email?.trim().isNotEmpty ?? false)
              ? widget.email!.trim()
              : AppSettings.instance.lastAuthEmail ?? '';

          final response = await ApiClient.post('/auth/reset-password', {
            'email': targetEmail,
            'otp': widget.otp ?? '',
            'newPassword': _password.text,
          });

          if (mounted) {
            AppTopToast.success(
              response['message']?.toString() ??
                  'Kata sandi berhasil diubah. Silakan masuk kembali.'.tr,
            );
            context.go('/login');
          }
        } catch (e) {
          if (mounted) {
            final msg = e.toString().replaceFirst('Exception: ', '');
            AppTopToast.error('Gagal mengubah kata sandi: $msg'.tr);
          }
        } finally {
          if (mounted) {
            setState(() => _isLoading = false);
          }
        }
      } else {
        AppTopToast.error('Harap penuhi kriteria kata sandi'.tr);
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
          maintainBottomViewPadding: true,
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
                            _isAuthenticatedChangePassword
                                ? 'Ubah Kata Sandi'.tr
                                : 'Buat Kata Sandi Baru'.tr,
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
                            _requiresCurrentPassword
                                ? 'Masukkan kata sandi saat ini terlebih dahulu, lalu buat kata sandi baru yang kuat untuk akun Anda.'
                                      .tr
                                : 'Buat kata sandi baru yang kuat dan mudah diingat untuk mengamankan akun DinoyoCraft Anda.'
                                      .tr,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              height: 1.6,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 24),

                          if (_requiresCurrentPassword) ...[
                            DcTextField(
                              label: 'Kata Sandi Saat Ini'.tr,
                              hint: 'Masukkan kata sandi saat ini'.tr,
                              controller: _currentPassword,
                              leadingIconPath: AppAssets.iconLock,
                              obscureText: true,
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Kata sandi saat ini wajib diisi'.tr
                                  : null,
                            ),
                            SizedBox(height: 16),
                          ],

                          // ── Field Kata Sandi Baru ──
                          DcTextField(
                            label: 'Kata Sandi Baru'.tr,
                            hint: 'Masukkan kata sandi baru'.tr,
                            controller: _password,
                            leadingIconPath: AppAssets.iconLock,
                            obscureText: true,
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Kata sandi wajib diisi'.tr
                                : null,
                          ),
                          SizedBox(height: 16),

                          // ── Field Konfirmasi Kata Sandi ──
                          DcTextField(
                            label: 'Konfirmasi Kata Sandi Baru'.tr,
                            hint: 'Ulangi kata sandi baru'.tr,
                            controller: _confirmPassword,
                            leadingIconPath: AppAssets.iconLock,
                            obscureText: true,
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Konfirmasi kata sandi wajib diisi'.tr
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'KRITERIA KATA SANDI:'.tr,
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
                                      _isCriteriaMet
                                          ? 'Terpenuhi'.tr
                                          : 'Belum Terpenuhi'.tr,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: _isCriteriaMet
                                            ? AppColors.successText
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                _buildCriterion(
                                  'Minimal 8 karakter'.tr,
                                  _isMinLength,
                                ),
                                _buildCriterion(
                                  'Mengandung huruf besar dan angka'.tr,
                                  _hasUpperAndNumber,
                                ),
                                _buildCriterion(
                                  'Cocok dengan konfirmasi kata sandi'.tr,
                                  _isMatch,
                                ),
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
                                onPressed: (_isCriteriaMet && !_isLoading)
                                    ? _submit
                                    : null,
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
                                        'Simpan Kata Sandi Baru'.tr,
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
                                  'Butuh bantuan lebih lanjut?'.tr,
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
                                    'Hubungi kami'.tr,
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
