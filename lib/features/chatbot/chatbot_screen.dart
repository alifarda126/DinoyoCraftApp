import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/app_settings.dart';
import '../../core/app_text.dart';
import '../../core/assets.dart';
import '../../core/network/api_client.dart';
import '../../core/services/auth_session.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_back_scope.dart';
import '../../core/widgets/dc_bottom_nav.dart';
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
    this.isCS = false,
    this.createdAtMs,
  });

  final String text;
  final bool isBot;
  final String time;
  final String? imagePath;

  /// True bila [imagePath] adalah file di disk (hasil kamera/galeri),
  /// false bila path aset bawaan aplikasi.
  final bool isFileImage;
  final bool isSticker;
  final bool isCS;
  final int? createdAtMs;

  Map<String, dynamic> toJson() => {
        'text': text,
        'isBot': isBot,
        'time': time,
        'imagePath': imagePath,
        'isFileImage': isFileImage,
        'isSticker': isSticker,
        'isCS': isCS,
        'createdAtMs': createdAtMs ?? DateTime.now().millisecondsSinceEpoch,
      };

  static _ChatMessage fromJson(Map<String, dynamic> map) => _ChatMessage(
        text: (map['text'] ?? '').toString(),
        isBot: map['isBot'] == true,
        time: (map['time'] ?? '').toString(),
        imagePath: map['imagePath']?.toString(),
        isFileImage: map['isFileImage'] == true,
        isSticker: map['isSticker'] == true,
        isCS: map['isCS'] == true,
        createdAtMs: map['createdAtMs'] is int
            ? map['createdAtMs'] as int
            : int.tryParse(map['createdAtMs']?.toString() ?? ''),
      );
}

/// Penyimpanan riwayat chat ClayBot selama 1x24 jam (otomatis terhapus setelah lewat 24 jam).
abstract final class _ClayBotHistoryStore {
  static const Duration ttl = Duration(hours: 24);
  static final Map<String, List<_ChatMessage>> _memoryCache = {};

  static String _scopeKey() {
    final uid = AuthSession.user?['id'] ?? AuthSession.user?['userId'];
    final cleaned = uid?.toString().trim() ?? '';
    return cleaned.isNotEmpty ? 'user_$cleaned' : 'guest';
  }

  static Future<File> _getFile(String scope) async {
    final fileName = 'dinoyocraft_claybot_history_$scope.json';
    try {
      final docDir = await getApplicationDocumentsDirectory();
      return File('${docDir.path}/$fileName');
    } catch (_) {
      try {
        final supportDir = await getApplicationSupportDirectory();
        return File('${supportDir.path}/$fileName');
      } catch (_) {
        return File('${Directory.systemTemp.path}/$fileName');
      }
    }
  }

  static List<_ChatMessage> _filterNotExpired(List<_ChatMessage> items) {
    final cutoffMs = DateTime.now().subtract(ttl).millisecondsSinceEpoch;
    return items.where((m) {
      final ts = m.createdAtMs ?? 0;
      if (ts <= cutoffMs) return false;
      if (m.isFileImage && m.imagePath != null && m.imagePath!.isNotEmpty) {
        if (!kIsWeb && !File(m.imagePath!).existsSync()) return false;
      }
      return true;
    }).toList();
  }

  static List<_ChatMessage>? getCachedSync() {
    final scope = _scopeKey();
    final cached = _memoryCache[scope];
    if (cached == null) return null;
    final fresh = _filterNotExpired(cached);
    if (fresh.isEmpty) {
      _memoryCache.remove(scope);
      return null;
    }
    _memoryCache[scope] = fresh;
    return List<_ChatMessage>.from(fresh);
  }

  static Future<List<_ChatMessage>> load() async {
    final scope = _scopeKey();
    if (kIsWeb) {
      return getCachedSync() ?? [];
    }
    try {
      final file = await _getFile(scope);
      if (!await file.exists()) {
        return getCachedSync() ?? [];
      }
      final raw = await file.readAsString();
      if (raw.trim().isEmpty) return [];
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return [];
      final savedAtMs = decoded['updated_at_ms'] is int
          ? decoded['updated_at_ms'] as int
          : int.tryParse(decoded['updated_at_ms']?.toString() ?? '') ?? 0;
      final cutoffMs = DateTime.now().subtract(ttl).millisecondsSinceEpoch;
      if (savedAtMs <= cutoffMs) {
        _memoryCache.remove(scope);
        await file.delete().catchError((_) => file);
        return [];
      }
      final rawList = decoded['messages'];
      if (rawList is! List) return [];
      final parsed = rawList
          .whereType<Map>()
          .map((m) => _ChatMessage.fromJson(Map<String, dynamic>.from(m)))
          .toList();
      final fresh = _filterNotExpired(parsed);
      if (fresh.isEmpty) {
        _memoryCache.remove(scope);
        await file.delete().catchError((_) => file);
        return [];
      }
      _memoryCache[scope] = fresh;
      return List<_ChatMessage>.from(fresh);
    } catch (e) {
      debugPrint('[ClayBotHistory] Gagal membaca riwayat: $e');
      return getCachedSync() ?? [];
    }
  }

  static Future<void> save(List<_ChatMessage> messages) async {
    final scope = _scopeKey();
    final fresh = _filterNotExpired(messages);
    if (fresh.isEmpty) {
      _memoryCache.remove(scope);
      if (!kIsWeb) {
        try {
          final file = await _getFile(scope);
          if (await file.exists()) await file.delete();
        } catch (_) {}
      }
      return;
    }

    _memoryCache[scope] = List<_ChatMessage>.from(fresh);
    if (kIsWeb) return;
    try {
      final file = await _getFile(scope);
      final parent = file.parent;
      if (!parent.existsSync()) {
        parent.createSync(recursive: true);
      }
      final payload = {
        'updated_at_ms': DateTime.now().millisecondsSinceEpoch,
        'expires_at': DateTime.now().add(ttl).toIso8601String(),
        'messages': fresh.map((m) => m.toJson()).toList(),
      };
      await file.writeAsString(jsonEncode(payload), flush: true);
    } catch (e) {
      debugPrint('[ClayBotHistory] Gagal menyimpan riwayat: $e');
    }
  }
}

String _nowTime() {
  final now = DateTime.now();
  return '${now.hour.toString().padLeft(2, '0')}:'
      '${now.minute.toString().padLeft(2, '0')}';
}

// ─── Quick replies sesuai Proto_Final/Chatbot.png ─────────────────────────────
const _quickReplies = [
  ('💬', 'Chat dengan customer service langsung'),
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
  'Chat dengan customer service langsung':
      'Menghubungkan kamu ke Customer Service DinoyoCraft... Mohon tunggu sebentar ya.',
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
  final bool _isCSConnected = false;
  bool _isBotTyping = false;

  late final List<_ChatMessage> _messages = _buildInitialMessages();

  _ChatMessage _greetingMessage() => _ChatMessage(
        text: ('Halo! 👋\n\nSaya ClayBot, asisten DinoyoCraft. '
            'Saya siap membantu kamu menemukan produk keramik lokal, '
            'mencari studio toko, info jadwal workshop, hingga bantuan pesananmu.').tr,
        isBot: true,
        createdAtMs: DateTime.now().millisecondsSinceEpoch,
      );

  List<_ChatMessage> _buildInitialMessages() {
    final cached = _ClayBotHistoryStore.getCachedSync();
    if (cached != null && cached.isNotEmpty) {
      if (cached.any((m) => !m.isBot)) {
        _showQuickReplies = false;
      }
      return cached;
    }
    return [_greetingMessage()];
  }

  @override
  void initState() {
    super.initState();
    _restoreSavedHistory();
  }

  Future<void> _restoreSavedHistory() async {
    final saved = await _ClayBotHistoryStore.load();
    if (!mounted || saved.isEmpty) return;
    // Jangan timpa bila user sudah mulai mengetik/kirim pesan sebelum load disk selesai
    if (_messages.any((m) => !m.isBot)) return;
    setState(() {
      _messages
        ..clear()
        ..addAll(saved);
      if (saved.any((m) => !m.isBot)) {
        _showQuickReplies = false;
      }
    });
    _scrollToBottom();
  }

  void _persistMessages() {
    // Hanya simpan ke disk bila sudah ada interaksi user (bukan cuma salam awal)
    if (_messages.any((m) => !m.isBot)) {
      unawaited(_ClayBotHistoryStore.save(_messages));
    }
  }

  @override
  void dispose() {
    _persistMessages();
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _connectToRealCS() async {
    if (!AuthSession.isLoggedIn) {
      if (!mounted) return;
      setState(() {
        _isBotTyping = false;
        _messages.add(
          _ChatMessage(
            text:
                'Untuk terhubung langsung dengan Customer Service DinoyoCraft secara realtime, silakan masuk ke akun kamu terlebih dahulu ya 😊'
                    .tr,
            isBot: true,
            time: _nowTime(),
            createdAtMs: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      });
      _persistMessages();
      _scrollToBottom();
      return;
    }

    setState(() => _isBotTyping = true);
    try {
      final res = await ApiClient.get('/chat/cs-agent');
      final data = res['data'] as Map<String, dynamic>?;
      final csId = data?['id']?.toString() ?? '';
      const csName = 'Customer Service';

      if (!mounted) return;
      setState(() => _isBotTyping = false);

      if (csId.isNotEmpty) {
        final router = GoRouter.of(context);
        Navigator.of(context).pop();
        final uri = Uri(
          path: '/chat-room',
          queryParameters: {
            'store': csName,
            'userId': csId,
            'isCs': '1',
            'direct': '1',
          },
        );
        router.push(uri.toString());
        return;
      }
    } catch (_) {
      if (mounted) setState(() => _isBotTyping = false);
    }

    if (!mounted) return;
    setState(() {
      _messages.add(
        _ChatMessage(
          text:
              'Maaf, layanan Live Chat CS sedang tidak terjangkau saat ini. Silakan hubungi csdinoyocraft@gmail.com atau coba sesaat lagi ya.'
                  .tr,
          isBot: true,
          time: _nowTime(),
          createdAtMs: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    });
    _persistMessages();
    _scrollToBottom();
  }

  Future<void> _send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _isBotTyping) return;
    final t = _nowTime();

    final isCSRequest = trimmed == 'Chat dengan customer service langsung' ||
        trimmed.toLowerCase().contains('customer service') ||
        trimmed.toLowerCase().contains('cs langsung') ||
        trimmed.toLowerCase() == 'cs';

    final historyPayload = _messages
        .where((m) => m.text.trim().isNotEmpty)
        .skip(_messages.length > 8 ? _messages.length - 8 : 0)
        .map((m) => {
              'role': m.isBot ? 'assistant' : 'user',
              'content': m.text.trim(),
            })
        .toList();

    setState(() {
      _showQuickReplies = false;
      _messages.add(_ChatMessage(
        text: trimmed,
        isBot: false,
        time: t,
        createdAtMs: DateTime.now().millisecondsSinceEpoch,
      ));
    });
    _persistMessages();
    _input.clear();
    _scrollToBottom();

    if (isCSRequest) {
      await _connectToRealCS();
      return;
    }

    setState(() => _isBotTyping = true);
    try {
      final res = await ApiClient.post('/ai/chat', {
        'message': trimmed,
        'locale': AppSettings.instance.locale == 'en' ? 'en' : 'id',
        'role_context': 'claybot',
        'save_to_chat': false,
        'history': historyPayload,
      });
      final reply = (res['data']?['reply'] ?? '').toString().trim();
      if (!mounted) return;
      setState(() {
        _isBotTyping = false;
        _messages.add(
          _ChatMessage(
            text: reply.isNotEmpty
                ? reply
                : (_scripted[trimmed] ??
                    'Ada produk keramik spesifik yang sedang ingin kamu cari hari ini?'),
            isBot: true,
            time: _nowTime(),
            createdAtMs: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      });
      _persistMessages();
      _scrollToBottom();
    } catch (_) {
      if (!mounted) return;
      final fallback = _scripted[trimmed] ??
          'Halo! Saat ini koneksi ClayBot sedang sibuk, namun kamu bisa menjelajahi koleksi keramik di tab Produk, Toko, atau pilih "Chat dengan customer service langsung" ya 😊';
      setState(() {
        _isBotTyping = false;
        _messages.add(
          _ChatMessage(
            text: fallback,
            isBot: true,
            time: _nowTime(),
            createdAtMs: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      });
      _persistMessages();
      _scrollToBottom();
    }
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
        createdAtMs: DateTime.now().millisecondsSinceEpoch,
      ));
    });
    _persistMessages();
    _scrollToBottom();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _messages.add(_ChatMessage(
          text: _isCSConnected
              ? 'Terima kasih Kak, foto produknya sudah kami terima! Tim Customer Service sedang memeriksanya.'.tr
              : 'Terima kasih, foto produknya sudah kami terima! '
                  'Ada yang ingin ditanyakan tentang produk pada gambar ini?',
          isBot: true,
          isCS: _isCSConnected,
          time: _nowTime(),
          createdAtMs: DateTime.now().millisecondsSinceEpoch,
        ));
      });
      _persistMessages();
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
      _showQuickReplies = false;
      _messages.add(
        _ChatMessage(
          text: '',
          isBot: false,
          time: _nowTime(),
          imagePath: sticker.assetPath,
          isSticker: true,
          createdAtMs: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    });
    _persistMessages();
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
            createdAtMs: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      });
      _persistMessages();
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
    final gestureNavBar = DcBottomNav.systemNavInset(context);
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
                          _isCSConnected
                              ? AppAssets.iconFloatingCS
                              : AppAssets.iconBot,
                          width: _isCSConnected ? 22 : 24,
                          height: _isCSConnected ? 22 : 24,
                          colorFilter: const ColorFilter.mode(
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
                          color: const Color(0xFF22C55E),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isCSConnected ? 'Customer Service' : 'ClayBot',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      Text(
                        _isCSConnected
                            ? 'Tim DinoyoCraft • Siap membantu'.tr
                            : 'Asisten DinoyoCraft'.tr,
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
              itemCount: _messages.length + (_isBotTyping ? 1 : 0),
              itemBuilder: (context, i) {
                if (i == _messages.length) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'ClayBot sedang mengetik...'.tr,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textMuted,
                      ),
                    ),
                  );
                }
                final msg = _messages[i];
                return _buildMessage(context, msg);
              },
            ),
          ),

          // ── quick replies / rekomendasi saat di mulai & saat di chat ───────────
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
            )
          else if (!_isCSConnected)
            // Rekomendasi bubble chat CS saat di dalam chat
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => _send('Chat dengan customer service langsung'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.border,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '💬 ${'Chat dengan customer service langsung'.tr}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ),
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
                // Keyboard inset ATAU system nav bar (mendukung penuh navigasi 3 tombol)
                10 + (bottomInset > 0
                    ? bottomInset.clamp(0.0, 400.0)
                    : gestureNavBar.clamp(0.0, 84.0))),
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
                  'ClayBot memiliki batasan tertentu, cerdaslah dalam bertanya...'.tr,
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
            // Bot / CS avatar kecil
            Container(
              width: 32,
              height: 32,
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
                  msg.isCS ? AppAssets.iconFloatingCS : AppAssets.iconBot,
                  width: msg.isCS ? 18 : 16,
                  height: msg.isCS ? 18 : 16,
                  colorFilter: const ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Bot / CS bubble
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (msg.isCS)
                    Padding(
                      padding: const EdgeInsets.only(left: 2, bottom: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Customer Service',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF22C55E),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Online',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF22C55E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.isDark
                          ? const Color(0xFF333336)
                          : AppColors.surfaceSubtle,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      border: Border.all(
                        color: AppColors.isDark
                            ? Colors.white.withValues(alpha: 0.16)
                            : AppColors.border.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      msg.text.tr,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        height: 1.5,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40),
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
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(4),
                        ),
                        border: AppColors.isDark
                            ? Border.all(
                                color: Colors.white.withValues(alpha: 0.35),
                                width: 1.2,
                              )
                            : null,
                        boxShadow: AppColors.darkButtonShadow,
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
