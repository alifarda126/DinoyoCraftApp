import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../core/assets.dart';

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

  /// Daftar foto galeri produk untuk carousel (selalu minimal 4 foto sesuai indikator 1/4)
  List<String> get gallery {
    if (images != null && images!.isNotEmpty) return images!;
    return switch (category) {
      'Vas' => [
          image,
          AppAssets.productVasModern,
          AppAssets.workshopHero,
          AppAssets.storeDinoyo,
        ],
      'Cangkir' => [
          image,
          AppAssets.productCangkirSpeckle,
          AppAssets.productCangkir,
          AppAssets.storeRuangTanah,
        ],
      'Piring' => [
          image,
          AppAssets.productSetPiring,
          AppAssets.productPiring,
          AppAssets.storeDinoyo,
        ],
      'Mangkuk' => [
          image,
          AppAssets.productMangkukRamen,
          AppAssets.productMangkuk,
          AppAssets.workshopHero,
        ],
      _ => [
          image,
          AppAssets.productVasModern,
          AppAssets.productSetPiring,
          AppAssets.productCangkirSpeckle,
        ],
    };
  }
}

class Store {
const   Store({
    required this.name,
    required this.location,
    required this.description,
    required this.rating,
    required this.image,
  });

  final String name;
  final String location;
  final String description;
  final double rating;
  final String image;
}

class FaqItem {
const   FaqItem({required this.question, required this.answer});

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
  /// Path foto profil pengguna (hasil kamera/galeri) untuk sesi ini.
  /// Null = foto profil default (ikon person). Sengaja in-memory: seluruh
  /// data profil di aplikasi mock belum dipersisten antar-restart.
  static String? userProfilePhotoPath;
  static Uint8List? userProfilePhotoBytes;

  static const List<String> categories = [
    'Semua',
    'Vas',
    'Cangkir',
    'Piring',
    'Mangkuk',
  ];

  // Image paths mapped to actual photo content (asset QA).
  static const List<Product> products = [
    Product(
      id: '1',
      name: 'Vas Minimalis',
      studio: 'Dinoyo Ceramic Studio',
      price: 85000,
      rating: 4.8,
      category: 'Vas',
      image: AppAssets.productVas,
      hot: true,
    ),
    Product(
      id: '2',
      name: 'Cangkir Handmade',
      studio: 'Karya Tanah',
      price: 65000,
      rating: 4.6,
      category: 'Cangkir',
      image: AppAssets.productMangkuk,
      hot: true,
    ),
    Product(
      id: '3',
      name: 'Mangkuk Keramik',
      studio: 'Ruang Tanah',
      price: 75000,
      rating: 4.7,
      category: 'Mangkuk',
      image: AppAssets.productPiring,
    ),
    Product(
      id: '4',
      name: 'Piring Artisan',
      studio: 'Dinoyo Craft House',
      price: 95000,
      rating: 4.9,
      category: 'Piring',
      image: AppAssets.productMangkukRamen,
      hot: true,
    ),
    Product(
      id: '5',
      name: 'Vas Modern',
      studio: 'Ruang Tanah',
      price: 120000,
      rating: 4.5,
      category: 'Vas',
      image: AppAssets.productVasModern,
    ),
    Product(
      id: '6',
      name: 'Cangkir Speckle',
      studio: 'Dinoyo Ceramic Studio',
      price: 70000,
      rating: 4.4,
      category: 'Cangkir',
      image: AppAssets.productCangkirSpeckle,
    ),
    Product(
      id: '7',
      name: 'Set Piring Dinoyo',
      studio: 'Dinoyo Craft House',
      price: 110000,
      rating: 4.8,
      category: 'Piring',
      image: AppAssets.productSetPiring,
    ),
    Product(
      id: '8',
      name: 'Mangkuk Spekel',
      studio: 'Karya Tanah',
      price: 80000,
      rating: 4.6,
      category: 'Mangkuk',
      image: AppAssets.productPiring,
    ),
  ];

  static const List<Store> stores = [
    Store(
      name: 'Dinoyo Ceramic Studio',
      location: 'Jl. MT Haryono, Dinoyo, Malang',
      description:
          'Studio keramik klasik Dinoyo dengan koleksi vas dan cangkir handmade.',
      rating: 4.9,
      image: AppAssets.storeDinoyo,
    ),
    Store(
      name: 'Karya Tanah',
      location: 'Kampung Keramik Dinoyo, Malang',
      description:
          'Pengrajin muda yang fokus pada cangkir dan mangkuk spekel unik.',
      rating: 4.7,
      image: AppAssets.storeRuangTanah,
    ),
    Store(
      name: 'Ruang Tanah',
      location: 'Jl. Keramik No. 12, Dinoyo',
      description:
          'Galeri dan workshop terbuka untuk eksplorasi tanah liat kontemporer.',
      rating: 4.8,
      image: AppAssets.storeRuangTanah,
    ),
    Store(
      name: 'Dinoyo Craft House',
      location: 'Jl. Simpang Gajayana, Malang',
      description:
          'Rumah craft dengan set piring artisan dan merchandise lokal.',
      rating: 4.6,
      image: AppAssets.storeDinoyo,
    ),
  ];

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

  /// ValueNotifier untuk jumlah jenis produk di keranjang agar header dan badge reaktif seketika
  static final ValueNotifier<int> cartCountNotifier = ValueNotifier<int>(2);

  /// Jumlah item keranjang untuk badge di header
  static int get cartCount => cartCountNotifier.value;
  static set cartCount(int val) {
    cartCountNotifier.value = val;
  }

  // Keranjang sesi: mutable & reaktif agar aksi tambah/hapus langsung mengupdate badge header seketika.
  static final List<CartItem> mockCart = _CartList();

  /// Set ID notifikasi yang sudah dibaca. Item '1' dan '2' belum dibaca sejak awal (hanya 2 teratas yang baru).
  static final Set<String> readNotificationIds = {'3', '4', '5'};

  /// ValueNotifier untuk jumlah notifikasi belum dibaca agar header reaktif secara langsung.
  static final ValueNotifier<int> unreadNotificationsNotifier =
      ValueNotifier<int>(2);

  /// Jumlah notifikasi belum dibaca untuk badge angka di header (default 2)
  static int get unreadNotificationsCount => unreadNotificationsNotifier.value;
  static set unreadNotificationsCount(int val) {
    unreadNotificationsNotifier.value = val;
  }

  /// Menandai notifikasi sebagai terbaca dan mengupdate hitungan notifikasi.
  static void markNotificationAsRead(String id) {
    if (!readNotificationIds.contains(id)) {
      readNotificationIds.add(id);
      unreadNotificationsCount =
          {'1', '2'}.difference(readNotificationIds).length;
    }
  }

  /// Reset state notifikasi ke kondisi awal (hanya untuk pengujian atau reset).
  static void resetNotifications() {
    readNotificationIds
      ..clear()
      ..addAll({'3', '4', '5'});
    unreadNotificationsCount = 2;
  }

  /// Set nama toko dengan chat yang belum dibaca (default: 'Karya Tanah')
  static final Set<String> unreadChatStores = {'Karya Tanah'};

  /// ValueNotifier untuk jumlah pesan chat belum dibaca agar reaktif
  static final ValueNotifier<int> unreadChatNotifier = ValueNotifier<int>(1);

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

  /// Reset state chat (untuk pengujian)
  static void resetChats() {
    unreadChatStores
      ..clear()
      ..add('Karya Tanah');
    unreadChatCount = 1;
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

  /// Reset keranjang ke kondisi awal (berguna untuk pengujian)
  static void resetCart() {
    mockCart.clear();
    mockCart.addAll([
      CartItem(product: products[0], qty: 1),
      CartItem(product: products[1], qty: 2),
    ]);
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
  final List<CartItem> _inner = [
    CartItem(product: MockData.products[0], qty: 1),
    CartItem(product: MockData.products[1], qty: 2),
  ];

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

