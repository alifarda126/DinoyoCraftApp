import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../payment_screen.dart';

import '../../../../core/widgets/dc_button.dart';
import '../../../../data/mock_data.dart';

class CheckoutScreen extends StatefulWidget {
const   CheckoutScreen({super.key});

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
    final now = DateTime.now();
    final args = PaymentArgs(
      orderId:
          'DC-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${1000 + (now.millisecondsSinceEpoch % 9000)}',
      items: List<CartItem>.from(MockData.mockCart),
      qtys: List<int>.from(_qtys),
      subtotal: _subtotal,
      shippingFee: _shippingFee,
      serviceFee: _serviceFee,
      total: _total,
      paymentMethod: _payment,
      shippingMethod: _shipping,
      recipientName: 'Customer',
      recipientPhone: '0859-777-588-138',
      recipientAddress:
          'Jl. Sawiji Sari No.14, Kel. Mulyorejo, Kec. Sukun, Kota Malang, Jawa Timur 65147',
      note: _noteCtrl.text.trim().isNotEmpty ? _noteCtrl.text.trim() : null,
    );

    try {
      context.push('/checkout/payment', extra: args);
    } catch (_) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => PaymentScreen(args: args),
        ),
      );
    }
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
            colorFilter: ColorFilter.mode(AppColors.ink, BlendMode.srcIn),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
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
                // â”€â”€â”€ Alamat Pengiriman â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                _SectionHeader(
                  icon: Icons.location_on_outlined,
                  title: 'Alamat Pengiriman',
                  trailing: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(40, 28),
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
                          SizedBox(width: 8),
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
                          Spacer(),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(
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
                              minimumSize: Size(0, 28),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 13,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '0812-3456-7890',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 4),
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
                      SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(
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
                          side: BorderSide(
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
                SizedBox(height: 16),

                // â”€â”€â”€ Produk yang Dibeli â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
                                child: Icon(
                                  Icons.image_outlined,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
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
                                SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.store_outlined,
                                      size: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                    SizedBox(width: 3),
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
                                SizedBox(height: 6),
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
                SizedBox(height: 6),

                // â”€â”€â”€ Metode Pengiriman â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                _SectionHeader(
                  icon: Icons.local_shipping_outlined,
                  title: 'Metode Pengiriman',
                ),
                _ShippingTile(
                  title: 'Reguler',
                  subtitle: 'Estimasi 2â€“4 hari kerja',
                  price: 'Rp15.000',
                  selected: _shipping == 'Regular',
                  onTap: () => setState(() => _shipping = 'Regular'),
                ),
                _ShippingTile(
                  title: 'Hemat',
                  subtitle: 'Estimasi 4â€“7 hari kerja',
                  price: 'Rp10.000',
                  selected: _shipping == 'Hemat',
                  onTap: () => setState(() => _shipping = 'Hemat'),
                ),
                _ShippingTile(
                  title: 'Express',
                  subtitle: 'Estimasi 1â€“2 hari kerja (Prioritas)',
                  price: 'Rp25.000',
                  selected: _shipping == 'Express',
                  onTap: () => setState(() => _shipping = 'Express'),
                ),
                SizedBox(height: 16),

                // â”€â”€â”€ Metode Pembayaran â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
                  tags: ['QRIS', 'GoPay', 'OVO', 'ShopeePay', 'BCA'],
                  selected: _payment == 'QRIS',
                  onTap: () => setState(() => _payment = 'QRIS'),
                ),
                SizedBox(height: 8),
                _PaymentCard(
                  id: 'VA',
                  title: 'Virtual Account',
                  subtitle:
                      'Verifikasi otomatis 24 jam tanpa perlu bukti transfer.',
                  tags: ['BCA', 'Mandiri', 'BRI', 'BNI 46'],
                  selected: _payment == 'VA',
                  onTap: () => setState(() => _payment = 'VA'),
                ),
                SizedBox(height: 8),
                _PaymentCard(
                  id: 'E-Wallet',
                  title: 'E-Wallet',
                  subtitle:
                      'Terhubung langsung ke akun dompet digital favorit kamu.',
                  tags: ['ShopeePay', 'GoPay', 'OVO', 'DANA'],
                  selected: _payment == 'E-Wallet',
                  onTap: () => setState(() => _payment = 'E-Wallet'),
                ),
                SizedBox(height: 16),

                // â”€â”€â”€ Catatan untuk Penjual â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
                SizedBox(height: 16),

                // â”€â”€â”€ Ringkasan Pembayaran â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                Text(
                  'Ringkasan Pembayaran',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 12),
                _RowLine('Subtotal Produk', MockData.formatPrice(_subtotal)),
                _RowLine(
                  'Biaya Pengiriman (${_shippingLabel()})',
                  MockData.formatPrice(_shippingFee),
                ),
                _RowLine('Biaya Layanan', MockData.formatPrice(_serviceFee)),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1, color: AppColors.border),
                ),
                _RowLine(
                  'Total Pembayaran',
                  MockData.formatPrice(_total),
                  bold: true,
                ),
                SizedBox(height: 12),
              ],
            ),
          ),

          // â”€â”€â”€ Sticky footer â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: Offset(0, -4),
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
                          SizedBox(height: 2),
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
                    SizedBox(width: 12),
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

// â”€â”€â”€ Section header â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
          SizedBox(width: 6),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          if (trailing != null) ...[Spacer(), trailing!],
        ],
      ),
    );
  }
}

// â”€â”€â”€ White card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
        border: Border.all(color: Color(0xFFEEEEEE)),
      ),
      child: child,
    );
  }
}

// â”€â”€â”€ Qty button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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

// â”€â”€â”€ Shipping tile â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
    final isDark =
        Theme.of(context).brightness == Brightness.dark || AppColors.isDark;
    final selectedBorderColor = isDark ? Colors.white : AppColors.black;
    final selectedRadioColor = isDark ? Colors.white : AppColors.black;
    final backgroundColor = selected
        ? (isDark ? const Color(0xFF282828) : AppColors.surface)
        : AppColors.surface;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? selectedBorderColor : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
            boxShadow: (selected && isDark)
                ? [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.08),
                      blurRadius: 8,
                      spreadRadius: 0.5,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 20,
                color: selected ? selectedRadioColor : AppColors.textMuted,
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

// â”€â”€â”€ Payment card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
    final isDark =
        Theme.of(context).brightness == Brightness.dark || AppColors.isDark;
    final selectedBorderColor = isDark ? Colors.white : AppColors.black;
    final selectedRadioColor = isDark ? Colors.white : AppColors.black;
    final backgroundColor = selected
        ? (isDark ? const Color(0xFF282828) : AppColors.surface)
        : AppColors.surface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? selectedBorderColor : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
          boxShadow: (selected && isDark)
              ? [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.08),
                    blurRadius: 8,
                    spreadRadius: 0.5,
                  ),
                ]
              : null,
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
                  color: selected ? selectedRadioColor : AppColors.textMuted,
                ),
                SizedBox(width: 10),
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                if (badge != null) ...[
                  SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF333333) : AppColors.black,
                      borderRadius: BorderRadius.circular(4),
                      border: isDark
                          ? Border.all(color: Colors.white.withValues(alpha: 0.25))
                          : null,
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
                Spacer(),
                Icon(
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
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: tags.map((tag) => _BrandChip(tag)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Chip merek pembayaran (QRIS, GoPay, OVO, ...) ────────────────────────────
class _BrandChip extends StatelessWidget {
  const _BrandChip(this.tag);
  final String tag;

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark || AppColors.isDark;

    Widget content;
    switch (tag) {
      case 'QRIS':
        content = SvgPicture.asset(
          AppAssets.paymentQris,
          height: 12,
          fit: BoxFit.contain,
        );
        break;
      case 'BCA':
        content = SvgPicture.asset(
          AppAssets.paymentBca,
          height: 12,
          fit: BoxFit.contain,
        );
        break;
      case 'BNI':
      case 'BNI 46':
        content = SvgPicture.asset(
          AppAssets.paymentBni,
          height: 12,
          fit: BoxFit.contain,
        );
        break;
      case 'BRI':
        content = SvgPicture.asset(
          AppAssets.paymentBri,
          height: 14,
          fit: BoxFit.contain,
        );
        break;
      case 'Mandiri':
        content = SvgPicture.asset(
          AppAssets.paymentMandiri,
          height: 12,
          fit: BoxFit.contain,
        );
        break;
      case 'GoPay':
        content = SvgPicture.asset(
          AppAssets.paymentGopay,
          height: 10,
          fit: BoxFit.contain,
        );
        break;
      case 'OVO':
        content = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppAssets.paymentOvo,
              height: 12,
              width: 12,
            ),
            const SizedBox(width: 4),
            Text(
              'OVO',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF4C2A86),
              ),
            ),
          ],
        );
        break;
      case 'ShopeePay':
        content = SvgPicture.asset(
          AppAssets.paymentShopeepay,
          height: 13,
          fit: BoxFit.contain,
        );
        break;
      case 'DANA':
        content = SvgPicture.asset(
          AppAssets.paymentDana,
          height: 11,
          fit: BoxFit.contain,
        );
        break;
      default:
        content = Text(
          tag,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.ink,
          ),
        );
    }

    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark ? const Color(0xFF383838) : const Color(0xFFE2E8F0),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          content,
        ],
      ),
    );
  }
}

// â”€â”€â”€ Row line â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
