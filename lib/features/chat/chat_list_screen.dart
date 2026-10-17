import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';

class ChatListScreen extends StatelessWidget {
const   ChatListScreen({super.key});

  static const Color _onlineGreen = Color(0xFF059669);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 54,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 19,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Pesan',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 30),
                itemCount: _chats.length,
                separatorBuilder: (_, _) => SizedBox(height: 12),
                itemBuilder: (context, i) => _ChatCard(chat: _chats[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatData {
  const _ChatData({
    required this.store,
    required this.time,
    required this.preview,
    required this.image,
    this.unread = false,
    this.online = false,
    this.productChip,
    this.productImage,
    this.contextLabel,
  });

  final String store;
  final String time;
  final String preview;
  final String image;
  final bool unread;
  final bool online;
  final String? productChip;
  final String? productImage;
  final String? contextLabel;
}

const List<_ChatData> _chats = [
  _ChatData(
    store: 'Dinoyo Ceramic Studio',
    time: '14:17',
    preview: 'Ini foto kemasan standar kami kak sebelum dikirim.',
    image: AppAssets.storeDinoyo,
    online: true,
    productChip: 'Vas Keramik Minimalis',
    productImage: AppAssets.productVas,
  ),
  _ChatData(
    store: 'Karya Tanah',
    time: 'Kemarin',
    preview:
        'Siap kak, untuk pesanan cangkir kopi handmade bisa kami proses hari ini.',
    image: AppAssets.storeRuangTanah,
    online: true,
    unread: true,
    productChip: 'Cangkir Kopi Handmade',
    productImage: AppAssets.productCangkir,
  ),
  _ChatData(
    store: 'Ruang Tanah',
    time: '18 Feb',
    preview:
        'Baik kak, silakan kirimkan alamat lengkap untuk cek ongkos kirim kayu.',
    image: AppAssets.storeRuangTanah,
    contextLabel: 'Diskusi Pengiriman Khusus',
  ),
  _ChatData(
    store: 'Dinoyo Craft House',
    time: '14 Feb',
    preview:
        'Halo, untuk paket workshop keramik akhir pekan masih ada 2 slot ya kak.',
    image: AppAssets.storeDinoyo,
    productChip: 'Wisata Edukasi Keramik',
    productImage: AppAssets.workshopHero,
  ),
];

class _ChatCard extends StatelessWidget {
  const _ChatCard({required this.chat});

  final _ChatData chat;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          () => context.push('/chat-room?store=${Uri.encodeComponent(chat.store)}'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: chat.unread ? AppColors.black : AppColors.borderAlt,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar + online dot
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(chat.image),
                ),
                if (chat.online)
                  Positioned(
                    right: -1,
                    bottom: -1,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: ChatListScreen._onlineGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
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
                  // Name + time (+ unread badge)
                  Row(
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                chat.store,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.verified_rounded,
                              size: 14,
                              color: AppColors.ink,
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      if (chat.unread) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.black,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '1',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                      ],
                      Text(
                        chat.time,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: chat.unread
                              ? AppColors.ink
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  // Preview
                  Row(
                    children: [
                      if (chat.unread)
                        Icon(
                          Icons.done_all_rounded,
                          size: 13,
                          color: AppColors.ink,
                        )
                      else
                        Icon(
                          Icons.done_all_rounded,
                          size: 13,
                          color: AppColors.textMuted,
                        ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          chat.preview,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: chat.unread
                                ? AppColors.ink
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Product chip / context label + chevron
                  Row(
                    children: [
                      if (chat.productChip != null) ...[
                        Container(
                          padding: const EdgeInsets.fromLTRB(6, 4, 10, 4),
                          decoration: BoxDecoration(
                            color: AppColors.inputBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.borderAlt),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.asset(
                                  chat.productImage!,
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 6),
                              Text(
                                chat.productChip!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF4C4546),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else
                        Text(
                          chat.contextLabel!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      Spacer(),
                      Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: AppColors.textMuted,
                      ),
                    ],
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
