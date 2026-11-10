import 'dart:collection';
import 'package:flutter/foundation.dart';

import '../core/assets.dart';
import '../core/network/api_client.dart';

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

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawPrice = json['price'];
    final int price;
    if (rawPrice is num) {
      price = rawPrice.toInt();
    } else if (rawPrice is String) {
      price = double.tryParse(rawPrice)?.toInt() ?? 0;
    } else {
      price = 0;
    }

    final rawImages = json['images'];
    List<String>? imagesList;
    if (rawImages is List) {
      imagesList = rawImages
          .where((e) => e != null)
          .map((e) => ApiClient.resolveImageUrl(e.toString()))
          .toList();
    }

    final imagePath = json['image']?.toString() ??
        json['image_url']?.toString() ??
        (imagesList != null && imagesList.isNotEmpty ? imagesList.first : null);
    final resolvedImage = ApiClient.resolveImageUrl(imagePath);

    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['title']?.toString() ?? '',
      studio: json['studio']?.toString() ??
          json['store_name']?.toString() ??
          'Dinoyo Craft',
      price: price,
      rating: (json['rating'] is num)
          ? (json['rating'] as num).toDouble()
          : 4.8,
      category: json['category']?.toString() ??
          json['category_name']?.toString() ??
          'Keramik',
      image: resolvedImage,
      images: imagesList,
      hot: json['hot'] == true,
      mitraId: (json['mitra_id'] is num)
          ? (json['mitra_id'] as num).toInt()
          : int.tryParse('${json['mitra_id']}') ?? 0,
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
    required this.name,
    required this.location,
    required this.description,
    required this.rating,
    required this.image,
    this.banner,
    this.avatar,
  });

  static const String defaultBanner =
      'https://images.unsplash.com/photo-1610701596007-11502861dcfa?q=80&w=1200&auto=format&fit=crop';

  final int id;
  final String name;
  final String location;
  final String description;
  final double rating;
  final String image;
  final String? banner;
  final String? avatar;

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

    return Store(
      id: (json['id'] is num)
          ? (json['id'] as num).toInt()
          : int.tryParse('${json['id']}') ?? 0,
      name: json['store_name']?.toString() ?? json['name']?.toString() ?? 'Studio Dinoyo',
      location: json['location']?.toString() ??
          json['workshop_address']?.toString() ??
          'Dinoyo, Malang',
      description: resolvedDesc,
      rating: (json['rating'] is num)
          ? (json['rating'] as num).toDouble()
          : 4.8,
      image: resolvedBanner,
      banner: resolvedBanner,
      avatar: resolvedAvatar,
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
          'MVP mendukung QRIS, Virtual Account, dan E-Wallet. Pembayaran di demo ini bersifat simulasi.',
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
      unreadNotificationsCount = 0;
    }
  }

  /// Reset state notifikasi ke kondisi kosong
  static void resetNotifications() {
    readNotificationIds.clear();
    unreadNotificationsCount = 0;
  }

  /// Set nama toko dengan chat yang belum dibaca (dimulai dari KOSONG)
  static final Set<String> unreadChatStores = {};

  /// ValueNotifier untuk jumlah pesan chat belum dibaca (default 0)
  static final ValueNotifier<int> unreadChatNotifier = ValueNotifier<int>(0);

  /// Jumlah pesan chat belum dibaca untuk badge angka di header
  static int get unreadChatCount => unreadChatNotifier.value;
  static set unreadChatCount(int val) {
    unreadChatNotifier.value = val;
  }

  /// Menandai chat toko sebagai terbaca
  static void markChatAsRead(String store) {
    final trimmed = store.trim().toLowerCase();
    final matching = unreadChatStores
        .where((s) => s.trim().toLowerCase() == trimmed)
        .toList();
    if (matching.isNotEmpty) {
      for (final s in matching) {
        unreadChatStores.remove(s);
      }
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
    unreadChatCount = 0;
  }

  /// Tambah produk ke keranjang; qty di-merge bila produk dan varian sama.
  static void addToCart(Product product, int qty, [String? variant]) {
    final index = mockCart.indexWhere(
      (item) =>
          item.product.id == product.id &&
          (item.variant == variant || item.variant == null),
    );
    if (index >= 0) {
      mockCart[index] = CartItem(
        product: product,
        qty: mockCart[index].qty + qty,
        variant: variant ?? mockCart[index].variant,
      );
    } else {
      mockCart.add(CartItem(product: product, qty: qty, variant: variant));
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
