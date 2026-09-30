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

  int get _subtotal => MockData.mockCart
      .fold(0, (sum, item) => sum + item.product.price * item.qty);

  int get _shippingFee {
    switch (_shipping) {
      case 'Hemat':
        return 8000;
      case 'Express':
        return 25000;
      default:
        return 15000;
    }
  }

  int get _total => _subtotal + _shippingFee;

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
      appBar: AppBar(
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
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                _SectionTitle('Alamat Pengiriman'),
                _Card(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 22,
                        color: AppColors.ink,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Mochammad Al Hizyan Yaikaful\n'
                          'Jl. Soekarno Hatta No. 10, Lowokwaru, Malang\n'
                          '6281234567890',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            height: 1.5,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _SectionTitle('Pesanan'),
                ...MockData.mockCart.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _Card(
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              item.product.image,
                              width: 68,
                              height: 68,
                              fit: BoxFit.cover,
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
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${item.product.studio} · x${item.qty}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  MockData.formatPrice(
                                    item.product.price * item.qty,
                                  ),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                _SectionTitle('Pengiriman'),
                _OptionTile(
                  title: 'Regular',
                  subtitle: '2–3 hari · ${MockData.formatPrice(15000)}',
                  selected: _shipping == 'Regular',
                  onTap: () => setState(() => _shipping = 'Regular'),
                ),
                _OptionTile(
                  title: 'Hemat',
                  subtitle: '4–6 hari · ${MockData.formatPrice(8000)}',
                  selected: _shipping == 'Hemat',
                  onTap: () => setState(() => _shipping = 'Hemat'),
                ),
                _OptionTile(
                  title: 'Express',
                  subtitle: '1 hari · ${MockData.formatPrice(25000)}',
                  selected: _shipping == 'Express',
                  onTap: () => setState(() => _shipping = 'Express'),
                ),
                const SizedBox(height: 16),
                _SectionTitle('Pembayaran'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['QRIS', 'VA', 'E-Wallet'].map((opt) {
                    final selected = _payment == opt;
                    return InkWell(
                      onTap: () => setState(() => _payment = opt),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.black : AppColors.inputBg,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: selected
                                ? AppColors.black
                                : AppColors.border.withValues(alpha: 0.6),
                          ),
                        ),
                        child: Text(
                          opt,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selected ? AppColors.white : AppColors.ink,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                _SectionTitle('Rincian Biaya'),
                _Card(
                  child: Column(
                    children: [
                      _RowLine('Subtotal', MockData.formatPrice(_subtotal)),
                      _RowLine(
                        'Ongkir ($_shipping)',
                        MockData.formatPrice(_shippingFee),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(height: 1, color: AppColors.border),
                      ),
                      _RowLine(
                        'Total',
                        MockData.formatPrice(_total),
                        bold: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                      child: DcButton(
                        label: 'Bayar Sekarang',
                        onPressed: _pay,
                      ),
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
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.black.withValues(alpha: 0.06)
                : AppColors.inputBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.black : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
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
                    const SizedBox(height: 2),
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
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                size: 20,
                color: selected ? AppColors.black : AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
    );
  }
}

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
