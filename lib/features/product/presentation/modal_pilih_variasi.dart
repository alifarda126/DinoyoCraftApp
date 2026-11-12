import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_text.dart';
import '../../../core/assets.dart';
import '../../../core/network/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/cart_fly_animation.dart';
import '../../../core/widgets/dc_cached_image.dart';
import '../../../core/widgets/image_preview_dialog.dart';
import '../../../data/mock_data.dart';

/// Tipe aksi yang memicu modal.
enum ModalVariasiMode { keranjang, beliLangsung, keduanya }

/// Tampilkan modal pilih variasi & jumlah produk sebagai bottom sheet.
Future<void> showModalPilihVariasi(
  BuildContext context, {
  required Product product,
  required ModalVariasiMode mode,
}) {
  return showModalBottomSheet(
    context: context,
    // Root navigator agar modal tampil di atas bottom navbar (seperti
    // modal Notifikasi, Keranjang, dan Semua Pesanan).
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x73000000),
    builder: (_) => _ModalPilihVariasi(product: product, mode: mode),
  );
}

Color get _borderColor => AppColors.border;

class _ModalPilihVariasi extends StatefulWidget {
  const _ModalPilihVariasi({required this.product, required this.mode});

  final Product product;
  final ModalVariasiMode mode;

  @override
  State<_ModalPilihVariasi> createState() => _ModalPilihVariasiState();
}

class _ModalPilihVariasiState extends State<_ModalPilihVariasi> {
  final GlobalKey _imageKey = GlobalKey();
  late Product _product;
  int _selectedVariasi = 0;
  int _jumlah = 1;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    _pickInitialVariant();
    _clampQty();
    _refreshLiveProduct();
  }

  void _pickInitialVariant() {
    if (_product.variants.isEmpty) {
      _selectedVariasi = 0;
      return;
    }
    final inStockIdx = _product.variants.indexWhere((v) => v.stock > 0);
    _selectedVariasi = inStockIdx >= 0 ? inStockIdx : 0;
  }

  Future<void> _refreshLiveProduct() async {
    if (widget.product.id.trim().isEmpty || widget.product.id == '0') return;
    try {
      final res = await ApiClient.get('/products/${widget.product.id}/public');
      if (res['success'] == true && res['data'] is Map<String, dynamic>) {
        final fresh = Product.fromJson(res['data'] as Map<String, dynamic>);
        MockData.upsertProduct(fresh);
        if (!mounted) return;
        setState(() {
          final prevName = _selectedVariant?.name;
          _product = fresh;
          if (fresh.variants.isNotEmpty) {
            final idx = prevName != null
                ? fresh.variants.indexWhere((v) => v.name == prevName)
                : -1;
            if (idx >= 0) {
              _selectedVariasi = idx;
            } else {
              _pickInitialVariant();
            }
          } else {
            _selectedVariasi = 0;
          }
          _clampQty();
        });
      }
    } catch (_) {}
  }

  List<ProductVariant> get _variants => _product.variants;

  ProductVariant? get _selectedVariant =>
      (_variants.isNotEmpty && _selectedVariasi < _variants.length)
          ? _variants[_selectedVariasi]
          : null;

  int get _stokTersedia {
    if (_selectedVariant != null) return _selectedVariant!.stock;
    return _product.stock < 0 ? 0 : _product.stock;
  }

  void _clampQty() {
    final max = _stokTersedia;
    if (max <= 0) {
      _jumlah = 0;
    } else if (_jumlah < 1) {
      _jumlah = 1;
    } else if (_jumlah > max) {
      _jumlah = max;
    }
  }

  int get _effectiveJumlah => _stokTersedia <= 0 ? 0 : _jumlah;

  int get _subtotal => _product.price * _effectiveJumlah;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final hasVariants = _variants.isNotEmpty;
    final selected = _selectedVariant;
    final stok = _stokTersedia;

    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: const [
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
          // ── Handle ──
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(9999),
            ),
          ),

          // ── Header: info produk + tombol X ──
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                child: _ProductInfoRow(
                  imageKey: _imageKey,
                  product: _product,
                  stok: stok,
                ),
              ),
              Positioned(
                top: 6,
                right: 14,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSubtle,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, size: 16, color: AppColors.ink),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          Divider(height: 1, thickness: 1, color: _borderColor),

          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasVariants && selected != null) ...[
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'PILIHAN WARNA / GLAZE'.tr,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  '${selected.name} ${selected.label}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: AppColors.textZinc,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final cardWidth = (constraints.maxWidth - 10) / 2;
                              return Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: List.generate(_variants.length, (i) {
                                  final v = _variants[i];
                                  return SizedBox(
                                    width: cardWidth,
                                    child: GestureDetector(
                                      onTap: () => setState(() {
                                        _selectedVariasi = i;
                                        _clampQty();
                                      }),
                                      child: _VariasiCard(
                                        variasi: v,
                                        isSelected: _selectedVariasi == i,
                                      ),
                                    ),
                                  );
                                }),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: _borderColor,
                      ),
                    ),
                  ],

                  const SizedBox(height: 14),

                  // ── Jumlah produk ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'JUMLAH PRODUK'.tr,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                stok <= 0
                                    ? (AppText.isEnglish
                                          ? 'Out of stock'
                                          : 'Stok produk habis')
                                    : hasVariants
                                    ? (AppText.isEnglish
                                          ? 'Only $stok items left for this variant'
                                          : 'Stok tersisa $stok buah untuk varian ini')
                                    : (AppText.isEnglish
                                          ? 'Only $stok items left'
                                          : 'Stok tersisa $stok buah'),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: stok <= 0
                                      ? AppColors.danger
                                      : AppColors.textZinc,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        _JumlahCounter(
                          value: _effectiveJumlah,
                          min: stok <= 0 ? 0 : 1,
                          max: stok,
                          onChanged: (v) => setState(() => _jumlah = v),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),

          Divider(height: 1, thickness: 1, color: _borderColor),

          // ── Bottom action bar ──
          Container(
            color: AppColors.surfaceElevated,
            padding: EdgeInsets.fromLTRB(20, 12, 20, 14 + bottomPad),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Subtotal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Subtotal Estimasi:'.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textZinc,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        MockData.formatPrice(_subtotal),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Tombol aksi
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: switch (widget.mode) {
                    ModalVariasiMode.keranjang => _buildKeranjangButton(
                      isFullWidth: true,
                      enabled: stok > 0 && _effectiveJumlah > 0,
                    ),
                    ModalVariasiMode.beliLangsung => _buildBeliLangsungButton(
                      enabled: stok > 0 && _effectiveJumlah > 0,
                    ),
                    ModalVariasiMode.keduanya => Row(
                      children: [
                        Expanded(
                          child: _buildKeranjangButton(
                            isFullWidth: false,
                            enabled: stok > 0 && _effectiveJumlah > 0,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildBeliLangsungButton(
                            enabled: stok > 0 && _effectiveJumlah > 0,
                          ),
                        ),
                      ],
                    ),
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeranjangButton({
    required bool isFullWidth,
    required bool enabled,
  }) {
    return OutlinedButton.icon(
      onPressed: enabled ? _onKeranjang : null,
      icon: SvgPicture.asset(
        AppAssets.iconCartPlus,
        width: isFullWidth ? 22 : 20,
        height: isFullWidth ? 22 : 20,
        colorFilter: ColorFilter.mode(
          enabled ? AppColors.ink : AppColors.textMuted,
          BlendMode.srcIn,
        ),
      ),
      label: Text(
        isFullWidth ? 'Tambah ke Keranjang'.tr : 'Keranjang'.tr,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: enabled ? AppColors.ink : AppColors.textMuted,
        shape: const StadiumBorder(),
        side: BorderSide(
          color: enabled ? AppColors.ink : AppColors.border,
          width: isFullWidth ? 2 : 1.5,
        ),
        padding: isFullWidth
            ? null
            : const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  Widget _buildBeliLangsungButton({required bool enabled}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        boxShadow: enabled ? AppColors.darkButtonShadow : const [],
      ),
      child: FilledButton(
        onPressed: enabled ? _onBeliLangsung : null,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.black,
          disabledBackgroundColor: AppColors.border,
          foregroundColor: AppColors.white,
          disabledForegroundColor: AppColors.textMuted,
          elevation: 0,
          shape: AppColors.stadiumButtonShape,
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        child: Text(
          enabled
              ? 'Beli Langsung'.tr
              : (AppText.isEnglish ? 'Out of Stock' : 'Stok Habis'),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  void _onKeranjang() {
    if (_stokTersedia <= 0 || _effectiveJumlah <= 0) return;
    final renderBox =
        _imageKey.currentContext?.findRenderObject() as RenderBox?;
    Offset? startOffset;
    if (renderBox != null && renderBox.hasSize && renderBox.attached) {
      startOffset = renderBox.localToGlobal(
        Offset(renderBox.size.width / 2, renderBox.size.height / 2),
      );
    }

    final variantLabel = _selectedVariant?.name;
    MockData.addToCart(
      _product,
      _effectiveJumlah,
      variantLabel,
    );

    CartFlyAnimation.run(
      context,
      imagePath: _product.image,
      startPosition: startOffset,
    );

    Navigator.pop(context);
    final variantSuffix = (variantLabel != null && variantLabel.isNotEmpty)
        ? ' — $variantLabel'
        : '';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${_product.name}$variantSuffix (x$_effectiveJumlah) '
          '${AppText.isEnglish ? 'added to cart!' : 'ditambahkan ke keranjang!'}',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onBeliLangsung() {
    if (_stokTersedia <= 0 || _effectiveJumlah <= 0) return;
    final selectedVariantLabel = _selectedVariant?.name;
    final directItem = CartItem(
      product: _product,
      qty: _effectiveJumlah,
      variant: selectedVariantLabel,
    );
    Navigator.pop(context);
    context.push('/checkout', extra: [directItem]);
  }
}

// ── Widget: Info produk ───────────────────────────────────────────────────────

class _ProductInfoRow extends StatelessWidget {
  const _ProductInfoRow({
    this.imageKey,
    required this.product,
    required this.stok,
  });

  final Key? imageKey;
  final Product product;
  final int stok;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          key: imageKey,
          onTap: () {
            ImagePreviewDialog.show(
              context,
              title: product.name,
              subtitle: product.studio,
              assetPath: product.image,
            );
          },
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _borderColor),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: DcCachedImage(
                imageUrl: product.image,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.studio,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.textZinc,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  product.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  MockData.formatPrice(product.price),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        AppText.isEnglish
                            ? 'Artisan Stock: '
                            : 'Stok Pengrajin: ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textZinc,
                        ),
                      ),
                    ),
                    Text(
                      stok <= 0
                          ? (AppText.isEnglish ? 'Out of stock' : 'Habis')
                          : (AppText.isEnglish ? '$stok items' : '$stok buah'),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: stok <= 0 ? AppColors.danger : AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Widget: Kartu variasi ─────────────────────────────────────────────────────

class _VariasiCard extends StatelessWidget {
  const _VariasiCard({required this.variasi, required this.isSelected});

  final ProductVariant variasi;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final swatchColor = variasi.colorValue;
    final swatchIsDark = swatchColor.computeLuminance() < 0.4;
    final isOutOfStock = variasi.stock <= 0;

    return Opacity(
      opacity: isOutOfStock ? 0.55 : 1.0,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.ink : _borderColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.surface,
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: swatchColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check,
                    size: 13,
                    color: swatchIsDark ? Colors.white : Colors.black,
                  ),
              ],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    variasi.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  Text(
                    '${variasi.label} • ${isOutOfStock ? (AppText.isEnglish ? 'Empty' : 'Habis') : '${variasi.stock}'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: isOutOfStock ? AppColors.danger : AppColors.textZinc,
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
}

// ── Widget: Counter jumlah ────────────────────────────────────────────────────

class _JumlahCounter extends StatelessWidget {
  const _JumlahCounter({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepBtn(
            icon: Icons.remove,
            filled: false,
            enabled: value > min,
            onTap: () => onChanged(value - 1),
          ),
          SizedBox(
            width: 36,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
          _StepBtn(
            icon: Icons.add,
            filled: true,
            enabled: value < max,
            onTap: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({
    required this.icon,
    required this.filled,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool filled;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final Border? border;

    if (filled) {
      bg = enabled ? AppColors.black : AppColors.border;
      fg = enabled ? Colors.white : AppColors.textMuted;
      border = null;
    } else {
      bg = AppColors.surface;
      fg = enabled ? AppColors.ink : AppColors.textMuted;
      border = Border.all(color: _borderColor);
    }

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          border: border,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: fg),
      ),
    );
  }
}
