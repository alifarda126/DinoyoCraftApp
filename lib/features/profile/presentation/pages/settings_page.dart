import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifTransaksi = true;
  bool _notifPromo = true;
  bool _notifWorkshop = false;
  bool _twoFa = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg, elevation: 0, scrolledUnderElevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ink), onPressed: () => Navigator.of(context).maybePop()),
        title: Text('Kelola Pengaturan', style: AppTextStyles.appBarTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppDimensions.pageHorizontal, AppDimensions.paddingL, AppDimensions.pageHorizontal, AppDimensions.bottomNavClearance),
        children: [
          // AKUN & KEAMANAN
          _SectionHeader(label: 'AKUN & KEAMANAN'),
          _MenuTile(icon: Icons.lock_outline, title: 'Ubah Kata Sandi', subtitle: 'Terakhir diubah 3 bulan lalu', onTap: () {}),
          _SwitchTile(icon: Icons.security_outlined, title: 'Autentikasi 2 Langkah (2FA)', subtitle: 'Tingkatkan keamanan akun via SMS/OTP', value: _twoFa, onChanged: (v) => setState(() => _twoFa = v)),
          _MenuTile(icon: Icons.devices_outlined, title: 'Perangkat Terhubung', subtitle: '1 perangkat aktif saat ini', onTap: () {}),
          const Divider(height: 28, color: AppColors.border),

          // NOTIFIKASI
          _SectionHeader(label: 'NOTIFIKASI'),
          _SwitchTile(icon: Icons.receipt_long_outlined, title: 'Transaksi & Pesanan', subtitle: 'Update status pesanan realtime', value: _notifTransaksi, onChanged: (v) => setState(() => _notifTransaksi = v)),
          _SwitchTile(icon: Icons.local_offer_outlined, title: 'Promo & Diskon', subtitle: 'Voucher dan penawaran terbaru', value: _notifPromo, onChanged: (v) => setState(() => _notifPromo = v)),
          _SwitchTile(icon: Icons.brush_outlined, title: 'Workshop Keramik', subtitle: 'Jadwal dan kuota workshop', value: _notifWorkshop, onChanged: (v) => setState(() => _notifWorkshop = v)),
          const Divider(height: 28, color: AppColors.border),

          // LAINNYA
          _SectionHeader(label: 'LAINNYA'),
          _MenuTile(icon: Icons.privacy_tip_outlined, title: 'Kebijakan Privasi', onTap: () {}),
          _MenuTile(icon: Icons.description_outlined, title: 'Syarat & Ketentuan', onTap: () {}),
          _MenuTile(icon: Icons.info_outline, title: 'Tentang Aplikasi', subtitle: 'Versi 1.0.0', onTap: () {}),
          const Divider(height: 28, color: AppColors.border),

          // ZONA BERBAHAYA
          _SectionHeader(label: 'ZONA BERBAHAYA'),
          _DangerTile(
            icon: Icons.logout,
            title: 'Keluar',
            color: Colors.redAccent,
            onTap: () => _showConfirmDialog(context, title: 'Keluar dari akun?', body: 'Anda harus login kembali untuk mengakses akun.', confirmLabel: 'Keluar', onConfirm: () { /* TODO: logout */ }),
          ),
          const SizedBox(height: AppDimensions.paddingS),
          _DangerTile(
            icon: Icons.delete_forever_outlined,
            title: 'Hapus Akun',
            color: Colors.red.shade700,
            onTap: () => _showDeleteAccountDialog(context),
          ),
        ],
      ),
    );
  }

  Future<void> _showConfirmDialog(BuildContext context, {required String title, required String body, required String confirmLabel, required VoidCallback onConfirm}) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title, style: AppTextStyles.cardTitle),
        content: Text(body, style: AppTextStyles.bodySmall),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Batal', style: AppTextStyles.seeAll)),
          ElevatedButton(
            onPressed: () { Navigator.pop(context); onConfirm(); },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: AppColors.white, elevation: 0, shape: const StadiumBorder()),
            child: Text(confirmLabel, style: AppTextStyles.buttonLabel),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteAccountDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Hapus Akun', style: AppTextStyles.cardTitle.copyWith(color: Colors.red)),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Tindakan ini tidak dapat dibatalkan. Semua data Anda akan dihapus permanen termasuk:', style: AppTextStyles.bodySmall),
          const SizedBox(height: AppDimensions.gapM),
          ...[' Riwayat pesanan', ' Ulasan yang ditulis', ' Alamat tersimpan', ' Data akun'].map((t) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(children: [const Icon(Icons.close, size: 14, color: Colors.redAccent), const SizedBox(width: 6), Text(t, style: AppTextStyles.bodySmall)]),
          )),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Batal', style: AppTextStyles.seeAll)),
          ElevatedButton(
            onPressed: () { Navigator.pop(context); /* TODO: delete account */ },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: AppColors.white, elevation: 0, shape: const StadiumBorder()),
            child: Text('Hapus Akun', style: AppTextStyles.buttonLabel),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppDimensions.paddingM),
    child: Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.8)),
  );
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.title, this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
      child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(AppDimensions.radiusM)), child: Icon(icon, color: AppColors.ink, size: 20)),
        const SizedBox(width: AppDimensions.gapM),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: AppTextStyles.subTitle),
          if (subtitle != null) Text(subtitle!, style: AppTextStyles.caption),
        ])),
        const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
      ]),
    ),
  );
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({required this.icon, required this.title, this.subtitle, required this.value, required this.onChanged});
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
    child: Row(children: [
      Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(AppDimensions.radiusM)), child: Icon(icon, color: AppColors.ink, size: 20)),
      const SizedBox(width: AppDimensions.gapM),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: AppTextStyles.subTitle),
        if (subtitle != null) Text(subtitle!, style: AppTextStyles.caption),
      ])),
      Switch(value: value, onChanged: onChanged, activeThumbColor: AppColors.black),
    ]),
  );
}

class _DangerTile extends StatelessWidget {
  const _DangerTile({required this.icon, required this.title, required this.color, required this.onTap});
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
      child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppDimensions.radiusM)), child: Icon(icon, color: color, size: 20)),
        const SizedBox(width: AppDimensions.gapM),
        Text(title, style: AppTextStyles.subTitle.copyWith(color: color)),
      ]),
    ),
  );
}
