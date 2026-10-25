import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_text.dart';
import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_back_scope.dart';
import '../../core/widgets/gallery_picker_sheet.dart';
import '../../core/widgets/image_preview_dialog.dart';
import '../../core/widgets/sticker_picker_sheet.dart';

// ─── Data model ───────────────────────────────────────────────────────────────
class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.isBot,
    this.time = '',
    this.imagePath,
    this.isFileImage = false,
    this.isSticker = false,
  });

  final String text;
  final bool isBot;
  final String time;
  final String? imagePath;

  /// True bila [imagePath] adalah file di disk (hasil kamera/galeri),
  /// false bila path aset bawaan aplikasi.
  final bool isFileImage;
  final bool isSticker;
}

String _nowTime() {
  final now = DateTime.now();
  return '${now.hour.toString().padLeft(2, '0')}:'
      '${now.minute.toString().padLeft(2, '0')}';
}

// ─── Quick replies sesuai Proto_Final/Chatbot.png ─────────────────────────────
const _quickReplies = [
  ('🫙', 'Cari produk'),
  ('🏺', 'Rekomendasi cangkir'),
  ('🏪', 'Cari toko'),
  ('🎨', 'Info workshop'),
  ('📦', 'Bantuan pesanan'),
];

const _scripted = <String, String>{
  'Cari produk':
      'Kamu bisa cari produk keramik di tab Produk atau lewat ikon 🔍 di header Beranda. Filter berdasarkan kategori: Vas, Cangkir, Piring, dan Mangkuk.',
  'Rekomendasi cangkir':
      'Tentu! Saya menemukan beberapa pilihan cangkir terfavorit langsung dari pengrajin Dinoyo: Cangkir Handmade (Karya Tanah) & Cangkir Speckle (Dinoyo Ceramic Studio).',
  'Cari toko':
      'Ada 4 studio keramik di Kampung Dinoyo: Dinoyo Ceramic Studio, Karya Tanah, Ruang Tanah, dan Dinoyo Craft House. Lihat di tab Toko!',
  'Info workshop':
      'Workshop keramik tersedia di Dinoyo! Buka tab Workshop untuk info jadwal dan reservasi via WhatsApp. Sesi berlangsung ±2 jam.',
  'Bantuan pesanan':
      'Untuk informasi pesanan kamu, kunjungi tab Bantuan atau halaman Profil → Riwayat Pesanan. Atau tanya saya langsung!',
};

// ─── Popup chatbot — dipanggil via showClayBotPopup() ────────────────────────
Future<void> showClayBotPopup(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (ctx) => const _ClayBotSheet(),
  );
}

class _ClayBotSheet extends StatefulWidget {
  const _ClayBotSheet();

  @override
  State<_ClayBotSheet> createState() => _ClayBotSheetState();
}

class _ClayBotSheetState extends State<_ClayBotSheet> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  bool _showQuickReplies = true;

  late final List<_ChatMessage> _messages = [
    _ChatMessage(
      text: ('Halo! 👋\n\nSaya ClayBot, asisten DinoyoCraft. '
          'Saya siap membantu kamu menemukan produk keramik lokal, '
          'mencari studio toko, info jadwal workshop, hingga bantuan pesananmu.').tr,
      isBot: true,
    ),
  ];

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final t = _nowTime();
    setState(() {
      _showQuickReplies = false;
      _messages.add(_ChatMessage(text: trimmed, isBot: false, time: t));
      final reply = _scripted[trimmed] ??
          'Ada produk keramik spesifik yang sedang ingin kamu cari hari ini?';
      Future.delayed(Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() {
            _messages.add(
                _ChatMessage(text: reply, isBot: true, time: _nowTime()));
          });
          _scrollToBottom();
        }
      });
    });
    _input.clear();
    _scrollToBottom();
  }

  /// Kirim foto produk (dari sheet lampiran) sebagai bubble gambar.
  void _sendImage(String assetPath, {bool isFile = false}) {
    setState(() {
      _showQuickReplies = false;
      _messages.add(_ChatMessage(
        text: '',
        isBot: false,
        time: _nowTime(),
        imagePath: assetPath,
        isFileImage: isFile,
      ));
    });
    _scrollToBottom();
    Future.delayed(Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _messages.add(_ChatMessage(
          text: 'Terima kasih, foto produknya sudah kami terima! '
              'Ada yang ingin ditanyakan tentang produk pada gambar ini?',
          isBot: true,
          time: _nowTime(),
        ));
      });
      _scrollToBottom();
    });
  }

  Future<void> _openAttachmentSheet() async {
    final result = await GalleryPickerSheet.show(
      context,
      title: 'Kirim Foto Produk'.tr,
    );
    if (result != null && mounted) {
      _sendImage(result.path, isFile: result.isFile);
    }
  }

  void _openStickerSheet() {
    StickerPickerSheet.show(
      context,
      onSelected: (sticker) => _sendSticker(sticker),
    );
  }

  void _sendSticker(DinoyoSticker sticker) {
    setState(() {
      _messages.add(
        _ChatMessage(
          text: '',
          isBot: false,
          time: _nowTime(),
          imagePath: sticker.assetPath,
          isSticker: true,
        ),
      );
    });
    _scrollToBottom();

    // Respons ramah dari ClayBot menyambut stiker
    Future.delayed(const Duration(milliseconds: 650), () {
      if (!mounted) return;
      setState(() {
        _messages.add(
          _ChatMessage(
            text: 'Wah, stiker Si Clay yang lucu! Ada yang bisa ClayBot bantu seputar produk atau workshop keramik Dinoyo? 😊',
            isBot: true,
            time: _nowTime(),
          ),
        );
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent + 120,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    // viewPadding.bottom = gesture navigation bar height (Android)
    final gestureNavBar = MediaQuery.viewPaddingOf(context).bottom;
    final screenH = MediaQuery.sizeOf(context).height;

    return Container(
      height: screenH * 0.82,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // ── drag handle ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── header ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 10),
            child: Row(
              children: [
                // Bot avatar dengan green dot
                Stack(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.iconBot,
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            AppColors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    // Online dot
                    Positioned(
                      right: 1,
                      bottom: 1,
                      child: Container(
                        width: 11,
                        height: 11,
                        decoration: BoxDecoration(
                          color: Color(0xFF22C55E),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ClayBot',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      Text(
                        'Asisten DinoyoCraft'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Close button
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close_rounded,
                      size: 22, color: AppColors.ink),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.divider),

          // ── messages list ─────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final msg = _messages[i];
                return _buildMessage(context, msg);
              },
            ),
          ),

          // ── quick replies ─────────────────────────────────────────────
          if (_showQuickReplies)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Apa yang ingin kamu cari?'.tr,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _quickReplies.map((qr) {
                      return GestureDetector(
                        onTap: () => _send(qr.$2),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.border, width: 1),
                          ),
                          child: Text(
                            '${qr.$1} ${qr.$2.tr}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

          // ── input bar ─────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                top: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: AppColors.isDark ? 0.2 : 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(
                14,
                10,
                14,
                // Keyboard inset ATAU gesture nav bar (whichever is taller)
                10 + (bottomInset > 0
                    ? bottomInset.clamp(0.0, 400.0)
                    : gestureNavBar.clamp(0.0, 48.0))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // + attachment button
                    GestureDetector(
                      onTap: _openAttachmentSheet,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSubtle,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.border.withValues(alpha: 0.6),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AppAssets.iconBerkas,
                            width: 20,
                            height: 20,
                            colorFilter: ColorFilter.mode(
                              AppColors.ink,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // text field container
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: AppColors.border.withValues(alpha: 0.6),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _input,
                                onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  color: AppColors.ink,
                                ),
                                cursorColor: AppColors.ink,
                                decoration: InputDecoration(
                                  hintText: 'Tulis pesan kamu...'.tr,
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    color: AppColors.textMuted,
                                  ),
                                  isDense: true,
                                  filled: false,
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                onSubmitted: _send,
                              ),
                            ),
                            GestureDetector(
                              onTap: _openStickerSheet,
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 14, left: 4),
                                child: SvgPicture.asset(
                                  AppAssets.iconEmoji,
                                  width: 20,
                                  height: 20,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.textSecondary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // send button
                    GestureDetector(
                      onTap: () => _send(_input.text),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          shape: BoxShape.circle,
                          border: AppColors.isDark
                              ? Border.all(
                                  color: Colors.white.withValues(alpha: 0.35),
                                  width: 1.2,
                                )
                              : null,
                          boxShadow: AppColors.darkButtonShadow,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AppAssets.iconKirimPesan,
                            width: 16,
                            height: 16,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'ClayBot memiliki batasan tertentu, cerdaslah dalam bertanya...',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(BuildContext context, _ChatMessage msg) {
    if (msg.isBot) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bot avatar kecil
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.black,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.iconBot,
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            // Bot bubble
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Text(
                  msg.text,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    height: 1.5,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
            SizedBox(width: 40),
          ],
        ),
      );
    } else {
      // User bubble — kanan, hitam
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(width: 60),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (msg.imagePath != null)
                    GestureDetector(
                      onTap: () {
                        ImagePreviewDialog.show(
                          context,
                          title: msg.isSticker
                              ? 'Stiker ChatBot'.tr
                              : 'Foto ChatBot'.tr,
                          subtitle: msg.time,
                          filePath: msg.isFileImage ? msg.imagePath : null,
                          assetPath: msg.isFileImage ? null : msg.imagePath,
                        );
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: msg.isFileImage
                                ? Image.file(
                                    File(msg.imagePath!),
                                    width: msg.isSticker ? 140 : 200,
                                    height: msg.isSticker ? 140 : 140,
                                    fit: msg.isSticker
                                        ? BoxFit.contain
                                        : BoxFit.cover,
                                    errorBuilder: (_, _, _) => Container(
                                      width: msg.isSticker ? 140 : 200,
                                      height: msg.isSticker ? 140 : 140,
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
                                    msg.imagePath!,
                                    width: msg.isSticker ? 140 : 200,
                                    height: msg.isSticker ? 140 : 140,
                                    fit: msg.isSticker
                                        ? BoxFit.contain
                                        : BoxFit.cover,
                                  ),
                          ),
                          if (!msg.isSticker)
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
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(4),
                        ),
                      ),
                      child: Text(
                        msg.text,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          height: 1.45,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  SizedBox(height: 4),
                  Text(
                    msg.time,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: AppColors.textMuted,
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
}

// ─── Legacy full-screen route (kept for backward-compat, now just shows popup)
// Ini tidak lagi dipakai sebagai route — bisa dihapus jika router di-cleanup.
class ChatbotScreen extends StatelessWidget {
const   ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackScope(
      fallbackRoute: '/home',
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: Builder(
          builder: (ctx) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showClayBotPopup(ctx).then((_) {
                // Kembali ke halaman sebelumnya agar tidak terjebak layar kosong.
                if (ctx.mounted && Navigator.of(ctx).canPop()) {
                  Navigator.of(ctx).pop();
                }
              });
            });
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
