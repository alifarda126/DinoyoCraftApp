import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  static const Color _destructive = Color(0xFFBA1A1A);
  static const Color _bannerBg = Color(0xFFFFDAD6);
  static const Color _bannerText = Color(0xFF93000A);

  static const List<String> _reasons = [
    'Sudah jarang membeli keramik',
    'Ingin membuat akun baru',
    'Kekhawatiran privasi & keamanan data',
    'Lainnya',
  ];

  final Set<int> _selectedReasons = {};
  bool _confirmed = false;
  bool _obscurePassword = true;
  final TextEditingController _passwordController = TextEditingController();

  bool get _canDelete => _confirmed && _passwordController.text.isNotEmpty;

  Future<void> _confirmDelete() async {
    if (!_canDelete) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Hapus Akun?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        content: Text(
          'Akun DinoyoCraft kamu akan dihapus secara permanen. Tindakan ini '
          'tidak dapat dibatalkan.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Batalkan',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: _destructive,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Hapus',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (ok == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.black,
          content: Text(
            'Permintaan penghapusan akun terkirim (demo).',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppColors.white,
            ),
          ),
        ),
      );
      context.go('/profile');
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 54,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 19,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Hapus Akun',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 30),
                children: [
                  _buildWarningBanner(),
                  const SizedBox(height: 20),
                  Text(
                    'Beri tahu kami alasan kamu (Opsional)',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Masukan kamu sangat berharga untuk kemajuan perajin '
                    'keramik lokal Dinoyo.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final (i, reason) in _reasons.indexed)
                    _buildReasonCard(i, reason),
                  const SizedBox(height: 14),
                  _buildConfirmationCard(),
                  const SizedBox(height: 20),
                  Text(
                    'Masukkan Kata Sandi untuk Konfirmasi',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    onChanged: (_) => setState(() {}),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: AppColors.ink,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Masukkan kata sandi akunmu',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 13,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.borderAlt,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.borderAlt,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.ink),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Verifikasi keamanan untuk memastikan ini benar-benar '
                    'pemilik akun.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: _canDelete ? _confirmDelete : null,
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: AppColors.white,
                      ),
                      label: Text(
                        'Hapus Akun Secara Permanen',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: _destructive,
                        disabledBackgroundColor:
                            _destructive.withValues(alpha: 0.4),
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bannerBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x4DBA1A1A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 26,
                color: _bannerText,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Apakah kamu yakin ingin menghapus akun?',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _bannerText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                height: 1.55,
                color: AppColors.textSecondary,
              ),
              children: [
                const TextSpan(text: 'Tindakan ini bersifat '),
                TextSpan(
                  text: 'permanen dan tidak dapat dibatalkan',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSecondary,
                  ),
                ),
                const TextSpan(
                  text:
                      '. Seluruh data profil, riwayat kurasi produk keramik, '
                      'serta poin DinoyoCraft kamu akan dihapus selamanya.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonCard(int index, String reason) {
    final selected = _selectedReasons.contains(index);

    return InkWell(
      onTap: () => setState(() {
        selected
            ? _selectedReasons.remove(index)
            : _selectedReasons.add(index);
      }),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.ink : AppColors.borderAlt,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.circle_outlined,
              size: 18,
              color: selected ? AppColors.ink : const Color(0xFF7E7576),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                reason,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: AppColors.ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationCard() {
    return InkWell(
      onTap: () => setState(() => _confirmed = !_confirmed),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _confirmed ? AppColors.ink : AppColors.borderAlt,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 18,
              height: 18,
              margin: const EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _confirmed ? AppColors.ink : AppColors.white,
                border: Border.all(
                  color: _confirmed ? AppColors.ink : const Color(0xFF7E7576),
                  width: 1.4,
                ),
              ),
              child: _confirmed
                  ? const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: AppColors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Saya mengerti konsekuensi penghapusan akun DinoyoCraft ini '
                'dan menyatakan bahwa keputusan ini bersifat final.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  height: 1.55,
                  color: AppColors.ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
