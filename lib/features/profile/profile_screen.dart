import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/dc_app_header.dart';
import '../../data/mock_data.dart';

/// Halaman Profil — bagian "Riwayat Pesanan" disesuaikan 1:1 dengan desain
/// Figma (ProfilPesananDikemas / ProfilPesananDikrim / ProfilPesananDiterima).
/// Foto produk pesanan tetap memakai data project (MockData).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ── Warna dari desain Figma ──────────────────────────────────────────────
  static const Color _black = Color(0xFF000000);
  static const Color _text = Color(0xFF1A1C1C);
  static const Color _textGray = Color(0xFF5F5E5E);
  static const Color _textLight = Color(0xFF888888);
  static const Color _priceGray = Color(0xFF848484);
  static const Color _chipGray = Color(0xFF666666);
  static const Color _lineGray = Color(0xFFE5E5E5);
  static const Color _borderGray = Color(0xFFCCCCCC);
  static const Color _borderPink = Color(0xFFCFC4C5);
  static const Color _dividerPink = Color(0xFFE6DCDD);
  static const Color _badgeGray = Color(0xFFF4F3F3);
  static const Color _btnLight = Color(0xFFFAF9F9);
  static const Color _dikirimRed = Color(0xFFFF0024);
  static const Color _dikemasYellow = Color(0xFFFFD400);
  static const Color _logoutRed = Color(0xFFFF0000);

  String _orderTab = 'Dikemas';

  // Produk dari project (MockData) — hanya dipakai untuk gambar.
  Product get _vasProduct => MockData.products.firstWhere((p) => p.id == '1');
  Product get _cangkirProduct =>
      MockData.products.firstWhere((p) => p.id == '2');
  Product get _mangkukProduct =>
      MockData.products.firstWhere((p) => p.id == '3');

  @override
  Widget build(BuildContext context) {
    const tabs = ['Dikemas', 'Dikirim', 'Diterima'];

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          const SliverPinnedDcHeader(),
          SliverToBoxAdapter(
            child: Padding(
              // Padding bawah 120 agar tombol logout & teks versi leluasa
              // di atas navbar melayang (MainShell memakai extendBody: true).
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileBlock(),
                  const SizedBox(height: 28),
                  _buildOrderSectionHeader(),
                  const SizedBox(height: 12),
                  _buildSegmentedTabs(tabs),
                  const SizedBox(height: 14),
                  ..._buildOrderCards(context),
                  const SizedBox(height: 12),
                  _buildSeeAllButton(context),
                  const SizedBox(height: 28),
                  // Bagian bawah tetap memakai margin 24 seperti sebelumnya.
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAccountSection(context),
                        const SizedBox(height: 24),
                        _buildLogoutButton(context),
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 3),
                        Center(
                          child: Text(
                            'Sentra Keramik Dinoyo Malang • Jawa Timur',
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
    );
  }

  // ═══ Blok profil ════════════════════════════════════════════════════════
  Widget _buildProfileBlock() {
    return Column(
      children: [
        Center(
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              size: 44,
              color: AppColors.ink,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Center(
          child: Text(
            'Mochammad Al Mizan Ya Hafidl',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            '@mizanyf',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Center(
          child: OutlinedButton.icon(
            onPressed: () => context.push('/profile/edit'),
            icon: const Icon(
              Icons.person_outline_rounded,
              size: 16,
              color: AppColors.ink,
            ),
            label: Text(
              'Data Diri',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.white,
              side: const BorderSide(color: AppColors.ink),
              shape: const StadiumBorder(),
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
        Text(
          'Riwayat Pesanan',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: _lineGray),
          ),
          // Sesuai desain: selalu "1 Pesanan" di ketiga tab.
          child: Text(
            '1 Pesanan',
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
        color: AppColors.white,
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
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: i < tabs.length - 1 ? 9 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: tabs[i] == _orderTab ? _black : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: tabs[i] == _orderTab
                        ? const [
                            BoxShadow(
                              color: Color(0x0D000000),
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      tabs[i],
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color:
                            tabs[i] == _orderTab ? AppColors.white : _chipGray,
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
            price: 'Harga: Rp85.000',
            total: 'Total: Rp102.000',
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
            price: 'Harga: Rp75.000',
            total: 'Total: Rp90.000',
            leftLabel: 'Lihat Ulasan',
            onLeft: () => context.push('/reviews'),
            onBuyAgain: () => context.push('/product/3'),
          ),
        ],
      };

  // ═══ Kartu: DIKEMAS ═════════════════════════════════════════════════════
  Widget _dikemasCard() {
    return _cardShell(
      borderColor: _borderGray,
      radius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 17),
      children: [
        _cardHeader(
          id: '#DNC-001',
          store: 'Dinoyo Ceramic Studio',
          badge: 'Dikemas Penjual',
          fontSize: 11,
          storeColor: _textLight,
          badgeBorder: _borderGray,
        ),
        const SizedBox(height: 10),
        const Divider(height: 1, thickness: 1, color: _lineGray),
        const SizedBox(height: 11),
        _statusBox(
          title: 'Menyerahkan ke Pihak Jasa Kirim',
          dotColor: _dikemasYellow,
          note: 'Paket sedang dalam perjalanan untuk diserahkan\n'
              'ke Pihak Jasa Kirim',
          noteColor: _dikemasYellow,
        ),
        const SizedBox(height: 10),
        _simpleProductRow(
          product: _mangkukProduct,
          name: 'Mangkuk Keramik',
          qty: 'Jumlah: 1',
          price: 'Rp20.000',
          imageSize: 72,
          imageRadius: 8,
          gap: 16,
        ),
        const SizedBox(height: 10),
        _totalRow('Total (1 Produk):', 'Rp25.000', _lineGray),
      ],
    );
  }

  // ═══ Kartu: DIKIRIM ═════════════════════════════════════════════════════
  Widget _dikirimCard(BuildContext context) {
    return _cardShell(
      borderColor: _borderPink,
      radius: 12,
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 16),
      children: [
        _cardHeader(
          id: '#DNC-004',
          store: 'Karya Tanah',
          badge: 'Sedang Dikirim',
          fontSize: 12,
          storeColor: _textGray,
          badgeBorder: _borderGray,
        ),
        const SizedBox(height: 10),
        const Divider(height: 1, thickness: 1, color: _lineGray),
        const SizedBox(height: 16),
        _statusBox(
          title: 'J&T Express - Reguler',
          titleTrailing: 'JT92817294820',
          dotColor: _logoutRed,
          note: 'Paket sedang dalam perjalanan menuju kota\n'
              'Malang (Hub Sukun)',
          noteColor: _dikirimRed,
        ),
        const SizedBox(height: 16),
        _simpleProductRow(
          product: _cangkirProduct,
          name: 'Cangkir Handmade Artisan',
          qty: 'Jumlah: 2',
          price: 'Rp130.000',
          imageSize: 80,
          imageRadius: 8,
          gap: 8,
        ),
        const SizedBox(height: 10),
        _totalRow('Total (2 Produk):', 'Rp145.000', _dividerPink),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _actionButton(
                label: 'Lacak Resi',
                icon: Icons.local_shipping_outlined,
                bg: _btnLight,
                fg: _text,
                borderColor: _borderPink,
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
            const SizedBox(width: 9),
            Expanded(
              child: _actionButton(
                label: 'Hubungi Penjual',
                icon: Icons.chat_bubble_outline_rounded,
                bg: _black,
                fg: AppColors.white,
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
      borderColor: _lineGray,
      radius: 16,
      padding: const EdgeInsets.all(15),
      children: [
        _cardHeader(
          id: id,
          store: store,
          badge: 'Pesanan Selesai',
          fontSize: 12,
          storeColor: _textGray,
          badgeBorder: _lineGray,
          badgeFill: _badgeGray,
          showBullet: true,
        ),
        const SizedBox(height: 11),
        const Divider(height: 1, thickness: 1, color: _lineGray),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.check_circle_outline_rounded,
                size: 14, color: _textGray),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                deliveredText,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: _textGray,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 72,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _productImage(product, 72, 12),
              const SizedBox(width: 12),
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
                        const SizedBox(height: 2),
                        Text(
                          variant,
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
                          price,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: _priceGray,
                          ),
                        ),
                        Text(
                          total,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _text,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 1, color: _lineGray),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _actionButton(
                label: leftLabel,
                bg: AppColors.white,
                fg: _text,
                borderColor: _lineGray,
                bold: true,
                height: 36,
                onTap: onLeft,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _actionButton(
                label: 'Beli Lagi',
                bg: _black,
                fg: AppColors.white,
                bold: true,
                height: 36,
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
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor),
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
    Color badgeFill = Colors.white,
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
        const SizedBox(width: 8),
        if (showBullet) ...[
          Text(
            '•',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              color: _priceGray,
            ),
          ),
          const SizedBox(width: 6),
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
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: badgeFill,
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
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_shipping_outlined,
                  size: 14, color: _black),
              const SizedBox(width: 6),
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
          const SizedBox(height: 6),
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
              const SizedBox(width: 8),
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
          child: const Icon(Icons.image_outlined, color: AppColors.textMuted),
        ),
      ),
    );
  }

  /// Baris produk untuk tab Dikemas & Dikirim:
  /// nama + toko di atas, "Jumlah" (kiri) dan harga (kanan) di bawah.
  Widget _simpleProductRow({
    required Product product,
    required String name,
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
                      'Karya Tanah Keramik Dinoyo',
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
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: _textGray,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _black,
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
                  const SizedBox(width: 6),
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
      backgroundColor: Colors.white,
      barrierColor: const Color(0x73000000),
      shape: const RoundedRectangleBorder(
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
                    'Semua Pesanan',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    icon: const Icon(Icons.close_rounded, size: 20),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: _lineGray),
            Expanded(
              child: ListView(
                controller: scrollCtrl,
                padding: const EdgeInsets.all(16),
                children: [
                  _dikemasCard(),
                  const SizedBox(height: 12),
                  _dikirimCard(ctx),
                  const SizedBox(height: 12),
                  _diterimaCard(
                    id: '#DNC-001',
                    store: 'Dinoyo Ceramic Studio',
                    deliveredText:
                        'Diterima pada 12 Feb 2025 - Diterima oleh Penerima',
                    product: _vasProduct,
                    name: 'Vas Keramik Minimalis',
                    variant: 'Sand White Glossy • 1x',
                    price: 'Harga: Rp85.000',
                    total: 'Total: Rp102.000',
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
                    price: 'Harga: Rp75.000',
                    total: 'Total: Rp90.000',
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
    const dashed = _DashedRRectPainter(
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
                'Lihat Semua Pesanan',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right, size: 16, color: AppColors.ink),
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
          'Akun',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _accountTile(
                context,
                icon: Icons.person_outline_rounded,
                title: 'Data Diri',
                subtitle: 'Kelola informasi akun & profil',
                route: '/profile/edit',
              ),
              const Divider(height: 1, indent: 60, color: _lineGray),
              _accountTile(
                context,
                icon: Icons.location_on_outlined,
                title: 'Alamat Pengiriman',
                subtitle: 'Kelola alamat tujuan pesanan',
                route: '/addresses',
              ),
              const Divider(height: 1, indent: 60, color: _lineGray),
              _accountTile(
                context,
                icon: Icons.settings_outlined,
                title: 'Pengaturan',
                subtitle: 'Notifikasi, bahasa & privasi',
                route: '/settings',
              ),
              const Divider(height: 1, indent: 60, color: _lineGray),
              _accountTile(
                context,
                icon: Icons.help_outline_rounded,
                title: 'Bantuan',
                subtitle: 'Temukan jawaban yang Anda butuhkan',
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
            const SizedBox(width: 12),
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
                  const SizedBox(height: 1),
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
            const Icon(
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
        onPressed: () => context.go('/'),
        icon: const Icon(
          Icons.logout_rounded,
          size: 20,
          color: Colors.redAccent,
        ),
        label: Text(
          'Keluar dari Akun',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.redAccent,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.redAccent, width: 1.5),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          backgroundColor: Colors.white,
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