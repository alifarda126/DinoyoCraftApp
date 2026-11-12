import 'dart:collection';
import 'dart:convert';
import 'dart:ui' show Color;
import 'package:flutter/foundation.dart';

import '../core/assets.dart';
import '../core/network/api_client.dart';

class ProductVariant {
  const ProductVariant({
    required this.name,
    required this.hex,
    this.label = 'Standar',
    required this.stock,
  });

  final String name;
  final String hex;
  final String label;
  final int stock;

  Color get colorValue {
    var clean = hex.trim().replaceFirst('#', '');
    if (clean.length == 6) clean = 'FF$clean';
    final parsed = int.tryParse(clean, radix: 16);
    if (parsed != null) return Color(parsed);
    return const Color(0xFFB85C3C);
  }

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    final rawStock = json['stock'];
    final int stock;
    if (rawStock is num) {
      stock = rawStock.toInt();
    } else if (rawStock is String) {
      stock = int.tryParse(rawStock) ?? 0;
    } else {
      stock = 0;
    }
    return ProductVariant(
      name: (json['name'] ?? json['label'] ?? '').toString().trim(),
      hex: (json['hex'] ?? '#b85c3c').toString().trim(),
      label: (json['label'] ?? 'Standar').toString().trim(),
      stock: stock < 0 ? 0 : stock,
    );
  }
}

class ProductReview {
  const ProductReview({
    required this.id,
    required this.userName,
    required this.rating,
    this.variant = '',
    this.comment = '',
    this.photoUrls = const [],
    this.helpfulCount = 0,
    this.sellerReply,
    this.repliedAt,
    this.createdAt,
  });

  final String id;
  final String userName;
  final double rating;
  final String variant;
  final String comment;
  final List<String> photoUrls;
  final int helpfulCount;
  final String? sellerReply;
  final String? repliedAt;
  final String? createdAt;

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    final photos = <String>[];
    final rawPhotos = json['photo_urls'];
    if (rawPhotos is List) {
      for (final p in rawPhotos) {
        if (p != null && p.toString().trim().isNotEmpty) {
          photos.add(ApiClient.resolveImageUrl(p.toString()));
        }
      }
    }
    final rawRating = json['rating'];
    final double parsedRating = rawRating is num
        ? rawRating.toDouble()
        : double.tryParse('$rawRating') ?? 5.0;

    return ProductReview(
      id: (json['id'] ?? '').toString(),
      userName: (json['user_name'] ?? 'Pembeli').toString().trim(),
      rating: parsedRating,
      variant: (json['variant'] ?? '').toString().trim(),
      comment: (json['comment'] ?? '').toString().trim(),
      photoUrls: photos,
      helpfulCount: (json['helpful_count'] is num)
          ? (json['helpful_count'] as num).toInt()
          : int.tryParse('${json['helpful_count']}') ?? 0,
      sellerReply: json['seller_reply']?.toString(),
      repliedAt: json['replied_at']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.studio,
    required this.price,
    required this.rating,
    required this.category,
    required this.image,
    this.images,
    this.hot = false,
    this.mitraId = 0,
    this.description = '',
    this.stock = 0,
    this.weightGram = 500,
    this.variants = const [],
    this.totalReviews = 0,
    this.soldCount = 0,
    this.workshopAddress = '',
    this.reviews = const [],
  });

  final String id;
  final String name;
  final String studio;
  final int price;
  final double rating;
  final String category;
  final String image;
  final List<String>? images;
  final bool hot;

  /// ID toko mitra pemilik produk (dari backend, untuk checkout).
  final int mitraId;

  final String description;
  final int stock;
  final int weightGram;
  final List<ProductVariant> variants;
  final int totalReviews;
  final int soldCount;
  final String workshopAddress;
  final List<ProductReview> reviews;

  bool get hasVariants => variants.isNotEmpty;

  /// Total stok efektif: bila varian diisi, jumlahkan stok tiap varian.
  int get effectiveStock => variants.isNotEmpty
      ? variants.fold<int>(0, (sum, v) => sum + v.stock)
      : stock;

  int availableStockForVariant(String? variantName) {
    if (variants.isNotEmpty) {
      final target = (variantName ?? '').trim().toLowerCase();
      if (target.isNotEmpty) {
        for (final v in variants) {
          if (v.name.trim().toLowerCase() == target) return v.stock;
        }
      }
      return variants.first.stock;
    }
    return stock < 0 ? 0 : stock;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic raw, [int fallback = 0]) {
      if (raw is num) return raw.toInt();
      if (raw is String) {
        return double.tryParse(raw)?.toInt() ?? fallback;
      }
      return fallback;
    }

    double parseDouble(dynamic raw, [double fallback = 0.0]) {
      if (raw is num) return raw.toDouble();
      if (raw is String) return double.tryParse(raw) ?? fallback;
      return fallback;
    }

    final price = parseInt(json['price'], 0);
    final rawImages = json['images'];
    List<String>? imagesList;
    if (rawImages is List) {
      imagesList = rawImages
          .where((e) => e != null && e.toString().trim().isNotEmpty)
          .map((e) => ApiClient.resolveImageUrl(e.toString()))
          .toList();
    }

    final imagePath = json['image']?.toString() ??
        json['image_url']?.toString() ??
        (imagesList != null && imagesList.isNotEmpty ? imagesList.first : null);
    final resolvedImage = ApiClient.resolveImageUrl(imagePath);

    // Parse variants array (bisa berbentuk List atau JSON string)
    final parsedVariants = <ProductVariant>[];
    dynamic rawVariants = json['variants'];
    if (rawVariants is String && rawVariants.trim().isNotEmpty) {
      try {
        rawVariants = jsonDecode(rawVariants);
      } catch (_) {
        rawVariants = null;
      }
    }
    if (rawVariants is List) {
      for (final v in rawVariants) {
        if (v is Map) {
          final variant = ProductVariant.fromJson(Map<String, dynamic>.from(v));
          if (variant.name.isNotEmpty) parsedVariants.add(variant);
        }
      }
    }

    // Parse reviews array jika tersedia (dari detail produk)
    final parsedReviews = <ProductReview>[];
    final rawReviews = json['reviews'];
    if (rawReviews is List) {
      for (final r in rawReviews) {
        if (r is Map) {
          parsedReviews.add(ProductReview.fromJson(Map<String, dynamic>.from(r)));
        }
      }
    }

    final storeMap = json['store'] is Map ? json['store'] as Map : null;
    final workshopAddr = (json['workshop_address'] ??
            storeMap?['workshop_address'] ??
            storeMap?['location'] ??
            '')
        .toString()
        .trim();

    final parsedTotalReviews = parseInt(json['total_reviews'], parsedReviews.length);
    final parsedRating = parseDouble(json['rating'], 0.0);

    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['title']?.toString() ?? '',
      studio: json['studio']?.toString() ??
          json['store_name']?.toString() ??
          'Dinoyo Craft',
      price: price,
      rating: parsedTotalReviews > 0 ? parsedRating : 0.0,
      category: json['category']?.toString() ??
          json['category_name']?.toString() ??
          'Keramik',
      image: resolvedImage,
      images: imagesList,
      hot: json['hot'] == true,
      mitraId: parseInt(json['mitra_id'], 0),
      description: (json['description'] ?? '').toString(),
      stock: parseInt(json['stock'], 0),
      weightGram: parseInt(json['weight_gram'], 500) <= 0
          ? 500
          : parseInt(json['weight_gram'], 500),
      variants: parsedVariants,
      totalReviews: parsedTotalReviews,
      soldCount: parseInt(json['sold_count'], 0),
      workshopAddress: workshopAddr,
      reviews: parsedReviews,
    );
  }

  /// Daftar foto galeri produk untuk carousel
  List<String> get gallery {
    if (images != null && images!.isNotEmpty) return images!;
    if (image.isNotEmpty) return [image];
    return [
      AppAssets.productVas,
      AppAssets.productMangkuk,
      AppAssets.productPiring,
      AppAssets.productCangkir,
    ];
  }
}

class Store {
  const Store({
    this.id = 0,
    this.userId,
    required this.name,
    required this.location,
    required this.description,
    required this.rating,
    required this.image,
    this.banner,
    this.avatar,
    this.totalReviews = 0,
  });

  static const String defaultBanner =
      'https://images.unsplash.com/photo-1610701596007-11502861dcfa?q=80&w=1200&auto=format&fit=crop';

  final int id;
  final int? userId;
  final String name;
  final String location;
  final String description;
  final double rating;
  final String image;
  final String? banner;
  final String? avatar;
  final int totalReviews;

  /// Memeriksa apakah toko memiliki foto profil khusus (bukan default Google avatar dan bukan fallback banner)
  bool get hasCustomAvatar {
    final a = avatar;
    if (a == null || a.trim().isEmpty || a.trim() == 'null') return false;
    if (a.contains('googleusercontent.com') || a.contains('google.com')) {
      return false;
    }
    if (a == defaultBanner) {
      return false;
    }
    return true;
  }

  /// Inisial nama toko (sama persis dengan formula FE: 1 huruf jika 1 kata, 2 huruf jika >= 2 kata)
  String get initials {
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return 'D';
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    }
    final first = words[0][0];
    final second = words[1][0];
    return (first + second).toUpperCase();
  }

  factory Store.fromJson(Map<String, dynamic> json) {
    final bannerPath = json['banner_url']?.toString();
    final avatarPath = json['avatar_url']?.toString() ?? json['image']?.toString();

    // Banner default sama persis dengan frontend (Unsplash pottery banner)
    final resolvedBanner = (bannerPath != null &&
            bannerPath.trim().isNotEmpty &&
            bannerPath.trim() != 'null')
        ? ApiClient.resolveImageUrl(bannerPath.trim())
        : defaultBanner;

    final resolvedAvatar = (avatarPath != null &&
            avatarPath.trim().isNotEmpty &&
            avatarPath.trim() != 'null')
        ? ApiClient.resolveImageUrl(avatarPath.trim())
        : null;

    final desc = json['description']?.toString();
    final resolvedDesc = (desc != null && desc.trim().isNotEmpty && desc.trim() != 'null')
        ? desc.trim()
        : 'Studio keramik pengrajin Dinoyo.';

    final totalReviews = (json['total_reviews'] is num)
        ? (json['total_reviews'] as num).toInt()
        : int.tryParse('${json['total_reviews']}') ?? 0;
    final rawRating = (json['rating'] is num)
        ? (json['rating'] as num).toDouble()
        : double.tryParse('${json['rating']}') ?? 0.0;

    return Store(
      id: (json['id'] is num)
          ? (json['id'] as num).toInt()
          : int.tryParse('${json['id']}') ?? 0,
      userId: (json['user_id'] is num)
          ? (json['user_id'] as num).toInt()
          : int.tryParse('${json['user_id']}'),
      name: json['store_name']?.toString() ?? json['name']?.toString() ?? 'Studio Dinoyo',
      location: json['location']?.toString() ??
          json['workshop_address']?.toString() ??
          'Dinoyo, Malang',
      description: resolvedDesc,
      rating: totalReviews > 0 ? rawRating : 0.0,
      image: resolvedBanner,
      banner: resolvedBanner,
      avatar: resolvedAvatar,
      totalReviews: totalReviews,
    );
  }
}

class FaqItem {
  const FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}

class CartItem {
  const CartItem({
    required this.product,
    required this.qty,
    this.variant,
  });

  final Product product;
  final int qty;
  final String? variant;
}

abstract final class MockData {
  static final Product fallbackProduct = const Product(
    id: '0',
    name: 'Produk Keramik',
    studio: 'Dinoyo Craft',
    price: 0,
    rating: 5.0,
    category: 'Keramik',
    image: '',
  );

  static final Store fallbackStore = const Store(
    name: 'Dinoyo Ceramic Studio',
    location: 'Dinoyo, Malang',
    description: 'Studio keramik Dinoyo.',
    rating: 5.0,
    image: '',
  );

  /// Path foto profil pengguna (hasil kamera/galeri) untuk sesi ini.
  static String? userProfilePhotoPath;
  static Uint8List? userProfilePhotoBytes;

  static List<String> categories = ['Semua'];

  /// Daftar produk nyata dari backend
  static List<Product> products = [];

  /// Daftar toko nyata dari backend
  static List<Store> stores = [];

  static bool isLoadingPublicData = false;

  static bool _lastOnline = true;
  static bool _connectivityHooked = false;

  /// Pasang listener: begitu perangkat (kembali) terhubung ke jaringan,
  /// katalog diambil ulang dari backend agar tampilan selalu data real.
  static void hookConnectivity(ValueNotifier<bool> isOnlineNotifier) {
    if (_connectivityHooked) return;
    _connectivityHooked = true;
    isOnlineNotifier.addListener(() {
      final online = isOnlineNotifier.value;
      final wasOnline = _lastOnline;
      _lastOnline = online;
      if (online && !wasOnline) {
        // Baru saja online (perangkat terhubung) → segarkan katalog real.
        fetchPublicData(force: true);
      }
    });
  }

  /// Mengambil data katalog produk dan toko mitra secara nyata dari Backend API.
  /// [force] = ambil ulang meski data sudah ada (mis. saat reconnect).
  static Future<void> fetchPublicData({bool force = false}) async {
    if (isLoadingPublicData) return;
    if (!force && products.isNotEmpty) return; // data real sudah dimuat
    isLoadingPublicData = true;
    try {
      // 1. Fetch Produk Publik
      final prodRes = await ApiClient.get('/products/public');
      if (prodRes['success'] == true && prodRes['data'] is List) {
        final list = (prodRes['data'] as List)
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList();
        products = list;

        // Ekstrak kategori unik
        final catSet = <String>{'Semua'};
        for (final p in list) {
          if (p.category.trim().isNotEmpty) {
            catSet.add(p.category.trim());
          }
        }
        categories = catSet.toList();
      }

      // 2. Fetch Mitra/Toko Publik
      final mitraRes = await ApiClient.get('/mitra/public');
      if (mitraRes['success'] == true && mitraRes['data'] is List) {
        final list = (mitraRes['data'] as List)
            .map((item) => Store.fromJson(item as Map<String, dynamic>))
            .toList();
        stores = list;
      }
    } catch (e) {
      debugPrint('[MockData] Error fetching public data from backend: $e');
    } finally {
      isLoadingPublicData = false;
    }
  }

  static const List<FaqItem> faqs = [
    FaqItem(
      question: 'Bagaimana cara memesan produk?',
      answer:
          'Pilih produk dari Beranda atau tab Produk, tap tombol +, lalu lanjutkan ke Checkout untuk menyelesaikan pembayaran.',
    ),
    FaqItem(
      question: 'Apakah bisa pickup di toko?',
      answer:
          'Ya. Pilih opsi ambil di toko pada checkout jika tersedia, atau hubungi studio terkait melalui ClayBot.',
    ),
    FaqItem(
      question: 'Berapa lama pengiriman ke luar kota?',
      answer:
          'Estimasi 2–5 hari kerja tergantung kurir (Regular/Hemat/Express) dan destinasi pengiriman.',
    ),
    FaqItem(
      question: 'Apakah produk bisa dikustom?',
      answer:
          'Beberapa studio menerima custom order. Hubungi ClayBot atau WhatsApp studio untuk konfirmasi desain dan estimasi harga.',
    ),
    FaqItem(
      question: 'Bagaimana cara reservasi workshop?',
      answer:
          'Buka tab Workshop, baca detail pengalaman, lalu tap Reservasi via WhatsApp untuk menjadwalkan sesi.',
    ),
    FaqItem(
      question: 'Metode pembayaran apa saja yang tersedia?',
      answer:
          'DinoyoCraft mendukung pembayaran via Midtrans Sandbox: QRIS, Virtual Account (BCA, Mandiri, BRI, BNI, Permata), serta E-Wallet (GoPay & ShopeePay).',
    ),
  ];

  /// ValueNotifier untuk jumlah jenis produk di keranjang (dimulai dari 0)
  static final ValueNotifier<int> cartCountNotifier = ValueNotifier<int>(0);

  /// Jumlah item keranjang untuk badge di header
  static int get cartCount => cartCountNotifier.value;
  static set cartCount(int val) {
    cartCountNotifier.value = val;
  }

  /// Keranjang sesi nyata: dimulai dari KOSONG (tanpa data mockup)
  static final List<CartItem> mockCart = _CartList();

  /// Set ID notifikasi yang sudah dibaca
  static final Set<String> readNotificationIds = {};

  /// ValueNotifier untuk jumlah notifikasi belum dibaca (dimulai dari 0)
  static final ValueNotifier<int> unreadNotificationsNotifier =
      ValueNotifier<int>(0);

  /// Jumlah notifikasi belum dibaca untuk badge angka di header (default 0)
  static int get unreadNotificationsCount => unreadNotificationsNotifier.value;
  static set unreadNotificationsCount(int val) {
    unreadNotificationsNotifier.value = val;
  }

  /// Menandai notifikasi sebagai terbaca dan mengupdate hitungan notifikasi.
  static void markNotificationAsRead(String id) {
    if (!readNotificationIds.contains(id)) {
      readNotificationIds.add(id);
      if (unreadNotificationsCount > 0) {
        unreadNotificationsCount = unreadNotificationsCount - 1;
      }
    }
  }

  /// Sinkronisasi hitungan notifikasi belum dibaca dari server.
  static void syncUnreadNotificationsCount(int count) {
    final safeCount = count < 0 ? 0 : count;
    if (unreadNotificationsCount != safeCount) {
      unreadNotificationsCount = safeCount;
    }
  }

  /// Naikkan hitungan badge notifikasi saat push/realtime baru diterima.
  static void incrementUnreadNotifications([int delta = 1]) {
    if (delta <= 0) return;
    unreadNotificationsCount = unreadNotificationsCount + delta;
  }

  /// Reset state notifikasi ke kondisi kosong
  static void resetNotifications() {
    readNotificationIds.clear();
    unreadNotificationsCount = 0;
  }

  /// Set nama toko dengan chat yang belum dibaca (dimulai dari KOSONG)
  static final Set<String> unreadChatStores = {};

  /// Rincian jumlah pesan belum dibaca per toko (lowercase store name)
  static final Map<String, int> unreadChatCountByStore = {};

  /// Room obrolan yang sedang dibuka user saat ini agar pesan masuk tidak
  /// otomatis menambah badge unread.
  static String? activeChatStoreName;
  static String? activeChatUserId;

  /// ValueNotifier untuk jumlah pesan chat belum dibaca (default 0)
  static final ValueNotifier<int> unreadChatNotifier = ValueNotifier<int>(0);

  /// Jumlah pesan chat belum dibaca untuk badge angka di header
  static int get unreadChatCount => unreadChatNotifier.value;
  static set unreadChatCount(int val) {
    unreadChatNotifier.value = val < 0 ? 0 : val;
  }

  /// Sinkronkan daftar toko & total pesan chat belum dibaca dari respons `/chat/contacts`.
  static void syncUnreadChatFromContacts(List<Map<String, dynamic>> contacts) {
    unreadChatStores.clear();
    unreadChatCountByStore.clear();
    int total = 0;
    for (final c in contacts) {
      final storeName = (c['name'] ?? c['store_name'] ?? '').toString().trim();
      final rawUnread = c['unread'] ?? c['unread_count'] ?? 0;
      final unread = rawUnread is num
          ? rawUnread.toInt()
          : int.tryParse('$rawUnread') ?? 0;
      if (unread > 0) {
        total += unread;
        if (storeName.isNotEmpty) {
          unreadChatStores.add(storeName);
          unreadChatCountByStore[storeName.toLowerCase()] = unread;
        }
      }
    }
    unreadChatCount = total;
  }

  /// Tambah hitungan badge chat secara instan saat pesan baru masuk di luar room.
  static void recordIncomingUnreadChat(String storeName) {
    final trimmed = storeName.trim();
    if (trimmed.isEmpty) {
      unreadChatCount = unreadChatCount + 1;
      return;
    }
    final key = trimmed.toLowerCase();
    unreadChatStores.add(trimmed);
    unreadChatCountByStore[key] = (unreadChatCountByStore[key] ?? 0) + 1;
    unreadChatCount = unreadChatCount + 1;
  }

  /// Menandai chat toko sebagai terbaca
  static void markChatAsRead(String store) {
    final trimmed = store.trim().toLowerCase();
    final matching = unreadChatStores
        .where((s) => s.trim().toLowerCase() == trimmed)
        .toList();
    final removedCount = unreadChatCountByStore.remove(trimmed) ?? 0;
    if (matching.isNotEmpty) {
      for (final s in matching) {
        unreadChatStores.remove(s);
      }
    }
    if (unreadChatCountByStore.isNotEmpty) {
      unreadChatCount = unreadChatCountByStore.values.fold(0, (a, b) => a + b);
    } else if (removedCount > 0) {
      final next = unreadChatCount - removedCount;
      unreadChatCount = next < 0 ? 0 : next;
    } else if (matching.isNotEmpty) {
      unreadChatCount = unreadChatStores.length;
    }
  }

  /// Cek apakah chat toko belum dibaca
  static bool isChatUnread(String store) {
    final trimmed = store.trim().toLowerCase();
    return unreadChatStores.any((s) => s.trim().toLowerCase() == trimmed);
  }

  /// Reset state chat (kosong)
  static void resetChats() {
    unreadChatStores.clear();
    unreadChatCountByStore.clear();
    unreadChatCount = 0;
  }

  static bool _isRefreshingUnreadCounts = false;

  /// Ambil ulang jumlah notifikasi & pesan chat belum dibaca dari backend.
  static Future<void> refreshUnreadCounts() async {
    final token = ApiClient.authToken;
    if (token == null || token.trim().isEmpty || _isRefreshingUnreadCounts) {
      return;
    }
    _isRefreshingUnreadCounts = true;
    try {
      await Future.wait([
        _refreshNotificationUnreadCount(),
        _refreshChatUnreadCount(),
      ]);
    } finally {
      _isRefreshingUnreadCounts = false;
    }
  }

  static Future<void> _refreshNotificationUnreadCount() async {
    try {
      final res = await ApiClient.get('/notifications/unread-count');
      final rawCount = res['unread_count'] ??
          (res['data'] is Map ? (res['data'] as Map)['unread_count'] : null);
      if (rawCount != null) {
        final parsed = rawCount is num
            ? rawCount.toInt()
            : int.tryParse('$rawCount') ?? 0;
        syncUnreadNotificationsCount(parsed);
        return;
      }
    } catch (_) {
      // Fallback ke endpoint list jika endpoint unread-count belum tersedia.
    }

    try {
      final res = await ApiClient.get('/notifications');
      final rawCount = res['unread_count'];
      if (rawCount != null) {
        final parsed = rawCount is num
            ? rawCount.toInt()
            : int.tryParse('$rawCount') ?? 0;
        syncUnreadNotificationsCount(parsed);
        return;
      }
      final list = res['notifications'] ?? res['data'];
      if (list is List) {
        final unread = list.where((e) {
          if (e is Map) {
            return e['is_read'] != true && e['is_read'] != 1;
          }
          return false;
        }).length;
        syncUnreadNotificationsCount(unread);
      }
    } catch (_) {}
  }

  static Future<void> _refreshChatUnreadCount() async {
    try {
      final res = await ApiClient.get('/chat/unread-count');
      final dataMap = res['data'] is Map
          ? Map<String, dynamic>.from(res['data'] as Map)
          : null;
      final rawCount = res['unread_count'] ?? dataMap?['unread_count'];
      final rawSenders = res['unread_senders'] ?? dataMap?['unread_senders'];
      if (rawSenders is List) {
        final senderMaps = rawSenders
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
        syncUnreadChatFromContacts(senderMaps);
      }
      if (rawCount != null) {
        final parsed = rawCount is num
            ? rawCount.toInt()
            : int.tryParse('$rawCount') ?? 0;
        unreadChatCount = parsed;
        return;
      }
    } catch (_) {
      // Fallback ke endpoint contacts jika endpoint unread-count belum tersedia.
    }

    try {
      final res = await ApiClient.get('/chat/contacts');
      final list = res['contacts'] ?? res['data'];
      if (list is List) {
        final contacts = list
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
        syncUnreadChatFromContacts(contacts);
      }
    } catch (_) {}
  }

  /// Update / sisipkan 1 produk ke cache [products].
  static void upsertProduct(Product product) {
    final idx = products.indexWhere((p) => p.id == product.id);
    if (idx >= 0) {
      products[idx] = product;
    } else {
      products.add(product);
    }
  }

  /// Tambah produk ke keranjang; qty di-merge bila produk dan varian sama,
  /// serta dibatasi stok varian/produk yang tersedia.
  static void addToCart(Product product, int qty, [String? variant]) {
    final normalizedVariant =
        (variant != null && variant.trim().isNotEmpty) ? variant.trim() : null;
    final maxStock = product.availableStockForVariant(normalizedVariant);
    final index = mockCart.indexWhere(
      (item) =>
          item.product.id == product.id &&
          (item.variant ?? '').trim().toLowerCase() ==
              (normalizedVariant ?? '').trim().toLowerCase(),
    );
    if (index >= 0) {
      final combined = mockCart[index].qty + qty;
      final clampedQty = maxStock > 0 ? combined.clamp(1, maxStock) : combined;
      mockCart[index] = CartItem(
        product: product,
        qty: clampedQty,
        variant: normalizedVariant,
      );
    } else {
      final clampedQty = maxStock > 0 ? qty.clamp(1, maxStock) : qty;
      mockCart.add(
        CartItem(product: product, qty: clampedQty, variant: normalizedVariant),
      );
    }
    cartCountNotifier.value = mockCart.length;
  }

  /// Hapus produk dari keranjang berdasarkan index dan beri notifikasi reaktif.
  static void removeFromCart(int index) {
    if (index >= 0 && index < mockCart.length) {
      mockCart.removeAt(index);
    }
  }

  /// Reset keranjang ke kondisi kosong
  static void resetCart() {
    mockCart.clear();
  }

  static String formatPrice(int price) {
    final digits = price.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[i]);
    }
    return 'Rp${buffer.toString()}';
  }

  static List<Product> filterProducts({
    String category = 'Semua',
    String query = '',
  }) {
    final q = query.trim().toLowerCase();
    return products.where((p) {
      final catOk = category == 'Semua' || p.category == category;
      final queryOk = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.studio.toLowerCase().contains(q);
      return catOk && queryOk;
    }).toList();
  }

  static List<Store> filterStores(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return stores;
    return stores
        .where(
          (s) =>
              s.name.toLowerCase().contains(q) ||
              s.location.toLowerCase().contains(q),
        )
        .toList();
  }
}

/// List keranjang yang secara otomatis memicu [MockData.cartCountNotifier]
/// seketika terjadi penambahan, penghapusan, atau perubahan isi keranjang.
class _CartList extends ListBase<CartItem> {
  // Dimulai dari list KOSONG murni (tanpa item dummy Vas atau Cangkir)
  final List<CartItem> _inner = [];

  @override
  int get length => _inner.length;

  @override
  set length(int newLength) {
    _inner.length = newLength;
    MockData.cartCountNotifier.value = _inner.length;
  }

  @override
  CartItem operator [](int index) => _inner[index];

  @override
  void operator []=(int index, CartItem value) {
    _inner[index] = value;
    MockData.cartCountNotifier.value = _inner.length;
  }

  @override
  void add(CartItem element) {
    _inner.add(element);
    MockData.cartCountNotifier.value = _inner.length;
  }

  @override
  void addAll(Iterable<CartItem> iterable) {
    _inner.addAll(iterable);
    MockData.cartCountNotifier.value = _inner.length;
  }

  @override
  CartItem removeAt(int index) {
    final item = _inner.removeAt(index);
    MockData.cartCountNotifier.value = _inner.length;
    return item;
  }

  @override
  bool remove(Object? element) {
    final removed = _inner.remove(element);
    if (removed) {
      MockData.cartCountNotifier.value = _inner.length;
    }
    return removed;
  }

  @override
  void removeWhere(bool Function(CartItem element) test) {
    _inner.removeWhere(test);
    MockData.cartCountNotifier.value = _inner.length;
  }

  @override
  void clear() {
    _inner.clear();
    MockData.cartCountNotifier.value = 0;
  }
}
