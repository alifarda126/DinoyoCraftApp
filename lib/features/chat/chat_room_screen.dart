import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_text.dart';
import '../../core/assets.dart';
import '../../core/services/pusher_service.dart';
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

enum _SenderType {
  user,
  store,
  storeBot,
  seller,
  system,
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
    this.senderType = _SenderType.store,
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
  final _SenderType senderType;
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  static const Color _onlineGreen = Color(0xFF059669);

  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Product? _productPreview;
  bool _isSellerConnected = false;
  bool _isConnectingSeller = false;
  Timer? _botTimer;
  Timer? _sellerTimer;

  late final String _channelName =
      'chat.store.${widget.storeName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_')}';

  @override
  void initState() {
    super.initState();
    MockData.markChatAsRead(widget.storeName);
    _subscribePusher();
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

  void _subscribePusher() {
    PusherService.instance.subscribeToChat(
      channelName: _channelName,
      onMessage: _handleIncomingPusherMessage,
    );
  }

  void _handleIncomingPusherMessage(PusherChatMessage message) {
    if (!mounted || message.isMine) return;
    setState(() {
      _messages.add(
        _ChatMessage(
          isMine: false,
          time: message.time.isNotEmpty ? message.time : _nowLabel(),
          text: message.text,
          senderType: _SenderType.seller,
        ),
      );
    });
    _scrollToBottom();
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

  void _send([String? customText]) {
    final text = customText ?? _inputController.text.trim();
    if (text.isEmpty && _productPreview == null) return;
    final sentProduct = _productPreview;
    setState(() {
      if (sentProduct != null) {
        _messages.add(
          _ChatMessage(
            isMine: true,
            time: _nowLabel(),
            text: '',
            product: sentProduct,
            senderType: _SenderType.user,
          ),
        );
        _productPreview = null;
      }
      if (text.isNotEmpty) {
        _messages.add(
          _ChatMessage(
            isMine: true,
            time: _nowLabel(),
            text: text,
            senderType: _SenderType.user,
          ),
        );
        if (customText == null) {
          _inputController.clear();
        }

        // Kirim event chat ke Pusher Channels (siap integrasi BE)
        PusherService.instance.sendChatMessage(
          channelName: _channelName,
          message: PusherChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            channel: _channelName,
            senderId: 'customer_current',
            senderName: 'Customer',
            text: text,
            time: _nowLabel(),
            isMine: true,
          ),
        );
      }
    });
    _scrollToBottom();

    if (!_isSellerConnected && !_isConnectingSeller) {
      _triggerStoreBotResponse(text, sentProduct);
    } else if (_isSellerConnected) {
      _triggerSellerResponse(text);
    }
  }

  void _triggerStoreBotResponse(
    String text,
    Product? product, {
    bool isMedia = false,
    bool isSticker = false,
  }) {
    final lower = text.toLowerCase();

    // Jika customer ingin bicara langsung dengan manusia/penjual
    if (lower.contains('penjual') ||
        lower.contains('owner') ||
        lower.contains('manusia') ||
        lower.contains('cs') ||
        lower.contains('admin') ||
        lower.contains('bicara langsung')) {
      _connectToSeller();
      return;
    }

    String botReply;
    if (product != null) {
      botReply =
          'Halo Kak! Terima kasih sudah menanyakan ${product.name}. Karya keramik ini ready stock dan langsung dibuat oleh pengrajin sentra Dinoyo. Ingin info varian warna atau estimasi packing? Asisten bot siap membantu, atau klik tombol di bawah untuk berbicara langsung dengan penjual! 😊'
              .tr;
    } else if (isMedia) {
      botReply =
          'Foto referensi berhasil kami terima kak! Ada model keramik serupa yang ingin ditanyakan ketersediaannya? Asisten bot siap membantu, atau hubungi penjual langsung jika butuh custom keramik! 📸🏺'
              .tr;
    } else if (isSticker) {
      botReply =
          'Terima kasih stikernya kak! Ada yang bisa kami bantu mengenai pesanan atau koleksi keramik DinoyoCraft hari ini? 🎨✨'
              .tr;
    } else if (lower.contains('stok') ||
        lower.contains('ready') ||
        lower.contains('ada') ||
        lower.contains('tersedia')) {
      botReply =
          'Halo Kak! Produk keramik di ${widget.storeName} sebagian besar ready stock dan siap dikirim. Setiap karya diproduksi langsung dari tanah liat Dinoyo dengan pembakaran suhu tinggi. Butuh detail stok varian tertentu? Hubungi penjual langsung lewat tombol di bawah ya! 👍'
              .tr;
    } else if (lower.contains('kirim') ||
        lower.contains('ongkir') ||
        lower.contains('packing') ||
        lower.contains('aman') ||
        lower.contains('pecah') ||
        lower.contains('kayu') ||
        lower.contains('surabaya') ||
        lower.contains('luar kota')) {
      botReply =
          'Untuk pengiriman luar kota, toko kami menggunakan proteksi ekstra: bubble wrap tebal berlapis dan rangka kayu pelindung. Kami juga memberikan garansi ganti baru jika produk retak di perjalanan! 📦🛡️'
              .tr;
    } else if (lower.contains('harga') ||
        lower.contains('diskon') ||
        lower.contains('promo') ||
        lower.contains('nego') ||
        lower.contains('murah')) {
      botReply =
          'Harga di etalase kami merupakan harga pengrajin lokal tangan pertama. Untuk pemesanan grosir atau souvenir acara dalam jumlah banyak, Kakak bisa nego langsung dengan penjual lewat tombol di bawah! 🏷️'
              .tr;
    } else if (lower.contains('custom') ||
        lower.contains('motif') ||
        lower.contains('nama') ||
        lower.contains('desain') ||
        lower.contains('warna')) {
      botReply =
          '${widget.storeName} melayani pembuatan keramik custom (desain motif, glasir khusus, ukiran nama/logo). Silakan chat langsung dengan penjual untuk berkonsultasi detailnya ya! 🏺'
              .tr;
    } else {
      botReply =
          'Halo Kak! Pesanmu sudah kami terima. Penjual saat ini sedang di workshop keramik. Saya sebagai Asisten Bot Toko siap membantu menjawab pertanyaan seputar keramik. Jika butuh respons langsung dari pemilik toko, silakan tekan tombol di bawah ya! 🙏'
              .tr;
    }

    _botTimer?.cancel();
    _botTimer = Timer(const Duration(milliseconds: 650), () {
      if (!mounted) return;
      setState(() {
        _messages.add(
          _ChatMessage(
            isMine: false,
            time: _nowLabel(),
            text: botReply,
            senderType: _SenderType.storeBot,
          ),
        );
      });
      _scrollToBottom();
    });
  }

  void _connectToSeller() {
    if (_isSellerConnected || _isConnectingSeller) return;

    setState(() {
      _isConnectingSeller = true;
      _messages.add(
        _ChatMessage(
          isMine: false,
          time: _nowLabel(),
          text: 'Menghubungkan ke Pemilik Toko... Mohon tunggu sebentar ya.'.tr,
          senderType: _SenderType.system,
        ),
      );
    });
    _scrollToBottom();

    _sellerTimer?.cancel();
    _sellerTimer = Timer(const Duration(milliseconds: 850), () {
      if (!mounted) return;
      setState(() {
        _isConnectingSeller = false;
        _isSellerConnected = true;
        _messages.add(
          _ChatMessage(
            isMine: false,
            time: _nowLabel(),
            text:
                'Halo Kak! Saya Mas Dinoyo dari ${widget.storeName}. Maaf tadi masih mengecek pembakaran di workshop. Ada yang bisa saya bantu secara langsung terkait produk atau pesanan Kakak? 😊'
                    .tr,
            senderType: _SenderType.seller,
          ),
        );
      });
      _scrollToBottom();
    });
  }

  void _triggerSellerResponse(String text) {
    _sellerTimer?.cancel();
    _sellerTimer = Timer(const Duration(milliseconds: 750), () {
      if (!mounted) return;
      setState(() {
        _messages.add(
          _ChatMessage(
            isMine: false,
            time: _nowLabel(),
            text:
                'Baik Kak, pertanyaan Kakak sudah saya catat langsung. Kualitas tembikar dan keramik Dinoyo kami utamakan selalu. Jika ingin memesan, silakan langsung checkout atau kabari saya jika butuh varian custom ya! 🙌'
                    .tr,
            senderType: _SenderType.seller,
          ),
        );
      });
      _scrollToBottom();
    });
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
    if (!_isSellerConnected && !_isConnectingSeller) {
      _triggerStoreBotResponse('', null, isMedia: true);
    }
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
    if (!_isSellerConnected && !_isConnectingSeller) {
      _triggerStoreBotResponse('', null, isSticker: true);
    }
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
    _botTimer?.cancel();
    _sellerTimer?.cancel();
    PusherService.instance.unsubscribe(_channelName);
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
                  _buildAssistantBanner(),
                  _buildInputBar(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAssistantBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 0.8),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _isSellerConnected
                  ? const Color(0xFFE8F5E9)
                  : AppColors.surfaceSubtle,
              shape: BoxShape.circle,
            ),
            child: _isSellerConnected
                ? const Icon(Icons.verified_user_rounded,
                    size: 14, color: Color(0xFF16A34A))
                : SvgPicture.asset(
                    AppAssets.iconBot,
                    width: 14,
                    height: 14,
                    colorFilter: ColorFilter.mode(
                      AppColors.ink,
                      BlendMode.srcIn,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _isSellerConnected
                  ? 'Terhubung langsung dengan Penjual'.tr
                  : 'Asisten Bot toko siap menjawab saat toko sibuk'.tr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          if (!_isSellerConnected)
            GestureDetector(
              onTap: _connectToSeller,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppAssets.iconFloatingCS,
                      width: 12,
                      height: 12,
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Chat Penjual'.tr,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            GestureDetector(
              onTap: () {
                setState(() {
                  _isSellerConnected = false;
                  _messages.add(
                    _ChatMessage(
                      isMine: false,
                      time: _nowLabel(),
                      text:
                          'Asisten Bot Toko aktif kembali. Silakan tanyakan seputar produk atau toko! 🤖'
                              .tr,
                      senderType: _SenderType.storeBot,
                    ),
                  );
                });
                _scrollToBottom();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.borderAlt),
                ),
                child: Text(
                  'Beralih ke Asisten Bot'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
        ],
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
                    color: _isSellerConnected
                        ? _onlineGreen
                        : const Color(0xFF3B82F6),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.storeName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _isSellerConnected
                            ? _onlineGreen
                            : const Color(0xFF3B82F6),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        _isSellerConnected
                            ? 'Penjual Online • Siap melayani'.tr
                            : 'Asisten Toko Siaga • Dibalas otomatis'.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: _isSellerConnected
                              ? _onlineGreen
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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
                  child: SvgPicture.asset(
                    AppAssets.iconCartPlus,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      AppColors.ink,
                      BlendMode.srcIn,
                    ),
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

  Widget _buildTextContent(_ChatMessage message) {
    if (message.senderType == _SenderType.storeBot) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.borderAlt, width: 0.8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  AppAssets.iconBot,
                  width: 10,
                  height: 10,
                  colorFilter:
                      ColorFilter.mode(AppColors.ink, BlendMode.srcIn),
                ),
                const SizedBox(width: 4),
                Text(
                  'Asisten Toko (Bot)'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
          Text(
            message.text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              height: 1.5,
              color: AppColors.ink,
            ),
          ),
          if (!_isSellerConnected) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _connectToSeller,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppAssets.iconFloatingCS,
                      width: 12,
                      height: 12,
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        'Chat dengan Penjual'.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      );
    }

    if (message.senderType == _SenderType.seller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFC8E6C9), width: 0.8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_rounded,
                    size: 10, color: Color(0xFF16A34A)),
                const SizedBox(width: 4),
                Text(
                  'Penjual Toko'.tr,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF16A34A),
                  ),
                ),
              ],
            ),
          ),
          Text(
            message.text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              height: 1.5,
              color: AppColors.ink,
            ),
          ),
        ],
      );
    }

    return Text(
      message.text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        height: 1.5,
        color: AppColors.ink,
      ),
    );
  }

  Widget _buildBubble(_ChatMessage message) {
    if (message.senderType == _SenderType.system) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.borderAlt),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline_rounded,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    message.text,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
            : _buildTextContent(message);

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
                  backgroundColor: message.senderType == _SenderType.storeBot
                      ? AppColors.black
                      : Colors.transparent,
                  backgroundImage: message.senderType == _SenderType.storeBot
                      ? null
                      : AssetImage(_storeImage),
                  child: message.senderType == _SenderType.storeBot
                      ? SvgPicture.asset(
                          AppAssets.iconBot,
                          width: 14,
                          height: 14,
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                        )
                      : null,
                ),
                const SizedBox(width: 8),
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
          const SizedBox(height: 4),
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
                  const SizedBox(width: 3),
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
