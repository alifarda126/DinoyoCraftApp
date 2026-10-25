import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_text.dart';
import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_back_scope.dart';
import '../../core/widgets/gallery_picker_sheet.dart';
import '../../core/widgets/image_preview_dialog.dart';
import '../../core/widgets/sticker_picker_sheet.dart';
import '../../data/mock_data.dart';
import '../product/presentation/modal_pilih_variasi.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({
    super.key,
    this.storeName = 'Dinoyo Ceramic Studio',
    this.productId,
  });

  final String storeName;
  final String? productId;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.isMine,
    required this.time,
    this.imagePath,
    this.isFileImage = false,
    this.isSticker = false,
    this.product,
  });

  final String text;
  final bool isMine;
  final String time;
  final String? imagePath;

  /// True bila [imagePath] adalah file di disk (hasil kamera/galeri),
  /// false bila path aset bawaan aplikasi.
  final bool isFileImage;
  final bool isSticker;
  final Product? product;
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  static const Color _onlineGreen = Color(0xFF059669);

  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Product? _productPreview;

  @override
  void initState() {
    super.initState();
    MockData.markChatAsRead(widget.storeName);
    if (widget.productId != null) {
      try {
        _productPreview = MockData.products.firstWhere(
          (p) => p.id == widget.productId,
        );
      } catch (_) {
        _productPreview = null;
      }
    }
  }

  late final List<_ChatMessage> _messages = [
    const _ChatMessage(
      isMine: false,
      time: '14:12',
      text:
          'Halo Kak Customer! Terima kasih sudah menghubungi Dinoyo Ceramic '
          'Studio. Ada yang bisa kami bantu terkait produk tembikar dan '
          'keramik kami? 😊',
    ),
    const _ChatMessage(
      isMine: true,
      time: '14:15',
      text:
          'Halo min, untuk Vas Keramik Minimalis warna Sand White Glossy '
          'apakah ready stock untuk pengiriman ke Surabaya? Apakah packing '
          'kayunya dijamin aman?',
    ),
    const _ChatMessage(
      isMine: false,
      time: '14:16',
      text:
          'Ready stock kak! Untuk pengiriman luar kota kami selalu lapis '
          'bubble wrap tebal 3 lapis dan rangka kayu pengaman. Dijamin aman '
          'sampai tujuan tanpa retak kak 👍',
    ),
    const _ChatMessage(
      isMine: false,
      time: '14:17',
      text: '',
      imagePath: AppAssets.productVas,
    ),
    const _ChatMessage(
      isMine: false,
      time: '14:18',
      text: '',
      imagePath: AppAssets.stickerClayPacking,
      isSticker: true,
    ),
  ];

  String get _storeImage {
    final name = widget.storeName;
    if (name.contains('Karya Tanah') || name.contains('Ruang Tanah')) {
      return AppAssets.storeRuangTanah;
    }
    return AppAssets.storeDinoyo;
  }

  void _send() {
    final text = _inputController.text.trim();
    if (text.isEmpty && _productPreview == null) return;
    setState(() {
      if (_productPreview != null) {
        _messages.add(
          _ChatMessage(
            isMine: true,
            time: _nowLabel(),
            text: '',
            product: _productPreview,
          ),
        );
        _productPreview = null;
      }
      if (text.isNotEmpty) {
        _messages.add(
          _ChatMessage(isMine: true, time: _nowLabel(), text: text),
        );
        _inputController.clear();
      }
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Kirim foto produk (dari sheet lampiran) sebagai bubble gambar.
  void _sendImage(String assetPath) {
    setState(() {
      _messages.add(_ChatMessage(
        isMine: true,
        time: _nowLabel(),
        text: '',
        imagePath: assetPath,
      ));
    });
    _scrollToBottom();
  }

  /// Kirim stiker DinoyoCraft (Si Clay) ke ruang obrolan.
  void _sendSticker(DinoyoSticker sticker) {
    setState(() {
      _messages.add(_ChatMessage(
        isMine: true,
        time: _nowLabel(),
        text: '',
        imagePath: sticker.assetPath,
        isSticker: true,
      ));
    });
    _scrollToBottom();
  }

  Future<void> _openAttachmentSheet() async {
    final result = await GalleryPickerSheet.show(
      context,
      title: 'Kirim Foto'.tr,
    );
    if (result != null && mounted) {
      if (result.isFile) {
        setState(() {
          _messages.add(_ChatMessage(
            isMine: true,
            time: _nowLabel(),
            text: '',
            imagePath: result.path,
            isFileImage: true,
          ));
        });
        _scrollToBottom();
      } else {
        _sendImage(result.path);
      }
    }
  }

  void _openStickerSheet() {
    StickerPickerSheet.show(
      context,
      onSelected: (sticker) => _sendSticker(sticker),
    );
  }

  void _openChatMenu() {
    final router = GoRouter.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.storefront_outlined, size: 22),
              title: Text(
                'Lihat Profil Toko'.tr,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
              onTap: () {
                Navigator.of(sheetCtx).pop();
                final index = MockData.stores
                    .indexWhere((s) => widget.storeName.contains(s.name));
                router.push('/store/${index < 0 ? 0 : index}');
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline_rounded, size: 22),
              title: Text(
                'Hapus Percakapan'.tr,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
              onTap: () {
                Navigator.of(sheetCtx).pop();
                setState(() => _messages.clear());
              },
            ),
            ListTile(
              leading: Icon(Icons.flag_outlined, size: 22),
              title: Text(
                'Laporkan Percakapan'.tr,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
              onTap: () {
                Navigator.of(sheetCtx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Terima kasih, laporanmu kami terima.'.tr),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _nowLabel() {
    final now = DateTime.now();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(now.hour)}:${two(now.minute)}';
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackScope(
      fallbackRoute: '/messages',
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxHeight < 80 || constraints.maxWidth < 100) {
                return const SizedBox.shrink();
              }
              return Column(
                children: [
                  _buildHeader(),
                  Divider(height: 1, color: AppColors.divider),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                      itemCount: _messages.length + 1,
                      itemBuilder: (context, i) {
                        if (i == 0) return _buildDateDivider();
                        return _buildBubble(_messages[i - 1]);
                      },
                    ),
                  ),
                  if (_productPreview != null)
                    _buildBottomProductPreview(_productPreview!),
                  _buildInputBar(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 62,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/messages');
              }
            },
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 19),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 19,
                backgroundImage: AssetImage(_storeImage),
              ),
              Positioned(
                right: -1,
                bottom: -1,
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: _onlineGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.storeName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
          IconButton(
            onPressed: _openChatMenu,
            icon: Icon(Icons.more_vert_rounded, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildDateDivider() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.borderAlt),
        ),
        child: Text(
          'Hari ini, 14:10'.tr,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomProductPreview(Product product) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.divider),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => context.push('/product/${product.id}'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                product.image,
                width: 58,
                height: 58,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => context.push('/product/${product.id}'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: AppColors.borderAlt,
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chat_bubble_rounded,
                              size: 8,
                              color: AppColors.ink,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'Ditanyakan'.tr,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          product.studio,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    MockData.formatPrice(product.price),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              setState(() {
                _productPreview = null;
              });
            },
            icon: Icon(
              Icons.close_rounded,
              size: 20,
              color: AppColors.textMuted,
            ),
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            splashRadius: 18,
            tooltip: 'Hapus Preview'.tr,
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => context.push('/product/${product.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  product.image,
                  width: 68,
                  height: 68,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      product.studio,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 13,
                          color: Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${product.rating}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            '• Terjual 340+'.tr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      MockData.formatPrice(product.price),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: 38,
                height: 34,
                child: OutlinedButton(
                  key: const ValueKey('chat_product_cart_button'),
                  onPressed: () => showModalPilihVariasi(
                    context,
                    product: product,
                    mode: ModalVariasiMode.keranjang,
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    foregroundColor: AppColors.ink,
                    backgroundColor: AppColors.surfaceSubtle,
                    side: BorderSide(
                      color: AppColors.borderAlt,
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    size: 16,
                    color: AppColors.ink,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 34,
                  child: ElevatedButton.icon(
                    onPressed: () => context.push('/product/${product.id}'),
                    icon: const Icon(
                      Icons.shopping_bag_outlined,
                      size: 14,
                      color: AppColors.white,
                    ),
                    label: Text(
                      'Lihat Produk'.tr,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.black,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.zero,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: AppColors.darkButtonSide ?? BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(_ChatMessage message) {
    final bubbleRadius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(message.isMine ? 16 : 2),
      bottomRight: Radius.circular(message.isMine ? 2 : 16),
    );

    final isProduct = message.product != null;
    final isSticker = message.isSticker;
    final content = isProduct
        ? _buildProductCard(message.product!)
        : message.imagePath != null
            ? GestureDetector(
                onTap: () {
                  ImagePreviewDialog.show(
                    context,
                    title: message.isMine
                        ? (isSticker ? 'Stiker Terkirim'.tr : 'Foto Terkirim'.tr)
                        : (isSticker ? 'Stiker dari Toko'.tr : 'Foto dari Toko'.tr),
                    subtitle: message.time,
                    filePath: message.isFileImage ? message.imagePath : null,
                    assetPath: message.isFileImage ? null : message.imagePath,
                  );
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: message.isFileImage
                          ? Image.file(
                              File(message.imagePath!),
                              width: isSticker ? 140 : 220,
                              height: isSticker ? 140 : 158,
                              fit: isSticker ? BoxFit.contain : BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                width: isSticker ? 140 : 220,
                                height: isSticker ? 140 : 158,
                                color: AppColors.inputBg,
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image_rounded,
                                    size: 28,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                            )
                          : Image.asset(
                              message.imagePath!,
                              width: isSticker ? 140 : 220,
                              height: isSticker ? 140 : 158,
                              fit: isSticker ? BoxFit.contain : BoxFit.cover,
                            ),
                    ),
                    if (!isSticker)
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.fullscreen_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              )
            : Text(
                message.text,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  height: 1.5,
                  color: AppColors.ink,
                ),
              );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: message.isMine
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: message.isMine
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!message.isMine) ...[
                CircleAvatar(
                  radius: 12,
                  backgroundImage: AssetImage(_storeImage),
                ),
                SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: isProduct
                      ? const EdgeInsets.all(10)
                      : message.imagePath != null
                          ? const EdgeInsets.all(6)
                          : const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                  constraints: BoxConstraints(
                    maxWidth: isProduct ? 272 : (isSticker ? 152 : 260),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: bubbleRadius,
                    border: Border.all(color: AppColors.borderAlt),
                  ),
                  child: content,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.time,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
                if (message.isMine) ...[
                  SizedBox(width: 3),
                  Icon(
                    Icons.done_all_rounded,
                    size: 12,
                    color: AppColors.textMuted,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      color: AppColors.surfaceSubtle,
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        10 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _openAttachmentSheet,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.inputBg,
              child: SvgPicture.asset(
                AppAssets.iconBerkas,
                width: 22,
                height: 22,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _inputController,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _send(),
              onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.ink,
              ),
              decoration: InputDecoration(
                hintText: 'Ketik pesan...'.tr,
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
                suffixIcon: GestureDetector(
                  onTap: _openStickerSheet,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      AppAssets.iconEmoji,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 11,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide(color: AppColors.borderAlt),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide(color: AppColors.borderAlt),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide(color: AppColors.ink),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          InkWell(
            key: const ValueKey('chat_send_button'),
            onTap: _send,
            borderRadius: BorderRadius.circular(22),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.black,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.iconKirimPesan,
                  width: 16,
                  height: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
