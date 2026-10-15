import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key, this.storeName = 'Dinoyo Ceramic Studio'});

  final String storeName;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.isMine,
    required this.time,
    this.imagePath,
  });

  final String text;
  final bool isMine;
  final String time;
  final String? imagePath;
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  static const Color _onlineGreen = Color(0xFF059669);

  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final List<_ChatMessage> _messages = [
    const _ChatMessage(
      isMine: false,
      time: '14:12',
      text:
          'Halo Kak Mochammad! Terima kasih sudah menghubungi Dinoyo Ceramic '
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
    if (text.isEmpty) return;
    setState(() {
      _messages.add(
        _ChatMessage(isMine: true, time: _nowLabel(), text: text),
      );
      _inputController.clear();
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
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

  void _openAttachmentSheet() {
    const assets = [
      AppAssets.productVas,
      AppAssets.productMangkuk,
      AppAssets.productPiring,
    ];
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kirim Foto',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Pilih foto dari galeri contoh (demo).',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 92,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: assets.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, i) => GestureDetector(
                    onTap: () {
                      Navigator.of(sheetCtx).pop();
                      _sendImage(assets[i]);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        assets[i],
                        width: 92,
                        height: 92,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openEmojiSheet() {
    const emojis = [
      '😊', '😂', '😍', '🥰', '😎', '👍', '🙏',
      '🔥', '✨', '❤️', '🤩', '😁', '🫙', '🏺',
    ];
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: emojis.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, i) => GestureDetector(
              onTap: () {
                final selection = _inputController.selection;
                final text = _inputController.text;
                final pos = selection.baseOffset >= 0 &&
                        selection.baseOffset <= text.length
                    ? selection.baseOffset
                    : text.length;
                final newText = text.replaceRange(pos, pos, emojis[i]);
                _inputController.value = TextEditingValue(
                  text: newText,
                  selection: TextSelection.collapsed(
                    offset: pos + emojis[i].length,
                  ),
                );
              },
              child: Center(
                child: Text(emojis[i], style: const TextStyle(fontSize: 24)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openChatMenu() {
    final router = GoRouter.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.storefront_outlined, size: 22),
              title: Text(
                'Lihat Profil Toko',
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
              leading: const Icon(Icons.delete_outline_rounded, size: 22),
              title: Text(
                'Hapus Percakapan',
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
              leading: const Icon(Icons.flag_outlined, size: 22),
              title: Text(
                'Laporkan Percakapan',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
              onTap: () {
                Navigator.of(sheetCtx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Terima kasih, laporanmu kami terima.'),
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
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
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
            _buildInputBar(),
          ],
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
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
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
          const SizedBox(width: 10),
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
            icon: const Icon(Icons.more_vert_rounded, size: 20),
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
          color: AppColors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.borderAlt),
        ),
        child: Text(
          'Hari ini, 14:10',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
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

    final content = message.imagePath != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              message.imagePath!,
              width: 220,
              height: 158,
              fit: BoxFit.cover,
            ),
          )
        : Text(
            message.text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              height: 1.5,
              color: message.isMine ? AppColors.white : AppColors.ink,
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
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: message.imagePath != null
                      ? const EdgeInsets.all(6)
                      : const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                  constraints: const BoxConstraints(maxWidth: 260),
                  decoration: BoxDecoration(
                    color: message.isMine
                        ? AppColors.black
                        : AppColors.white,
                    borderRadius: bubbleRadius,
                    border: message.isMine
                        ? null
                        : Border.all(color: AppColors.borderAlt),
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
                  const Icon(
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
      color: const Color(0xFFFAF9F9),
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
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _inputController,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _send(),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.ink,
              ),
              decoration: InputDecoration(
                hintText: 'Ketik pesan...',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
                suffixIcon: GestureDetector(
                  onTap: _openEmojiSheet,
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
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 11,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: const BorderSide(color: AppColors.borderAlt),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: const BorderSide(color: AppColors.borderAlt),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: const BorderSide(color: AppColors.ink),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: _send,
            borderRadius: BorderRadius.circular(22),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
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
