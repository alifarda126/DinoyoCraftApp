import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';

class _ChatMessage {
  const _ChatMessage({required this.text, required this.isBot});

  final String text;
  final bool isBot;
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text:
          'Halo! Aku ClayBot, asisten DinoyoCraft. Ada yang bisa dibantu hari ini?',
      isBot: true,
    ),
  ];

  static const _quickReplies = [
    'Cara pesan',
    'Status pesanan',
    'Bantuan lainnya',
  ];

  static const _scripted = {
    'Cara pesan':
        'Pilih produk di Beranda/Produk, tap tombol +, lalu selesaikan pembayaran di Checkout. Mudah!',
    'Status pesanan':
        'Untuk demo ini, status pesanan ditampilkan setelah Bayar Sekarang (snackbar sukses). Backend belum terhubung.',
    'Bantuan lainnya':
        'Kamu bisa buka tab Bantuan untuk FAQ lengkap, atau hubungi CS di hello@dinoyocraft.id.',
  };

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: trimmed, isBot: false));
      final reply = _scripted[trimmed] ??
          'Terima kasih! Tim kami akan bantu lebih lanjut. '
              'Coba quick reply di bawah atau cek tab Bantuan.';
      _messages.add(_ChatMessage(text: reply, isBot: true));
    });
    _input.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.black,
              child: SvgPicture.asset(
                AppAssets.iconChat,
                width: 16,
                height: 16,
                colorFilter:
                    const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'ClayBot',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
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
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment:
                      msg.isBot ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width * 0.78,
                    ),
                    decoration: BoxDecoration(
                      color: msg.isBot ? AppColors.inputBg : AppColors.black,
                      borderRadius: BorderRadius.circular(16).copyWith(
                        bottomLeft: msg.isBot
                            ? const Radius.circular(4)
                            : const Radius.circular(16),
                        bottomRight: msg.isBot
                            ? const Radius.circular(16)
                            : const Radius.circular(4),
                      ),
                    ),
                    child: Text(
                      msg.text,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        height: 1.45,
                        color: msg.isBot ? AppColors.ink : AppColors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickReplies.map((q) {
                return ActionChip(
                  label: Text(
                    q,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: AppColors.white,
                  side: const BorderSide(color: AppColors.border),
                  onPressed: () => _send(q),
                );
              }).toList(),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      decoration: InputDecoration(
                        hintText: 'Tulis pesan...',
                        hintStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                        filled: true,
                        fillColor: AppColors.inputBg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: _send,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: AppColors.black,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => _send(_input.text),
                      child: const SizedBox(
                        width: 48,
                        height: 48,
                        child: Icon(Icons.send, color: AppColors.white, size: 20),
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
