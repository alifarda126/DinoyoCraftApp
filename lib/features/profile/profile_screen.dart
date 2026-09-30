import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../auth/onboarding_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menus = [
      (Icons.person_outline, 'Data Diri'),
      (Icons.location_on_outlined, 'Alamat Pengiriman'),
      (Icons.credit_card_outlined, 'Metode Pembayaran'),
      (Icons.settings_outlined, 'Pengaturan'),
    ];

    return Scaffold(
      appBar: AuthBackHeader(onBack: () => context.pop()),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.inputBg,
                child: Text(
                  'MY',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Mochammad Al Hizyan Yaikaful',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'yaikaful@email.com',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 28),
            ...menus.map(
              (m) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(m.$1, color: AppColors.ink),
                title: Text(
                  m.$2,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${m.$2} segera hadir')),
                  );
                },
              ),
            ),
            const Divider(height: 32),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: Text(
                'Keluar',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.redAccent,
                ),
              ),
              onTap: () => context.go('/'),
            ),
          ],
        ),
      ),
    );
  }
}
