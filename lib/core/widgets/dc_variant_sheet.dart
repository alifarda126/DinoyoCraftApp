import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

// ─── Model ───────────────────────────────────────────────────────────────────
class VariantOption {
const   VariantOption({required this.label, this.imagePath});

  final String label;
  final String? imagePath;
}

// ─── Fungsi helper untuk membuka sheet ───────────────────────────────────────
/// Panggil ini dari product_detail_page atau product_card saat tombol "+"/"Keranjang" diklik.
///
/// Contoh:
/// ```dart
/// DcVariantSheet.show(
///   context,
///   productName: 'Cangkir Handmade',
///   productImagePath: AppAssets.productCangkir,
///   price: 75000,
///   variants: ['S', 'M', 'L'],
///   onAddToCart: (variant, qty) { ... },
/// );
/// ```
class DcVariantSheet extends StatefulWidget {
const   DcVariantSheet({
    super.key,
    required this.productName,
    required this.productImagePath,
    required this.price,
    required this.variants,
    required this.onAddToCart,
  });

  final String productName;
  final String productImagePath;
  final int price;
  final List<String> variants;
  final void Function(String variant, int qty) onAddToCart;

  static Future<void> show(
    BuildContext context, {
    required String productName,
    required String productImagePath,
    required int price,
    required List<String> variants,
    required void Function(String variant, int qty) onAddToCart,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        expand: false,
        builder: (_, controller) => DcVariantSheet(
          productName: productName,
          productImagePath: productImagePath,
          price: price,
          variants: variants,
          onAddToCart: onAddToCart,
        ),
      ),
    );
  }

  @override
  State<DcVariantSheet> createState() => _DcVariantSheetState();
}

class _DcVariantSheetState extends State<DcVariantSheet> {
  String? _selectedVariant;
  int _qty = 1;

  String _formatPrice(int price) {
    final formatted = price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return 'Rp$formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusSheet),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 40,
            offset: Offset(0, -12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
            child: Container(
              width: 48,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.pageHorizontal,
                0,
                AppDimensions.pageHorizontal,
                AppDimensions.paddingXL,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Product preview ────────────────────────────────
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                        child: Image.asset(
                          widget.productImagePath,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => ColoredBox(
                            color: AppColors.inputBg,
                            child: SizedBox(width: 80, height: 80),
                          ),
                        ),
                      ),
                      SizedBox(width: AppDimensions.paddingL),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedVariant != null
                                  ? _formatPrice(widget.price)
                                  : 'Pilih variasi dulu',
                              style: AppTextStyles.price,
                            ),
                            SizedBox(height: 4),
                            Text(widget.productName, style: AppTextStyles.bodySmall),
                            if (_selectedVariant != null)
                              Text(
                                'Variasi: $_selectedVariant',
                                style: AppTextStyles.caption,
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  Divider(height: 28, color: AppColors.border),

                  // ── Pilih Variasi ──────────────────────────────────
                  Text('Pilih Variasi', style: AppTextStyles.cardTitle),
                  SizedBox(height: AppDimensions.gapM),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.variants.map((v) {
                      final isSelected = v == _selectedVariant;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedVariant = v),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingL,
                            vertical: AppDimensions.paddingS,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.black : AppColors.inputBg,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                            border: Border.all(
                              color: isSelected ? AppColors.black : AppColors.border,
                            ),
                          ),
                          child: Text(
                            v,
                            style: AppTextStyles.fieldLabel.copyWith(
                              color: isSelected ? AppColors.white : AppColors.ink,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: AppDimensions.paddingXL),

                  // ── Jumlah ─────────────────────────────────────────
                  Row(
                    children: [
                      Text('Jumlah', style: AppTextStyles.cardTitle),
                      Spacer(),
                      _QtyCounter(
                        qty: _qty,
                        onDecrement: () {
                          if (_qty > 1) setState(() => _qty--);
                        },
                        onIncrement: () => setState(() => _qty++),
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.paddingXXL),

                  // ── Add to Cart Button ─────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: AppDimensions.buttonHeight,
                    child: ElevatedButton(
                      onPressed: _selectedVariant == null
                          ? null
                          : () {
                              widget.onAddToCart(_selectedVariant!, _qty);
                              Navigator.of(context).pop();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.black,
                        disabledBackgroundColor: AppColors.textMuted,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: StadiumBorder(),
                      ),
                      child: Text(
                        'Tambah ke Keranjang',
                        style: AppTextStyles.buttonLabel,
                      ),
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
}

// ─── Qty Counter Widget ───────────────────────────────────────────────────────
class _QtyCounter extends StatelessWidget {
  const _QtyCounter({
    required this.qty,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int qty;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QtyBtn(icon: Icons.remove, onTap: onDecrement),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            qty.toString(),
            style: AppTextStyles.subTitle,
          ),
        ),
        _QtyBtn(icon: Icons.add, onTap: onIncrement),
      ],
    );
  }
}

class _QtyBtn extends StatelessWidget {
  const _QtyBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.inputBg,
      shape: CircleBorder(),
      child: InkWell(
        customBorder: CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, size: 18, color: AppColors.ink),
        ),
      ),
    );
  }
}
