import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app_settings.dart';
import '../../../../core/assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dc_button.dart';
import '../../../../core/widgets/dc_text_field.dart';
import '../../onboarding_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
const   ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AuthBackHeader(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lupa Password',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Masukkan email terdaftar. Kami akan mengirim kode verifikasi.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 28),
                DcTextField(
                  label: 'Email',
                  hint: 'Masukkan email',
                  controller: _email,
                  leadingIconPath: AppAssets.iconEmail,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Email wajib diisi' : null,
                ),
                SizedBox(height: 28),
                DcButton(
                  label: 'Kirim Kode',
                  onPressed: () {
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
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
