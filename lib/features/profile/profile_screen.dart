import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_settings.dart';
import '../../core/app_text.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/dc_app_header.dart';
import '../../core/widgets/image_preview_dialog.dart';
import '../../data/mock_data.dart';

/// Halaman Profil — bagian "Riwayat Pesanan" disesuaikan 1:1 dengan desain
/// Figma (ProfilPesananDikemas / ProfilPesananDikrim / ProfilPesananDiterima).
/// Foto produk pesanan tetap memakai data project (MockData).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.initialTab});

  final String? initialTab;

  /// Global notifier/holder jika dipanggil dari luar (misal: tombol 'Bayar Nanti' di PaymentScreen).
  static final ValueNotifier<String?> selectedTabNotifier =
      ValueNotifier<String?>(null);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ── Token profil ────────────────────────────────────────────────────────
  // Seluruh warna netral mengacu ke token global agar kartu pesanan tetap
  // memiliki hierarki dan kontras yang sama di tema terang maupun gelap.
  Color get _black => AppColors.ink;
  Color get _text => AppColors.ink;
  Color get _textGray => AppColors.textSecondary;
  Color get _priceGray => AppColors.textSecondaryAlt;
  Color get _chipGray => AppColors.textSecondary;
  Color get _lineGray => AppColors.divider;
  Color get _borderGray => AppColors.border;
  Color get _badgeGray => AppColors.surfaceSubtle;
  Color get _btnLight => AppColors.surfaceSubtle;
  Color get _dikirimBlue =>
      AppColors.isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E88E5);
  Color get _dikemasAmber =>
      AppColors.isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706);
  Color get _statusGreen =>
      AppColors.isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A);

  String _orderTab = 'Dikemas';

  @override
  void initState() {
    super.initState();
    final target = ProfileScreen.selectedTabNotifier.value;
    if (target != null) {
      _orderTab = target;
      ProfileScreen.selectedTabNotifier.value = null;
    } else if (widget.initialTab != null) {
      _orderTab = widget.initialTab!;
    }
    ProfileScreen.selectedTabNotifier.addListener(_onSelectedTabChanged);
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTab != null && widget.initialTab != _orderTab) {
      setState(() => _orderTab = widget.initialTab!);
    }
  }

  @override
  void dispose() {
    ProfileScreen.selectedTabNotifier.removeListener(_onSelectedTabChanged);
    super.dispose();
  }

  void _onSelectedTabChanged() {
    final target = ProfileScreen.selectedTabNotifier.value;
    if (target != null && mounted) {
      setState(() => _orderTab = target);
      ProfileScreen.selectedTabNotifier.value = null;
    }
  }

  // Produk dari project (MockData) — hanya dipakai untuk gambar.
  Product get _vasProduct => MockData.products.firstWhere((p) => p.id == '1');
  Product get _cangkirProduct =>
      MockData.products.firstWhere((p) => p.id == '2');
  Product get _mangkukProduct =>
      MockData.products.firstWhere((p) => p.id == '3');

  Future<void> _handleRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const tabs = ['Belum Bayar', 'Dikemas', 'Dikirim', 'Diterima'];
    final topHeaderHeight = DcAppHeader.totalHeight(context);

    return Scaffold(
      backgroundColor: AppColors.bg,
      extendBody: true,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppColors.ink,
        backgroundColor: AppColors.surfaceElevated,
        edgeOffset: topHeaderHeight,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
          SliverPinnedDcHeader(),
          SliverToBoxAdapter(
            child: Padding(
              // Padding bawah disesuaikan agar elemen profil dapat leluasa bergulir
              // dan terlihat secara jelas di balik navbar kaca (extendBody: true).
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 56),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileBlock(),
                  SizedBox(height: 20),
                  _buildOrderSectionHeader(),
                  SizedBox(height: 10),
                  _buildSegmentedTabs(tabs),
                  SizedBox(height: 12),
                  ..._buildOrderCards(context),
                  SizedBox(height: 10),
                  _buildSeeAllButton(context),
                  SizedBox(height: 20),
                  // Bagian bawah tetap memakai margin 4 horizontal.
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAccountSection(context),
                        SizedBox(height: 24),
                        _buildLogoutButton(context),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            'DinoyoCraft App v1.0.0',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        SizedBox(height: 3),
                        Center(
                          child: Text(
                            'Sentra Keramik Dinoyo Malang • Jawa Timur'.tr,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: AppColors.textSecondary,
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
        ],
      ),
    ),
  );
  }

  void _openProfilePhotoPreview() {
    ImagePreviewDialog.show(
      context,
      title: 'Foto Profil'.tr,
      subtitle: 'Customer • @customer',
      bytes: MockData.userProfilePhotoBytes,
      filePath: MockData.userProfilePhotoPath,
      isAvatar: true,
    );
  }

  Widget _avatarPlaceholder() {
    return Icon(
      Icons.person_outline_rounded,
      size: 44,
      color: AppColors.ink,
    );
  }

  Widget _buildProfileAvatar() {
    Widget imageContent;
    if (MockData.userProfilePhotoBytes != null) {
      imageContent = Image.memory(
        MockData.userProfilePhotoBytes!,
        width: 88,
        height: 88,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _avatarPlaceholder(),
      );
    } else if (MockData.userProfilePhotoPath != null) {
      imageContent = Image.file(
        File(MockData.userProfilePhotoPath!),
        width: 88,
        height: 88,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _avatarPlaceholder(),
      );
    } else {
      imageContent = _avatarPlaceholder();
    }

    return GestureDetector(
      key: const Key('profile_avatar_tap'),
      onTap: _openProfilePhotoPreview,
      child: Container(
        width: 88,
        height: 88,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.inputBg,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: imageContent,
      ),
    );
  }

  // ═══ Blok profil ════════════════════════════════════════════════════════
  Widget _buildProfileBlock() {
    return Column(
      children: [
        Center(child: _buildProfileAvatar()),
        SizedBox(height: 14),
        Center(
          child: Text(
            'Customer',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
        ),
        SizedBox(height: 4),
        Center(
          child: Text(
            '@customer',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ),
        ),
        SizedBox(height: 14),
        Center(
          child: OutlinedButton.icon(
            onPressed: () async {
              await context.push('/profile/edit');
              if (mounted) setState(() {});
            },
            icon: Icon(
              Icons.person_outline_rounded,
              size: 16,
              color: AppColors.ink,
            ),
            label: Text(
              'Data Diri'.tr,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.surface,
              side: BorderSide(color: AppColors.ink),
              shape: StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  // ═══ Riwayat Pesanan: header & tab ══════════════════════════════════════
  Widget _buildOrderSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            'Riwayat Pesanan'.tr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: _lineGray),
          ),
          // Sesuai desain: selalu "1 Pesanan" di ketiga tab.
          child: Text(
            '1 Pesanan'.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: _chipGray,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentedTabs(List<String> tabs) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderGray),
      ),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _orderTab = tabs[i]),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: i < tabs.length - 1 ? 4 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                  decoration: BoxDecoration(
                    color: tabs[i] == _orderTab
                        ? AppColors.black
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: tabs[i] == _orderTab
                        ? [
                            BoxShadow(
                              color: Color(0x0D000000),
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        tabs[i].tr,
                        maxLines: 1,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: tabs[i] == _orderTab
                              ? AppColors.white
                              : _chipGray,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildOrderCards(BuildContext context) => switch (_orderTab) {
        'Belum Bayar' => [_belumBayarCard(context)],
        'Dikemas' => [_dikemasCard()],
        'Dikirim' => [_dikirimCard(context)],
        _ => [
          _diterimaCard(
            id: '#DNC-001',
            store: 'Dinoyo Ceramic Studio',
            deliveredText: 'Diterima pada 12 Feb 2025 - Diterima oleh Penerima',
            product: _vasProduct,
            name: 'Vas Keramik Minimalis',
            variant: 'Sand White Glossy • 1x',
            price: 'Rp85.000',
            total: 'Rp102.000',
            leftLabel: 'Beri Ulasan',
            onLeft: () => context.push('/review/write'),
            onBuyAgain: () => context.push('/product/1'),
          ),
          const SizedBox(height: 12),
          _diterimaCard(
            id: '#DNC-000',
            store: 'Ruang Tanah Studio',
            deliveredText: 'Diterima pada 28 Jan 2025 - Diterima oleh Satpam',
            product: _mangkukProduct,
            name: 'Mangkuk Keramik Artisanal',
            variant: 'Terracotta Glaze • 1x',
            price: 'Rp75.000',
            total: 'Rp90.000',
            leftLabel: 'Lihat Ulasan',
            onLeft: () => context.push('/reviews'),
            onBuyAgain: () => context.push('/product/3'),
          ),
        ],
      };

  // ═══ Kartu: BELUM BAYAR ═════════════════════════════════════════════════
  Widget _belumBayarCard(BuildContext context) {
    return _cardShell(
      borderColor: _borderGray,
      radius: 16,
      padding: const EdgeInsets.all(16),
      children: [
        _cardHeader(
          id: '#DNC-005',
          store: 'Dinoyo Ceramic Studio',
          badge: 'Menunggu Pembayaran'.tr,
          fontSize: 12,
          storeColor: _textGray,
          badgeBorder: _borderGray,
          badgeFill: _badgeGray,
          showBullet: true,
        ),
        const SizedBox(height: 12),
        Divider(height: 1, thickness: 1, color: _lineGray),
        const SizedBox(height: 12),
        _statusBox(
          icon: Icons.hourglass_top_rounded,
          title: 'Menunggu Pembayaran'.tr,
          titleTrailing: '23:59:45',
          dotColor: _dikemasAmber,
          note: 'Selesaikan pembayaran sebelum batas waktu berakhir\n'
              'agar pesanan tidak dibatalkan otomatis.'.tr,
          noteColor: _dikemasAmber,
        ),
        const SizedBox(height: 12),
        _simpleProductRow(
          product: _vasProduct,
          name: 'Vas Keramik Minimalis',
          subtitle: 'Sand White Glossy • 1x',
          qty: 'Jumlah: 1'.tr,
          price: 'Rp85.000',
          imageSize: 76,
          imageRadius: 10,
          gap: 12,
        ),
        const SizedBox(height: 10),
        _totalRow('Total (1 Produk):'.tr, 'Rp102.000', _lineGray),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _actionButton(
                label: 'Batalkan'.tr,
                icon: Icons.close_rounded,
                bg: _btnLight,
                fg: _text,
                borderColor: _borderGray,
                bold: true,
                height: 40,
                onTap: () => _confirmCancelOrder(context),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _actionButton(
                label: 'Bayar Sekarang'.tr,
                icon: Icons.payment_rounded,
                bg: AppColors.black,
                fg: AppColors.white,
                bold: true,
                height: 40,
                onTap: () {
                  context.push('/checkout/payment');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _confirmCancelOrder(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Batalkan Pesanan?'.tr,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        content: Text(
          'Pesanan #DNC-005 akan dibatalkan. Tindakan ini tidak dapat diurungkan.'.tr,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Kembali'.tr,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx, true);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.black,
                  content: Text(
                    'Pesanan #DNC-005 berhasil dibatalkan.'.tr,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppColors.white,
                    ),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              elevation: 0,
            ),
            child: Text(
              'Batalkan Pesanan'.tr,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══ Kartu: DIKEMAS ═════════════════════════════════════════════════════
  Widget _dikemasCard() {
    return _cardShell(
      borderColor: _borderGray,
      radius: 16,
      padding: const EdgeInsets.all(16),
      children: [
        _cardHeader(
          id: '#DNC-001',
          store: 'Dinoyo Ceramic Studio',
          badge: 'Dikemas Penjual'.tr,
          fontSize: 12,
          storeColor: _textGray,
          badgeBorder: _borderGray,
          badgeFill: _badgeGray,
          showBullet: true,
        ),
        const SizedBox(height: 12),
        Divider(height: 1, thickness: 1, color: _lineGray),
        const SizedBox(height: 12),
        _statusBox(
          title: 'Menyerahkan ke Pihak Jasa Kirim'.tr,
          dotColor: _dikemasAmber,
          note: 'Paket sedang dalam perjalanan untuk diserahkan\n'
              'ke Pihak Jasa Kirim'.tr,
          noteColor: _dikemasAmber,
        ),
        const SizedBox(height: 12),
        _simpleProductRow(
          product: _mangkukProduct,
          name: 'Mangkuk Keramik',
          subtitle: 'Karya Tanah Keramik Dinoyo',
          qty: 'Jumlah: 1'.tr,
          price: 'Rp20.000',
          imageSize: 76,
          imageRadius: 10,
          gap: 12,
        ),
        const SizedBox(height: 10),
        _totalRow('Total (1 Produk):'.tr, 'Rp25.000', _lineGray),
      ],
    );
  }

  // ═══ Kartu: DIKIRIM ═════════════════════════════════════════════════════
  Widget _dikirimCard(BuildContext context) {
    return _cardShell(
      borderColor: _borderGray,
      radius: 16,
      padding: const EdgeInsets.all(16),
      children: [
        _cardHeader(
          id: '#DNC-004',
          store: 'Karya Tanah',
          badge: 'Sedang Dikirim'.tr,
          fontSize: 12,
          storeColor: _textGray,
          badgeBorder: _borderGray,
          badgeFill: _badgeGray,
          showBullet: true,
        ),
        const SizedBox(height: 12),
        Divider(height: 1, thickness: 1, color: _lineGray),
        const SizedBox(height: 12),
        _statusBox(
          title: 'J&T Express - Reguler',
          titleTrailing: 'JT92817294820',
          dotColor: _dikirimBlue,
          note: 'Paket sedang dalam perjalanan menuju kota\n'
              'Malang (Hub Sukun)'.tr,
          noteColor: _dikirimBlue,
        ),
        const SizedBox(height: 12),
        _simpleProductRow(
          product: _cangkirProduct,
          name: 'Cangkir Handmade Artisan',
          subtitle: 'Karya Tanah Keramik Dinoyo',
          qty: 'Jumlah: 2'.tr,
          price: 'Rp130.000',
          imageSize: 76,
          imageRadius: 10,
          gap: 12,
        ),
        const SizedBox(height: 10),
        _totalRow('Total (2 Produk):'.tr, 'Rp145.000', _lineGray),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _actionButton(
                label: 'Lacak Resi'.tr,
                icon: Icons.local_shipping_outlined,
                bg: _btnLight,
                fg: _text,
                borderColor: _borderGray,
                bold: true,
                height: 40,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.black,
                      content: Text(
                        'Resi JT92817294820 sedang dalam perjalanan.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _actionButton(
                label: 'Hubungi Penjual',
                icon: Icons.chat_bubble_outline_rounded,
                bg: AppColors.black,
                fg: AppColors.white,
                bold: true,
                height: 40,
                onTap: () {
                  context.push('/chat-room?store='
                      '${Uri.encodeComponent('Dinoyo Ceramic Studio')}');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ═══ Kartu: DITERIMA ════════════════════════════════════════════════════
  Widget _diterimaCard({
    required String id,
    required String store,
    required String deliveredText,
    required Product product,
    required String name,
    required String variant,
    required String price,
    required String total,
    required String leftLabel,
    required VoidCallback onLeft,
    required VoidCallback onBuyAgain,
  }) {
    return _cardShell(
      borderColor: _borderGray,
      radius: 16,
      padding: const EdgeInsets.all(16),
      children: [
        _cardHeader(
          id: id,
          store: store,
          badge: 'Pesanan Selesai'.tr,
          fontSize: 12,
          storeColor: _textGray,
          badgeBorder: _borderGray,
          badgeFill: _badgeGray,
          showBullet: true,
        ),
        const SizedBox(height: 12),
        Divider(height: 1, thickness: 1, color: _lineGray),
        const SizedBox(height: 12),
        _deliveredStatusBox(deliveredText),
        const SizedBox(height: 12),
        _simpleProductRow(
          product: product,
          name: name,
          subtitle: variant,
          qty: 'Jumlah: 1'.tr,
          price: price,
          imageSize: 76,
          imageRadius: 10,
          gap: 12,
        ),
        const SizedBox(height: 10),
        _totalRow('Total (1 Produk):'.tr, total, _lineGray),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _actionButton(
                label: leftLabel.tr,
                bg: _btnLight,
                fg: _text,
                borderColor: _borderGray,
                bold: true,
                height: 40,
                onTap: onLeft,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _actionButton(
                label: 'Beli Lagi'.tr,
                bg: AppColors.black,
                fg: AppColors.white,
                bold: true,
                height: 40,
                onTap: onBuyAgain,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ═══ Komponen bersama kartu pesanan ═════════════════════════════════════
  Widget _cardShell({
    required Color borderColor,
    required double radius,
    required EdgeInsets padding,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: AppColors.isDark ? 0.25 : 0.04,
            ),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _cardHeader({
    required String id,
    required String store,
    required String badge,
    required double fontSize,
    required Color storeColor,
    required Color badgeBorder,
    Color? badgeFill,
    bool showBullet = false,
  }) {
    return Row(
      children: [
        Text(
          id,
          style: GoogleFonts.plusJakartaSans(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: _text,
          ),
        ),
        SizedBox(width: 8),
        if (showBullet) ...[
          Text(
            '•',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              color: _priceGray,
            ),
          ),
          SizedBox(width: 6),
        ],
        Expanded(
          child: Text(
            store,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: fontSize,
              color: storeColor,
            ),
          ),
        ),
        SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: badgeFill ?? AppColors.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: badgeBorder),
          ),
          child: Text(
            badge,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: _text,
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusBox({
    required String title,
    String? titleTrailing,
    required Color dotColor,
    required String note,
    required Color noteColor,
    IconData icon = Icons.local_shipping_outlined,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: _black),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: _black,
                  ),
                ),
              ),
              if (titleTrailing != null)
                Text(
                  titleTrailing,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: _textGray,
                  ),
                ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  note,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    height: 1.4,
                    color: noteColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _deliveredStatusBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _black),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 15,
            color: _statusGreen,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: _black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _productImage(Product product, double size, double radius) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        product.image,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, stack) => Container(
          width: size,
          height: size,
          color: AppColors.inputBg,
          child: Icon(Icons.image_outlined, color: AppColors.textMuted),
        ),
      ),
    );
  }

  /// Baris produk untuk seluruh tab pesanan:
  /// nama + info di atas, "Jumlah" (kiri) dan harga (kanan) di bawah.
  Widget _simpleProductRow({
    required Product product,
    required String name,
    required String subtitle,
    required String qty,
    required String price,
    required double imageSize,
    required double imageRadius,
    required double gap,
  }) {
    return SizedBox(
      height: imageSize,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _productImage(product, imageSize, imageRadius),
          SizedBox(width: gap),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: _textGray,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      qty,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: _textGray,
                      ),
                    ),
                    Text(
                      price,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalRow(String label, String value, Color dividerColor) {
    return Column(
      children: [
        Divider(height: 1, thickness: 1, color: dividerColor),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: _textGray,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required String label,
    required Color bg,
    required Color fg,
    required VoidCallback onTap,
    required double height,
    Color? borderColor,
    IconData? icon,
    bool bold = false,
  }) {
    return Material(
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: borderColor != null
            ? BorderSide(color: borderColor)
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: height,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 14, color: fg),
                  SizedBox(width: 6),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
                      color: fg,
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

  /// Sheet berisi seluruh pesanan dari ketiga tab status.
  void _showAllOrdersSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      // Root navigator agar sheet tampil di atas bottom navbar (seperti
      // modal Notifikasi & Keranjang).
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceElevated,
      barrierColor: Color(0x73000000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        builder: (ctx, scrollCtrl) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                children: [
                  Text(
                    'Semua Pesanan'.tr,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    icon: Icon(Icons.close_rounded, size: 20),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: _lineGray),
            Expanded(
              child: ListView(
                controller: scrollCtrl,
                padding: const EdgeInsets.all(16),
                children: [
                  _belumBayarCard(ctx),
                  SizedBox(height: 12),
                  _dikemasCard(),
                  SizedBox(height: 12),
                  _dikirimCard(ctx),
                  SizedBox(height: 12),
                  _diterimaCard(
                    id: '#DNC-001',
                    store: 'Dinoyo Ceramic Studio',
                    deliveredText:
                        'Diterima pada 12 Feb 2025 - Diterima oleh Penerima',
                    product: _vasProduct,
                    name: 'Vas Keramik Minimalis',
                    variant: 'Sand White Glossy • 1x',
                    price: 'Rp85.000',
                    total: 'Rp102.000',
                    leftLabel: 'Beri Ulasan',
                    onLeft: () => ctx.push('/review/write'),
                    onBuyAgain: () => ctx.push('/product/1'),
                  ),
                  const SizedBox(height: 12),
                  _diterimaCard(
                    id: '#DNC-000',
                    store: 'Ruang Tanah Studio',
                    deliveredText:
                        'Diterima pada 28 Jan 2025 - Diterima oleh Satpam',
                    product: _mangkukProduct,
                    name: 'Mangkuk Keramik Artisanal',
                    variant: 'Terracotta Glaze • 1x',
                    price: 'Rp75.000',
                    total: 'Rp90.000',
                    leftLabel: 'Lihat Ulasan',
                    onLeft: () => ctx.push('/reviews'),
                    onBuyAgain: () => ctx.push('/product/3'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeeAllButton(BuildContext context) {
    final dashed = _DashedRRectPainter(
      color: _black,
      radius: 12,
      dashWidth: 4,
      dashGap: 3,
    );
    return CustomPaint(
      painter: dashed,
      child: InkWell(
        onTap: () => _showAllOrdersSheet(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          height: 40,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Lihat Semua Pesanan'.tr,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              SizedBox(width: 6),
              Icon(Icons.chevron_right, size: 16, color: AppColors.ink),
            ],
          ),
        ),
      ),
    );
  }

  // ═══ Akun ═══════════════════════════════════════════════════════════════
  Widget _buildAccountSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Akun'.tr,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: AppColors.isDark ? 0.25 : 0.04,
                ),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              _accountTile(
                context,
                icon: Icons.person_outline_rounded,
                title: 'Data Diri'.tr,
                subtitle: 'Kelola informasi akun & profil'.tr,
                route: '/profile/edit',
              ),
              Divider(height: 1, indent: 60, color: _lineGray),
              _accountTile(
                context,
                icon: Icons.location_on_outlined,
                title: 'Alamat Pengiriman'.tr,
                subtitle: 'Kelola alamat tujuan pesanan'.tr,
                route: '/addresses',
              ),
              Divider(height: 1, indent: 60, color: _lineGray),
              _accountTile(
                context,
                icon: Icons.settings_outlined,
                title: 'Pengaturan'.tr,
                subtitle: 'Notifikasi, bahasa & privasi'.tr,
                route: '/settings',
              ),
              Divider(height: 1, indent: 60, color: _lineGray),
              _accountTile(
                context,
                icon: Icons.help_outline_rounded,
                title: 'Bantuan'.tr,
                subtitle: 'Temukan jawaban yang Anda butuhkan'.tr,
                route: '/help',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _accountTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String route,
  }) {
    return InkWell(
      onTap: () => context.push(route),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 18, color: AppColors.ink),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 16,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    // Ukuran & gaya disamakan dengan tombol Keluar dari Akun
    // di halaman Kelola Pengaturan.
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: () {
          // Logout → login berikutnya butuh OTP (jika 2FA aktif).
          AppSettings.instance.markLoggedOut();
          context.go('/login');
        },
        icon: Icon(
          Icons.logout_rounded,
          size: 20,
          color: AppColors.danger,
        ),
        label: Text(
          'Keluar dari Akun'.tr,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.danger,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.danger, width: 1.5),
          shape: StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          backgroundColor: AppColors.surface,
        ),
      ),
    );
  }
}

/// Border putus-putus (dashed) untuk tombol "Lihat Semua Pesanan".
class _DashedRRectPainter extends CustomPainter {
  const _DashedRRectPainter({
    required this.color,
    required this.radius,
    this.dashWidth = 6,
    this.dashGap = 4,
  });

  final Color color;
  final double radius;
  final double dashWidth;
  final double dashGap;
  static const double strokeWidth = 1;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(radius),
        ),
      );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    for (final metric in path.computeMetrics()) {
      var dist = 0.0;
      while (dist < metric.length) {
        final len = math.min(dashWidth, metric.length - dist);
        canvas.drawPath(metric.extractPath(dist, dist + len), paint);
        dist += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.radius != radius ||
      oldDelegate.dashWidth != dashWidth ||
      oldDelegate.dashGap != dashGap;
}
