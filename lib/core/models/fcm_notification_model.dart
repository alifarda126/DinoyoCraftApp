import 'package:firebase_messaging/firebase_messaging.dart';

import '../app_text.dart';

/// Kategori notifikasi untuk klasifikasi pesan dari Backend.
enum FcmNotificationCategory {
  transaction,
  chat,
  promo,
  account,
  system;

  String get displayName {
    switch (this) {
      case FcmNotificationCategory.transaction:
        return 'Transaksi & Pesanan'.tr;
      case FcmNotificationCategory.chat:
        return 'Pesan Toko'.tr;
      case FcmNotificationCategory.promo:
        return 'Promo & Voucher'.tr;
      case FcmNotificationCategory.account:
      case FcmNotificationCategory.system:
        return 'Info Akun'.tr;
    }
  }

  static FcmNotificationCategory fromString(String? value) {
    if (value == null) return FcmNotificationCategory.system;
    final lower = value.toLowerCase().trim();
    if (lower.contains('order') ||
        lower.contains('transaksi') ||
        lower.contains('pesanan') ||
        lower.contains('payment') ||
        lower.contains('bayar')) {
      return FcmNotificationCategory.transaction;
    }
    if (lower.contains('chat') ||
        lower.contains('pesan') ||
        lower.contains('message')) {
      return FcmNotificationCategory.chat;
    }
    if (lower.contains('promo') ||
        lower.contains('voucher') ||
        lower.contains('diskon')) {
      return FcmNotificationCategory.promo;
    }
    if (lower.contains('account') ||
        lower.contains('akun') ||
        lower.contains('security') ||
        lower.contains('keamanan')) {
      return FcmNotificationCategory.account;
    }
    return FcmNotificationCategory.system;
  }
}

/// Model data notifikasi terstruktur dari FCM untuk integrasi Backend.
class FcmNotificationModel {
  FcmNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.createdAt,
    this.isRead = false,
    this.route,
    this.data = const {},
    this.imageUrl,
  });

  final String id;
  final String title;
  final String body;
  final FcmNotificationCategory category;
  final DateTime createdAt;
  bool isRead;
  final String? route;
  final Map<String, dynamic> data;
  final String? imageUrl;

  /// Buat model dari RemoteMessage FCM.
  factory FcmNotificationModel.fromRemoteMessage(RemoteMessage message) {
    final notification = message.notification;
    final rawData = message.data;

    final type = rawData['type']?.toString() ?? rawData['category']?.toString();
    final category = FcmNotificationCategory.fromString(type);

    String? route = rawData['route']?.toString();
    if (route == null || route.isEmpty || route == '/chat' || route == '/profile') {
      if (category == FcmNotificationCategory.transaction) {
        final orderId = (rawData['order_id'] ?? rawData['orderId'] ?? '').toString().trim();
        final status = (rawData['status'] ?? '').toString().trim().toLowerCase();
        final tab = switch (status) {
          'pending' => 'Belum Bayar',
          'paid' || 'processing' || 'packed' => 'Dikemas',
          'shipped' => 'Dikirim',
          'completed' || 'delivered' => 'Diterima',
          _ => null,
        };
        route = Uri(
          path: '/profile',
          queryParameters: {
            'tab': ?tab,
            if (orderId.isNotEmpty) 'trackOrderId': orderId,
          },
        ).toString();
      } else if (category == FcmNotificationCategory.chat) {
        final storeName = rawData['store_name']?.toString().trim() ??
            rawData['sender_name']?.toString().trim();
        final senderId = rawData['sender_id']?.toString().trim();
        final isCs = rawData['is_cs']?.toString() == 'true' ||
            rawData['is_cs']?.toString() == '1';
        if (storeName != null && storeName.isNotEmpty) {
          route = Uri(
            path: '/chat-room',
            queryParameters: {
              'store': storeName,
              if (senderId != null && senderId.isNotEmpty) 'userId': senderId,
              if (isCs) 'isCs': '1',
            },
          ).toString();
        } else {
          route = '/messages';
        }
      } else if (category == FcmNotificationCategory.account) {
        final subtype = rawData['subtype']?.toString().toLowerCase() ?? '';
        if (rawData['type']?.toString().toLowerCase() == 'account_deleted') {
          route = '/login';
        } else if (subtype.contains('device')) {
          route = '/settings?open=devices';
        } else {
          route = '/settings';
        }
      } else if (category == FcmNotificationCategory.promo) {
        final productId = rawData['product_id']?.toString().trim();
        route = (productId != null && productId.isNotEmpty)
            ? '/product/$productId'
            : '/products';
      }
    }

    return FcmNotificationModel(
      id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: notification?.title ?? rawData['title']?.toString() ?? 'Pemberitahuan DinoyoCraft',
      body: notification?.body ?? rawData['body']?.toString() ?? '',
      category: category,
      createdAt: message.sentTime ?? DateTime.now(),
      route: route,
      data: rawData,
      imageUrl: notification?.android?.imageUrl ??
          notification?.apple?.imageUrl ??
          rawData['image_url']?.toString(),
    );
  }

  /// Buat model dari payload JSON Backend.
  factory FcmNotificationModel.fromJson(Map<String, dynamic> json) {
    return FcmNotificationModel(
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title']?.toString() ?? 'DinoyoCraft',
      body: json['body']?.toString() ?? '',
      category: FcmNotificationCategory.fromString(json['category']?.toString() ?? json['type']?.toString()),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      isRead: json['is_read'] == true,
      route: json['route']?.toString(),
      data: json['data'] is Map<String, dynamic> ? json['data'] : {},
      imageUrl: json['image_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'category': category.name,
        'created_at': createdAt.toIso8601String(),
        'is_read': isRead,
        'route': route,
        'data': data,
        'image_url': imageUrl,
      };

  String get timeLabel {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return 'Baru saja'.tr;
    if (diff.inMinutes < 60) {
      return AppText.isEnglish
          ? '${diff.inMinutes}m ago'
          : '${diff.inMinutes} mnt lalu';
    }
    if (diff.inHours < 24) {
      return AppText.isEnglish
          ? '${diff.inHours}h ago'
          : '${diff.inHours} jam lalu';
    }
    return AppText.isEnglish
        ? '${diff.inDays}d ago'
        : '${diff.inDays} hari lalu';
  }
}

