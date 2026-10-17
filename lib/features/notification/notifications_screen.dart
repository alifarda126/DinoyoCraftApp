import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// Menampilkan modal notifikasi sesuai desain Figma (Notif.dart)
/// Menggunakan useRootNavigator: true agar berada di atas navbar dan FAB
Future<void> showNotificationsModal(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Color(0x73000000),
    builder: (context) => NotificationsModalSheet(),
  );
}

class NotificationsScreen extends StatelessWidget {
const   NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x73000000),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.pop(),
                child: const SizedBox.expand(),
              ),
            ),
            NotificationsModalSheet(isFullPageFallback: true),
          ],
        ),
      ),
    );
  }
}

class NotificationsModalSheet extends StatefulWidget {
const   NotificationsModalSheet({super.key, this.isFullPageFallback = false});

  final bool isFullPageFallback;

  @override
  State<NotificationsModalSheet> createState() =>
      _NotificationsModalSheetState();
}

class _NotificationsModalSheetState extends State<NotificationsModalSheet> {
  String _selectedFilter = 'Semua';

  // ID notifikasi yang sudah dibaca (item 1 dan 2 belum dibaca, 3-5 sudah)
  final Set<String> _readIds = {'3', '4', '5'};

  static const Color _black = Color(0xFF000000);
  static const Color _textDark = Color(0xFF1A1C1C);
  static const Color _textGray = Color(0xFF5F5E5E);
  static const Color _textDesc = Color(0xFF4C4546);
  static const Color _cardBgUnread = Color(0xB0F4F3F3);
  static const Color _cardBgRead = Color(0xFFFFFFFF);
  static const Color _borderRead = Color(0xFFEEEEEE);
  static const Color _chipInactiveBg = Color(0xFFF4F3F3);
  static const Color _chipInactiveBorder = Color(0xFFCFC4C5);
  static const Color _handleBarColor = Color(0xFFCFC4C5);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenH = mediaQuery.size.height;
    final bottomPad = mediaQuery.padding.bottom;

    // Tinggi tetap (fixed) konsisten seperti tampilan awal:
    // Muat pas sekitar 3 kartu notifikasi pertama dan tidak menyusut/turun saat filter ditekan.
    final modalH = (screenH * 0.64).clamp(510.0, 600.0) + bottomPad;

    return Container(
      height: modalH,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 40,
            offset: Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Handle Bar ───────────────────────────────────────────────
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 14, bottom: 16),
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
                color: _handleBarColor,
              ),
            ),
          ),

          // ── Header: Judul + Badge + Tombol Close (X) ─────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Notifikasi',
                      style: GoogleFonts.plusJakartaSans(
                        color: _textDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2.5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9999),
                        color: _black,
                      ),
                      child: Text(
                        '3 Baru',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF4F3F3),
                      border: Border.all(
                        color: Color(0xFFE5E5E5),
                        width: 0.8,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: _textDark,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // ── Filter Chips: Semua, Transaksi & Pesanan, Info Akun ───────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildFilterChip('Semua'),
                SizedBox(width: 8),
                _buildFilterChip('Transaksi & Pesanan'),
                SizedBox(width: 8),
                _buildFilterChip('Info Akun'),
              ],
            ),
          ),

          SizedBox(height: 16),

          // ── Daftar Kartu Notifikasi (Expanded + Scrollable) ───────────
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + bottomPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kartu 1: Voucher Diskon
                  if (_shouldShow('Transaksi & Pesanan')) ...[
                    _buildVoucherCard(context),
                    SizedBox(height: 12),
                  ],

                  // Kartu 2: Jadwal Workshop
                  if (_shouldShow('Info Akun')) ...[
                    _buildWorkshopCard(context),
                    SizedBox(height: 12),
                  ],

                  // Kartu 3: Pembayaran Dikonfirmasi
                  if (_shouldShow('Transaksi & Pesanan')) ...[
                    GestureDetector(
                      onTap: () => _openNotificationTarget('3', '/profile'),
                      child: _buildPaymentCard(),
                    ),
                    SizedBox(height: 12),
                  ],

                  // Kartu 4: Status Pesanan Dikemas (terlihat saat discroll)
                  if (_shouldShow('Transaksi & Pesanan')) ...[
                    GestureDetector(
                      onTap: () => _openNotificationTarget('4', '/profile'),
                      child: _buildOrderPackedCard(),
                    ),
                    SizedBox(height: 12),
                  ],

                  // Kartu 5: Info Keamanan Akun (terlihat saat discroll)
                  if (_shouldShow('Info Akun')) ...[
                    GestureDetector(
                      onTap: () => _openNotificationTarget('5', '/settings'),
                      child: _buildAccountSecurityCard(),
                    ),
                    SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShow(String category) {
    if (_selectedFilter == 'Semua') return true;
    return _selectedFilter == category;
  }

  /// Tandai kartu sudah dibaca, tutup modal, lalu buka halaman terkait.
  void _openNotificationTarget(String readId, String route) {
    final router = GoRouter.of(context);
    setState(() => _readIds.add(readId));
    Navigator.of(context).pop();
    router.push(route);
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9999),
          color: isSelected ? _black : _chipInactiveBg,
          border: Border.all(
            color: isSelected ? _black : _chipInactiveBorder,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : _textDark,
          ),
        ),
      ),
    );
  }

  // ── Kartu 1: Voucher Diskon Keramik 15% ──────────────────────────────────
  Widget _buildVoucherCard(BuildContext context) {
    final isUnread = !_readIds.contains('1');

    return Container(
      decoration: BoxDecoration(
        color: isUnread ? _cardBgUnread : _cardBgRead,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnread ? _black : _borderRead,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFE5E5E5)),
            ),
            child: Icon(
              Icons.local_offer_outlined,
              size: 20,
              color: _textDark,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DISKON PENGRAJIN',
                      style: GoogleFonts.plusJakartaSans(
                        color: _textGray,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '2 jam lalu',
                          style: GoogleFonts.plusJakartaSans(
                            color: _textGray,
                            fontSize: 12,
                          ),
                        ),
                        if (isUnread) ...[
                          SizedBox(width: 7),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _black,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 3),
                Text(
                  'Voucher Diskon Keramik 15%',
                  style: GoogleFonts.plusJakartaSans(
                    color: _textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Gunakan kode '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFCFC4C5),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                            color: Color(0xFFEEEEEE),
                          ),
                          child: Text(
                            'DINOYOKARYA',
                            style: GoogleFonts.plusJakartaSans(
                              color: _black,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                      TextSpan(
                        text:
                            ' untuk potongan belanja produk tembikar buatan pengrajin Dinoyo.',
                      ),
                    ],
                  ),
                  style: GoogleFonts.plusJakartaSans(
                    color: _textDesc,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: 'DINOYOKARYA'),
                    );
                    setState(() => _readIds.add('1'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Kode voucher DINOYOKARYA berhasil disalin!',
                          style: GoogleFonts.plusJakartaSans(),
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Salin Voucher',
                        style: GoogleFonts.plusJakartaSans(
                          color: _black,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.copy_rounded,
                        size: 13,
                        color: _black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Kartu 2: Jadwal Workshop Pembuatan Keramik ──────────────────────────
  Widget _buildWorkshopCard(BuildContext context) {
    final isUnread = !_readIds.contains('2');

    return Container(
      decoration: BoxDecoration(
        color: isUnread ? _cardBgUnread : _cardBgRead,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnread ? _black : _borderRead,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFE5E5E5)),
            ),
            child: Icon(
              Icons.calendar_today_outlined,
              size: 20,
              color: _textDark,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'WISATA KREATIF',
                      style: GoogleFonts.plusJakartaSans(
                        color: _textGray,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Kemarin, 14:20',
                          style: GoogleFonts.plusJakartaSans(
                            color: _textGray,
                            fontSize: 12,
                          ),
                        ),
                        if (isUnread) ...[
                          SizedBox(width: 7),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _black,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 3),
                Text(
                  'Jadwal Workshop Pembuatan Keramik',
                  style: GoogleFonts.plusJakartaSans(
                    color: _textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Kelas seni putar tanah liat akhir pekan ini di Studio Dinoyo dibuka. Kuota tersisa 3 orang!',
                  style: GoogleFonts.plusJakartaSans(
                    color: _textDesc,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    setState(() => _readIds.add('2'));
                    Navigator.of(context).pop();
                    context.go('/workshop');
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Lihat Detail Workshop',
                        style: GoogleFonts.plusJakartaSans(
                          color: _black,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: _black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Kartu 3: Pembayaran Dikonfirmasi ────────────────────────────────────
  Widget _buildPaymentCard() {
    return Container(
      decoration: BoxDecoration(
        color: _cardBgRead,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _borderRead,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFEEEEEE)),
            ),
            child: Icon(
              Icons.check_circle_outline_rounded,
              size: 22,
              color: _textGray,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PEMBAYARAN',
                      style: GoogleFonts.plusJakartaSans(
                        color: _textGray,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '2 hari lalu',
                      style: GoogleFonts.plusJakartaSans(
                        color: _textGray,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3),
                Text(
                  'Pembayaran Dikonfirmasi',
                  style: GoogleFonts.plusJakartaSans(
                    color: _textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Pembayaran via GoPay untuk pesanan Cangkir Speckle sebesar Rp70.000 telah berhasil diverifikasi.',
                  style: GoogleFonts.plusJakartaSans(
                    color: _textDesc,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Kartu 4: Status Pesanan Dikemas ──────────────────────────────────────
  Widget _buildOrderPackedCard() {
    return Container(
      decoration: BoxDecoration(
        color: _cardBgRead,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _borderRead,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFEEEEEE)),
            ),
            child: Icon(
              Icons.local_shipping_outlined,
              size: 22,
              color: _textGray,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'STATUS PESANAN',
                      style: GoogleFonts.plusJakartaSans(
                        color: _textGray,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '3 hari lalu',
                      style: GoogleFonts.plusJakartaSans(
                        color: _textGray,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3),
                Text(
                  'Pesanan Sedang Dikemas',
                  style: GoogleFonts.plusJakartaSans(
                    color: _textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Penjual Dinoyo Ceramic Studio sedang menyiapkan pesanan #DNC-001 milikmu.',
                  style: GoogleFonts.plusJakartaSans(
                    color: _textDesc,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Kartu 5: Info Keamanan Akun ──────────────────────────────────────────
  Widget _buildAccountSecurityCard() {
    return Container(
      decoration: BoxDecoration(
        color: _cardBgRead,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _borderRead,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFEEEEEE)),
            ),
            child: Icon(
              Icons.shield_outlined,
              size: 22,
              color: _textGray,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'KEAMANAN AKUN',
                      style: GoogleFonts.plusJakartaSans(
                        color: _textGray,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '5 hari lalu',
                      style: GoogleFonts.plusJakartaSans(
                        color: _textGray,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3),
                Text(
                  'Masuk dari Perangkat Baru',
                  style: GoogleFonts.plusJakartaSans(
                    color: _textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Akun @customer terdeteksi masuk dari perangkat baru pada 12 Feb 2025.',
                  style: GoogleFonts.plusJakartaSans(
                    color: _textDesc,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
