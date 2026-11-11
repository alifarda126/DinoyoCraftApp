import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../data/mock_data.dart';
import '../models/fcm_notification_model.dart';
import '../network/api_client.dart';
import '../storage/local_storage.dart';

/// Handler tingkat atas untuk notifikasi FCM saat aplikasi berada di
/// latar belakang (background) atau ditutup (terminated).
/// Harus berupa fungsi top-level dan di-annotasi `@pragma('vm:entry-point')`.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
  } catch (_) {}
  debugPrint(
    '[FCM Background] Notifikasi masuk: ${message.messageId} | ${message.notification?.title}: ${message.notification?.body}',
  );
}

/// Service singleton untuk mengelola Push Notifications menggunakan
/// Firebase Cloud Messaging (FCM).
/// Terintegrasi dengan Backend DinoyoCraft untuk pengiriman notifikasi pesanan & obrolan.
class FcmService {
  FcmService._internal();

  /// Plugin notifikasi TRAY asli — dipakai saat app di FOREGROUND
  /// (FCM tidak otomatis menampilkan notifikasi sistem pada mode ini).
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  bool _localNotifInitialized = false;
  static final FcmService instance = FcmService._internal();

  bool _isInitialized = false;
  String? _deviceToken;
  void Function(String route)? _notificationRouteHandler;

  final Map<String, DateTime> _recentNotifDedup = {};
  final List<FcmNotificationModel> _notificationsHistory = [];

  /// Daftarkan callback navigasi saat notifikasi tray diketuk pengguna.
  void setNotificationRouteHandler(void Function(String route)? handler) {
    _notificationRouteHandler = handler;
  }

  /// Helper untuk memvalidasi apakah RemoteMessage layak ditampilkan di tray/banner.
  @visibleForTesting
  bool shouldDisplayRemoteMessage(RemoteMessage message) =>
      _hasDisplayableContent(message);

  /// Membangun konfigurasi Android tray notification agar seragam dan dapat diuji.
  @visibleForTesting
  AndroidNotificationDetails buildAndroidNotificationDetails(
    FcmNotificationModel model,
  ) {
    final hasBody = model.body.trim().isNotEmpty;
    return AndroidNotificationDetails(
      'dinoyocraft_channel',
      'Notifikasi DinoyoCraft',
      channelDescription: 'Update pesanan, pembayaran, chat, dan promo DinoyoCraft',
      icon: '@drawable/ic_stat_dinoyocraft',
      importance: Importance.max,
      priority: Priority.high,
      visibility: NotificationVisibility.public,
      playSound: true,
      enableVibration: true,
      ticker: model.title,
      styleInformation: hasBody ? BigTextStyleInformation(model.body) : null,
    );
  }

  final StreamController<RemoteMessage> _foregroundMessageController =
      StreamController<RemoteMessage>.broadcast();
  final StreamController<RemoteMessage> _messageOpenedController =
      StreamController<RemoteMessage>.broadcast();
  final StreamController<FcmNotificationModel> _notificationModelController =
      StreamController<FcmNotificationModel>.broadcast();

  /// Riwayat notifikasi yang diterima selama aplikasi aktif.
  List<FcmNotificationModel> get notificationsHistory =>
      List.unmodifiable(_notificationsHistory);

  /// Stream pesan notifikasi yang diterima saat aplikasi sedang terbuka (foreground).
  Stream<RemoteMessage> get foregroundMessageStream =>
      _foregroundMessageController.stream;

  /// Stream model notifikasi terstruktur untuk UI Banner in-app.
  Stream<FcmNotificationModel> get notificationModelStream =>
      _notificationModelController.stream;

  /// Stream notifikasi yang diketuk/dibuka oleh pengguna dari system tray.
  Stream<RemoteMessage> get messageOpenedStream =>
      _messageOpenedController.stream;

  /// Token FCM perangkat saat ini (digunakan BE untuk target kirim notifikasi).
  String? get deviceToken => _deviceToken;

  /// Status apakah FCM berhasil diinisialisasi.
  bool get isInitialized => _isInitialized;

  /// Inisialisasi Firebase & FCM.
  /// Berjalan secara safe (aman bila google-services.json belum dipasang).
  Future<void> initialize({
    bool autoRequestPermission = true,
    void Function(RemoteMessage)? onNotificationClick,
  }) async {
    if (_isInitialized) return;

    try {
      // 1. Pastikan Firebase Core telah diinisialisasi
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }

      // 2. Daftarkan background & local tray notification channel lebih awal
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      await _ensureLocalNotifications();

      // 3. Minta izin notifikasi (Android 13+ & iOS)
      if (autoRequestPermission) {
        await requestNotificationPermission();
      }

      // 4. Dengarkan pendaftaran token / FID FCM (rekomendasi firebase_messaging modern)
      FirebaseMessaging.instance.onRegistered.listen((newToken) {
        _deviceToken = newToken;
        debugPrint('[FCM] Token/FID Terdaftar: $newToken');
        syncTokenWithBackend(newToken);
      });

      // Daftarkan instance FCM ke service
      try {
        await FirebaseMessaging.instance.register();
      } catch (_) {}

      // Ambil token perangkat
      try {
        // ignore: deprecated_member_use
        _deviceToken = await FirebaseMessaging.instance.getToken();
      } catch (_) {}
      debugPrint('[FCM] Device Token: $_deviceToken');

      // Cold-start: pastikan token terdaftar di backend bila sesi aktif
      // (token FCM bisa berotasi saat aplikasi tidak berjalan).
      if (LocalStorage.isLoggedIn) {
        unawaited(syncTokenWithBackend(_deviceToken));
      }

      // 5. Tangani notifikasi saat aplikasi berada di latar depan (foreground)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (!_hasDisplayableContent(message)) {
          debugPrint(
            '[FCM Foreground] Mengabaikan pesan kosong tanpa judul/isi (messageId=${message.messageId}, data=${message.data})',
          );
          return;
        }
        debugPrint(
          '[FCM Foreground] Pesan: ${message.notification?.title} - ${message.notification?.body}',
        );
        final model = FcmNotificationModel.fromRemoteMessage(message);

        // Deduplikasi bila Pusher realtime lebih dulu memicu notifikasi yang sama
        final dedupKey = _buildDedupKeyFromData(model.category, message.data);
        final isDup = dedupKey != null && _isRecentlyHandled(dedupKey);
        if (dedupKey != null) {
          _markHandled(dedupKey);
        }

        if (!isDup) {
          // Jangan tampilkan banner/tray chat jika user sedang membuka room yg sama
          final senderId = message.data['sender_id']?.toString().trim();
          final storeName = (message.data['store_name'] ?? message.data['sender_name'])
              ?.toString()
              .trim();
          final suppressActiveChat =
              model.category == FcmNotificationCategory.chat &&
              _isViewingActiveChat(storeName: storeName, userId: senderId);

          if (!suppressActiveChat) {
            unawaited(_showTrayNotification(model));
            _notificationsHistory.insert(0, model);
            _notificationModelController.add(model);
          }

          if (model.category == FcmNotificationCategory.chat) {
            if (!suppressActiveChat) {
              MockData.recordIncomingUnreadChat(storeName ?? '');
            }
          } else {
            MockData.incrementUnreadNotifications();
          }
        }

        _foregroundMessageController.add(message);
        unawaited(MockData.refreshUnreadCounts());
      });

      // 6. Tangani saat pengguna mengetuk notifikasi dari system tray
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('[FCM Opened] Pengguna membuka notifikasi: ${message.data}');
        _messageOpenedController.add(message);
        onNotificationClick?.call(message);
      });

      // 7. Periksa apakah aplikasi dibuka dari kondisi terminated lewat notifikasi
      final initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        debugPrint(
          '[FCM Initial] Dibuka dari terminated state: ${initialMessage.data}',
        );
        _messageOpenedController.add(initialMessage);
        onNotificationClick?.call(initialMessage);
      }

      _isInitialized = true;
      debugPrint('[FCM] Firebase Cloud Messaging berhasil aktif!');
    } catch (e) {
      debugPrint(
        '[FCM] Firebase/FCM belum aktif (safe fallback untuk mode dev/lokal): $e',
      );
    }
  }

  /// Memancarkan notifikasi secara manual / simulasi untuk testing UI.
  void emitNotification(FcmNotificationModel model) {
    _notificationsHistory.insert(0, model);
    _notificationModelController.add(model);
  }

  /// Simulasi notifikasi update status pesanan.
  void simulateOrderNotification({
    String orderId = 'DNC-001',
    String productName = 'Vas Keramik Minimalis',
  }) {
    emitNotification(
      FcmNotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Pesanan #$orderId Sedang Dikirim! 🚚',
        body:
            'Paket $productName buatan pengrajin Dinoyo telah diserahkan ke pihak ekspedisi.',
        category: FcmNotificationCategory.transaction,
        createdAt: DateTime.now(),
        route: '/profile',
        data: {'type': 'order', 'order_id': orderId},
      ),
    );
  }

  /// Simulasi notifikasi chat masuk dari toko.
  void simulateChatNotification({
    String storeName = 'Dinoyo Ceramic Studio',
    String message =
        'Halo Kak! Stok keramik glasir putih glossy sudah siap dikemas hari ini ya.',
  }) {
    emitNotification(
      FcmNotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Pesan Baru dari $storeName 💬',
        body: message,
        category: FcmNotificationCategory.chat,
        createdAt: DateTime.now(),
        route: Uri(
          path: '/chat-room',
          queryParameters: {'store': storeName},
        ).toString(),
        data: {'type': 'chat', 'store_name': storeName},
      ),
    );
  }

  /// Simulasi notifikasi promo & voucher diskon.
  void simulatePromoNotification({
    String title = 'Voucher Diskon Spesial 25%! 🏷️',
    String body =
        'Klaim diskon akhir pekan untuk tembikar & keramik artisan Kampung Dinoyo.',
  }) {
    emitNotification(
      FcmNotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        body: body,
        category: FcmNotificationCategory.promo,
        createdAt: DateTime.now(),
        route: '/products',
        data: {'type': 'promo'},
      ),
    );
  }

  /// Meminta izin notifikasi kepada pengguna (wajib untuk iOS dan Android 13+).
  Future<NotificationSettings?> requestNotificationPermission() async {
    try {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } catch (_) {}

    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      debugPrint(
        '[FCM] Status Izin Notifikasi: ${settings.authorizationStatus}',
      );
      return settings;
    } catch (e) {
      debugPrint('[FCM] Gagal meminta izin notifikasi: $e');
      return null;
    }
  }

  /// Mengambil FCM Device Token terkini.
  /// Abaikan broadcast FCM kosong/internal yang tidak membawa judul maupun isi.
  bool _hasDisplayableContent(RemoteMessage message) {
    final title = message.notification?.title?.trim() ?? '';
    final body = message.notification?.body?.trim() ?? '';
    if (title.isNotEmpty || body.isNotEmpty) return true;

    for (final key in const ['title', 'body', 'message', 'text', 'alert']) {
      final val = message.data[key]?.toString().trim() ?? '';
      if (val.isNotEmpty) return true;
    }
    return false;
  }

  bool _isViewingActiveChat({String? storeName, String? userId}) {
    final activeId = MockData.activeChatUserId?.trim();
    if (activeId != null &&
        activeId.isNotEmpty &&
        userId != null &&
        userId.trim().isNotEmpty &&
        activeId == userId.trim()) {
      return true;
    }
    final activeStore = MockData.activeChatStoreName?.trim().toLowerCase();
    final targetStore = storeName?.trim().toLowerCase();
    return activeStore != null &&
        activeStore.isNotEmpty &&
        targetStore != null &&
        targetStore.isNotEmpty &&
        activeStore == targetStore;
  }

  String? _buildDedupKeyFromData(
    FcmNotificationCategory category,
    Map<String, dynamic> data,
  ) {
    if (category == FcmNotificationCategory.transaction) {
      final orderId = (data['order_id'] ?? data['orderId'] ?? '').toString().trim();
      final status = (data['status'] ?? '').toString().trim().toLowerCase();
      if (orderId.isNotEmpty && status.isNotEmpty) {
        return 'order:$orderId:$status';
      }
    } else if (category == FcmNotificationCategory.chat) {
      final msgId = (data['message_id'] ?? data['id'] ?? '').toString().trim();
      if (msgId.isNotEmpty) {
        return 'chat:$msgId';
      }
    }
    return null;
  }

  bool _isRecentlyHandled(String key) {
    final now = DateTime.now();
    _recentNotifDedup.removeWhere((_, ts) => now.difference(ts).inSeconds > 20);
    final ts = _recentNotifDedup[key];
    return ts != null && now.difference(ts).inSeconds <= 20;
  }

  void _markHandled(String key) {
    _recentNotifDedup[key] = DateTime.now();
  }

  int _resolveTrayNotificationId(FcmNotificationModel model) {
    final orderId = (model.data['order_id'] ?? model.data['orderId'] ?? '')
        .toString()
        .trim();
    final status = (model.data['status'] ?? '').toString().trim().toLowerCase();
    if (orderId.isNotEmpty && status.isNotEmpty) {
      return 'order_${orderId}_$status'.hashCode & 0x7fffffff;
    }
    return model.id.hashCode & 0x7fffffff;
  }

  /// Tampilkan notifikasi tray + banner in-app untuk event status pesanan realtime
  /// (fallback bila Pusher lebih dulu tiba atau FCM tertunda saat app foreground).
  Future<void> showOrderStatusNotificationFromRealtime(
    Map<String, dynamic> event,
  ) async {
    final orderId = (event['order_id'] ?? event['orderId'] ?? '').toString().trim();
    final eventName = (event['event'] ?? '').toString().trim().toLowerCase();
    var status = (event['status'] ?? '').toString().trim().toLowerCase();
    if (status.isEmpty && eventName == 'order-paid') {
      status = 'paid';
    }
    if (orderId.isEmpty && status.isEmpty) return;

    final dedupKey = 'order:$orderId:$status';
    if (_isRecentlyHandled(dedupKey)) return;
    _markHandled(dedupKey);

    final fallbackTitles = <String, String>{
      'paid': 'Pembayaran Berhasil',
      'processing': 'Pesanan Sedang Dikemas',
      'packed': 'Pesanan Sedang Dikemas',
      'shipped': 'Pesanan Sedang Dikirim',
      'delivered': 'Pesanan Diterima & Selesai',
      'cancelled': 'Pesanan Dibatalkan',
    };
    final tracking = event['tracking_number']?.toString().trim();
    final fallbackBodies = <String, String>{
      'paid':
          'Pembayaran pesanan #$orderId telah dikonfirmasi. Penjual akan segera memproses barang Anda.',
      'processing':
          'Pesanan #$orderId sedang dikemas oleh pengrajin. Mohon tunggu hingga pesanan dikirim.',
      'packed':
          'Pesanan #$orderId sedang dikemas oleh pengrajin. Mohon tunggu hingga pesanan dikirim.',
      'shipped': tracking != null && tracking.isNotEmpty
          ? 'Pesanan #$orderId telah dikirim! No. Resi: $tracking'
          : 'Pesanan #$orderId sedang dalam perjalanan menuju alamat Anda.',
      'delivered':
          'Pesanan #$orderId telah diterima dan selesai. Terima kasih telah berbelanja di DinoyoCraft!',
      'cancelled': 'Mohon maaf, pesanan #$orderId telah dibatalkan.',
    };

    final rawTitle = event['title']?.toString().trim();
    final rawBody = (event['message'] ?? event['body'])?.toString().trim();
    final title = (rawTitle != null && rawTitle.isNotEmpty)
        ? rawTitle
        : (fallbackTitles[status] ?? 'Update Status Pesanan #$orderId');
    final body = (rawBody != null && rawBody.isNotEmpty)
        ? rawBody
        : (fallbackBodies[status] ?? 'Status pesanan #$orderId diperbarui menjadi $status.');

    final model = FcmNotificationModel(
      id: 'rt_${orderId}_${status}_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      body: body,
      category: FcmNotificationCategory.transaction,
      createdAt: DateTime.now(),
      route: '/profile',
      data: {
        'type': 'order',
        'order_id': orderId,
        'status': status,
      },
    );

    await _showTrayNotification(model);
    _notificationsHistory.insert(0, model);
    _notificationModelController.add(model);
    MockData.incrementUnreadNotifications();
    unawaited(MockData.refreshUnreadCounts());
  }

  /// Tampilkan notifikasi tray + perbarui badge chat saat pesan baru masuk lewat Pusher
  /// ketika pengguna sedang tidak berada di ruang obrolan toko tersebut.
  Future<void> showTrayForChatMessage({
    required String messageId,
    required String senderName,
    required String body,
    String? senderId,
    String? storeName,
  }) async {
    final resolvedStore =
        (storeName != null && storeName.trim().isNotEmpty)
            ? storeName.trim()
            : senderName.trim();
    if (_isViewingActiveChat(storeName: resolvedStore, userId: senderId)) {
      return;
    }

    final trimmedId = messageId.trim();
    if (trimmedId.isNotEmpty) {
      final dedupKey = 'chat:$trimmedId';
      if (_isRecentlyHandled(dedupKey)) return;
      _markHandled(dedupKey);
    }

    final route = resolvedStore.isNotEmpty
        ? Uri(
            path: '/chat-room',
            queryParameters: {
              'store': resolvedStore,
              if (senderId != null && senderId.trim().isNotEmpty)
                'userId': senderId.trim(),
            },
          ).toString()
        : '/messages';

    final model = FcmNotificationModel(
      id: trimmedId.isNotEmpty
          ? 'chat_$trimmedId'
          : 'chat_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Pesan dari ${resolvedStore.isNotEmpty ? resolvedStore : 'Penjual'}',
      body: body.trim().isNotEmpty ? body.trim() : 'Anda menerima pesan baru',
      category: FcmNotificationCategory.chat,
      createdAt: DateTime.now(),
      route: route,
      data: {
        'type': 'chat',
        if (senderId != null && senderId.trim().isNotEmpty) 'sender_id': senderId.trim(),
        if (resolvedStore.isNotEmpty) 'store_name': resolvedStore,
        if (trimmedId.isNotEmpty) 'message_id': trimmedId,
      },
    );

    await _showTrayNotification(model);
    _notificationsHistory.insert(0, model);
    _notificationModelController.add(model);
    MockData.recordIncomingUnreadChat(resolvedStore);
    unawaited(MockData.refreshUnreadCounts());
  }

  /// Inisialisasi plugin notifikasi lokal + channel Android.
  Future<void> _ensureLocalNotifications() async {
    if (_localNotifInitialized) return;
    try {
      const androidInit = AndroidInitializationSettings('@drawable/ic_stat_dinoyocraft');
      const initSettings = InitializationSettings(android: androidInit);
      await _localNotifications.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (response) {
          final payload = response.payload?.trim();
          if (payload != null && payload.isNotEmpty) {
            _notificationRouteHandler?.call(payload);
          }
        },
      );

      const channel = AndroidNotificationChannel(
        'dinoyocraft_channel',
        'Notifikasi DinoyoCraft',
        description: 'Update pesanan, pembayaran, chat, dan promo DinoyoCraft',
        importance: Importance.max,
      );
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      _localNotifInitialized = true;
    } catch (e) {
      debugPrint('[FCM] Gagal inisialisasi notifikasi lokal: $e');
    }
  }

  /// Tampilkan notifikasi di TRAY sistem (terlihat walau app terbuka).
  Future<void> _showTrayNotification(FcmNotificationModel model) async {
    await _ensureLocalNotifications();
    if (!_localNotifInitialized) return;
    try {
      await _localNotifications.show(
        id: _resolveTrayNotificationId(model),
        title: model.title,
        body: model.body,
        notificationDetails: NotificationDetails(
          android: buildAndroidNotificationDetails(model),
        ),
        payload: model.route ?? '/profile',
      );
    } catch (e) {
      debugPrint('[FCM] Gagal menampilkan notifikasi tray: $e');
    }
  }

  Future<String?> getDeviceToken() async {
    if (_deviceToken != null) return _deviceToken;
    try {
      try {
        await FirebaseMessaging.instance.register();
      } catch (_) {}
      // ignore: deprecated_member_use
      _deviceToken = await FirebaseMessaging.instance.getToken();
      return _deviceToken;
    } catch (e) {
      debugPrint('[FCM] Gagal mengambil token: $e');
      return null;
    }
  }

  /// Mengirimkan FCM Token perangkat ke Backend server agar BE dapat
  /// mengirim push notification terkait status pesanan atau obrolan baru.
  Future<bool> syncTokenWithBackend([String? customToken]) async {
    final token = customToken ?? _deviceToken;
    if (token == null || token.isEmpty) return false;

    try {
      final response = await ApiClient.post('/user/fcm-token', {
        'fcm_token': token,
        'platform': defaultTargetPlatform.name,
      });
      debugPrint('[FCM] Token berhasil disinkronkan ke BE: $response');
      return true;
    } catch (e) {
      debugPrint('[FCM] Sinkronisasi token ke BE tertunda (BE offline/dev): $e');
      return false;
    }
  }

  /// Berlangganan ke topik tertentu (contoh: 'promo', 'broadcast', 'pengumuman').
  Future<void> subscribeToTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
      debugPrint('[FCM] Berhasil subscribe ke topic: $topic');
    } catch (e) {
      debugPrint('[FCM] Gagal subscribe ke topic $topic: $e');
    }
  }

  /// Berhenti berlangganan dari topik tertentu.
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
      debugPrint('[FCM] Berhasil unsubscribe dari topic: $topic');
    } catch (e) {
      debugPrint('[FCM] Gagal unsubscribe dari topic $topic: $e');
    }
  }

  /// Helper untuk mengarahkan pengguna ke halaman yang sesuai berdasarkan
  /// payload data notifikasi FCM (Deep Link Routing).
  void handleNotificationRouting(BuildContext context, RemoteMessage message) {
    final data = message.data;
    final type = data['type']?.toString().toLowerCase();

    switch (type) {
      case 'chat':
        final storeName = (data['store_name'] ?? data['sender_name'])
            ?.toString()
            .trim();
        final senderId = data['sender_id']?.toString().trim();
        if (storeName != null && storeName.isNotEmpty) {
          final uri = Uri(
            path: '/chat-room',
            queryParameters: {
              'store': storeName,
              if (senderId != null && senderId.isNotEmpty) 'userId': senderId,
            },
          );
          context.push(uri.toString());
        } else {
          context.push('/messages');
        }
        break;

      case 'order':
        context.push('/profile');
        break;

      case 'promo':
      case 'product':
        final productId = data['product_id']?.toString();
        if (productId != null && productId.isNotEmpty) {
          context.push('/product/$productId');
        } else {
          context.push('/products');
        }
        break;

      default:
        // Default bila tidak ada tipe spesifik
        if (data.containsKey('route')) {
          context.push(data['route'] as String);
        }
        break;
    }
  }
}
