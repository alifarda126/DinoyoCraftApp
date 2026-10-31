import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/fcm_notification_model.dart';
import '../network/api_client.dart';

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
  static final FcmService instance = FcmService._internal();

  bool _isInitialized = false;
  String? _deviceToken;

  final List<FcmNotificationModel> _notificationsHistory = [];

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

      // 2. Daftarkan background handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

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

      // 5. Tangani notifikasi saat aplikasi berada di latar depan (foreground)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint(
          '[FCM Foreground] Pesan: ${message.notification?.title} - ${message.notification?.body}',
        );
        final model = FcmNotificationModel.fromRemoteMessage(message);
        _notificationsHistory.insert(0, model);
        _notificationModelController.add(model);
        _foregroundMessageController.add(message);
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
        route: '/chat',
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
        final storeName = data['store_name']?.toString() ?? 'Dinoyo Ceramic Studio';
        final productId = data['product_id']?.toString();
        final extraMap = <String, dynamic>{
          'storeName': storeName,
        };
        if (productId != null) {
          extraMap['productId'] = productId;
        }
        context.push('/chat', extra: extraMap);
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
