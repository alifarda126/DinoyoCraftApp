import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app_settings.dart';
import '../../../../core/assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dc_button.dart';
import '../../../../core/widgets/dc_text_field.dart';
import '../../onboarding_screen.dart';

class RegisterScreen extends StatefulWidget {
const   RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _birth = TextEditingController();
  final _wa = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _terms = false;
  DateTime? _birthDate;

  @override
  void dispose() {
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
        _birth.text = '$d/$m/${picked.year}';
      });
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_terms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Setujui syarat & ketentuan terlebih dahulu')),
      );
      return;
    }
    final email = _email.text.trim();
    AppSettings.instance.lastAuthEmail = email;
    final uri = Uri(
      path: '/verify-otp',
      queryParameters: {
        'from': 'register',
        if (email.isNotEmpty) 'email': email,
      },
    );
    context.push(uri.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AuthBackHeader(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Buat Akun',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Daftar untuk mulai menjelajah DinoyoCraft.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 24),
                DcTextField(
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama',
                  controller: _name,
                  leadingIcon: Icons.person_outline,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
                ),
                SizedBox(height: 14),
                DcTextField(
                  label: 'Username',
                  hint: 'Masukkan username',
                  controller: _username,
                  leadingIcon: Icons.alternate_email,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Username wajib diisi' : null,
                ),
                SizedBox(height: 14),
                DcTextField(
                  label: 'Email',
                  hint: 'Masukkan email',
                  controller: _email,
                  leadingIcon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Email wajib diisi' : null,
                ),
                SizedBox(height: 14),
                DcTextField(
                  label: 'Tanggal Lahir',
                  hint: 'dd/mm/yyyy',
                  controller: _birth,
                  leadingIcon: Icons.calendar_today_outlined,
                  readOnly: true,
                  onTap: _pickDate,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Tanggal lahir wajib diisi' : null,
                ),
                SizedBox(height: 14),
                DcTextField(
                  label: 'Nomor WhatsApp',
                  hint: '08xxxxxxxxxx',
                  controller: _wa,
                  leadingIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'WhatsApp wajib diisi' : null,
                ),
                SizedBox(height: 14),
                DcTextField(
                  label: 'Password',
                  hint: 'Buat password',
                  controller: _password,
                  leadingIcon: Icons.lock_outline,
                  obscureText: true,
                  validator: (v) =>
                      (v == null || v.length < 6) ? 'Minimal 6 karakter' : null,
                ),
                SizedBox(height: 14),
                DcTextField(
                  label: 'Konfirmasi Password',
                  hint: 'Ulangi password',
                  controller: _confirm,
                  leadingIcon: Icons.lock_outline,
                  obscureText: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Konfirmasi wajib diisi';
                    if (v != _password.text) return 'Password tidak cocok';
                    return null;
                  },
                ),
                SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _terms,
                      onChanged: (v) => setState(() => _terms = v ?? false),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          'Saya setuju dengan Syarat & Ketentuan serta Kebijakan Privasi DinoyoCraft.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                DcButton(label: 'Daftar', onPressed: _submit),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.border)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'atau',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.border)),
                  ],
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () => context.go('/home'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.border),
                      shape: StadiumBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AppAssets.iconGoogle, width: 20, height: 20),
                        SizedBox(width: 10),
                        Text(
                          'Daftar dengan Google',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Text.rich(
                      TextSpan(
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                        children: [
                          TextSpan(text: 'Sudah punya akun? '),
                          TextSpan(
                            text: 'Masuk',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                              decoration: TextDecoration.underline,
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
  }
}
