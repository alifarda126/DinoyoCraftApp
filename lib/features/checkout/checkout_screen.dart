import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/dc_button.dart';
import '../../data/mock_data.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _shipping = 'Regular';
  String _payment = 'QRIS';
  final TextEditingController _noteCtrl = TextEditingController();

  // Local mutable cart quantities
  late final List<int> _qtys;

  @override
  void initState() {
    super.initState();
    _qtys = MockData.mockCart.map((item) => item.qty).toList();
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  int get _subtotal {
    int total = 0;
    for (var i = 0; i < MockData.mockCart.length; i++) {
      total += MockData.mockCart[i].product.price * _qtys[i];
    }
    return total;
  }

  int get _shippingFee {
    switch (_shipping) {
      case 'Hemat':
        return 10000;
      case 'Express':
        return 25000;
      default: // Regular
        return 15000;
    }
  }

  static const int _serviceFee = 2000;

  int get _total => _subtotal + _shippingFee + _serviceFee;

  Future<void> _pay() async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Pembayaran berhasil',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
        content: Text(
          'Metode $_payment · Total ${MockData.formatPrice(_total)}\n'
          'Ini simulasi MVP — belum terhubung gateway nyata.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/home');
            },
            child: Text(
              'Kembali ke Beranda',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: Text(
          'Checkout',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
          icon: SvgPicture.asset(
            AppAssets.iconBack,
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(AppColors.ink, BlendMode.srcIn),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.help_outline_rounded,
              color: AppColors.ink,
              size: 22,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                // ─── Alamat Pengiriman ──────────────────────────────────
                _SectionHeader(
                  icon: Icons.location_on_outlined,
                  title: 'Alamat Pengiriman',
                  trailing: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(40, 28),
                    ),
                    child: Text(
                      'Mode Kosong',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Customer',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.black,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'UTAMA',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit_outlined,
                              size: 13,
                              color: AppColors.textSecondary,
                            ),
                            label: Text(
                              'Ubah Alamat',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 28),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.phone_outlined,
                            size: 13,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '0812-3456-7890',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Jl. Veteran No.1, RT/RW. 04/02, Kel. Ketawanggede, Kec. Lowokwaru, Kota Malang, Jawa Timur 65145',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                height: 1.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.add,
                          size: 14,
                          color: AppColors.ink,
                        ),
                        label: Text(
                          'Tambah Alamat Baru',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColors.border,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ─── Produk yang Dibeli ─────────────────────────────────
                _SectionHeader(
                  icon: Icons.shopping_bag_outlined,
                  title:
                      'Produk yang Dibeli (${_qtys.fold(0, (s, q) => s + q)})',
                  trailing: Text(
                    '${MockData.mockCart.length} Penjual Terpilih',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                ...List.generate(MockData.mockCart.length, (i) {
                  final item = MockData.mockCart[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _Card(
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              item.product.image,
                              width: 68,
                              height: 68,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => Container(
                                width: 68,
                                height: 68,
                                color: AppColors.inputBg,
                                child: const Icon(
                                  Icons.image_outlined,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.store_outlined,
                                      size: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 3),
                                    Expanded(
                                      child: Text(
                                        item.product.studio,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  MockData.formatPrice(
                                    item.product.price * _qtys[i],
                                  ),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Qty controls
                          Row(
                            children: [
                              _QtyBtn(
                                icon: Icons.remove,
                                onTap: _qtys[i] > 1
                                    ? () => setState(() => _qtys[i]--)
                                    : null,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Text(
                                  '${_qtys[i]}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ),
                              _QtyBtn(
                                icon: Icons.add,
                                onTap: () => setState(() => _qtys[i]++),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 6),

                // ─── Metode Pengiriman ──────────────────────────────────
                _SectionHeader(
                  icon: Icons.local_shipping_outlined,
                  title: 'Metode Pengiriman',
                ),
                _ShippingTile(
                  title: 'Reguler',
                  subtitle: 'Estimasi 2–4 hari kerja',
                  price: 'Rp15.000',
                  selected: _shipping == 'Regular',
                  onTap: () => setState(() => _shipping = 'Regular'),
                ),
                _ShippingTile(
                  title: 'Hemat',
                  subtitle: 'Estimasi 4–7 hari kerja',
                  price: 'Rp10.000',
                  selected: _shipping == 'Hemat',
                  onTap: () => setState(() => _shipping = 'Hemat'),
                ),
                _ShippingTile(
                  title: 'Express',
                  subtitle: 'Estimasi 1–2 hari kerja (Prioritas)',
                  price: 'Rp25.000',
                  selected: _shipping == 'Express',
                  onTap: () => setState(() => _shipping = 'Express'),
                ),
                const SizedBox(height: 16),

                // ─── Metode Pembayaran ──────────────────────────────────
                _SectionHeader(
                  icon: Icons.payment_outlined,
                  title: 'Metode Pembayaran',
                ),
                _PaymentCard(
                  id: 'QRIS',
                  title: 'QRIS Instant',
                  subtitle:
                      'Bayar instan bebas biaya admin dengan scan kode QRIS.',
                  badge: 'DIREKOMENDASIKAN',
                  tags: const ['QRIS', 'GoPay', 'OVO', 'ShopeePay', 'BCA'],
                  selected: _payment == 'QRIS',
                  onTap: () => setState(() => _payment = 'QRIS'),
                ),
                const SizedBox(height: 8),
                _PaymentCard(
                  id: 'VA',
                  title: 'Virtual Account',
                  subtitle:
                      'Verifikasi otomatis 24 jam tanpa perlu bukti transfer.',
                  tags: const ['BCA', 'Mandiri', 'BRI', 'BNI 46'],
                  selected: _payment == 'VA',
                  onTap: () => setState(() => _payment = 'VA'),
                ),
                const SizedBox(height: 8),
                _PaymentCard(
                  id: 'E-Wallet',
                  title: 'E-Wallet',
                  subtitle:
                      'Terhubung langsung ke akun dompet digital favorit kamu.',
                  tags: const ['ShopeePay', 'GoPay', 'OVO', 'DANA'],
                  selected: _payment == 'E-Wallet',
                  onTap: () => setState(() => _payment = 'E-Wallet'),
                ),
                const SizedBox(height: 16),

                // ─── Catatan untuk Penjual ──────────────────────────────
                _SectionHeader(
                  icon: Icons.notes_rounded,
                  title: 'Catatan untuk Penjual (Opsional)',
                ),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.inputBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TextField(
                    controller: _noteCtrl,
                    maxLines: 3,
                    minLines: 2,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppColors.ink,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Contoh: Tolong bungkus dengan bubble wrap tebal dan kardus aman.',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ─── Ringkasan Pembayaran ───────────────────────────────
                Text(
                  'Ringkasan Pembayaran',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 12),
                _RowLine('Subtotal Produk', MockData.formatPrice(_subtotal)),
                _RowLine(
                  'Biaya Pengiriman (${_shippingLabel()})',
                  MockData.formatPrice(_shippingFee),
                ),
                _RowLine('Biaya Layanan', MockData.formatPrice(_serviceFee)),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1, color: AppColors.border),
                ),
                _RowLine(
                  'Total Pembayaran',
                  MockData.formatPrice(_total),
                  bold: true,
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // ─── Sticky footer ─────────────────────────────────────────────
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Total bayar',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            MockData.formatPrice(_total),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DcButton(label: 'Bayar Sekarang', onPressed: _pay),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _shippingLabel() {
    switch (_shipping) {
      case 'Hemat':
        return 'Hemat';
      case 'Express':
        return 'Express';
      default:
        return 'Reguler';
    }
  }
}

// ─── Section header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.ink),
          const SizedBox(width: 6),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          if (trailing != null) ...[const Spacer(), trailing!],
        ],
      ),
    );
  }
}

// ─── White card ───────────────────────────────────────────────────────────────
class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: child,
    );
  }
}

// ─── Qty button ───────────────────────────────────────────────────────────────
class _QtyBtn extends StatelessWidget {
  const _QtyBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(
            color: onTap == null ? AppColors.border : AppColors.ink,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 14,
          color: onTap == null ? AppColors.textMuted : AppColors.ink,
        ),
      ),
    );
  }
}

// ─── Shipping tile ────────────────────────────────────────────────────────────
class _ShippingTile extends StatelessWidget {
  const _ShippingTile({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String price;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.black : const Color(0xFFEEEEEE),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 20,
                color: selected ? AppColors.black : AppColors.textMuted,
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
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                price,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Payment card ─────────────────────────────────────────────────────────────
class _PaymentCard extends StatelessWidget {
  const _PaymentCard({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.tags,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  final String id;
  final String title;
  final String subtitle;
  final List<String> tags;
  final bool selected;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.black : const Color(0xFFEEEEEE),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  size: 20,
                  color: selected ? AppColors.black : AppColors.textMuted,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                if (badge != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      badge!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: AppColors.textMuted,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 4),
              child: Text(
                subtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  height: 1.4,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.inputBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Row line ─────────────────────────────────────────────────────────────────
class _RowLine extends StatelessWidget {
  const _RowLine(this.label, this.value, {this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.plusJakartaSans(
      fontSize: bold ? 15 : 13,
      fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
      color: AppColors.ink,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
}
