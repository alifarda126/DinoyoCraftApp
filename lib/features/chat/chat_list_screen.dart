import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_text.dart';
import '../../core/assets.dart';
import '../../core/network/api_client.dart';
import '../../core/services/auth_session.dart';
import '../../core/services/pusher_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_back_scope.dart';
import '../../core/widgets/dc_cached_image.dart';
import '../../data/mock_data.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  static const Color _onlineGreen = Color(0xFF059669);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<_ChatData> _serverChats = [];
  bool _loading = false;
  StreamSubscription? _msgSub;

  @override
  void initState() {
    super.initState();
    if (AuthSession.isLoggedIn) {
      _loading = true;
      _fetchContacts();
    }
    _msgSub = PusherService.instance.messageStream.listen((_) {
      if (AuthSession.isLoggedIn && mounted) {
        _fetchContacts();
      }
    });
  }

  @override
  void dispose() {
    _msgSub?.cancel();
    super.dispose();
  }

  Future<void> _fetchContacts() async {
    if (!AuthSession.isLoggedIn) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final res = await ApiClient.get('/chat/contacts');
      final rows = res['data'];
      if (rows is List) {
        final maps = rows
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();

        // Normalisasi display name agar sinkron dengan MockData.syncUnreadChatFromContacts
        final normalizedForSync = <Map<String, dynamic>>[];
        final parsed = <_ChatData>[];

        for (final c in maps) {
          final rawStore = (c['store_name'] ?? '').toString().trim();
          final rawName = (c['name'] ?? '').toString().trim();
          final role = (c['role'] ?? '').toString().trim().toLowerCase();
          final lastMsg = (c['last_message'] ?? '').toString().trim();
          final displayName = rawStore.isNotEmpty
              ? rawStore
              : (rawName.isNotEmpty ? rawName : 'Pengrajin Dinoyo');

          normalizedForSync.add({
            'store_name': displayName,
            'unread_count': c['unread_count'] ?? 0,
          });

          if (role != 'mitra' && rawStore.isEmpty && lastMsg.isEmpty) {
            continue;
          }

          final rawUnread = c['unread_count'] ?? 0;
          final unreadCount = rawUnread is num
              ? rawUnread.toInt()
              : int.tryParse('$rawUnread') ?? 0;
          final rawAvatar = c['avatar_url']?.toString().trim();
          final avatarUrl = (rawAvatar != null &&
                  rawAvatar.isNotEmpty &&
                  rawAvatar != 'null')
              ? ApiClient.resolveImageUrl(rawAvatar)
              : null;

          parsed.add(
            _ChatData(
              userId: c['id']?.toString(),
              store: displayName,
              time: _formatChatTime(c['last_message_time']?.toString()),
              preview: lastMsg.isNotEmpty
                  ? lastMsg
                  : 'Mulai obrolan dengan $displayName',
              image: AppAssets.storeDinoyo,
              avatarUrl: avatarUrl,
              unread: unreadCount > 0,
              unreadCount: unreadCount,
              online: role == 'mitra',
              contextLabel: role == 'mitra' ? 'Pengrajin DinoyoCraft' : 'Pesan',
            ),
          );
        }

        MockData.syncUnreadChatFromContacts(normalizedForSync);
        if (mounted) {
          setState(() {
            _serverChats = parsed;
            _loading = false;
          });
          return;
        }
      }
    } catch (_) {
      // Fallback ke daftar lokal bila jaringan offline.
    }
    if (mounted) setState(() => _loading = false);
  }

  String _formatChatTime(String? iso) {
    if (iso == null || iso.trim().isEmpty || iso.trim() == 'null') return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final targetDay = DateTime(dt.year, dt.month, dt.day);
      final diffDays = today.difference(targetDay).inDays;
      String two(int v) => v.toString().padLeft(2, '0');
      if (diffDays == 0) {
        return '${two(dt.hour)}:${two(dt.minute)}';
      }
      if (diffDays == 1) {
        return 'Kemarin';
      }
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
      ];
      return '${dt.day} ${months[dt.month - 1]}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = AuthSession.isLoggedIn ? _serverChats : _chats;

    return AppBackScope(
      fallbackRoute: '/home',
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxHeight < 54 || constraints.maxWidth < 96) {
                return const SizedBox.shrink();
              }
              return Column(
                children: [
                  SizedBox(
                    height: 54,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/home');
                            }
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 19,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Pesan'.tr,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _loading && items.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ValueListenableBuilder<int>(
                            valueListenable: MockData.unreadChatNotifier,
                            builder: (context, unreadCount, child) {
                              if (items.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Text(
                                      'Belum ada percakapan dengan toko.'.tr,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return RefreshIndicator(
                                onRefresh: _fetchContacts,
                                color: AppColors.ink,
                                child: ListView.separated(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 6, 20, 30),
                                  itemCount: items.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, i) => _ChatCard(
                                    chat: items[i],
                                    onTap: () {
                                      if (AuthSession.isLoggedIn) {
                                        _fetchContacts();
                                      } else if (mounted) {
                                        setState(() {});
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
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
    this.userId,
    this.avatarUrl,
    this.unread = false,
    this.unreadCount = 0,
    this.online = false,
    this.productChip,
    this.productImage,
    this.contextLabel,
  });

  final String? userId;
  final String store;
  final String time;
  final String preview;
  final String image;
  final String? avatarUrl;
  final bool unread;
  final int unreadCount;
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
  const _ChatCard({required this.chat, this.onTap});

  final _ChatData chat;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark || AppColors.isDark;
    final isUnread = MockData.isChatUnread(chat.store);

    final Color borderColor;
    final double borderWidth;
    final List<BoxShadow>? boxShadow;

    if (isUnread) {
      if (isDark) {
        // Mode gelap: border dibuat lebih terang dari chat lain (borderAlt) + glow halus
        borderColor = Colors.white.withValues(alpha: 0.75);
        borderWidth = 1.3;
        boxShadow = [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.12),
            blurRadius: 8,
            spreadRadius: 0.5,
          ),
        ];
      } else {
        borderColor = AppColors.black;
        borderWidth = 1.2;
        boxShadow = null;
      }
    } else {
      // Chat sudah dibaca: warna sama dengan chat lainnya
      borderColor = AppColors.borderAlt;
      borderWidth = 1.0;
      boxShadow = null;
    }

    final badgeUnreadCount =
        MockData.unreadChatCountByStore[chat.store.trim().toLowerCase()] ??
            (isUnread ? (chat.unreadCount > 0 ? chat.unreadCount : 1) : 0);

    return InkWell(
      onTap: () async {
        MockData.markChatAsRead(chat.store);
        onTap?.call();
        final uri = Uri(
          path: '/chat-room',
          queryParameters: {
            'store': chat.store,
            if (chat.userId != null && chat.userId!.isNotEmpty)
              'userId': chat.userId!,
          },
        );
        await context.push(uri.toString());
        if (context.mounted) {
          onTap?.call();
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
          boxShadow: boxShadow,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar + online dot
            Stack(
              clipBehavior: Clip.none,
              children: [
                if (chat.avatarUrl != null && chat.avatarUrl!.startsWith('http'))
                  ClipOval(
                    child: DcCachedImage(
                      imageUrl: chat.avatarUrl!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  )
                else
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
                      if (isUnread) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white : AppColors.black,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            badgeUnreadCount > 99 ? '99+' : '$badgeUnreadCount',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color:
                                  isDark ? AppColors.black : AppColors.white,
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
                          color: isUnread
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
                      if (isUnread)
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
                            color: isUnread
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
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(6, 4, 10, 4),
                            decoration: BoxDecoration(
                              color: AppColors.inputBg,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.borderAlt),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
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
                              Flexible(
                                child: Text(
                                  chat.productChip!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              ],
                            ),
                          ),
                        ),
                      ] else if (chat.contextLabel != null &&
                          chat.contextLabel!.isNotEmpty)
                        Flexible(
                          child: Text(
                            chat.contextLabel!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
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
