import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class ChatMessage {
  const ChatMessage({required this.text, required this.isMe, required this.time, this.senderName});
  final String text;
  final bool isMe;
  final String time;
  final String? senderName;
}

/// Halaman chat dengan toko.
/// Terima [storeId] dan [storeName] agar bisa dipakai untuk semua toko.
class ChatPage extends StatefulWidget {
  const ChatPage({super.key, this.storeName = 'Dinoyo Ceramic Studio', this.storeId = '1'});
  final String storeName;
  final String storeId;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _ctrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  final List<ChatMessage> _messages = const [
    ChatMessage(text: 'Ini foto kemasan standar kami kak sebelum dikirim.', isMe: false, time: '14:17', senderName: 'Dinoyo Ceramic Studio'),
    ChatMessage(text: 'Siap kak, untuk pesanan cangkir kopi handmade bisa kami proses hari ini.', isMe: false, time: 'Kemarin', senderName: 'Karya Tanah'),
    ChatMessage(text: 'Baik kak, silakan kirimkan alamat lengkap untuk cek ongkos kirim.', isMe: false, time: '18 Feb', senderName: 'Ruang Tanah'),
  ];

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    // TODO: Kirim pesan ke repository/API
    _ctrl.clear();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.ink), onPressed: () => Navigator.of(context).maybePop()),
        title: Row(children: [
          CircleAvatar(radius: 18, backgroundColor: AppColors.inputBg,
            child: const Icon(Icons.store_outlined, size: 16, color: AppColors.textMuted)),
          const SizedBox(width: 10),
          Text(widget.storeName, style: AppTextStyles.appBarTitle),
        ]),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(AppDimensions.pageHorizontal),
              itemCount: _messages.length,
              itemBuilder: (context, i) => _ChatBubble(message: _messages[i]),
            ),
          ),
          _ChatInput(controller: _ctrl, onSend: _send),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!message.isMe && message.senderName != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 4),
              child: Text(message.senderName!, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
            ),
          Container(
            margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL, vertical: AppDimensions.paddingM),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
            decoration: BoxDecoration(
              color: message.isMe ? AppColors.black : AppColors.inputBg,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(AppDimensions.radiusL),
                topRight: const Radius.circular(AppDimensions.radiusL),
                bottomLeft: Radius.circular(message.isMe ? AppDimensions.radiusL : 4),
                bottomRight: Radius.circular(message.isMe ? 4 : AppDimensions.radiusL),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message.text, style: AppTextStyles.bodySmall.copyWith(color: message.isMe ? AppColors.white : AppColors.ink)),
                const SizedBox(height: 4),
                Text(message.time, style: AppTextStyles.caption.copyWith(color: message.isMe ? AppColors.white.withValues(alpha: 0.7) : AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatInput extends StatelessWidget {
  const _ChatInput({required this.controller, required this.onSend});
  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(AppDimensions.pageHorizontal, AppDimensions.paddingS, AppDimensions.paddingS, AppDimensions.paddingS + bottomPad),
      decoration: const BoxDecoration(color: AppColors.white, border: Border(top: BorderSide(color: AppColors.border, width: 0.5))),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: controller,
            style: AppTextStyles.fieldText,
            decoration: InputDecoration(
              hintText: 'Tulis pesan...',
              hintStyle: AppTextStyles.fieldHint,
              filled: true, fillColor: AppColors.inputBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusXL), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL, vertical: 10),
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.gapS),
        Material(
          color: AppColors.black, shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onSend,
            child: const Padding(padding: EdgeInsets.all(12), child: Icon(Icons.send_rounded, size: 20, color: AppColors.white)),
          ),
        ),
      ]),
    );
  }
}
