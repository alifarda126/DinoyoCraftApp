import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';

class DataDiriScreen extends StatefulWidget {
  const DataDiriScreen({super.key});

  @override
  State<DataDiriScreen> createState() => _DataDiriScreenState();
}

class _DataDiriScreenState extends State<DataDiriScreen> {
  late final TextEditingController _nameController = TextEditingController(
    text: 'Mochammad Al Mizan Ya Hafidl',
  );
  late final TextEditingController _usernameController = TextEditingController(
    text: 'mizanyf',
  );
  late final TextEditingController _emailController = TextEditingController(
    text: 'mizan.artisan@gmail.com',
  );
  late final TextEditingController _phoneController = TextEditingController(
    text: '+62 859-777-588-138',
  );
  late final TextEditingController _birthController = TextEditingController(
    text: '14 Agustus 1998',
  );

  bool _isMale = true;

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  @override
  void dispose() {
    _emailFocus.dispose();
    _phoneFocus.dispose();
    for (final c in [
      _nameController,
      _usernameController,
      _emailController,
      _phoneController,
      _birthController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                children: [
                  _buildTitleBlock(),
                  const SizedBox(height: 16),
                  _buildAvatarSection(),
                  const SizedBox(height: 20),
                  _buildLabelRow('Nama Lengkap', hint: 'Sesuai KTP'),
                  _buildField(
                    controller: _nameController,
                    icon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 14),
                  _buildLabelRow(
                    'Username',
                    badge: 'Tersedia',
                  ),
                  _buildField(
                    controller: _usernameController,
                    icon: Icons.alternate_email_rounded,
                    prefixText: '@',
                  ),
                  const SizedBox(height: 6),
                  _buildHelper(
                    'Username profil dinoyocraft.id/@mizanyf. Ubah 30 hari '
                    'sekali.',
                  ),
                  const SizedBox(height: 14),
                  _buildLabelRow(
                    'Alamat Email',
                    verified: true,
                    onEdit: () => _emailFocus.requestFocus(),
                  ),
                  _buildField(
                    controller: _emailController,
                    icon: Icons.mail_outline_rounded,
                    focusNode: _emailFocus,
                  ),
                  const SizedBox(height: 14),
                  _buildLabelRow(
                    'Nomor WhatsApp / Seluler',
                    verified: true,
                    onEdit: () => _phoneFocus.requestFocus(),
                  ),
                  _buildField(
                    controller: _phoneController,
                    icon: Icons.phone_outlined,
                    focusNode: _phoneFocus,
                  ),
                  const SizedBox(height: 14),
                  _buildLabelRow('Jenis Kelamin'),
                  _buildGenderSegment(),
                  const SizedBox(height: 14),
                  _buildLabelRow('Tanggal Lahir'),
                  _buildField(
                    controller: _birthController,
                    icon: Icons.calendar_today_outlined,
                  ),
                  const SizedBox(height: 18),
                  _buildNoticeBox(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            _buildSaveBar(),
          ],
        ),
      ),
    );
  }

  /// Dialog pilih sumber foto profil.
  void _showPhotoSourceDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(
          'Ubah Foto Profil',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        content: Text(
          'Pilih sumber foto baru untuk profilmu.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              _notifyPhotoDemo('Kamera');
            },
            child: const Text('Kamera'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              _notifyPhotoDemo('Galeri');
            },
            child: const Text('Galeri'),
          ),
        ],
      ),
    );
  }

  void _notifyPhotoDemo(String source) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Mengambil foto dari $source (integrasi kamera/galeri menyusul).',
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 54,
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
          ),
          Expanded(
            child: Text(
              'Kelola Data Diri',
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
    );
  }

  Widget _buildTitleBlock() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ubah Data Diri',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Kelola informasi akun dan profil pengrajin Anda',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.borderAlt),
          ),
          child: Text(
            'ID #8821',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarSection() {
    return Row(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.inputBg,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.borderAlt),
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            size: 44,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _showPhotoSourceDialog,
                child: Text(
                  'Ubah Foto Profil',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Format JPG, PNG atau WEBP. Maksimal 5 MB.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabelRow(
    String label, {
    String? hint,
    String? badge,
    bool verified = false,
    VoidCallback? onEdit,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          const Spacer(),
          if (hint != null)
            Text(
              hint,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
          if (badge != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                badge,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF474746),
                ),
              ),
            ),
          ],
          if (verified) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF50B0FF),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.white),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_rounded,
                    size: 10,
                    color: AppColors.ink,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    'Verif',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onEdit,
              child: Text(
                'Ubah',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required IconData icon,
    String prefixText = '',
    FocusNode? focusNode,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        color: AppColors.ink,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 18, color: AppColors.textSecondary),
        prefixText: prefixText,
        prefixStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderAlt),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderAlt),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.ink),
        ),
      ),
    );
  }

  Widget _buildHelper(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.info_outline_rounded,
          size: 12,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSegment() {
    return Row(
      children: [
        Expanded(
          child: _genderButton(
            label: 'Laki-laki',
            iconAsset: AppAssets.iconMale,
            selected: _isMale,
            onTap: () => setState(() => _isMale = true),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _genderButton(
            label: 'Perempuan',
            iconAsset: AppAssets.iconFemale,
            selected: !_isMale,
            onTap: () => setState(() => _isMale = false),
          ),
        ),
      ],
    );
  }

  Widget _genderButton({
    required String label,
    required String iconAsset,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: selected ? AppColors.black : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.black : AppColors.borderAlt,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconAsset,
              width: 14,
              height: 14,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(
                selected ? AppColors.white : AppColors.ink,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.white : AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeBox() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderAlt),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Pastikan data diri sesuai dengan identitas resmi untuk '
              'kemudahan verifikasi pesanan dan pengiriman keramik di '
              'Aplikasi DinoyoCraft.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        12 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.black,
                    content: Text(
                      'Perubahan data diri disimpan.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                );
                context.pop();
              },
              icon: SvgPicture.asset(
                AppAssets.iconSave,
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
              label: Text(
                'Simpan Perubahan',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.black,
                shape: const StadiumBorder(),
              ),
            ),
          ),
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Batalkan',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
